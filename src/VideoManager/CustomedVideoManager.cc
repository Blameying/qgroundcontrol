#include <QQmlContext>
#include <QQmlEngine>
#include <QSettings>
#include <QUrl>
#include <QDir>

#ifndef QGC_DISABLE_UVC
#include <QCameraInfo>
#endif

#include "ScreenToolsController.h"
#include "VideoManager.h"
#include "QGCToolbox.h"
#include "QGCCorePlugin.h"
#include "QGCOptions.h"
#include "MultiVehicleManager.h"
#include "Settings/SettingsManager.h"
#include "Vehicle.h"
#include "QGCCameraManager.h"

#if defined(QGC_GST_STREAMING)
#include "GStreamer.h"
#include "VideoSettings.h"
#else
#include "GLVideoItemStub.h"
#endif

#ifdef QGC_GST_TAISYNC_ENABLED
#include "TaisyncHandler.h"
#endif

#include "CustomedVideoManager.h"

#if defined(QGC_GST_STREAMING)
static const char* kFileExtension[VideoReceiver::FILE_FORMAT_MAX - VideoReceiver::FILE_FORMAT_MIN] = {
    "mkv",
    "mov",
    "mp4"
};
#endif

CustomedVideoManager::CustomedVideoManager(QGCApplication* app, QGCToolbox* toolbox)
    : VideoManager(app, toolbox)
{

}

CustomedVideoManager::~CustomedVideoManager()
{

}

