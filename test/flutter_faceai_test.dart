import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_faceai/flutter_faceai.dart';
import 'package:flutter_faceai/flutter_faceai_platform_interface.dart';
import 'package:flutter_faceai/src/flutter_faceai_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterFaceaiPlatform
    with MockPlatformInterfaceMixin
    implements FlutterFaceaiPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterFaceaiPlatform initialPlatform = FlutterFaceaiPlatform.instance;

  test('$MethodChannelFlutterFaceai is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterFaceai>());
  });

  test('getPlatformVersion', () async {
    FlutterFaceai flutterFaceaiPlugin = FlutterFaceai();
    MockFlutterFaceaiPlatform fakePlatform = MockFlutterFaceaiPlatform();
    FlutterFaceaiPlatform.instance = fakePlatform;

    expect(await flutterFaceaiPlugin.getPlatformVersion(), '42');
  });
}
