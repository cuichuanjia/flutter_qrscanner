package com.alphay.flutter.plugin.qrscanner.flutter_qrscanner.service

import android.graphics.Bitmap
import android.os.Handler
import android.os.Looper
import android.util.Log
import com.google.zxing.BarcodeFormat
import com.google.zxing.BinaryBitmap
import com.google.zxing.DecodeHintType
import com.google.zxing.MultiFormatReader
import com.google.zxing.RGBLuminanceSource
import com.google.zxing.Result
import com.google.zxing.common.HybridBinarizer
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodChannel
import java.util.*

object FlutterQrscannerEngine {
    private const val TAG = "FlutterQRScannerEngine"
    
    private var channel: MethodChannel? = null
    private var isScanning = false
    private var isPaused = false
    private val mainHandler = Handler(Looper.getMainLooper())
    
    private val reader = MultiFormatReader().apply {
        val hints = mapOf(
            DecodeHintType.POSSIBLE_FORMATS to listOf(
                BarcodeFormat.QR_CODE,
                BarcodeFormat.CODE_128,
                BarcodeFormat.CODE_39,
                BarcodeFormat.EAN_13,
                BarcodeFormat.EAN_8,
                BarcodeFormat.UPC_A,
                BarcodeFormat.UPC_E
            ),
            DecodeHintType.CHARACTER_SET to "UTF-8"
        )
        setHints(hints)
    }

    fun startScan(channel: MethodChannel, binding: ActivityPluginBinding) {
        this.channel = channel
        isScanning = true
        isPaused = false
        Log.d(TAG, "开始二维码扫描")
        
        // 发送扫描就绪状态
        channel.invokeMethod("scanTips", mapOf("code" to 0))
    }

    fun stopScan() {
        isScanning = false
        isPaused = false
        channel = null
        Log.d(TAG, "停止二维码扫描")
    }

    fun pauseScan() {
        isPaused = true
        Log.d(TAG, "暂停二维码扫描")
    }

    fun resumeScan() {
        isPaused = false
        Log.d(TAG, "恢复二维码扫描")
    }

    fun processFrame(bitmap: Bitmap) {
        if (!isScanning || isPaused || channel == null) {
            return
        }

        try {
            // 发送处理中状态 - 切换到主线程
            mainHandler.post {
                channel?.invokeMethod("scanTips", mapOf("code" to 1))
            }
            
            val result = decodeQRCode(bitmap)
            if (result != null) {
                Log.d(TAG, "二维码识别成功: ${result.text}")
                // 停止扫描避免重复识别
                isScanning = false
                // 切换到主线程发送结果
                mainHandler.post {
                    channel?.invokeMethod("qrCodeDetected", mapOf("qrCode" to result.text))
                    channel?.invokeMethod("scanTips", mapOf("code" to 2))
                }
            }
            // 移除未识别到二维码时的日志，减少日志输出
        } catch (e: Exception) {
            Log.e(TAG, "二维码处理异常", e)
            // 切换到主线程发送错误状态
            mainHandler.post {
                channel?.invokeMethod("scanTips", mapOf("code" to 3))
            }
        }
    }

    private fun decodeQRCode(bitmap: Bitmap): Result? {
        return try {
            val width = bitmap.width
            val height = bitmap.height
            val pixels = IntArray(width * height)
            bitmap.getPixels(pixels, 0, width, 0, 0, width, height)
            
            val source = RGBLuminanceSource(width, height, pixels)
            val binaryBitmap = BinaryBitmap(HybridBinarizer(source))
            
            reader.decode(binaryBitmap)
        } catch (e: Exception) {
//            Log.d(TAG, "二维码解码失败: ${e.message}")
            null
        }
    }
}
