#include "AudioManager.h"
#include <fftw3.h> // Include FFTW for frequency analysis

AudioManager::AudioManager(QObject *parent)
    : QObject(parent), pEnumerator(nullptr), pDevice(nullptr), pAudioClient(nullptr), pWaveFormat(nullptr), currentFrequency(0.0) {
    initializeAudioDevice();

    audioCaptureThread = new QThread(this);
    this->moveToThread(audioCaptureThread);

    connect(audioCaptureThread, &QThread::started, this, &AudioManager::captureAudio);
    connect(audioCaptureThread, &QThread::finished, audioCaptureThread, &QObject::deleteLater);

    audioCaptureThread->start();
}

AudioManager::~AudioManager() {
    releaseResources();
    if (audioCaptureThread && audioCaptureThread->isRunning()) {
        qDebug() << "Stopping audio capture thread...";
        audioCaptureThread->quit();  // Просим поток завершиться
        audioCaptureThread->wait();  // Ждем завершения потока
    }
}

void AudioManager::initializeAudioDevice() {
    HRESULT hr;

    // Step 1: Create a device enumerator
    hr = CoInitialize(nullptr);
    if (FAILED(hr)) {
        qDebug() << "Failed to initialize COM library.";
        return;
    }

    hr = CoCreateInstance(__uuidof(MMDeviceEnumerator), nullptr, CLSCTX_ALL, __uuidof(IMMDeviceEnumerator), (void**)&pEnumerator);
    if (FAILED(hr)) {
        qDebug() << "Failed to create device enumerator.";
        return;
    }

    // Step 2: Get the default audio capture device
    hr = pEnumerator->GetDefaultAudioEndpoint(eCapture, eCommunications, &pDevice);
    if (FAILED(hr)) {
        qDebug() << "Failed to get default audio endpoint.";
        return;
    }

    // Step 3: Activate the audio client for this device
    hr = pDevice->Activate(__uuidof(IAudioClient), CLSCTX_ALL, nullptr, (void**)&pAudioClient);
    if (FAILED(hr)) {
        qDebug() << "Failed to activate the audio client.";
        return;
    }

    // Step 4: Get the mix format for the audio stream
    hr = pAudioClient->GetMixFormat(&pWaveFormat);
    if (FAILED(hr)) {
        qDebug() << "Failed to get wave format.";
        return;
    }

    // Step 5: Initialize the audio stream
    hr = pAudioClient->Initialize(AUDCLNT_SHAREMODE_SHARED, 0, 10000000, 0, pWaveFormat, nullptr);
    if (FAILED(hr)) {
        qDebug() << "Failed to initialize the audio client.";
        return;
    }

    qDebug() << "Audio device initialized successfully.";
}

void AudioManager::releaseResources() {
    if (pWaveFormat) {
        CoTaskMemFree(pWaveFormat);
        pWaveFormat = nullptr;
    }
    if (pAudioClient) {
        pAudioClient->Release();
        pAudioClient = nullptr;
    }
    if (pDevice) {
        pDevice->Release();
        pDevice = nullptr;
    }
    if (pEnumerator) {
        pEnumerator->Release();
        pEnumerator = nullptr;
    }
    CoUninitialize();
    qDebug() << "Resources released successfully.";
}

void AudioManager::captureAudio() {
    HRESULT hr;
    IAudioCaptureClient* pCaptureClient = nullptr;

    // Get the capture client
    hr = pAudioClient->GetService(__uuidof(IAudioCaptureClient), (void**)&pCaptureClient);
    if (FAILED(hr)) {
        qDebug() << "Failed to get audio capture client.";
        return;
    }

    // Start capturing audio
    hr = pAudioClient->Start();
    if (FAILED(hr)) {
        qDebug() << "Failed to start audio client.";
        return;
    }

    UINT32 packetLength = 0;
    BYTE* pData;
    DWORD flags;

    while (true) {
        hr = pCaptureClient->GetNextPacketSize(&packetLength);
        if (FAILED(hr)) {
            qDebug() << "Failed to get packet size.";
            break;
        }

        if (packetLength > 0) {
            hr = pCaptureClient->GetBuffer(&pData, &packetLength, &flags, nullptr, nullptr);
            if (FAILED(hr)) {
                qDebug() << "Failed to get buffer.";
                break;
            }

            // Convert raw audio data to floating point and store in audioBuffer
            float* floatData = reinterpret_cast<float*>(pData);
            for (UINT32 i = 0; i < packetLength / sizeof(float); ++i) {
                audioBuffer.append(floatData[i]);
            }

            hr = pCaptureClient->ReleaseBuffer(packetLength);
            if (FAILED(hr)) {
                qDebug() << "Failed to release buffer.";
                break;
            }
        }

        // Process the audio buffer to calculate frequency
        processAudioData();
        // if (audioBuffer.isEmpty()) {
        //     break;
        // }
    }

    pCaptureClient->Release();
    pAudioClient->Stop();
}

void AudioManager::processAudioData() {
    if (audioBuffer.isEmpty()) {
        return;
    }

    // Apply FFT using FFTW3 to analyze frequency
    int N = audioBuffer.size();
    double* in = new double[N];
    fftw_complex* out = (fftw_complex*)fftw_malloc(sizeof(fftw_complex) * N);
    fftw_plan plan = fftw_plan_dft_r2c_1d(N, in, out, FFTW_ESTIMATE);

    for (int i = 0; i < N; ++i) {
        in[i] = static_cast<double>(audioBuffer[i]);
    }

    fftw_execute(plan);

    // Find the peak in the frequency spectrum
    double maxAmplitude = 0.0;
    int peakIndex = 0;

    for (int i = 0; i < N / 2; ++i) {
        double magnitude = sqrt(out[i][0] * out[i][0] + out[i][1] * out[i][1]);
        if (magnitude > maxAmplitude) {
            maxAmplitude = magnitude;
            peakIndex = i;
        }
    }

    // Calculate the corresponding frequency
    double sampleRate = pWaveFormat ? pWaveFormat->nSamplesPerSec : 44100; // Default to 44.1kHz if not set
    currentFrequency = (peakIndex * sampleRate) / N;

    qDebug() << "Current frequency: " << currentFrequency << " Hz";

    // Cleanup
    fftw_destroy_plan(plan);
    fftw_free(out);
    delete[] in;

    // Clear the buffer for the next batch
    audioBuffer.clear();
}
