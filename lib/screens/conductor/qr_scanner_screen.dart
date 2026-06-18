// QR Scanner screen for ticket verification
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:easy_ride/core/constants/app_constants.dart';
import 'package:easy_ride/core/constants/route_constants.dart';
import 'package:easy_ride/providers/conductor_provider.dart';
import 'package:easy_ride/providers/user_provider.dart';
import 'package:easy_ride/localization/localization_service.dart';
import 'package:easy_ride/widgets/common/custom_app_bar.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({Key? key}) : super(key: key);

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen>
    with WidgetsBindingObserver {
  late MobileScannerController _cameraController;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  void _initCamera() {
    _cameraController = MobileScannerController(
      facing: CameraFacing.back,
      detectionSpeed: DetectionSpeed.normal,
    );
    if (mounted) {
      setState(() => _isProcessing = false);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // startArguments.value is non-null only after the camera has successfully started.
    if (_cameraController.startArguments.value == null) return;
    switch (state) {
      case AppLifecycleState.resumed:
        if (!_cameraController.isStarting) {
          _cameraController.start();
        }
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        _cameraController.stop();
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final code = barcodes.first.rawValue;
    if (code == null || code.isEmpty) return;

    // Block new detections via flag — do NOT call stop() yet.
    // On web, calling stop() then start() on the same ZXing controller
    // causes the camera to get stuck on the next scan.
    setState(() => _isProcessing = true);

    if (!mounted) return;

    final conductorProvider =
        Provider.of<ConductorProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final conductorId = userProvider.currentUser?.userId ?? '';

    final success =
        await conductorProvider.verifyTicketFromQR(code, conductorId);

    if (!mounted) return;

    if (success) {
      // Only stop the camera when we are leaving the screen.
      await _cameraController.stop();
      if (!mounted) return;
      Navigator.of(context)
          .pushReplacementNamed(RouteConstants.ticketVerification);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              conductorProvider.errorMessage ?? 'Verification failed'),
          backgroundColor: AppConstants.errorColor,
          duration: const Duration(seconds: 2),
        ),
      );
      // Camera is still live — just unblock detection for the next scan.
      setState(() => _isProcessing = false);
    }
  }

  String _describeError(MobileScannerException error) {
    switch (error.errorCode) {
      case MobileScannerErrorCode.permissionDenied:
        return 'Camera permission denied.\n\nGo to device Settings → Apps → EasyRide → Permissions and enable Camera.';
      case MobileScannerErrorCode.unsupported:
        return 'Camera is not supported on this device.';
      case MobileScannerErrorCode.controllerUninitialized:
        return 'Camera failed to initialize. Tap Retry.';
      default:
        return 'Camera error (${error.errorCode.name}).\n${error.errorDetails?.message ?? ''}\n\nTap Retry.';
    }
  }

  Widget _buildErrorOverlay(MobileScannerException error) {
    final message = _describeError(error);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.no_photography_outlined,
                color: Colors.white70, size: 64),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                _cameraController.dispose();
                _initCamera();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryGreen,
                foregroundColor: Colors.white,
              ),  
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'scan_qr_code'.tr(context),
      ),
      body: Stack(
        children: [
          // Camera view
          MobileScanner(
            controller: _cameraController,
            onDetect: _onDetect,
            errorBuilder: (context, error, child) => Container(
              color: Colors.black,
              child: _buildErrorOverlay(error),
            ),
          ),

          // Scan overlay frame
          CustomPaint(
            painter: ScannerOverlay(),
            child: Container(),
          ),

          // Instruction banner
          Positioned(
            top: AppConstants.spacingLarge,
            left: AppConstants.spacing,
            right: AppConstants.spacing,
            child: Container(
              padding: const EdgeInsets.all(AppConstants.spacing),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius:
                    BorderRadius.circular(AppConstants.borderRadius),
              ),
              child: Text(
                'place_qr_in_frame'.tr(context),
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // Flash / flip controls
          Positioned(
            bottom: AppConstants.spacingLarge,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.flash_on,
                      color: Colors.white, size: 32),
                  onPressed: () => _cameraController.toggleTorch(),
                ),
                const SizedBox(width: AppConstants.spacingLarge),
                IconButton(
                  icon: const Icon(Icons.flip_camera_android,
                      color: Colors.white, size: 32),
                  onPressed: () => _cameraController.switchCamera(),
                ),
              ],
            ),
          ),

          // Processing overlay
          if (_isProcessing)
            Container(
              color: Colors.black.withValues(alpha: 0.7),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Scanner overlay with transparent hole and corner brackets
class ScannerOverlay extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double scanAreaSize = size.width * 0.7;
    final double left = (size.width - scanAreaSize) / 2;
    final double top = (size.height - scanAreaSize) / 2;

    // Dark surround
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, scanAreaSize, scanAreaSize),
        const Radius.circular(16),
      ))
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);

    // Green border
    final borderPaint = Paint()
      ..color = AppConstants.primaryGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, scanAreaSize, scanAreaSize),
        const Radius.circular(16),
      ),
      borderPaint,
    );

    // Corner brackets
    final cornerPaint = Paint()
      ..color = AppConstants.primaryGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    const cornerLength = 30.0;

    canvas.drawLine(
        Offset(left, top + cornerLength), Offset(left, top), cornerPaint);
    canvas.drawLine(
        Offset(left, top), Offset(left + cornerLength, top), cornerPaint);

    canvas.drawLine(Offset(left + scanAreaSize - cornerLength, top),
        Offset(left + scanAreaSize, top), cornerPaint);
    canvas.drawLine(Offset(left + scanAreaSize, top),
        Offset(left + scanAreaSize, top + cornerLength), cornerPaint);

    canvas.drawLine(Offset(left, top + scanAreaSize - cornerLength),
        Offset(left, top + scanAreaSize), cornerPaint);
    canvas.drawLine(Offset(left, top + scanAreaSize),
        Offset(left + cornerLength, top + scanAreaSize), cornerPaint);

    canvas.drawLine(
        Offset(left + scanAreaSize - cornerLength, top + scanAreaSize),
        Offset(left + scanAreaSize, top + scanAreaSize),
        cornerPaint);
    canvas.drawLine(
        Offset(left + scanAreaSize, top + scanAreaSize - cornerLength),
        Offset(left + scanAreaSize, top + scanAreaSize),
        cornerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