void CustomedVideoManager::setToolbox(QGCToolbox *toolbox)
{
    QGCTool::setToolbox(toolbox);
    QQmlEngine::setObjectOwnership(this, QQmlEngine::CppOwnership);
    qmlRegisterUncreatableType<VideoManager> ("QGroundControl.CustomedVideoManager", 1, 0, "CustomedVideoManager", "Reference only");

    _videoSettings = toolbox->settingsManager()->customedVideoSettings();
   QString videoSource = _videoSettings->videoSource()->rawValue().toString();
   connect(_videoSettings->videoSource(),   &Fact::rawValueChanged, this, &CustomedVideoManager::_videoSourceChanged);
   connect(_videoSettings->udpPort(),       &Fact::rawValueChanged, this, &CustomedVideoManager::_udpPortChanged);
   connect(_videoSettings->rtspUrl(),       &Fact::rawValueChanged, this, &CustomedVideoManager::_rtspUrlChanged);
   connect(_videoSettings->tcpUrl(),        &Fact::rawValueChanged, this, &CustomedVideoManager::_tcpUrlChanged);
   connect(_videoSettings->aspectRatio(),   &Fact::rawValueChanged, this, &CustomedVideoManager::_aspectRatioChanged);
   connect(_videoSettings->lowLatencyMode(),&Fact::rawValueChanged, this, &CustomedVideoManager::_lowLatencyModeChanged);
   MultiVehicleManager *pVehicleMgr = qgcApp()->toolbox()->multiVehicleManager();
   connect(pVehicleMgr, &MultiVehicleManager::activeVehicleChanged, this, &CustomedVideoManager::_setActiveVehicle);

#if defined(QGC_GST_STREAMING)
    GStreamer::blacklist(static_cast<VideoSettings::VideoDecoderOptions>(_videoSettings->forceVideoDecoder()->rawValue().toInt()));
#ifndef QGC_DISABLE_UVC
   // If we are using a UVC camera setup the device name
   _updateUVC();
#endif

    emit isGStreamerChanged();
    qCDebug(VideoManagerLog) << "New Video Source:" << videoSource;
#if defined(QGC_GST_STREAMING)
    _videoReceiver[0] = toolbox->corePlugin()->createVideoReceiver(this);
    _videoReceiver[1] = toolbox->corePlugin()->createVideoReceiver(this);

    connect(_videoReceiver[0], &VideoReceiver::streamingChanged, this, [this](bool active){
        _streaming = active;
        emit streamingChanged();
    });

    connect(_videoReceiver[0], &VideoReceiver::onStartComplete, this, [this](VideoReceiver::STATUS status) {
        if (status == VideoReceiver::STATUS_OK) {
            _videoStarted[0] = true;
            if (_videoSink[0] != nullptr) {
                // It is absolytely ok to have video receiver active (streaming) and decoding not active
                // It should be handy for cases when you have many streams and want to show only some of them
                // NOTE that even if decoder did not start it is still possible to record video
                _videoReceiver[0]->startDecoding(_videoSink[0]);
            }
        } else if (status == VideoReceiver::STATUS_INVALID_URL) {
            // Invalid URL - don't restart
        } else if (status == VideoReceiver::STATUS_INVALID_STATE) {
            // Already running
        } else {
            _restartVideo(0);
        }
    });

    connect(_videoReceiver[0], &VideoReceiver::onStopComplete, this, [this](VideoReceiver::STATUS) {
        _videoStarted[0] = false;
        _startReceiver(0);
    });

    connect(_videoReceiver[0], &VideoReceiver::decodingChanged, this, [this](bool active){
        _decoding = active;
        emit decodingChanged();
    });

    connect(_videoReceiver[0], &VideoReceiver::recordingChanged, this, [this](bool active){
        _recording = active;
        if (!active) {
            _subtitleWriter.stopCapturingTelemetry();
        }
        emit recordingChanged();
    });

    connect(_videoReceiver[0], &VideoReceiver::recordingStarted, this, [this](){
        _subtitleWriter.startCapturingTelemetry(_videoFile);
    });

    connect(_videoReceiver[0], &VideoReceiver::videoSizeChanged, this, [this](QSize size){
        _videoSize = ((quint32)size.width() << 16) | (quint32)size.height();
        emit videoSizeChanged();
    });

    //connect(_videoReceiver, &VideoReceiver::onTakeScreenshotComplete, this, [this](VideoReceiver::STATUS status){
    //    if (status == VideoReceiver::STATUS_OK) {
    //    }
    //});

    // FIXME: AV: I believe _thermalVideoReceiver should be handled just like _videoReceiver in terms of event
    // and I expect that it will be changed during multiple video stream activity
    if (_videoReceiver[1] != nullptr) {
        connect(_videoReceiver[1], &VideoReceiver::onStartComplete, this, [this](VideoReceiver::STATUS status) {
            if (status == VideoReceiver::STATUS_OK) {
                _videoStarted[1] = true;
                if (_videoSink[1] != nullptr) {
                    _videoReceiver[1]->startDecoding(_videoSink[1]);
                }
            } else if (status == VideoReceiver::STATUS_INVALID_URL) {
                // Invalid URL - don't restart
            } else if (status == VideoReceiver::STATUS_INVALID_STATE) {
                // Already running
            } else {
                _restartVideo(1);
            }
        });

        connect(_videoReceiver[1], &VideoReceiver::onStopComplete, this, [this](VideoReceiver::STATUS) {
            _videoStarted[1] = false;
            _startReceiver(1);
        });
    }
#endif
    _updateSettings(0);
    _updateSettings(1);
    if(isGStreamer()) {
        startVideo();
    } else {
        stopVideo();
    }

#endif
}

void CustomedVideoManager::startVideo()
{
    if (qgcApp()->runningUnitTests()) {
        return;
    }

    if(!_videoSettings->streamEnabled()->rawValue().toBool() || !_videoSettings->streamConfigured()) {
        qCDebug(VideoManagerLog) << "Stream not enabled/configured";
        return;
    }

    _startReceiver(0);
    _startReceiver(1);
}

void CustomedVideoManager::_cleanupOldVideos()
{
#if defined(QGC_GST_STREAMING)
    //-- Only perform cleanup if storage limit is enabled
    if(!_videoSettings->enableStorageLimit()->rawValue().toBool()) {
        return;
    }
    QString savePath = qgcApp()->toolbox()->settingsManager()->appSettings()->videoSavePath();
    QDir videoDir = QDir(savePath);
    videoDir.setFilter(QDir::Files | QDir::Readable | QDir::NoSymLinks | QDir::Writable);
    videoDir.setSorting(QDir::Time);

    QStringList nameFilters;

    for(size_t i = 0; i < sizeof(kFileExtension) / sizeof(kFileExtension[0]); i += 1) {
        // 与主摄像头的视频区分开
        nameFilters << QString("*_second.") + kFileExtension[i];
    }

    videoDir.setNameFilters(nameFilters);
    //-- get the list of videos stored
    QFileInfoList vidList = videoDir.entryInfoList();
    if(!vidList.isEmpty()) {
        uint64_t total   = 0;
        //-- Settings are stored using MB
        uint64_t maxSize = _videoSettings->maxVideoSize()->rawValue().toUInt() * 1024 * 1024;
        //-- Compute total used storage
        for(int i = 0; i < vidList.size(); i++) {
            total += vidList[i].size();
        }
        //-- Remove old movies until max size is satisfied.
        while(total >= maxSize && !vidList.isEmpty()) {
            total -= vidList.last().size();
            qCDebug(VideoManagerLog) << "Removing old video file:" << vidList.last().filePath();
            QFile file (vidList.last().filePath());
            file.remove();
            vidList.removeLast();
        }
    }
#endif
}

