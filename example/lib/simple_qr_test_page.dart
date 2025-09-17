import 'package:flutter/material.dart';
import 'package:flutter_qrscanner/flutter_qrscanner.dart';

class SimpleQrTestPage extends StatefulWidget {
  const SimpleQrTestPage({super.key});

  @override
  State<SimpleQrTestPage> createState() => _SimpleQrTestPageState();
}

class _SimpleQrTestPageState extends State<SimpleQrTestPage> {
  FlutterQrscannerController _controller = FlutterQrscannerController();
  String _lastScannedCode = '';
  String _scanStatus = '准备扫描';
  bool _isScanning = false;

  @override
  void dispose() {
    // 在dispose时停止扫描
    _controller.stopScan();
    _controller.dispose();
    super.dispose();
  }

  void _onQRCodeDetected(String qrCode) {
    setState(() {
      _lastScannedCode = qrCode;
      _scanStatus = '扫描成功！';
      _isScanning = false; // 停止扫描状态
    });
    
    // 停止扫描
    _controller.stopScan();
    
    // 延迟显示结果对话框，避免UI冲突
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _showResult(qrCode);
      }
    });
  }

  void _onScanTips(int code, String status) {
    setState(() {
      _scanStatus = status;
    });
  }

  void _showResult(String qrCode) {
    if (!mounted) return;
    
    showDialog(
      context: context,
      barrierDismissible: false, // 防止意外关闭
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green),
              const SizedBox(width: 8),
              const Text('扫描成功'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('扫描结果：'),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: SelectableText(
                  qrCode,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _restartScan();
              },
              child: const Text('继续扫描'),
            ),
            TextButton(
              onPressed: () {
                // 停止扫描后再返回
                _controller.stopScan();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('返回'),
            ),
          ],
        );
      },
    );
  }

  void _restartScan() {
    if (!mounted) return;
    
    setState(() {
      _lastScannedCode = '';
      _scanStatus = '重新开始扫描';
      _isScanning = true;
    });
    
    // 延迟重启扫描，确保UI状态更新完成
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _controller.restartScan();
      }
    });
  }

  void _toggleScan() {
    setState(() {
      _isScanning = !_isScanning;
    });
    
    if (_isScanning) {
      _controller.startScan();
    } else {
      _controller.stopScan();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR扫描测试'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _toggleScan,
            icon: Icon(_isScanning ? Icons.pause : Icons.play_arrow),
            tooltip: _isScanning ? '暂停' : '开始',
          ),
        ],
      ),
      body: Column(
        children: [
          // 状态栏
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: _isScanning ? Colors.green[50] : Colors.grey[100],
            child: Row(
              children: [
                Icon(
                  _isScanning ? Icons.qr_code_scanner : Icons.qr_code,
                  color: _isScanning ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _scanStatus,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: _isScanning ? Colors.green[700] : Colors.grey[700],
                    ),
                  ),
                ),
                if (_lastScannedCode.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '已扫描',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // 扫描器
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FlutterQrscannerWidget(
                  name: 'USB摄像头',
                  camerakey: 'CAM1',
                  horizontalMirror: true,
                  degree: 180,
                  controller: _controller,
                  onQRCodeDetected: _onQRCodeDetected,
                  scanTips: _onScanTips,
                ),
              ),
            ),
          ),
          // 控制按钮
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _toggleScan,
                  icon: Icon(_isScanning ? Icons.pause : Icons.play_arrow),
                  label: Text(_isScanning ? '暂停扫描' : '开始扫描'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isScanning ? Colors.orange : Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _restartScan,
                  icon: const Icon(Icons.refresh),
                  label: const Text('重新扫描'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
