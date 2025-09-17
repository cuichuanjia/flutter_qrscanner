package com.alphay.flutter.plugin.qrscanner.flutter_qrscanner.views

import android.content.Context
import android.graphics.Bitmap
import android.os.Build
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import com.alphay.flutter.plugin.qrscanner.flutter_qrscanner.R
import com.alphay.flutter.plugin.qrscanner.flutter_qrscanner.service.FlutterQrscannerEngine
import com.alphay.flutter.plugin.qrscanner.flutter_qrscanner.uvccamera.FlutterCameraBuilder
import com.alphay.flutter.plugin.qrscanner.flutter_qrscanner.uvccamera.FlutterUVCCameraManager
import com.serenegiant.widget.AspectRatioSurfaceView
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class FlutterUVCCameraView(
    private val context: Context,
    private val viewId: Int,
    private val messenger: BinaryMessenger,
    private val activityBinding: ActivityPluginBinding
) : PlatformView, MethodChannel.MethodCallHandler {

    private var nativeView: View
    private var cameraManager: FlutterUVCCameraManager? = null
    private var channel: MethodChannel
    private var TAG: String = "FlutterUVCCameraView"

    init {
        // 确保使用正确的 context 来创建 view
        nativeView = LayoutInflater.from(context).inflate(R.layout.view_camera, null, false)
        // 确保 view 与 context 正确关联
        if (nativeView.parent != null) {
            (nativeView.parent as? android.view.ViewGroup)?.removeView(nativeView)
        }
        channel = MethodChannel(messenger, "flutter_qrscanner_view_" + viewId)
        channel.setMethodCallHandler(this)
        
        // 添加Android版本兼容性检查
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) {
            Log.w(TAG, "当前Android版本 ${Build.VERSION.SDK_INT} 可能存在ImageTextureEntry fence兼容性问题")
        }
    }

    private fun initCamera(param: Map<String, Any>) {
        var view: AspectRatioSurfaceView = nativeView.findViewById(R.id.surface_view)
        var cameraBuilder = FlutterCameraBuilder.Builder()
            .setCameraName(param.get("name") as String)
            .setCameraKey(param.get("key") as String)
            .setHorizontalMirror(param.get("horizontalMirror") as Boolean)
            .setDegree(param.get("degree") as Int)
            .setCameraView(view)
            .setContext(context)
            .build()
        cameraManager = FlutterUVCCameraManager(cameraBuilder)
        
        // 设置二维码扫描回调
        cameraManager!!.setFaceAIAnalysis(object :
            FlutterUVCCameraManager.OnFaceAIAnalysisCallBack {
            override fun onBitmapFrame(bitmap: Bitmap) {
                FlutterQrscannerEngine.processFrame(bitmap)
            }
        })
    }

    private fun startQrScan() {
        if (cameraManager == null) {
            throw RuntimeException("Camera has not init")
        }
        // 二维码扫描已经在initCamera中设置，这里只需要启动扫描引擎
        FlutterQrscannerEngine.startScan(channel, activityBinding)
    }

    override fun onMethodCall(
        call: MethodCall,
        result: MethodChannel.Result
    ) {
        when (call.method) {
            "init" -> {
                val param: Map<String, Any> = call.arguments as Map<String, Any>
                initCamera(param)
                result.success(true)
            }
            "startQrScan" -> {
                try {
                    startQrScan()
                    result.success(true)
                } catch (e: RuntimeException) {
                    result.error("RuntimeException", e.message, null)
                }
            }
            "startScan" -> {
                try {
                    FlutterQrscannerEngine.startScan(channel, activityBinding)
                    result.success(true)
                } catch (e: RuntimeException) {
                    result.error("RuntimeException", e.message, null)
                }
            }
            "stopScan" -> {
                try {
                    FlutterQrscannerEngine.stopScan()
                    result.success(true)
                } catch (e: RuntimeException) {
                    result.error("RuntimeException", e.message, null)
                }
            }
            "pauseScan" -> {
                try {
                    FlutterQrscannerEngine.pauseScan()
                    result.success(true)
                } catch (e: RuntimeException) {
                    result.error("RuntimeException", e.message, null)
                }
            }
            "resumeScan" -> {
                try {
                    FlutterQrscannerEngine.resumeScan()
                    result.success(true)
                } catch (e: RuntimeException) {
                    result.error("RuntimeException", e.message, null)
                }
            }
            "restartScan" -> {
                try {
                    // 先停止扫描
                    FlutterQrscannerEngine.stopScan()
                    // 延迟重新开始扫描，确保停止操作完成
                    android.os.Handler(android.os.Looper.getMainLooper()).postDelayed({
                        try {
                            FlutterQrscannerEngine.startScan(channel, activityBinding)
                        } catch (e: Exception) {
                            Log.e(TAG, "重启扫描失败", e)
                        }
                    }, 100)
                    result.success(true)
                } catch (e: RuntimeException) {
                    Log.e(TAG, "重启扫描异常", e)
                    result.error("RuntimeException", e.message, null)
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }


    override fun getView(): View? {
        return nativeView
    }

    override fun dispose() {
        FlutterQrscannerEngine.stopScan()
        cameraManager?.releaseCameraHelper()
    }

}