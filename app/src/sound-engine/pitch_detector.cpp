#include <cmath>
#include <vector>
#include <algorithm>

float detectPitch(const int16_t* buffer, int size, int sampleRate)
{
    std::vector<float> floatBuffer(size);
    for (int i = 0; i < size; ++i) 
    {
        floatBuffer[i] = static_cast<float>(buffer[i]);
    }

    // jsut preliminary values for sample rates.
    int minLag = sampleRate / 1000;  // 1000 Hz
    int maxLag = sampleRate / 50;    // 50 Hz

    float maxCorrelation = 0.0f;
    int bestLag = -1;

    for (int lag = minLag; lag < maxLag; ++lag) 
    {
        float correlation = 0.0f;
        for (int i = 0; i < size - lag; ++i) 
        {
            correlation += floatBuffer[i] * floatBuffer[i + lag];
        }

        if (correlation > maxCorrelation) 
        {
            maxCorrelation = correlation;
            bestLag = lag;
        }
    }

    if (bestLag != -1)
        return static_cast<float>(sampleRate) / bestLag;
    else 
        return -1.0f;
}