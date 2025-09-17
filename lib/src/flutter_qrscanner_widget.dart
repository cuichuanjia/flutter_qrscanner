import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'flutter_qrscanner_controller.dart';

class FlutterQrscannerWidget extends StatelessWidget {
  const FlutterQrscannerWidget({
    super.key,
    required this.name,
    required this.camerakey,
    required this.horizontalMirror,
    required this.degree,
    required this.onQRCodeDetected,
    required this.scanTips,
    this.controller,
  });

  final String name;
  final String camerakey;
  final bool horizontalMirror;
  final int degree;
  final Function(String) onQRCodeDetected;
  final Function(int, String) scanTips;
  final FlutterQrscannerController? controller;

  Future<void> _qrScanInit_onCompleted(
    MethodCall call,
    MethodChannel channel,
  ) async {
    if (call.method == 'qrCodeDetected') {
      final result = (call.arguments as Map).cast<String, dynamic>();
      final qrCode = result['qrCode'] as String;
      onQRCodeDetected(qrCode);
    } else if (call.method == 'scanTips') {
      String status = '';
      final code = call.arguments as int;
      switch (code) {
        case 0:
          status = '请将二维码放入扫描框内';
          break;
        case 1:
          status = '正在识别...';
          break;
        case 2:
          status = '识别成功';
          break;
        case 3:
          status = '识别失败，请重试';
          break;
        case 4:
          status = '摄像头初始化失败';
          break;
        case 5:
          status = '摄像头权限被拒绝';
          break;
      }
      scanTips(code, status);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AndroidView(
      viewType: 'flutter_uvc_camera_view',
      onPlatformViewCreated: (viewId) {
        final channel = MethodChannel('flutter_qrscanner_view_$viewId');
        channel.setMethodCallHandler(
          (call) => _qrScanInit_onCompleted(call, channel),
        );
        // 如果提供了控制器，将MethodChannel设置到控制器中
        controller?.setChannel(channel);
        _initCamera(channel);
      },
    );
  }


  Future<void> _startQrScan(MethodChannel channel) async {
    await channel.invokeMethod('startQrScan');
  }

  // 提取初始化方法，便于复用和异常处理
  Future<void> _initCamera(MethodChannel channel) async {
    try {
      await channel.invokeMethod('init', {
        "name": name,
        "key": camerakey,
        "horizontalMirror": horizontalMirror,
        "degree": degree,
      });
      _startQrScan(channel);
    } on PlatformException catch (e) {
      print('摄像头初始化失败: ${e.message}');
      // 调用扫描提示回调，通知初始化失败
      scanTips(4, '摄像头初始化失败');
    } catch (e) {
      print('未知错误: $e');
      scanTips(4, '摄像头初始化失败');
    }
  }
}

