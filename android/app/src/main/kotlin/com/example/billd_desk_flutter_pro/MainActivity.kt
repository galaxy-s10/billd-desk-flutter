package com.example.billd_desk_flutter_pro

import android.content.Context;
import android.provider.Settings;

import android.text.TextUtils
import android.content.Intent
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject
import android.util.DisplayMetrics
import android.view.WindowManager
import android.content.ComponentName
import org.json.JSONArray
import org.json.JSONException
import android.media.AudioManager

import java.lang.reflect.InvocationTargetException
import java.lang.reflect.Method
import android.os.Bundle
import android.os.Build

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.billd_desk_flutter_pro/channel"

    private var volumeDialogHelper: Any? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        // 调用父类的 onCreate 方法，确保 Flutter 环境正常初始化
        super.onCreate(savedInstanceState)
        println("MainActivity---onCreate")
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getMessage") {
                val message = "Hello Kotlin!"
                result.success(message)
            } else if (call.method == "getDeviceInfo") {
                val brand = Build.BRAND
                val model = Build.MODEL
                val androidVersion = Build.VERSION.RELEASE
                val obj = JSONObject()
                obj.put("brand", brand)
                obj.put("model", model)
                obj.put("androidVersion", androidVersion)
                result.success(obj)
            } else if (call.method == "isAccessibilityServiceEnabled") {
                result.success(isAccessibilityServiceEnabled())
            } else if (call.method == "enableAccessibility") {
                // 打开无障碍设置
                startActivity(Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS))
            } else if (call.method == "performMove") {
                println("执行-performMove")
                val json = call.argument<String>("json") ?: ""
                val jsondata = JSONObject(json)
                val arr = jsondata.getJSONArray("arr")
                val service = MyAccessibilityService.instance
                service?.performMove(arr)
            } else if (call.method == "performDown") {
                println("执行-performDown")
                val x = call.argument<Double>("x") ?: 0f
                val y = call.argument<Double>("y") ?: 0f
                val d = call.argument<Int>("d") ?: 0
                val service = MyAccessibilityService.instance
                service?.performDown(x.toFloat(), y.toFloat(), d.toLong())
            } else if (call.method == "performTouchDown") {
                println("执行-performTouchDown")
                val service = MyAccessibilityService.instance
                service?.performTouchDown()
            } else if (call.method == "performUp") {
                println("执行-performUp")
                val x = call.argument<Double>("x") ?: 0f
                val y = call.argument<Double>("y") ?: 0f
                val d = call.argument<Int>("d") ?: 0
                val end = call.argument<Boolean>("end") ?: false
                val service = MyAccessibilityService.instance
                service?.performUp(x.toFloat(), y.toFloat(), d.toLong(), end)
            } else if (call.method == "displayMetrics") {
                println("执行displayMetrics")
                val displayMetrics = DisplayMetrics()
                val windowManager = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager
                windowManager.defaultDisplay.getRealMetrics(displayMetrics)
                val obj = JSONObject()
                obj.put("width", displayMetrics.widthPixels)
                obj.put("height", displayMetrics.heightPixels)
                result.success(obj.toString())
            } else if (call.method == "phoneVolumeUp") {
                println("phoneVolumeUp")
                // https://cloud.tencent.com/developer/article/1524594
                // 获取 AudioManager 实例
                val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
                // 增加音乐音量，第三个参数 flags：FLAG_PLAY_SOUND 调整音量时播放声音、FLAG_SHOW_UI 调整时显示系统的音量进度条、0 表示什么都不做
                audioManager.adjustStreamVolume(AudioManager.STREAM_MUSIC, AudioManager.ADJUST_RAISE, AudioManager.FLAG_SHOW_UI)
            } else if (call.method == "phoneVolumeDown") {
                println("phoneVolumeDown")
                // 获取 AudioManager 实例
                val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
                // 减少音乐音量，第三个参数 flags：FLAG_PLAY_SOUND 调整音量时播放声音、FLAG_SHOW_UI 调整时显示系统的音量进度条、0 表示什么都不做
                audioManager.adjustStreamVolume(AudioManager.STREAM_MUSIC, AudioManager.ADJUST_LOWER, AudioManager.FLAG_SHOW_UI)
            } else if (call.method == "phoneVolumeShow") {
                println("phoneVolumeShow")
                // 获取 AudioManager 实例
                val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
                // 显示音乐音量，第三个参数 flags：FLAG_PLAY_SOUND 调整音量时播放声音、FLAG_SHOW_UI 调整时显示系统的音量进度条、0 表示什么都不做
                audioManager.adjustStreamVolume(AudioManager.STREAM_MUSIC, AudioManager.ADJUST_SAME, AudioManager.FLAG_SHOW_UI)
            } else if (call.method == "phoneBackButton") {
                println("phoneBackButton")
                val service = MyAccessibilityService.instance
                service?.performBackButton()
            } else if (call.method == "phoneHomeButton") {
                println("phoneHomeButton")
                val service = MyAccessibilityService.instance
                service?.performHomeButton()
            } else if (call.method == "phoneMenuButton") {
                println("phoneMenuButton")
                val service = MyAccessibilityService.instance
                service?.performMenuButton()
            } else {
                println("其他未处理method")
                // result.notImplemented()这个可以不加
                result.notImplemented()
            }
        }
    }

    private fun isAccessibilityServiceEnabled(): Boolean {
        val settingValue = Settings.Secure.getString(applicationContext.contentResolver, Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES)
        if (TextUtils.isEmpty(settingValue)) {
            return false
        }
        val colonSplitter = TextUtils.SimpleStringSplitter(':')
        colonSplitter.setString(settingValue)
        while (colonSplitter.hasNext()) {
            val accessibilityService = colonSplitter.next()
            val componentName = ComponentName.unflattenFromString(accessibilityService)
            if (componentName != null) {
                if (componentName.className == "com.example.billd_desk_flutter_pro.MyAccessibilityService") {
                    return true
                }
            }
        }
        return false
    }


}
