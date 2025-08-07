package com.example.response

import kotlinx.coroutines.*

class AndroidInterface(private val activity: MainActivity, private val audioProcessor: AudioProcessor) {
    
    fun startListening() {
        audioProcessor.startListening()
    }
    
    fun stopListening() {
        audioProcessor.stopListening()
    }
    
    fun playDrumHit() {
        audioProcessor.playDrumHit()
    }
    
    fun updateAudioLevel(level: Float) {
        activity.runOnUiThread {
            activity.updateAudioLevel(level)
        }
    }
    
    fun triggerHiHat() {
        activity.runOnUiThread {
            activity.triggerHiHat()
        }
    }
}