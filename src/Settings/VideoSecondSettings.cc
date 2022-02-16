#include "VideoSecondSettings.h"
#include "QGCApplication.h"
#include "VideoManager.h"

#include <QQmlEngine>
#include <QtQml>
#include <QVariantList>

#ifndef QGC_DISABLE_UVC
#include <QCameraInfo>
#endif

const char* VideoSecondSettings::videoSourceNoVideo           = "No Video Available";
const char* VideoSecondSettings::videoDisabled                = "Video2 Stream Disabled";
const char* VideoSecondSettings::videoSourceRTSP              = "RTSP Video Stream";
const char* VideoSecondSettings::videoSourceUDPH264           = "UDP h.264 Video Stream";
const char* VideoSecondSettings::videoSourceUDPH265           = "UDP h.265 Video Stream";
const char* VideoSecondSettings::videoSourceTCP               = "TCP-MPEG2 Video Stream";
const char* VideoSecondSettings::videoSourceMPEGTS            = "MPEG-TS (h.264) Video Stream";
const char* VideoSecondSettings::videoSource3DRSolo           = "3DR Solo (requires restart)";
const char* VideoSecondSettings::videoSourceParrotDiscovery   = "Parrot Discovery";

const char* VideoSecondSettings::name = "VideoSecond";
const char* VideoSecondSettings::settingsGroup = "VideoSecond"; 
VideoSecondSettings::VideoSecondSettings(QObject* parent)
    :VideoSettings(name, settingsGroup, parent)
{
    qmlRegisterUncreatableType<VideoSecondSettings>("QGroundControl.SettingsManager", 1, 0, "VideoSecondSettings", "Reference only");

    // Setup enum values for videoSource settings into meta data
    QStringList videoSourceList;
#ifdef QGC_GST_STREAMING
    videoSourceList.append(videoSourceRTSP);
#ifndef NO_UDP_VIDEO
    videoSourceList.append(videoSourceUDPH264);
    videoSourceList.append(videoSourceUDPH265);
#endif
    videoSourceList.append(videoSourceTCP);
    videoSourceList.append(videoSourceMPEGTS);
    videoSourceList.append(videoSource3DRSolo);
    videoSourceList.append(videoSourceParrotDiscovery);
#endif
#ifndef QGC_DISABLE_UVC
    QList<QCameraInfo> cameras = QCameraInfo::availableCameras();
    for (const QCameraInfo &cameraInfo: cameras) {
        videoSourceList.append(cameraInfo.description());
    }
#endif
    if (videoSourceList.count() == 0) {
        _noVideo = true;
        videoSourceList.append(videoSourceNoVideo);
    } else {
        videoSourceList.insert(0, videoDisabled);
    }
    QVariantList videoSourceVarList;
    for (const QString& videoSource: videoSourceList) {
        videoSourceVarList.append(QVariant::fromValue(videoSource));
    }
    _nameToMetaDataMap[videoSourceName]->setEnumInfo(videoSourceList, videoSourceVarList);

    const QVariantList removeForceVideoDecodeList{
#ifdef Q_OS_LINUX
        VideoDecoderOptions::ForceVideoDecoderDirectX3D,
        VideoDecoderOptions::ForceVideoDecoderVideoToolbox,
#endif
#ifdef Q_OS_WIN
        VideoDecoderOptions::ForceVideoDecoderVAAPI,
        VideoDecoderOptions::ForceVideoDecoderVideoToolbox,
#endif
#ifdef Q_OS_MAC
        VideoDecoderOptions::ForceVideoDecoderDirectX3D,
        VideoDecoderOptions::ForceVideoDecoderVAAPI,
#endif
    };

    for(const auto& value : removeForceVideoDecodeList) {
        _nameToMetaDataMap[forceVideoDecoderName]->removeEnumInfo(value);
    }

    // Set default value for videoSource
    _setDefaults();
}

void VideoSecondSettings::_setDefaults()
{
    if (_noVideo) {
        _nameToMetaDataMap[videoSourceName]->setRawDefaultValue(videoSourceNoVideo);
    } else {
        _nameToMetaDataMap[videoSourceName]->setRawDefaultValue(videoDisabled);
    }
}

DECLARE_SETTINGSFACT(VideoSecondSettings, aspectRatio)
DECLARE_SETTINGSFACT(VideoSecondSettings, videoFit)
DECLARE_SETTINGSFACT(VideoSecondSettings, gridLines)
DECLARE_SETTINGSFACT(VideoSecondSettings, showRecControl)
DECLARE_SETTINGSFACT(VideoSecondSettings, recordingFormat)
DECLARE_SETTINGSFACT(VideoSecondSettings, maxVideoSize)
DECLARE_SETTINGSFACT(VideoSecondSettings, enableStorageLimit)
DECLARE_SETTINGSFACT(VideoSecondSettings, rtspTimeout)
DECLARE_SETTINGSFACT(VideoSecondSettings, streamEnabled)
DECLARE_SETTINGSFACT(VideoSecondSettings, disableWhenDisarmed)
DECLARE_SETTINGSFACT(VideoSecondSettings, lowLatencyMode)

DECLARE_SETTINGSFACT_NO_FUNC(VideoSecondSettings, videoSource)
{
    if (!_videoSourceFact) {
        _videoSourceFact = _createSettingsFact(videoSourceName);
        //-- Check for sources no longer available
        if(!_videoSourceFact->enumStrings().contains(_videoSourceFact->rawValue().toString())) {
            if (_noVideo) {
                _videoSourceFact->setRawValue(videoSourceNoVideo);
            } else {
                _videoSourceFact->setRawValue(videoDisabled);
            }
        }
        connect(_videoSourceFact, &Fact::valueChanged, this, &VideoSecondSettings::_configChanged);
    }
    return _videoSourceFact;
}

DECLARE_SETTINGSFACT_NO_FUNC(VideoSecondSettings, forceVideoDecoder)
{
    if (!_forceVideoDecoderFact) {
        _forceVideoDecoderFact = _createSettingsFact(forceVideoDecoderName);

        _forceVideoDecoderFact->setVisible(
#ifdef Q_OS_IOS
            false
#else
#ifdef Q_OS_ANDROID
            false
#else
            true
#endif
#endif
        );

        connect(_forceVideoDecoderFact, &Fact::valueChanged, this, &VideoSecondSettings::_configChanged);
    }
    return _forceVideoDecoderFact;
}

DECLARE_SETTINGSFACT_NO_FUNC(VideoSecondSettings, udpPort)
{
    if (!_udpPortFact) {
        _udpPortFact = _createSettingsFact(udpPortName);
        connect(_udpPortFact, &Fact::valueChanged, this, &VideoSecondSettings::_configChanged);
    }
    return _udpPortFact;
}

DECLARE_SETTINGSFACT_NO_FUNC(VideoSecondSettings, rtspUrl)
{
    if (!_rtspUrlFact) {
        _rtspUrlFact = _createSettingsFact(rtspUrlName);
        connect(_rtspUrlFact, &Fact::valueChanged, this, &VideoSecondSettings::_configChanged);
    }
    return _rtspUrlFact;
}

DECLARE_SETTINGSFACT_NO_FUNC(VideoSecondSettings, tcpUrl)
{
    if (!_tcpUrlFact) {
        _tcpUrlFact = _createSettingsFact(tcpUrlName);
        connect(_tcpUrlFact, &Fact::valueChanged, this, &VideoSecondSettings::_configChanged);
    }
    return _tcpUrlFact;
}
