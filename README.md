# flutter_qrscanner

flutter_qrscanner is a Flutter plugin for QR code scanning using USB cameras. It supports UVC (USB Video Class) cameras and provides real-time QR code detection and scanning functionality. Currently only supports Android devices.

## Getting Started

### Installation
Import the plugin in ```main.dart```
```dart
const flutterQrscannerPlugin = FlutterQrscanner();
await flutterQrscannerPlugin.init();
```
Now the plugin is installed! You can start using it.

### Class Documentation
#### FlutterQrscanner
| Method      | Parameters | Description                    |
| ----------- | ---------- | ------------------------------ |
| init        |            | Initialize the QR scanner     |
| startScan   |            | Start QR code scanning         |
| stopScan    |            | Stop QR code scanning          |
| pauseScan   |            | Pause QR code scanning         |
| resumeScan  |            | Resume QR code scanning        |

#### FlutterUVCCameraWidget
Constructor Parameters

| Parameter        | Description                              |
| ---------------- | ---------------------------------------- |
| name             | Camera name                              |
| camerakey        | Camera name keyword                      |
| horizontalMirror | Whether to mirror horizontally           |
| degree           | Rotation angle, supports 0, 90, 180, 270 |

#### FlutterQrscannerWidget
Constructor Parameters

| Parameter        | Description                                  |
| ---------------- | -------------------------------------------- |
| name             | Camera name                                  |
| camerakey        | Camera name keyword                          |
| horizontalMirror | Whether to mirror horizontally               |
| degree           | Rotation angle, supports 0, 90, 180, 270     |
| onQRCodeDetected | Called when QR code is detected              |
| scanTips         | QR scanning tips                             |
| controller       | FlutterQrscannerController controller        |
| scanArea         | Scanning area rectangle                     |
| scanLineColor    | Color of the scanning line                  |
| cornerColor      | Color of the corner markers                 |
| borderColor      | Color of the scanning border                |

#### FlutterQrscannerController
| Method        | Parameters | Description                    |
| ------------- | ---------- | ------------------------------ |
| startScan     |            | Start QR code scanning         |
| stopScan      |            | Stop QR code scanning          |
| pauseScan     |            | Pause QR code scanning         |
| resumeScan    |            | Resume QR code scanning        |
| restartScan   |            | Restart QR code scanning       |
| setScanArea   | left, top, width, height | Set scanning area |
| setScanParams | enableBeep, enableVibration, scanInterval | Set scanning parameters |

## Usage Example

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

