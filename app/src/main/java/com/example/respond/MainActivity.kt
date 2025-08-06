package com.example.respond

import android.Manifest
import android.content.pm.PackageManager
import android.media.AudioFormat
import android.media.AudioRecord
import android.media.MediaRecorder
import android.os.Bundle
import android.util.Log
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.tween
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.material3.Button
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableFloatStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.core.content.ContextCompat
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleEventObserver
import androidx.lifecycle.lifecycleScope
import com.example.respond.ui.theme.RespondTheme
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.isActive
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import kotlin.math.log10

class MainActivity : ComponentActivity() {

    private var audioRecord: AudioRecord? = null
    private var recordingJob: Job? = null
    // bufferSize calculation relies on constants, not composable context
    private val bufferSize = AudioRecord.getMinBufferSize(
        SAMPLE_RATE,
        CHANNEL_CONFIG,
        AUDIO_FORMAT,
    )

    private val requestPermissionLauncher = registerForActivityResult(
        ActivityResultContracts.RequestPermission(),
    ) { isGranted: Boolean ->
        if (isGranted) {
            Log.d(TAG, "RECORD_AUDIO permission granted")
            // The UI state for hasAudioPermission will be updated on next recomposition
        } else {
            Log.w(TAG, "RECORD_AUDIO permission denied")
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            RespondTheme { // MaterialTheme context starts here
                var currentAmplitude by remember { mutableFloatStateOf(0f) }
                var isRecordingActive by remember { mutableStateOf(false) }
                var hasAudioPermission by remember {
                    mutableStateOf(
                        ContextCompat.checkSelfPermission(
                            this, // Context is available here
                            Manifest.permission.RECORD_AUDIO,
                        ) == PackageManager.PERMISSION_GRANTED,
                    )
                }

                val lifecycleOwner = androidx.lifecycle.compose.LocalLifecycleOwner.current
                val context = LocalContext.current // Context within Composable scope

                DisposableEffect(lifecycleOwner, context) {
                    val observer = LifecycleEventObserver { _, event ->
                        when (event) {
                            Lifecycle.Event.ON_START -> {
                                hasAudioPermission = ContextCompat.checkSelfPermission(
                                    context,
                                    Manifest.permission.RECORD_AUDIO,
                                ) == PackageManager.PERMISSION_GRANTED
                            }
                            Lifecycle.Event.ON_STOP -> {
                                stopRecording()
                                isRecordingActive = false
                            }
                            Lifecycle.Event.ON_DESTROY -> {
                                stopRecording()
                            }
                            else -> {}
                        }
                    }
                    lifecycleOwner.lifecycle.addObserver(observer)
                    onDispose {
                        lifecycleOwner.lifecycle.removeObserver(observer)
                    }
                }

                Scaffold(modifier = Modifier.fillMaxSize()) { innerPadding ->
                    Column(
                        modifier = Modifier
                            .fillMaxSize()
                            .padding(innerPadding)
                            .background(MaterialTheme.colorScheme.background), // OK now, inside Scaffold content
                        horizontalAlignment = Alignment.CenterHorizontally,
                    ) {
                        Spacer(Modifier.height(32.dp))
                        Text(
                            text = if (isRecordingActive) "Listening for sound..." else "Not listening",
                            style = MaterialTheme.typography.headlineSmall, // OK now
                            color = MaterialTheme.colorScheme.onBackground, // OK now
                        )
                        Spacer(Modifier.height(16.dp))

                        SoundVisualizer(
                            amplitude = currentAmplitude,
                            modifier = Modifier.weight(1f),
                        )

                        Spacer(Modifier.height(16.dp))

                        if (!hasAudioPermission) {
                            Button(onClick = {
                                requestPermissionLauncher.launch(Manifest.permission.RECORD_AUDIO)
                            }) {
                                Text("Request Microphone Permission")
                            }
                        } else {
                            if (isRecordingActive) {
                                Button(onClick = {
                                    stopRecording()
                                    isRecordingActive = false
                                }) {
                                    Text("Stop Listening")
                                }
                            } else {
                                Button(onClick = {
                                    if (hasAudioPermission) {
                                        startRecording { amplitude ->
                                            currentAmplitude = amplitude
                                        }
                                        isRecordingActive = true
                                    } else {
                                        Log.w(TAG, "Cannot start recording: Permission not granted.")
                                    }
                                }) {
                                    Text("Start Listening")
                                }
                            }
                        }
                        Spacer(Modifier.height(32.dp))
                    }
                }
            }
        }
    }

