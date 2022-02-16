/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#ifndef VideoSecondSettings_H
#define VideoSecondSettings_H

#include "SettingsGroup.h"
#include "VideoSettings.h"

class VideoSecondSettings : public VideoSettings
{
    Q_OBJECT

public:
    VideoSecondSettings(QObject* parent = nullptr);
    DEFINE_SETTING_NAME_GROUP()

    DEFINE_SETTINGFACT(videoSource)
    DEFINE_SETTINGFACT(udpPort)
    DEFINE_SETTINGFACT(tcpUrl)
    DEFINE_SETTINGFACT(rtspUrl)
    DEFINE_SETTINGFACT(aspectRatio)
    DEFINE_SETTINGFACT(videoFit)
    DEFINE_SETTINGFACT(gridLines)
    DEFINE_SETTINGFACT(showRecControl)
    DEFINE_SETTINGFACT(recordingFormat)
    DEFINE_SETTINGFACT(maxVideoSize)
    DEFINE_SETTINGFACT(enableStorageLimit)
    DEFINE_SETTINGFACT(rtspTimeout)
    DEFINE_SETTINGFACT(streamEnabled)
    DEFINE_SETTINGFACT(disableWhenDisarmed)
    DEFINE_SETTINGFACT(lowLatencyMode)
    DEFINE_SETTINGFACT(forceVideoDecoder)

    static const char* videoSourceNoVideo;
    static const char* videoDisabled;
    static const char* videoSourceUDPH264;
    static const char* videoSourceUDPH265;
    static const char* videoSourceRTSP;
    static const char* videoSourceTCP;
    static const char* videoSourceMPEGTS;
    static const char* videoSource3DRSolo;
    static const char* videoSourceParrotDiscovery;

private:
    void _setDefaults               ();
private:
    bool _noVideo = false;
};

#endif
