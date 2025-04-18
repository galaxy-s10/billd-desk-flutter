package com.example.billd_desk_flutter_pro

import android.graphics.Path

import android.accessibilityservice.GestureDescription
import android.accessibilityservice.AccessibilityService
import android.view.accessibility.AccessibilityEvent
import org.json.JSONObject
import org.json.JSONArray

import android.os.Handler
import android.os.Looper
import java.util.Timer
import java.util.TimerTask
import android.content.Intent


class MyAccessibilityService : AccessibilityService() {
    companion object {
        var instance: MyAccessibilityService? = null

        data class Point(val x: Float, val y: Float, val d: Long, val end: Boolean = false)

        var list: Array<Point> = arrayOf()

        var index: Int = 0

        var start: Boolean = false
        var lock: Boolean = false
        var timer: Timer? = null

        var upLock: Boolean = false

    }


    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        // 处理无障碍事件
        println("处理无障碍事件-onAccessibilityEvent")
    }

    override fun onInterrupt() {
        // 处理中断
        println("处理中断-onInterrupt")
    }

    override fun onServiceConnected() {
        println("连接-onServiceConnected")
        instance = this
    }

    fun performBackButton() {
        println("模拟返回键")
        performGlobalAction(GLOBAL_ACTION_BACK)
    }

    fun performHomeButton() {
        println("模拟home键")
        val homeIntent = Intent(Intent.ACTION_MAIN)
        homeIntent.addCategory(Intent.CATEGORY_HOME)
        homeIntent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        startActivity(homeIntent)
    }

    fun performMenuButton() {
        println("模拟menu键")
        performGlobalAction(GLOBAL_ACTION_RECENTS)
    }

    fun performDown(x: Float, y: Float, duration: Long) {
        println("模拟点击特定坐标-模拟鼠标按下")
        println("x:$x,y:$y,duration:$duration")
        val builder = GestureDescription.Builder()
        val path = Path()
        path.moveTo(x, y)
        path.lineTo(x, y)
        builder.addStroke(GestureDescription.StrokeDescription(path, 0, duration, true))
        val gesture = builder.build()
        dispatchGesture(gesture, object : AccessibilityService.GestureResultCallback() {
            override fun onCancelled(gestureDescription: GestureDescription) {
                println("模拟点击特定坐标-模拟鼠标按下取消,x:$x,y:$y")
            }

            override fun onCompleted(gestureDescription: GestureDescription) {
                println("模拟点击特定坐标-模拟鼠标按下完成,x:$x,y:$y")
            }
        }, null)
    }

    fun performUp(x: Float, y: Float, duration: Long, end: Boolean) {
        println("模拟点击特定坐标-模拟鼠标松开")
        println("x:$x,y:$y,duration:$duration")
        upLock = true
        var size = list.size
        println("upp,index:$index,size:$size")
        var lastX = x
        var lastY = y
        if (index < size) {
            var currentPoint = list.get(index)
            lastX = currentPoint.x
            lastY = currentPoint.y
        }


        start = false
        list = arrayOf()
        index = 0
        if (timer != null) {
            timer?.cancel()
            timer = null
        }

        val handler = Handler(Looper.getMainLooper())
        handler.postDelayed({
            upLock = false
        }, 100)

        val builder = GestureDescription.Builder()
        val path = Path()
        path.moveTo(lastX, lastY)
        path.lineTo(x, y)
        builder.addStroke(GestureDescription.StrokeDescription(path, 0, duration, !end))
        val gesture = builder.build()
        dispatchGesture(gesture, object : AccessibilityService.GestureResultCallback() {
            override fun onCancelled(gestureDescription: GestureDescription) {
                println("模拟点击特定坐标-模拟鼠标松开取消,x:$x,y:$y")
            }

            override fun onCompleted(gestureDescription: GestureDescription) {
                println("模拟点击特定坐标-模拟鼠标松开完成,x:$x,y:$y")
            }
        }, null)
    }

    // 模拟点击特定坐标
    fun performMove(arr: JSONArray) {
        println("模拟点击特定坐标-鼠标滑动")

        if (arr.length() == 0) {
            println("模拟点击特定坐标-鼠标滑动退出-arr长度是0")
            return
        }
        // 遍历 JSONArray 中的每个元素
        for (i in 0 until arr.length()) {
            // 获取每个 JSON 对象
            val jsonObject: JSONObject = arr.getJSONObject(i)

            // 提取坐标和其他信息
            val x = jsonObject.getDouble("x").toFloat()
            val y = jsonObject.getDouble("y").toFloat()
            val d = jsonObject.getDouble("d").toLong()

            list = arrayOf(*list, Point(x, y, d))
        }
        println("listtpptt,${list.size}")

        if (start) {
            println("模拟点击特定坐标-鼠标滑动退出-start了,index:$index,listsize,${list.size}")
            return
        }
        start = true

        fun loop(currentIndex: Int, previousStroke: GestureDescription.StrokeDescription) {
            println("进入loop,currentIndex:$currentIndex")
            lock = true
            if (upLock) {
                println("模拟点击特定坐标-鼠标滑动退出-loop-upLock")
                return
            }
            var size = list.size
            if (size <= 0) {
                println("模拟点击特定坐标-鼠标滑动退出-loop-数组无了")
                return
            }
            if (currentIndex > size - 1) {
                println("模拟点击特定坐标-鼠标滑动退出-loop-当前下标大于长度,currentIndex:$currentIndex,size:$size")
                val handler = Handler(Looper.getMainLooper())
                handler.postDelayed({
                    loop(currentIndex, previousStroke)
                }, 1)
                return
            }
            if (currentIndex - 1 > size - 1) {
                println("模拟点击特定坐标-鼠标滑动退出-loop-前一位的下标大于长度,currentIndex:$currentIndex,size:$size")
                val handler = Handler(Looper.getMainLooper())
                handler.postDelayed({
                    loop(currentIndex, previousStroke)
                }, 1)
                return
            }
            if (currentIndex - 1 < 0) {
                println("模拟点击特定坐标-鼠标滑动退出-loop-前一位的下标小于0,currentIndex:$currentIndex,size:$size")
                val handler = Handler(Looper.getMainLooper())
                handler.postDelayed({
                    loop(currentIndex, previousStroke)
                }, 1)
                return
            }

            var moveToX = 0f
            var moveToY = 0f
            var lineToX = 0f
            var lineToY = 0f
            var d = 10L

            val moveToPoint = list.get(currentIndex - 1)
            moveToX = moveToPoint.x
            moveToY = moveToPoint.y

            val lineToPoint = list.get(currentIndex)
            lineToX = lineToPoint.x
            lineToY = lineToPoint.y
            d = lineToPoint.d

            val continuePath = Path()
            continuePath.moveTo(moveToX, moveToY)
            continuePath.lineTo(lineToX, lineToY)
            println("模拟拟点击特定坐标loop,currentIndex:$currentIndex,moveToX:$moveToX,moveToY:$moveToY,lineToX:$lineToX,lineToY:$lineToY,duration:$d")
            val sdContinue = previousStroke.continueStroke(continuePath, 0, d, true)

            val builder = GestureDescription.Builder()
            builder.addStroke(sdContinue)
            val gesture = builder.build()

            println("dispatchGestureee,2,moveToX:$moveToX,moveToY:$moveToY,lineToX:$lineToX,lineToY:$lineToY,duration:$d")
            dispatchGesture(gesture, object : AccessibilityService.GestureResultCallback() {
                override fun onCancelled(gestureDescription: GestureDescription) {
                    println("模拟点击特定坐标-鼠标滑动取消-loop-手势取消,moveToX:$moveToX,moveToY:$moveToY,lineToX:$lineToX,lineToY:$lineToY")
                }

                override fun onCompleted(gestureDescription: GestureDescription) {
                    println("模拟点击特定坐标-鼠标滑动成功-loop,index:$index,moveToX:$moveToX,moveToY:$moveToY,lineToX:$lineToX,lineToY:$lineToY")
                    index = index + 1
                    lock = false
                    loop(index, sdContinue)
                }
            }, null)

        }

        var moveToX = 0f
        var moveToY = 0f
        var lineToX = 0f
        var lineToY = 0f

        var duration = 10L



        if (list.size == 1) {
            val point = list.get(0)
            moveToX = point.x
            moveToY = point.y
            lineToX = point.x
            lineToY = point.y
            duration = point.d
        }

        // 创建路径
        val path = Path()
        path.moveTo(moveToX, moveToY)
        path.lineTo(lineToX, lineToY)
        println("xxx111,moveToX:$moveToX,moveToY:$moveToY,lineToX:$lineToX,lineToY:$lineToY,duration:$duration");

        val currentStroke = GestureDescription.StrokeDescription(path, 0, duration, true)
        val builder = GestureDescription.Builder()
        builder.addStroke(currentStroke)
        timer = Timer()
        timer?.scheduleAtFixedRate(object : TimerTask() {

            override fun run() {
                if (list.size == 0) {
                    println("list没有了")
                }
                if (lock) {
                    println("模拟点击特定坐标-鼠标滑动退出-tiemr-锁着不执行,index:$index,listsize,${list.size}")
                    return
                }
                loop(index, currentStroke)
            }
        }, 0, 5) // 每5毫秒执行一次

        // 构建手势
        val gesture = builder.build()
        println("dispatchGestureee,1,moveToX:$moveToX,moveToY:$moveToY,lineToX:$lineToX,lineToY:$lineToY,duration:$duration")
        // 直接派发手势
        dispatchGesture(gesture, object : AccessibilityService.GestureResultCallback() {
            override fun onCancelled(gestureDescription: GestureDescription) {
                println("模拟点击特定坐标-模拟鼠标滑动取消,index:$index,moveToX:$moveToX,moveToY:$moveToY,lineToX:$lineToX,lineToY:$lineToY")

            }

            override fun onCompleted(gestureDescription: GestureDescription) {
                println("模拟点击特定坐标-模拟鼠标滑动完成,index:$index,moveToX:$moveToX,moveToY:$moveToY,lineToX:$lineToX,lineToY:$lineToY")
                index = index + 1
                lock = false

            }
        }, null)

    }


    // https://cloud.tencent.com/developer/ask/sof/108389913/answer/132959522
    // StrokeDescription：https://developer.android.com/reference/android/accessibilityservice/GestureDescription.StrokeDescription.html#StrokeDescription(android.graphics.Path,%20long,%20long,%20boolean)
    // continueStroke：https://developer.android.com/reference/android/accessibilityservice/GestureDescription.StrokeDescription.html#continueStroke(android.graphics.Path,%20long,%20long,%20boolean)
    // willContinue：https://developer.android.com/reference/android/accessibilityservice/GestureDescription.StrokeDescription.html#willContinue()
    // https://stackoverflow.com/questions/56389826/why-the-continuestroke-function-is-not-work


    fun performTouchDown() {
        println("模拟点击特定坐标-performTouchDown2")
        println("start了x")
        val path1 = Path()
        // path1.moveTo(360f, 2200f)
        // path1.lineTo(370f, 2100f)
        path1.moveTo(360f, 2200f)
        path1.lineTo(360f, 2200f)
        val sd1 = GestureDescription.StrokeDescription(path1, 0, 1L, true)

        val builder = GestureDescription.Builder()
        builder.addStroke(sd1)
        val gesture = builder.build()

        val handler = Handler(Looper.getMainLooper())
        handler.postDelayed({
            val path2 = Path()
            path2.moveTo(360f, 2200f)
            path2.lineTo(360f, 2200f)
            val sd2 = sd1.continueStroke(path2, 0, 500L, true)
            // val sd2 = GestureDescription.StrokeDescription(path2, 0, 1500L, true)

            val builder = GestureDescription.Builder()
            builder.addStroke(sd2)
            val gesture = builder.build()
            dispatchGesture(gesture, object : AccessibilityService.GestureResultCallback() {
                override fun onCancelled(gestureDescription: GestureDescription) {
                    println("模拟点击特定坐标-postDelayed-performTouchDown2取消")
                }

                override fun onCompleted(gestureDescription: GestureDescription) {
                    println("模拟点击特定坐标-postDelayed-performTouchDown2完成")
                }
            }, null)
            println("dfdf")
        }, 1000)

        dispatchGesture(gesture, object : AccessibilityService.GestureResultCallback() {
            override fun onCancelled(gestureDescription: GestureDescription) {
                println("模拟点击特定坐标-performTouchDown2取消")
            }

            override fun onCompleted(gestureDescription: GestureDescription) {
                println("模拟点击特定坐标-performTouchDown2完成")
            }
        }, null)
    }


}