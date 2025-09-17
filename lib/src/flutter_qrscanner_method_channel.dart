import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_qrscanner_platform_interface.dart';

/// An implementation of [FlutterQrscannerPlatform] that uses method channels.
class MethodChannelFlutterQrscanner extends FlutterQrscannerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_qrscanner');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  @override
  Future<void> init() async {
    return methodChannel.invokeMethod<void>('init');
  }

  @override
  Future<void> startScan() async {
    return methodChannel.invokeMethod<void>('startScan');
  }

  @override
  Future<void> stopScan() async {
    return methodChannel.invokeMethod<void>('stopScan');
  }

  @override
  Future<void> pauseScan() async {
    return methodChannel.invokeMethod<void>('pauseScan');
  }

  @override
  Future<void> resumeScan() async {
    return methodChannel.invokeMethod<void>('resumeScan');
  }
}
