package com.alphay.flutter.plugin.qrscanner.flutter_qrscanner.uvccamera

import android.content.Context
import com.alphay.flutter.plugin.qrscanner.flutter_qrscanner.bean.CamaraArgs
import com.serenegiant.widget.AspectRatioSurfaceView

/**
 * 构建管理USB摄像头（UVC协议）的参数集合Builder
 */
class FlutterCameraBuilder private constructor(
    val cameraName: String,
    val cameraKey: String,
    val context: Context,
    val cameraView: AspectRatioSurfaceView,
    val degree: Int,
    val isHorizontalMirror: Boolean
) {

    class Builder {
        var cameraName: String = ""
        var cameraKey: String = ""
        var context: Context? = null
        var cameraView: AspectRatioSurfaceView? = null
        var degree: Int = 0
        var horizontalMirror: Boolean = false

        fun fromArgs(args: CamaraArgs): Builder {
            this.cameraName = args.name
            this.cameraKey = args.key
            this.degree = args.degree
            this.horizontalMirror = args.horizontalMirror
            return this
        }

        fun setCameraName(cameraName: String): Builder {
            this.cameraName = cameraName
            return this
        }

        // RGB，IR 红外摄像头设备device.getProductName() 一般会有RGB/IR 字样关键字，也有不规范命名
        fun setCameraKey(cameraKey: String): Builder {
            this.cameraKey = cameraKey
            return this
        }

        fun setContext(context: Context): Builder {
            this.context = context
            return this
        }

        fun setCameraView(cameraView: AspectRatioSurfaceView): Builder {
            this.cameraView = cameraView
            return this
        }

        fun setDegree(degree: Int): Builder {
            this.degree = degree
            return this
        }

        fun setHorizontalMirror(horizontalMirror: Boolean): Builder {
            this.horizontalMirror = horizontalMirror
            return this
        }

        fun build(): FlutterCameraBuilder {
            return FlutterCameraBuilder(
                cameraName = cameraName,
                cameraKey = cameraKey,
                context = context!!,
                cameraView = cameraView!!,
                degree = degree,
                isHorizontalMirror = horizontalMirror
            )
        }
    }
}