void CustomedVideoManager::startRecording(const QString& videoFile)
{
    if (qgcApp()->runningUnitTests()) {
        return;
    }
#if defined(QGC_GST_STREAMING)
    if (!_videoReceiver[0]) {
        qgcApp()->showAppMessage(tr("Second Video receiver is not ready."));
        return;
    }

    const VideoReceiver::FILE_FORMAT fileFormat = static_cast<VideoReceiver::FILE_FORMAT>(_videoSettings->recordingFormat()->rawValue().toInt());

    if(fileFormat < VideoReceiver::FILE_FORMAT_MIN || fileFormat >= VideoReceiver::FILE_FORMAT_MAX) {
        qgcApp()->showAppMessage(tr("Second Invalid video format defined."));
        return;
    }
    QString ext = kFileExtension[fileFormat - VideoReceiver::FILE_FORMAT_MIN];

    //-- Disk usage maintenance
    _cleanupOldVideos();

    QString savePath = qgcApp()->toolbox()->settingsManager()->appSettings()->videoSavePath();

    if (savePath.isEmpty()) {
        qgcApp()->showAppMessage(tr("Unabled to record video. Video save path must be specified in Settings."));
        return;
    }

    _videoFile = savePath + "/"
            + (videoFile.isEmpty() ? QDateTime::currentDateTime().toString("yyyy-MM-dd_hh.mm.ss") : videoFile)
            + "_second.";
    QString videoFile2 = _videoFile + "2_second." + ext;
    _videoFile += ext;

    if (_videoReceiver[0] && _videoStarted[0]) {
        _videoReceiver[0]->startRecording(_videoFile, fileFormat);
    }
    if (_videoReceiver[1] && _videoStarted[1]) {
        _videoReceiver[1]->startRecording(videoFile2, fileFormat);
    }

#else
    Q_UNUSED(videoFile)
#endif
}

void CustomedVideoManager::grabImage(const QString& imageFile)
{
    if (qgcApp()->runningUnitTests()) {
        return;
    }
#if defined(QGC_GST_STREAMING)
    if (!_videoReceiver[0]) {
        return;
    }

    if (imageFile.isEmpty()) {
        _imageFile = qgcApp()->toolbox()->settingsManager()->appSettings()->photoSavePath();
        _imageFile += + "/" + QDateTime::currentDateTime().toString("yyyy-MM-dd_hh.mm.ss.zzz") + "_second.jpg";
    } else {
        _imageFile = imageFile;
    }

    emit imageFileChanged();

    _videoReceiver[0]->takeScreenshot(_imageFile);
#else
    Q_UNUSED(imageFile)
#endif
}

