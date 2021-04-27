package com.example.mobile_app

import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat

class MyService : Service() {
    override fun onCreate() {
        super.onCreate()
        
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
            val notificationBuilder = NotificationCompat.Builder(this, "messages")
            notificationBuilder.setContentText("This app is currently tracking your location")
            notificationBuilder.setContentTitle("MW Insider tracking")
            notificationBuilder.setSmallIcon(R.drawable.small_logo)

            startForeground(101, notificationBuilder.build())
        }
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }
}