import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  bool _imageReady = false;

  @override
  void initState() {
    super.initState();
    // Defer navigation timer until after the first frame to avoid jank
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _timer = Timer(const Duration(seconds: 3), () {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const OnboardingScreen()),
          );
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Precache the heavy background image so it doesn't block the first frame
    precacheImage(const AssetImage('Assets/background.jpg'), context).then((_) {
      if (mounted) {
        setState(() {
          _imageReady = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background — show only after precached to avoid decode jank
          if (_imageReady)
            Image.asset(
              'Assets/background.jpg',
              fit: BoxFit.cover,
              gaplessPlayback: true,
            ),
          // Content
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 4),
                // Logo
                Image.asset(
                  'Assets/logo.png',
                  width: MediaQuery.of(context).size.width * 0.85,
                ),
                const Spacer(flex: 2), // Lowered the position
                // Custom Stretching Loader
                const _StretchingLoader(size: 80, strokeWidth: 8),
                const Spacer(flex: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StretchingLoader extends StatefulWidget {
  final double size;
  final double strokeWidth;

  const _StretchingLoader({required this.size, required this.strokeWidth});

  @override
  State<_StretchingLoader> createState() => _StretchingLoaderState();
}

class _StretchingLoaderState extends State<_StretchingLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _startAngleAnimation;
  late Animation<double> _endAngleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    // Head of the arc
    _endAngleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.1, end: 0.8).chain(CurveTween(curve: Curves.easeInOut)), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 0.8, end: 1.0).chain(CurveTween(curve: Curves.easeInOut)), weight: 50),
    ]).animate(_controller);

    // Tail of the arc (catches up)
    _startAngleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 0.2).chain(CurveTween(curve: Curves.easeInOut)), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 0.2, end: 0.9).chain(CurveTween(curve: Curves.easeInOut)), weight: 50),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Circle - Static, no need to rebuild/repaint every frame
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.15),
                width: widget.strokeWidth,
              ),
            ),
          ),
          // Spinning Arc - Only this part needs to rebuild
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationAnimation.value,
                child: CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: _ArcPainter(
                    startAngleFactor: _startAngleAnimation.value,
                    endAngleFactor: _endAngleAnimation.value,
                    strokeWidth: widget.strokeWidth,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double startAngleFactor;
  final double endAngleFactor;
  final double strokeWidth;
  final Color color;

  // Cache the paint object — only create once per parameter set
  late final Paint _paint = Paint()
    ..color = color
    ..strokeWidth = strokeWidth
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  _ArcPainter({
    required this.startAngleFactor,
    required this.endAngleFactor,
    required this.strokeWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: (size.width - strokeWidth) / 2,
    );

    double startAngle = 2 * pi * startAngleFactor;
    double sweepAngle = 2 * pi * (endAngleFactor - startAngleFactor);

    if (sweepAngle < 0.05) sweepAngle = 0.05; // Minimum visible arc

    canvas.drawArc(rect, startAngle, sweepAngle, false, _paint);
  }

  @override
  bool shouldRepaint(covariant _ArcPainter oldDelegate) {
    return oldDelegate.startAngleFactor != startAngleFactor || oldDelegate.endAngleFactor != endAngleFactor;
  }
}
