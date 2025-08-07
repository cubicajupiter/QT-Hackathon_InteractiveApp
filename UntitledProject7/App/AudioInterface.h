#ifndef AUDIOINTERFACE_H
#define AUDIOINTERFACE_H

#include <QObject>
#include <QJniObject>
#include <QJniEnvironment>
#include <QGuiApplication>

class AudioInterface : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool isListening READ isListening NOTIFY isListeningChanged)
    Q_PROPERTY(float audioLevel READ audioLevel NOTIFY audioLevelChanged)
    Q_PROPERTY(int triggerCount READ triggerCount NOTIFY triggerCountChanged)

public:
    explicit AudioInterface(QObject *parent = nullptr);
    ~AudioInterface();

    bool isListening() const { return m_isListening; }
    float audioLevel() const { return m_audioLevel; }
    int triggerCount() const { return m_triggerCount; }

public slots:
    void startListening();
    void stopListening();
    void playDrumHit();

signals:
    void isListeningChanged(bool isListening);
    void audioLevelChanged(float level);
    void triggerCountChanged(int count);
    void hiHatTriggered();

private:
    bool m_isListening = false;
    float m_audioLevel = 0.0f;
    int m_triggerCount = 0;
    
    QJniObject m_audioProcessor;
    QJniObject m_androidInterface;
};

#endif // AUDIOINTERFACE_H