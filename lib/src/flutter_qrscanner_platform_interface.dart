import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_qrscanner_method_channel.dart';

abstract class FlutterQrscannerPlatform extends PlatformInterface {
  /// Constructs a FlutterQrscannerPlatform.
  FlutterQrscannerPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterQrscannerPlatform _instance = MethodChannelFlutterQrscanner();

  /// The default instance of [FlutterQrscannerPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterQrscanner].
  static FlutterQrscannerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterQrscannerPlatform] when
  /// they register themselves.
  static set instance(FlutterQrscannerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> init() {
    throw UnimplementedError('init() has not been implemented.');
  }

  Future<void> startScan() {
    throw UnimplementedError('startScan() has not been implemented.');
  }

  Future<void> stopScan() {
    throw UnimplementedError('stopScan() has not been implemented.');
  }

  Future<void> pauseScan() {
    throw UnimplementedError('pauseScan() has not been implemented.');
  }

  Future<void> resumeScan() {
    throw UnimplementedError('resumeScan() has not been implemented.');
  }
}

class FlutterQrscanner {
  Future<void> init() async {
    return FlutterQrscannerPlatform.instance.init();
  }

  Future<String?> getPlatformVersion() {
    return FlutterQrscannerPlatform.instance.getPlatformVersion();
  }

  Future<void> startScan() {
    return FlutterQrscannerPlatform.instance.startScan();
  }

  Future<void> stopScan() {
    return FlutterQrscannerPlatform.instance.stopScan();
  }

  Future<void> pauseScan() {
    return FlutterQrscannerPlatform.instance.pauseScan();
  }

  Future<void> resumeScan() {
    return FlutterQrscannerPlatform.instance.resumeScan();
  }
}
