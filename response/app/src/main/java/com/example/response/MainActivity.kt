package com.example.response

import android.os.Bundle
import android.widget.FrameLayout
import androidx.appcompat.app.AppCompatActivity
import org.qtproject.example.UntitledProject7App.UntitledProject7Content.Screen01
import org.qtproject.qt.android.QtQuickView
import org.qtproject.qt.android.QtQuickViewContent

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        // 1. Instantiate your generated QML content class
        val qtContent = Screen01()
        val qtView = QtQuickView(this)
        val qtFrame = findViewById<FrameLayout>(R.id.quickframe)
        qtFrame.addView(qtView)
        qtView.loadContent(qtContent)
    }
}