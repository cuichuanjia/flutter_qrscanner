package com.alphay.flutter.plugin.qrscanner.flutter_qrscanner.factory

import android.content.Context
import com.alphay.flutter.plugin.qrscanner.flutter_qrscanner.views.FlutterUVCCameraView
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class FlutterUVCCameraFactory(private val messenger: BinaryMessenger, private val activityBinding: ActivityPluginBinding) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(
        context: Context,
        viewId: Int,
        args: Any?
    ): PlatformView {
        return FlutterUVCCameraView(context, viewId, messenger, activityBinding)
    }
}