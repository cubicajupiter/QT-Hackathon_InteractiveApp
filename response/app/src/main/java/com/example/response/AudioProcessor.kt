'''package com.example.response

import android.Manifest
import android.content.pm.PackageManager
import android.media.AudioAttributes
import android.media.AudioFormat
import android.media.AudioManager
import android.media.AudioRecord
import android.media.AudioTrack
import android.media.MediaRecorder
import android.os.Build
import android.util.Log
import androidx.core.app.ActivityCompat
import kotlinx.coroutines.*
import java.util.concurrent.atomic.AtomicBoolean
import kotlin.math.abs
import kotlin.math.sqrt
import kotlin.random.Random

class AudioProcessor(private val context: android.content.Context) {
    private val TAG = "AudioProcessor"
    private val sampleRate = 44100
    private val bufferSize = AudioRecord.getMinBufferSize(sampleRate, AudioFormat.CHANNEL_IN_MONO, AudioFormat.ENCODING_PCM_16BIT)

    private var audioRecord: AudioRecord? = null
    private var audioTrack: AudioTrack? = null
    private var isRecording = AtomicBoolean(false)
    private var isProcessing = AtomicBoolean(false)

    private val coroutineScope = CoroutineScope(Dispatchers.Default + SupervisorJob())

    private val threshold = 0.1f // Audio threshold for triggering drum sound
    private var lastTriggerTime = 0L
    private val minTriggerInterval = 100L // Minimum 100ms between triggers

    // AndroidInterface for callbacks
    private var androidInterface: AndroidInterface? = null

    fun setAndroidInterface(androidInterface: AndroidInterface) {
        this.androidInterface = androidInterface
    }

    init {
        initializeAudioTrack()
    }

    private fun initializeAudioTrack() {
        try {
            val audioAttributes = AudioAttributes.Builder()
                .setUsage(AudioAttributes.USAGE_MEDIA)
                .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                .build()

            val audioFormat = AudioFormat.Builder()
                .setEncoding(AudioFormat.ENCODING_PCM_16BIT)
                .setSampleRate(sampleRate)
                .setChannelMask(AudioFormat.CHANNEL_OUT_MONO)
                .build()

            audioTrack = AudioTrack(
                audioAttributes,
                audioFormat,
                bufferSize,
                AudioTrack.MODE_STREAM,
                AudioManager.AUDIO_SESSION_ID_GENERATE
            )

            audioTrack?.play()
        } catch (e: Exception) {
            Log.e(TAG, "Error initializing AudioTrack: ${e.message}")
        }
    }

    fun startListening() {
        if (ActivityCompat.checkSelfPermission(context, Manifest.permission.RECORD_AUDIO) != PackageManager.PERMISSION_GRANTED) {
            // Note: In a real app, you would need to handle permission requests properly
            return
        }

        if (isRecording.get()) {
            Log.d(TAG, "Already recording")
            return
        }

        try {
            audioRecord = AudioRecord(
                MediaRecorder.AudioSource.MIC,
                sampleRate,
                AudioFormat.CHANNEL_IN_MONO,
                AudioFormat.ENCODING_PCM_16BIT,
                bufferSize
            )

            audioRecord?.startRecording()
            isRecording.set(true)

            coroutineScope.launch {
                processAudio()
            }

            Log.d(TAG, "Started listening to microphone")
        } catch (e: Exception) {
            Log.e(TAG, "Error starting audio recording: ${e.message}")
        }
    }

    fun stopListening() {
        if (!isRecording.get()) return

        isRecording.set(false)
        isProcessing.set(false)

        try {
            audioRecord?.stop()
            audioRecord?.release()
            audioRecord = null
        } catch (e: Exception) {
            Log.e(TAG, "Error stopping audio recording: ${e.message}")
        }

        Log.d(TAG, "Stopped listening to microphone")
    }

    fun playDrumHit() {
        coroutineScope.launch {
            generateAndPlayHiHatSound()
        }
    }

    private suspend fun processAudio() {
        val buffer = ShortArray(bufferSize / 2)

        while (isRecording.get()) {
            try {
                val readResult = audioRecord?.read(buffer, 0, buffer.size) ?: 0

                if (readResult > 0) {
                    val amplitude = calculateAmplitude(buffer)
                    val dominantFrequency = calculateDominantFrequency(buffer)

                    // Update audio level callback
                    androidInterface?.updateAudioLevel(amplitude)

                    if (amplitude > threshold && System.currentTimeMillis() - lastTriggerTime > minTriggerInterval) {
                        lastTriggerTime = System.currentTimeMillis()

                        // Determine which drum to trigger based on frequency
                        when {
                            dominantFrequency < 200 -> generateAndPlayKickSound()
                            dominantFrequency < 2000 -> generateAndPlaySnareSound()
                            else -> generateAndPlayHiHatSound()
                        }

                        androidInterface?.triggerHiHat() // Keep this for now, can be changed later
                    }
                }

                delay(10) // Small delay to prevent excessive CPU usage
            } catch (e: Exception) {
                Log.e(TAG, "Error processing audio: ${e.message}")
                break
            }
        }
    }

    private fun calculateAmplitude(buffer: ShortArray): Float {
        var sum = 0.0
        for (sample in buffer) {
            sum += (sample * sample).toDouble()
        }
        val rms = sqrt(sum / buffer.size)
        return (rms / Short.MAX_VALUE).toFloat()
    }

    private fun calculateDominantFrequency(buffer: ShortArray): Int {
        // Simplified frequency detection - this is a placeholder for a more robust FFT implementation
        var zeroCrossings = 0
        for (i in 0 until buffer.size - 1) {
            if (buffer[i] > 0 && buffer[i + 1] <= 0) {
                zeroCrossings++
            }
        }
        return zeroCrossings * (sampleRate / buffer.size)
    }

    private suspend fun generateAndPlayHiHatSound() {
        if (isProcessing.get()) return
        isProcessing.set(true)

        try {
            val duration = 0.1f // 100ms duration
            val samples = (sampleRate * duration).toInt()
            val hiHatBuffer = ShortArray(samples)

            // Generate hi-hat sound (white noise with envelope)
            for (i in 0 until samples) {
                val t = i.toFloat() / sampleRate
                val envelope = calculateEnvelope(t, duration)
                val noise = (Random.nextFloat() - 0.5f) * 2.0f // White noise between -1 and 1
                hiHatBuffer[i] = (noise * envelope * Short.MAX_VALUE * 0.3f).toInt().toShort()
            }

            // Play the sound
            audioTrack?.write(hiHatBuffer, 0, hiHatBuffer.size)

        } catch (e: Exception) {
            Log.e(TAG, "Error generating hi-hat sound: ${e.message}")
        } finally {
            isProcessing.set(false)
        }
    }

    private suspend fun generateAndPlayKickSound() {
        if (isProcessing.get()) return
        isProcessing.set(true)

        try {
            val duration = 0.15f // 150ms duration
            val samples = (sampleRate * duration).toInt()
            val kickBuffer = ShortArray(samples)

            val startFreq = 120.0
            val endFreq = 40.0

            // Generate kick sound (sine wave with pitch envelope)
            for (i in 0 until samples) {
                val t = i.toFloat() / sampleRate
                val envelope = calculateEnvelope(t, duration)
                val freq = startFreq * Math.pow(endFreq / startFreq, (t / duration).toDouble())
                val sampleValue = Math.sin(2.0 * Math.PI * freq * t)
                kickBuffer[i] = (sampleValue * envelope * Short.MAX_VALUE * 0.8f).toInt().toShort()
            }

            // Play the sound
            audioTrack?.write(kickBuffer, 0, kickBuffer.size)

        } catch (e: Exception) {
            Log.e(TAG, "Error generating kick sound: ${e.message}")
        } finally {
            isProcessing.set(false)
        }
    }

    private suspend fun generateAndPlaySnareSound() {
        if (isProcessing.get()) return
        isProcessing.set(true)

        try {
            val duration = 0.2f // 200ms duration
            val samples = (sampleRate * duration).toInt()
            val snareBuffer = ShortArray(samples)

            // Generate snare sound (noise and sine wave)
            for (i in 0 until samples) {
                val t = i.toFloat() / sampleRate
                val envelope = calculateEnvelope(t, duration)

                // Noise component
                val noise = (Random.nextFloat() - 0.5f) * 2.0f

                // Sine wave component
                val freq = 200.0
                val sine = Math.sin(2.0 * Math.PI * freq * t)

                val combined = (noise * 0.6f + sine * 0.4f)
                snareBuffer[i] = (combined * envelope * Short.MAX_VALUE * 0.5f).toInt().toShort()
            }

            // Play the sound
            audioTrack?.write(snareBuffer, 0, snareBuffer.size)

        } catch (e: Exception) {
            Log.e(TAG, "Error generating snare sound: ${e.message}")
        } finally {
            isProcessing.set(false)
        }
    }

    private fun calculateEnvelope(t: Float, duration: Float): Float {
        val normalizedTime = t / duration
        return when {
            normalizedTime < 0.01f -> normalizedTime / 0.01f // Quick attack
            normalizedTime < 0.1f -> 1.0f - (normalizedTime - 0.01f) / 0.09f * 0.7f // Initial decay
            else -> 0.3f * (1.0f - (normalizedTime - 0.1f) / (duration - 0.1f)) // Sustain and release
        }.coerceAtLeast(0.0f)
    }

    fun release() {
        stopListening()
        audioTrack?.stop()
        audioTrack?.release()
        audioTrack = null
        coroutineScope.cancel()
    }
}
'''