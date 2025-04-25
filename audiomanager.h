#ifndef AUDIOMANAGER_H
#define AUDIOMANAGER_H

#include <QObject>
#include <QDebug>
#include <QVector>
#include <QTimer>
#include <QThread>
#include <Windows.h>
#include <mmdeviceapi.h>
#include <audioclient.h>

class AudioManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(double currentFrequency READ getCurrentFrequency NOTIFY currentFrequencyChanged)

public:
    explicit AudioManager(QObject *parent = nullptr);
    Q_INVOKABLE double getCurrentFrequency() { return currentFrequency; }
    Q_INVOKABLE void captureAudio();                  // Method that captures audio and processes the frequency
    ~AudioManager();

signals:
    void currentFrequencyChanged(double frequency);

private:
    // Windows API related variables
    IMMDeviceEnumerator* pEnumerator;     // Enumerator to list audio devices
    IMMDevice* pDevice;                   // Selected audio device
    IAudioClient* pAudioClient;           // Audio client for capturing audio stream
    WAVEFORMATEX* pWaveFormat;            // Format of the audio stream

    // Internal variables
    QVector<float> audioBuffer;        // Buffer to store raw audio data
    double currentFrequency;              // Current detected frequency in Hz
    bool isRunning;
    QThread* audioCaptureThread;

    // Initialization methods
    void initializeAudioDevice();         // Initialize the audio capture device
    void releaseResources();              // Release all Windows API resources
    void processAudioData();              // Process raw audio data and detect frequency
};

#endif // AUDIOMANAGER_H
