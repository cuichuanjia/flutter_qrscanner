import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FlutterUVCCameraWidget extends StatelessWidget {
  const FlutterUVCCameraWidget({
    super.key,
    required this.name,
    required this.camerakey,
    required this.horizontalMirror,
    required this.degree,
  });

  final String name;
  final String camerakey;
  final bool horizontalMirror;
  final int degree;

  @override
  Widget build(BuildContext context) {
    return AndroidView(
      viewType: 'flutter_uvc_camera_view',
      onPlatformViewCreated: (viewId) {
        final channel = MethodChannel('flutter_uvc_camera_view_$viewId');
        channel.invokeMethod('init', {
          "name": name,
          "key": camerakey,
          "horizontalMirror": horizontalMirror,
          "degree": degree,
        });
      },
    );
  }
}
