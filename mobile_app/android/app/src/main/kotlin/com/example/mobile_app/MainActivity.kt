package com.example.mobile_app

import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.os.PersistableBundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {
    private val channelName = "com.identified.mw_insider"
    private var forService: Intent? = null;

    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        super.onCreate(savedInstanceState, persistentState)
        forService = Intent(this@MainActivity, MyService::class.java)
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setMethodCallHandler { call, result ->
            if (call.method == "startService"){
                startService()
                result.success("Service started!")
            }
            else if (call.method == "stopService"){
                if (forService != null){
                    stopService(forService)
                }
                result.success("Service stopped!")
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        if (forService != null){
            stopService(forService)
        }
    }

    private fun startService() {
        if (forService == null){
            forService = Intent(this@MainActivity, MyService::class.java)
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
            startForegroundService(forService)
        } else {
            startService(forService)
        }
    }
}