void CustomedVideoManager::_initVideo()
{
#if defined(QGC_GST_STREAMING)
    QQuickItem* root = qgcApp()->mainRootWindow();

    qDebug() << "Blame, init video was called";
    if (root == nullptr) {
        qCDebug(VideoManagerLog) << "mainRootWindow() failed. No root window";
        return;
    }

    QQuickItem* widget = root->findChild<QQuickItem*>("videoContentSecond");
    //QQuickItem* widget = nullptr;
    //auto listview = root->findChild<QQuickItem*>("dialogList");
    //if (listview != nullptr) {
    //    qDebug() << "Blame, we found dialogList";
    //    auto contentItem = listview->property("contentItem").value<QQuickItem*>();
    //    auto contentItemChildren = contentItem->childItems();
    //    for (auto childItem: contentItemChildren) {
    //        widget = childItem->findChild<QQuickItem*>("videoContentSecond");
    //        if (widget != nullptr) {
    //            break;
    //        }
    //    }
    //}
    qDebug() << "Blame, we found widget," << widget;

    if (widget != nullptr && _videoReceiver[0] != nullptr) {
        _videoSink[0] = qgcApp()->toolbox()->corePlugin()->createVideoSink(this, widget);
        if (_videoSink[0] != nullptr) {
            if (_videoStarted[0]) {
                _videoReceiver[0]->startDecoding(_videoSink[0]);
            }
        } else {
            qCDebug(VideoManagerLog) << "createVideoSink() failed";
        }
    } else {
        qCDebug(VideoManagerLog) << "video receiver disabled";
    }

    widget = root->findChild<QQuickItem*>("thermalVideoSecond");

    if (widget != nullptr && _videoReceiver[1] != nullptr) {
        _videoSink[1] = qgcApp()->toolbox()->corePlugin()->createVideoSink(this, widget);
        if (_videoSink[1] != nullptr) {
            if (_videoStarted[1]) {
                _videoReceiver[1]->startDecoding(_videoSink[1]);
            }
        } else {
            qCDebug(VideoManagerLog) << "createVideoSink() failed";
        }
    } else {
        qCDebug(VideoManagerLog) << "thermal video receiver disabled";
    }
#endif
}

void CustomedVideoManager::_startReceiver(unsigned id)
{
#if defined(QGC_GST_STREAMING)
    const unsigned timeout = _videoSettings->rtspTimeout()->rawValue().toUInt();
    //if (id == 0 && !_videoStarted[0]) {
    //    QQuickItem* root = qgcApp()->mainRootWindow();
    //    qDebug() << "Blame, init video was called";
    //    if (root == nullptr) {
    //        qCDebug(VideoManagerLog) << "mainRootWindow() failed. No root window";
    //        goto __blame_flag;
    //    }
    //    QQuickItem* widget = root->findChild<QQuickItem*>("videoContentSecond");
    //    qDebug() << "Blame, we found widget," << widget;
    //    if (widget != nullptr && _videoReceiver[0] != nullptr) {
    //        if (_videoSink[0] != nullptr) {
    //            qgcApp()->toolbox()->corePlugin()->releaseVideoSink(_videoSink[0]);
    //        } 
    //        _videoSink[0] = qgcApp()->toolbox()->corePlugin()->createVideoSink(this, widget);
    //        if (_videoSink[0] != nullptr) {
    //            qCDebug(VideoManagerLog) << "createVideoSink() successed";
    //        } else {
    //            qCDebug(VideoManagerLog) << "createVideoSink() failed";
    //        }
    //    } else {
    //        qCDebug(VideoManagerLog) << "video receiver disabled";
    //    }
    //}

__blame_flag:
    if (id > 1) {
        qCDebug(VideoManagerLog) << "Unsupported receiver id" << id;
    } else if (_videoReceiver[id] != nullptr/* && _videoSink[id] != nullptr*/) {
        if (!_videoUri[id].isEmpty()) {
            _videoReceiver[id]->start(_videoUri[id], timeout, _lowLatencyStreaming[id] ? -1 : 0);
        }
    }
#endif
}

