#include "AudioInterface.h"
#include <android/log.h>

#define LOG_TAG "AudioInterface"
#define LOGI(...) __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)

AudioInterface::AudioInterface(QObject *parent) : QObject(parent)
{
    // Get the Android context
    QJniObject context = QNativeInterface::QAndroidApplication::context();
    
    if (context.isValid()) {
        // Create AudioProcessor instance
        QJniObject audioProcessor = QJniObject(
            "com/example/response/AudioProcessor",
            "(Landroid/content/Context;)V",
            context.object<jobject>()
        );
        
        if (audioProcessor.isValid()) {
            m_audioProcessor = audioProcessor;
            
            // Create AndroidInterface instance
            QJniObject androidInterface = QJniObject(
                "com/example/response/AndroidInterface",
                "(Landroid/app/Activity;Lcom/example/response/AudioProcessor;)V",
                context.object<jobject>(),
                audioProcessor.object<jobject>()
            );
            
            if (androidInterface.isValid()) {
                m_androidInterface = androidInterface;
            }
        }
    }
}

AudioInterface::~AudioInterface()
{
    if (m_audioProcessor.isValid()) {
        m_audioProcessor.callMethod<void>("release");
    }
}

void AudioInterface::startListening()
{
    if (m_androidInterface.isValid()) {
        m_androidInterface.callMethod<void>("startListening");
        m_isListening = true;
        emit isListeningChanged(true);
        m_triggerCount = 0;
        emit triggerCountChanged(0);
    }
}

void AudioInterface::stopListening()
{
    if (m_androidInterface.isValid()) {
        m_androidInterface.callMethod<void>("stopListening");
        m_isListening = false;
        emit isListeningChanged(false);
    }
}

void AudioInterface::playDrumHit()
{
    if (m_androidInterface.isValid()) {
        m_androidInterface.callMethod<void>("playDrumHit");
        m_triggerCount++;
        emit triggerCountChanged(m_triggerCount);
        emit hiHatTriggered();
    }
}