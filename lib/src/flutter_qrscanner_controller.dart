import 'package:flutter/services.dart';

class FlutterQrscannerController {
  MethodChannel? _channel;

  void setChannel(MethodChannel channel) {
    _channel = channel;
  }

  /// 开始扫描
  Future<void> startScan() async {
    if (_channel != null) {
      await _channel!.invokeMethod('startScan');
    }
  }

  /// 停止扫描
  Future<void> stopScan() async {
    if (_channel != null) {
      await _channel!.invokeMethod('stopScan');
    }
  }

  /// 暂停扫描
  Future<void> pauseScan() async {
    if (_channel != null) {
      await _channel!.invokeMethod('pauseScan');
    }
  }

  /// 恢复扫描
  Future<void> resumeScan() async {
    if (_channel != null) {
      await _channel!.invokeMethod('resumeScan');
    }
  }

  /// 重新开始扫描
  Future<void> restartScan() async {
    if (_channel != null) {
      await _channel!.invokeMethod('restartScan');
    }
  }

  /// 设置扫描区域
  Future<void> setScanArea(double left, double top, double width, double height) async {
    if (_channel != null) {
      await _channel!.invokeMethod('setScanArea', {
        'left': left,
        'top': top,
        'width': width,
        'height': height,
      });
    }
  }

  /// 设置扫描参数
  Future<void> setScanParams({
    bool? enableBeep,
    bool? enableVibration,
    int? scanInterval,
  }) async {
    if (_channel != null) {
      await _channel!.invokeMethod('setScanParams', {
        'enableBeep': enableBeep,
        'enableVibration': enableVibration,
        'scanInterval': scanInterval,
      });
    }
  }

  void dispose() {
    _channel = null;
  }
}