    private fun startRecording(onAmplitudeUpdate: (Float) -> Unit) {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.RECORD_AUDIO) != PackageManager.PERMISSION_GRANTED) {
            Log.e(TAG, "Attempted to start recording without permission.")
            return
        }

        if (audioRecord == null) {
            try {
                audioRecord = AudioRecord(
                    MediaRecorder.AudioSource.MIC,
                    SAMPLE_RATE,
                    CHANNEL_CONFIG,
                    AUDIO_FORMAT,
                    bufferSize,
                )
                audioRecord?.startRecording()
                Log.d(TAG, "AudioRecord started successfully.")

                recordingJob = lifecycleScope.launch(Dispatchers.IO) {
                    val audioBuffer = ShortArray(bufferSize / 2)
                    while (isActive && audioRecord?.recordingState == AudioRecord.RECORDSTATE_RECORDING) {
                        val result = audioRecord?.read(audioBuffer, 0, audioBuffer.size) ?: 0
                        if (result > 0) {
                            val maxAmplitude = audioBuffer.maxOrNull()?.toFloat() ?: 0f
                            val dB = if (maxAmplitude > 0) {
                                20 * log10(maxAmplitude / MAX_SHORT_VALUE.toFloat())
                            } else {
                                MIN_DB_VALUE
                            }
                            // Map dB to a 0-1 range. This mapping is crucial.
                            // Adjusting MIN_DB_VALUE impacts sensitivity.
                            // A higher MIN_DB_VALUE means quieter sounds will register higher.
                            // A lower MIN_DB_VALUE means quieter sounds will be closer to 0.
                            val mappedAmplitude = ((dB - MIN_DB_VALUE) / (0f - MIN_DB_VALUE)).coerceIn(0f, 1f)

                            withContext(Dispatchers.Main) {
                                onAmplitudeUpdate(mappedAmplitude)
                            }
                            delay(5) // Adjust this delay to control update frequency
                        }
                    }
                    Log.d(TAG, "Recording job finished.")
                }
            } catch (e: SecurityException) {
                Log.e(TAG, "SecurityException: RECORD_AUDIO permission not granted.", e)
            } catch (e: Exception) {
                Log.e(TAG, "Error initializing or starting AudioRecord: ${e.message}", e)
                stopRecording()
            }
        }
    }

    private fun stopRecording() {
        recordingJob?.cancel()
        recordingJob = null
        audioRecord?.apply {
            if (state == AudioRecord.STATE_INITIALIZED) {
                try {
                    if (recordingState == AudioRecord.RECORDSTATE_RECORDING) {
                        stop()
                    }
                    release()
                    Log.d(TAG, "AudioRecord stopped and released.")
                } catch (e: IllegalStateException) {
                    Log.e(TAG, "IllegalStateException during AudioRecord stop/release: ${e.message}")
                }
            } else {
                Log.d(TAG, "AudioRecord not initialized, nothing to stop/release.")
            }
        }
        audioRecord = null
    }

    override fun onDestroy() {
        super.onDestroy()
        stopRecording()
    }

    companion object {
        private const val TAG = "AudioVisualizerApp"
        private const val SAMPLE_RATE = 44100 // Hz
        private const val CHANNEL_CONFIG = AudioFormat.CHANNEL_IN_MONO
        private const val AUDIO_FORMAT = AudioFormat.ENCODING_PCM_16BIT
        private const val MAX_SHORT_VALUE = 32767 // Max value for 16-bit signed short
        // Adjust MIN_DB_VALUE to control sensitivity to quiet sounds.
        // A value closer to 0 dB makes the visualizer more sensitive to even low sounds.
        // A value further from 0 dB (e.g., -90f) means it will only react to louder sounds.
        private const val MIN_DB_VALUE = -70f // Adjusted for potentially more responsiveness to quieter sounds
    }
}


@Composable
fun SoundVisualizer(amplitude: Float, modifier: Modifier = Modifier) {
    val animatedAmplitude by animateFloatAsState(
        targetValue = amplitude,
        animationSpec = tween(durationMillis = 50), // Reduced duration for snappier animation
        label = "amplitudeAnimation",
    )

    Box(
        modifier = modifier.fillMaxSize(),
        contentAlignment = Alignment.Center,
    ) {
        Canvas(
            modifier = Modifier.size(200.dp)
        ) {
            // Scale the radius to make the visualizer more reactive.
            // Multiplying animatedAmplitude by a factor greater than 1 makes the visual change more pronounced.
            val maxRadius = size.minDimension / 2
            val minRadius = 10.dp.toPx()
            // Map the 0-1 amplitude to a radius range.
            // Start from a base (minRadius) and add a scaled portion of the amplitude.
            val visualRadius = minRadius + (maxRadius - minRadius) * animatedAmplitude

            drawCircle(
                color = Color.Yellow,
                radius = visualRadius.coerceAtLeast(minRadius),
                center = Offset(size.width / 2, size.height / 2),
                style = Stroke(width = 4.dp.toPx()),
            )
            drawCircle(
                color = Color.Red,
                // The inner circle could be slightly smaller or based on amplitude * a different factor
                radius = visualRadius.coerceAtLeast(minRadius) * 0.8f, // Inner circle slightly smaller
                center = Offset(size.width / 2, size.height / 2),
            )
        }
    }
}

@Preview(showBackground = true)
@Composable
fun SoundVisualizerPreview() {
    RespondTheme {
        Column {
            Text("Preview of 0.1 amplitude")
            SoundVisualizer(amplitude = 0.1f, modifier = Modifier.height(150.dp))
            Spacer(Modifier.height(20.dp))
            Text("Preview of 0.5 amplitude")
            SoundVisualizer(amplitude = 0.5f, modifier = Modifier.height(150.dp))
            Spacer(Modifier.height(20.dp))
            Text("Preview of 0.9 amplitude")
            SoundVisualizer(amplitude = 0.9f, modifier = Modifier.height(150.dp)) // Corrected to 0.9f for preview
        }
    }
}