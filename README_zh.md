# flutter_qrscanner

flutter_qrscanner 是一个 Flutter 插件，用于通过USB摄像头进行二维码扫描。它支持UVC（USB视频类）摄像头，提供实时二维码检测和扫描功能。目前仅支持安卓设备。

## 上手教程

### 安装
在```main.dart```中引入插件
```dart
const flutterQrscannerPlugin = FlutterQrscanner();
await flutterQrscannerPlugin.init();
```
现在，插件就已经安装完成！可以开始使用了。
### 类说明
#### FlutterQrscanner
| 方法      | 参数 | 说明                    |
| --------- | ---- | ----------------------- |
| init      |      | 初始化二维码扫描器      |
| startScan |      | 开始二维码扫描          |
| stopScan  |      | 停止二维码扫描          |
| pauseScan |      | 暂停二维码扫描          |
| resumeScan|      | 恢复二维码扫描          |

#### FlutterUVCCameraWidget
构造参数

| 参数             | 说明                          |
| ---------------- | ----------------------------- |
| name             | 相机名称                      |
| camerakey        | 相机名称关键字                |
| horizontalMirror | 是否水平镜像                  |
| degree           | 旋转角度，支持0, 90, 180, 270 |

#### FlutterQrscannerWidget
构造参数

| 参数             | 说明                                    |
| ---------------- | --------------------------------------- |
| name             | 相机名称                                |
| camerakey        | 相机名称关键字                          |
| horizontalMirror | 是否水平镜像                            |
| degree           | 旋转角度，支持0, 90, 180, 270           |
| onQRCodeDetected | 扫描到二维码时调用                      |
| scanTips         | 二维码扫描提示                          |
| controller       | FlutterQrscannerController控制器        |
| scanArea         | 扫描区域矩形                            |
| scanLineColor    | 扫描线颜色                              |
| cornerColor      | 角标颜色                                |
| borderColor      | 扫描边框颜色                            |

#### FlutterQrscannerController
| 方法         | 参数 | 说明                    |
| ------------ | ---- | ----------------------- |
| startScan    |      | 开始二维码扫描          |
| stopScan     |      | 停止二维码扫描          |
| pauseScan    |      | 暂停二维码扫描          |
| resumeScan   |      | 恢复二维码扫描          |
| restartScan  |      | 重新开始二维码扫描      |
| setScanArea  | left, top, width, height | 设置扫描区域 |
| setScanParams| enableBeep, enableVibration, scanInterval | 设置扫描参数 |

## 使用示例

```dart
import 'package:flutter_qrscanner/flutter_qrscanner.dart';

class QRScannerPage extends StatefulWidget {
  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  FlutterQrscannerController _controller = FlutterQrscannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterQrscannerWidget(
        name: 'USB摄像头',
        camerakey: 'CAM1',
        horizontalMirror: true,
        degree: 0,
        controller: _controller,
        onQRCodeDetected: (String qrCode) {
          print('扫描到二维码: $qrCode');
          // 处理扫描结果
        },
        scanTips: (int code, String status) {
          print('扫描状态: $status');
        },
        scanArea: const Rect.fromLTWH(50, 100, 250, 250),
        scanLineColor: Colors.red,
        cornerColor: Colors.red,
        borderColor: Colors.white,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```


