import QtQuick

QtObject {
    id: audioBridge
    
    // Properties to expose to QML
    property bool isListening: audioInterface ? audioInterface.isListening : false
    property real audioLevel: audioInterface ? audioInterface.audioLevel : 0.0
    property int triggerCount: audioInterface ? audioInterface.triggerCount : 0
    
    // Signals for QML to connect to
    signal listeningStarted()
    signal listeningStopped()
    signal hiHatTriggered()
    signal audioLevelChanged(real level)
    
    // Connect to audioInterface signals
    Connections {
        target: audioInterface
        function onIsListeningChanged(listening) {
            if (listening) {
                listeningStarted()
            } else {
                listeningStopped()
            }
        }
        function onAudioLevelChanged(level) {
            audioLevelChanged(level)
        }
        function onHiHatTriggered() {
            hiHatTriggered()
        }
    }
    
    // Functions to be called from Android
    function startListening() {
        if (audioInterface) {
            audioInterface.startListening()
        }
    }
    
    function stopListening() {
        if (audioInterface) {
            audioInterface.stopListening()
        }
    }
    
    function updateAudioLevel(level) {
        // This is now handled by the audioInterface property binding
    }
    
    function triggerHiHat() {
        // This is now handled by the audioInterface property binding
    }
    
    function playDrumHit() {
        if (audioInterface) {
            audioInterface.playDrumHit()
        }
    }
}