bool CustomedVideoManager::_updateSettings(unsigned id)
{
    if(!_videoSettings)
        return false;

    const bool lowLatencyStreaming  =_videoSettings->lowLatencyMode()->rawValue().toBool();

    bool settingsChanged = _lowLatencyStreaming[id] != lowLatencyStreaming;

    _lowLatencyStreaming[id] = lowLatencyStreaming;

    //-- Auto discovery

    if(_activeVehicle && _activeVehicle->cameraManager()) {
        QGCVideoStreamInfo* pInfo = _activeVehicle->cameraManager()->currentStreamInstance();
        if(pInfo) {
            if (id == 0) {
                qCDebug(VideoManagerLog) << "Configure primary stream:" << pInfo->uri();
                switch(pInfo->type()) {
                    case VIDEO_STREAM_TYPE_RTSP:
                        if ((settingsChanged |= _updateVideoUri(id, pInfo->uri()))) {
                            _toolbox->settingsManager()->customedVideoSettings()->videoSource()->setRawValue(VideoSettings::videoSourceRTSP);
                        }
                        break;
                    case VIDEO_STREAM_TYPE_TCP_MPEG:
                        if ((settingsChanged |= _updateVideoUri(id, pInfo->uri()))) {
                            _toolbox->settingsManager()->customedVideoSettings()->videoSource()->setRawValue(VideoSettings::videoSourceTCP);
                        }
                        break;
                    case VIDEO_STREAM_TYPE_RTPUDP:
                        if ((settingsChanged |= _updateVideoUri(id, QStringLiteral("udp://0.0.0.0:%1").arg(pInfo->uri())))) {
                            _toolbox->settingsManager()->customedVideoSettings()->videoSource()->setRawValue(VideoSettings::videoSourceUDPH264);
                        }
                        break;
                    case VIDEO_STREAM_TYPE_MPEG_TS_H264:
                        if ((settingsChanged |= _updateVideoUri(id, QStringLiteral("mpegts://0.0.0.0:%1").arg(pInfo->uri())))) {
                            _toolbox->settingsManager()->customedVideoSettings()->videoSource()->setRawValue(VideoSettings::videoSourceMPEGTS);
                        }
                        break;
                    default:
                        settingsChanged |= _updateVideoUri(id, pInfo->uri());
                        break;
                }
            }
            else if (id == 1) { //-- Thermal stream (if any)
                QGCVideoStreamInfo* pTinfo = _activeVehicle->cameraManager()->thermalStreamInstance();
                if (pTinfo) {
                    qCDebug(VideoManagerLog) << "Configure secondary stream:" << pTinfo->uri();
                    switch(pTinfo->type()) {
                        case VIDEO_STREAM_TYPE_RTSP:
                        case VIDEO_STREAM_TYPE_TCP_MPEG:
                            settingsChanged |= _updateVideoUri(id, pTinfo->uri());
                            break;
                        case VIDEO_STREAM_TYPE_RTPUDP:
                            settingsChanged |= _updateVideoUri(id, QStringLiteral("udp://0.0.0.0:%1").arg(pTinfo->uri()));
                            break;
                        case VIDEO_STREAM_TYPE_MPEG_TS_H264:
                            settingsChanged |= _updateVideoUri(id, QStringLiteral("mpegts://0.0.0.0:%1").arg(pTinfo->uri()));
                            break;
                        default:
                            settingsChanged |= _updateVideoUri(id, pTinfo->uri());
                            break;
                    }
                }
            }
            return settingsChanged;
        }
    }
    QString source = _videoSettings->videoSource()->rawValue().toString();
    if (source == VideoSettings::videoSourceUDPH264)
        settingsChanged |= _updateVideoUri(0, QStringLiteral("udp://0.0.0.0:%1").arg(_videoSettings->udpPort()->rawValue().toInt()));
    else if (source == VideoSettings::videoSourceUDPH265)
        settingsChanged |= _updateVideoUri(0, QStringLiteral("udp265://0.0.0.0:%1").arg(_videoSettings->udpPort()->rawValue().toInt()));
    else if (source == VideoSettings::videoSourceMPEGTS)
        settingsChanged |= _updateVideoUri(0, QStringLiteral("mpegts://0.0.0.0:%1").arg(_videoSettings->udpPort()->rawValue().toInt()));
    else if (source == VideoSettings::videoSourceRTSP)
        settingsChanged |= _updateVideoUri(0, _videoSettings->rtspUrl()->rawValue().toString());
    else if (source == VideoSettings::videoSourceTCP)
        settingsChanged |= _updateVideoUri(0, QStringLiteral("tcp://%1").arg(_videoSettings->tcpUrl()->rawValue().toString()));
    else if (source == VideoSettings::videoSource3DRSolo)
        settingsChanged |= _updateVideoUri(0, QStringLiteral("udp://0.0.0.0:5600"));
    else if (source == VideoSettings::videoSourceParrotDiscovery)
        settingsChanged |= _updateVideoUri(0, QStringLiteral("udp://0.0.0.0:8888"));

    return settingsChanged;
}
