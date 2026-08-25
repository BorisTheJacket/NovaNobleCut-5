import 'package:flutter/material.dart';
import 'dart:math';

class InitializationScreen extends StatelessWidget {
  final AnimationController spinController;
  final double elapsedTime;
  final double loadingTime;

  const InitializationScreen({
    Key? key,
    required this.spinController,
    required this.elapsedTime,
    required this.loadingTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: spinController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: spinController.value * 2 * pi,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white30,
                        width: 4,
                      ),
                    ),
                    child: const Icon(
                      Icons.settings_suggest,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            const Text(
              'Initializing...',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                value: loadingTime > 0 ? elapsedTime / loadingTime : 0,
                backgroundColor: Colors.white12,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 2,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${((elapsedTime / loadingTime * 100).clamp(0, 100)).toInt()}%',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
