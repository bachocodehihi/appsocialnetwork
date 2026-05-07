import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:socialnetwork/app/pages/scanner/scanner_controller.dart';
import 'package:socialnetwork/app/pages/user/user_page.dart';

class ScannerView extends StatefulWidget {
  const ScannerView({super.key});

  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> {
  late final ScannerController _controller;
  late final MobileScannerController _scannerController;

  @override
  void initState() {
    super.initState();
    _controller = ScannerController();
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
    );
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (!_controller.isScanning) return;

    final barcode = capture.barcodes.firstOrNull;
    if (barcode == null || barcode.rawValue == null) return;

    final qrValue = barcode.rawValue!;

    // Dừng scan, tránh detect nhiều lần
    _controller.pauseScanning();
    _scannerController.stop();

    final userData = await _controller.fetchUserByQrCode(qrValue);

    if (!mounted) return;

    if (userData != null) {
      // Navigate qua UserPage
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => UserPage(userData: userData),
        ),
      );
      // Quay lại thì resume scan
      _scannerController.start();
      _controller.resumeScanning();
    } else {
      // Hiện lỗi
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_controller.errorMessage ?? 'Mã QR không hợp lệ'),
            backgroundColor: Colors.red,
          ),
        );
        _scannerController.start();
        _controller.resumeScanning();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera feed
          MobileScanner(
            controller: _scannerController,
            onDetect: _onDetect,
          ),

          // Overlay tối 4 góc + khung scan
          _buildScanOverlay(),

          // Top bar
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),

                  Text(
                    'Quét mã QR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  // Flash toggle
                  ListenableBuilder(
                    listenable: _controller,
                    builder: (_, __) => GestureDetector(
                      onTap: () {
                        _scannerController.toggleTorch();
                        _controller.toggleFlash();
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _controller.isFlashOn
                              ? Icons.flash_on
                              : Icons.flash_off,
                          color: _controller.isFlashOn
                              ? Colors.yellow
                              : Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Loading indicator
          ListenableBuilder(
            listenable: _controller,
            builder: (_, __) {
              if (!_controller.isLoading) return const SizedBox.shrink();
              return Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              );
            },
          ),

          // Bottom label
          Positioned(
            bottom: 80.h,
            left: 0,
            right: 0,
            child: Text(
              'Đưa mã QR vào khung để quét',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanOverlay() {
    final screenSize = MediaQuery.of(context).size;
    final scanBoxSize = screenSize.width * 0.65;
    final cornerSize = 28.0;
    final cornerThickness = 4.0;
    final cornerColor = Colors.white;

    return Stack(
      children: [
        // Overlay tối toàn màn hình
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.55),
            BlendMode.srcOut,
          ),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              Center(
                child: Container(
                  width: scanBoxSize,
                  height: scanBoxSize,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
              ),
            ],
          ),
        ),

        // 4 góc khung trắng
        Center(
          child: SizedBox(
            width: scanBoxSize,
            height: scanBoxSize,
            child: Stack(
              children: [
                // Top-left
                Positioned(
                  top: 0,
                  left: 0,
                  child: _corner(
                    top: true,
                    left: true,
                    size: cornerSize,
                    thickness: cornerThickness,
                    color: cornerColor,
                  ),
                ),
                // Top-right
                Positioned(
                  top: 0,
                  right: 0,
                  child: _corner(
                    top: true,
                    left: false,
                    size: cornerSize,
                    thickness: cornerThickness,
                    color: cornerColor,
                  ),
                ),
                // Bottom-left
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: _corner(
                    top: false,
                    left: true,
                    size: cornerSize,
                    thickness: cornerThickness,
                    color: cornerColor,
                  ),
                ),
                // Bottom-right
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: _corner(
                    top: false,
                    left: false,
                    size: cornerSize,
                    thickness: cornerThickness,
                    color: cornerColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _corner({
    required bool top,
    required bool left,
    required double size,
    required double thickness,
    required Color color,
  }) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _CornerPainter(
          top: top,
          left: left,
          thickness: thickness,
          color: color,
        ),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final bool top;
  final bool left;
  final double thickness;
  final Color color;

  _CornerPainter({
    required this.top,
    required this.left,
    required this.thickness,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final w = size.width;
    final h = size.height;

    if (top && left) {
      path.moveTo(0, h);
      path.lineTo(0, 0);
      path.lineTo(w, 0);
    } else if (top && !left) {
      path.moveTo(0, 0);
      path.lineTo(w, 0);
      path.lineTo(w, h);
    } else if (!top && left) {
      path.moveTo(0, 0);
      path.lineTo(0, h);
      path.lineTo(w, h);
    } else {
      path.moveTo(w, 0);
      path.lineTo(w, h);
      path.lineTo(0, h);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CornerPainter old) => false;
}