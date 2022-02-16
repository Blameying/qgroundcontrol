#ifndef CustomedVideoManager_H
#define CustomedVideoManager_H

#include <QObject>
#include <QTimer>
#include <QTime>
#include <QUrl>

#include "QGCMAVLink.h"
#include "QGCLoggingCategory.h"
#include "VideoReceiver.h"
#include "QGCToolbox.h"
#include "SubtitleWriter.h"
#include "VideoManager.h"

Q_DECLARE_LOGGING_CATEGORY(VideoManagerLog)

class VideoSettings;
class Vehicle;
class Joystick;

class CustomedVideoManager : public VideoManager
{
    Q_OBJECT

public:
    CustomedVideoManager (QGCApplication* app, QGCToolbox* toolbox);
    virtual ~CustomedVideoManager();

    Q_INVOKABLE virtual void setToolbox(QGCToolbox *toolbox);
    Q_INVOKABLE virtual void startRecording(const QString& videoFile = QString());
    Q_INVOKABLE virtual void grabImage(const QString& imageFile = QString());
    Q_INVOKABLE virtual void startVideo     ();
protected:
    friend class FinishVideoInitialization;

    virtual void _cleanupOldVideos();
    virtual void _initVideo();
    virtual bool _updateSettings(unsigned id);
    virtual void _startReceiver             (unsigned id);
};

#endif
