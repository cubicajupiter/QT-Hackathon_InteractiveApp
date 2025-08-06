#include "synthesizer.h"
#include "pitch_detector.h"
#include "utils/audio_utils.h"
#include <iostream>
#include <vector>

/* loads a sample, adjusts its pitch, and plays the audio.
Uses an autocorrelation algorithm to detect the pitch of the audio sample. The autocorrelation algo might introduce some delay, but it is effective for pitch detection in semi real time at least.
The algorithm takes the original recorded audio as an AUDIOBUFFER along with its size and sample rate.
Then it returns a float value representing the detected pitch, or a negative float for error.
Currently loads the audio in as a file, instead of real time.........
*/

Synthesizer::Synthesizer() {}

bool Synthesizer::captureAudio() 
{
    /* needs a real-time audio capture implementation.
    Kotlin APIs:
    AudioRecord, or
    AudioTrack, which plays processed audio back in real-time.
    Use JNI to bridge Kotlin with C++
    */
}

float Synthesizer::adjustPitch(float targetPitch) 
{
    float detectedPitch = detectPitch(audioBuffer.data(), audioBuffer.size(), sampleRate);
    if (detectedPitch <= 0.0f)
    {
        std::cerr << "Error: Could not detect pitch." << std::endl;
        return -1.0f;
    }

    float pitchRatio = targetPitch / detectedPitch;
    for (size_t i = 0; i < audioBuffer.size(); ++i)
        audioBuffer[i] *= pitchRatio; // Simple pitch adjustment

    return detectedPitch;
}

void Synthesizer::playBack() 
{
    ;
}