import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen>
    with WidgetsBindingObserver {
  bool _hasPermission = false;
  bool _isSuccess = false;
  bool _isScanned = false;
  bool _scannerError = false;
  MobileScannerController? _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Check camera permission after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPermissionAndInit();
    });
  }

  Future<void> _checkPermissionAndInit() async {
    if (kIsWeb) {
      _showPermissionDialog();
      return;
    }

    final status = await Permission.camera.status;
    if (status.isGranted) {
      _startScanner();
    } else if (status.isPermanentlyDenied) {
      _showSettingsDialog();
    } else {
      _showPermissionDialog();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle app lifecycle for camera
    if (_controller == null) return;
    switch (state) {
      case AppLifecycleState.resumed:
        if (_hasPermission && !_isSuccess) {
          _controller?.start();
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        _controller?.stop();
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  void _startScanner() {
    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
    );

    _controller!.start().then((_) {
      debugPrint('Scanner started successfully');
    }).catchError((error) {
      debugPrint('Scanner error: $error');
      if (mounted) {
        setState(() {
          _scannerError = true;
        });
      }
    });

    setState(() {
      _hasPermission = true;
    });
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Camera Access',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'BalooTamma',
                fontSize: 22,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'We use your camera to scan QR codes at Nova NobleCut. This lets you confirm your appointments, collect loyalty points, and activate special barbershop discounts!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'BalooTamma',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            _buildDialogButton('Continue', () async {
              Navigator.pop(context);
              if (kIsWeb) {
                _startScanner();
                return;
              }
              final status = await Permission.camera.request();
              if (status.isGranted) {
                _startScanner();
              } else if (status.isPermanentlyDenied) {
                _showSettingsDialog();
              } else {
                if (mounted) {
                  setState(() {
                    _scannerError = true;
                  });
                }
              }
            }, isPrimary: true),
            const SizedBox(height: 12),
            _buildDialogButton('Cancel', () {
              Navigator.pop(context);
              Navigator.pop(context);
            }, isPrimary: false),
          ],
        ),
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Camera Access Required',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'BalooTamma',
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Camera permission is required to scan QR codes. Please enable it in Settings.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'BalooTamma',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            _buildDialogButton('Open Settings', () {
              Navigator.pop(context);
              openAppSettings();
            }, isPrimary: true),
            const SizedBox(height: 12),
            _buildDialogButton('Cancel', () {
              Navigator.pop(context);
              Navigator.pop(context);
            }, isPrimary: false),
          ],
        ),
      ),
    );
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isScanned) return;
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      debugPrint('Barcode found! ${barcode.rawValue}');
      final value = barcode.rawValue?.trim();
      if (value == 'testforappstore' || value == 'testforappstor') {
        _isScanned = true;
        _controller?.stop();
        _showSuccessDialog();
        break;
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Your visit has been confirmed.\nEnjoy your haircut!',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'BalooTamma',
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24),
            _buildDialogButton('Ok', () {
              Navigator.pop(context);
              setState(() {
                _isSuccess = true;
              });
            }, isPrimary: true),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogButton(String text, VoidCallback onTap,
      {required bool isPrimary}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
          color: isPrimary
              ? const Color(0xFF2DCED7)
              : Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'BalooTamma',
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: isPrimary ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildScannerView() {
    if (_scannerError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 50),
            const SizedBox(height: 10),
            const Text(
              'Camera error.\nPlease check permissions\nin Settings.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'BalooTamma',
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    if (_controller == null) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF2DCED7)),
      );
    }

    return MobileScanner(
      controller: _controller!,
      onDetect: _onDetect,
      errorBuilder: (context, error, child) {
        debugPrint('MobileScanner error: ${error.errorCode}');
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline,
                  color: Colors.redAccent, size: 50),
              const SizedBox(height: 10),
              Text(
                'Camera error:\n${error.errorCode}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'BalooTamma',
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background
          Image.asset('Assets/background.jpg', fit: BoxFit.cover),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Title
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'QR-CODE',
                      style: TextStyle(
                        fontFamily: 'BalooTamma',
                        color: Colors.white,
                        fontSize: 42,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // Center View
                if (_isSuccess)
                  const Text(
                    'Welcome!\nEnjoy your\nhaircut',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'BalooTamma',
                      color: Colors.white,
                      fontSize: 52,
                      fontWeight: FontWeight.w400,
                      height: 1.1,
                    ),
                  )
                else if (_hasPermission)
                  Column(
                    children: [
                      Container(
                        width: 280,
                        height: 280,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFF2DCED7),
                            width: 3,
                          ),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: kIsWeb
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.camera_alt,
                                        color: Colors.white, size: 50),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'Web Preview\n(Scanner Mockup)',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  ],
                                ),
                              )
                            : _buildScannerView(),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'SCAN',
                        style: TextStyle(
                          fontFamily: 'BalooTamma',
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),

                const Spacer(),

                // BACK Button
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: _buildLargeButton('BACK', () {
                    Navigator.pop(context);
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLargeButton(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        height: 65,
        decoration: BoxDecoration(
          color: const Color(0xFF2DCED7),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2DCED7).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: const TextStyle(
            fontFamily: 'BalooTamma',
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w400,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
