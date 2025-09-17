package com.alphay.flutter.plugin.qrscanner.flutter_qrscanner

import android.util.Log
import com.alphay.flutter.plugin.qrscanner.flutter_qrscanner.factory.FlutterUVCCameraFactory
import com.alphay.flutter.plugin.qrscanner.flutter_qrscanner.service.FlutterQrscannerEngine
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** FlutterQrscannerPlugin */
class FlutterQrscannerPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    companion object {
        val TAG = FlutterQrscannerPlugin::class.simpleName
    }

    // 保存Flutter引擎绑定实例
    private var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding? = null
    private var activityBinding: ActivityPluginBinding? = null

    // 标记平台视图是否已注册
    private var isViewFactoryRegistered = false

    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_qrscanner")
        channel.setMethodCallHandler(this)
        this.flutterPluginBinding = flutterPluginBinding
    }


    // 注册平台视图工厂的方法
    private fun registerViewFactoryIfNeeded() {
        if (!isViewFactoryRegistered && flutterPluginBinding != null && activityBinding != null) {
            try {
                // 注册原生视图工厂
                flutterPluginBinding!!.platformViewRegistry.registerViewFactory(
                    "flutter_uvc_camera_view",
                    FlutterUVCCameraFactory(
                        flutterPluginBinding!!.binaryMessenger,
                        activityBinding!!
                    )
                )
                Log.i(TAG, "UI注册成功")
                isViewFactoryRegistered = true
            } catch (e: Exception) {
                // 如果注册失败，记录错误但不崩溃
                Log.e("FlutterFaceaiPlugin", "Failed to register view factory", e)
            }
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "init" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
                registerViewFactoryIfNeeded()
            }
            "startScan" -> {
                FlutterQrscannerEngine.startScan(channel, activityBinding!!)
                result.success(true)
            }
            "stopScan" -> {
                FlutterQrscannerEngine.stopScan()
                result.success(true)
            }
            "pauseScan" -> {
                FlutterQrscannerEngine.pauseScan()
                result.success(true)
            }
            "resumeScan" -> {
                FlutterQrscannerEngine.resumeScan()
                result.success(true)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.activityBinding = binding
    }

    override fun onDetachedFromActivityForConfigChanges() {
        this.activityBinding = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        this.activityBinding = binding

    }

    override fun onDetachedFromActivity() {
        this.activityBinding = null
    }
}
