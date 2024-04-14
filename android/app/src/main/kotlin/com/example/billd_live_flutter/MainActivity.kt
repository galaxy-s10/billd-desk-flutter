package com.example.billd_desk_flutter

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.mykotlinapp/mykotlinchannel"

    override fun onCreate(savedInstanceState: Bundle?) {
        println("-onCreate--onCreate")
        super.onCreate(savedInstanceState)
        //        setContentView(R.layout.activity_my_kotlin_page)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call,
                result ->
            if (call.method == "openKotlinPage") {
                openKotlinPage()
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun openKotlinPage() {
        println("openKotlinPageopenKotlinPage")
        val intent = android.content.Intent(this, MyKotlinActivity::class.java)
        startActivity(intent)
    }
}
