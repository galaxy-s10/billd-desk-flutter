import java.util.Timer
import java.util.TimerTask

fun main() {
    val timer = Timer()
    timer.scheduleAtFixedRate(object : TimerTask() {
        var count = 0
        
        override fun run() {
            if (count < 5) {
                println("轮询次数: $count")
                count++
            } else {
                timer.cancel() // 结束定时器
            }
        }
    }, 0, 1000) // 每秒执行一次
}