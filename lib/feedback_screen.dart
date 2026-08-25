import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  int _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background
          Image.asset('Assets/background.jpg', fit: BoxFit.cover),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          // Title
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'FEEDBACK',
                                style: TextStyle(
                                  fontFamily: 'BalooTamma',
                                  color: Colors.white,
                                  fontSize: 42,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),

                          const Spacer(flex: 2),

                          // Main Content
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40.0),
                            child: Column(
                              children: [
                                const Text(
                                  'Thank you for\nyour feedback',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'BalooTamma',
                                    color: Colors.white,
                                    fontSize: 42,
                                    fontWeight: FontWeight.w400,
                                    height: 1.1,
                                  ),
                                ),
                                const SizedBox(height: 40),
                                // Interactive Stars — using Text with Unicode stars
                                // to guarantee rendering in release builds
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(5, (index) {
                                    final bool isSelected = index < _rating;
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _rating = index + 1;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0,
                                        ),
                                        child: Text(
                                          isSelected ? '★' : '☆',
                                          style: TextStyle(
                                            fontSize: 52,
                                            color: const Color(0xFF2DCED7),
                                            shadows: [
                                              Shadow(
                                                color: Colors.black.withOpacity(0.5),
                                                blurRadius: 6,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),

                          const Spacer(flex: 3),

                          // Buttons
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                              vertical: 20,
                            ),
                            child: Column(
                              children: [
                                if (_rating > 0) ...[
                                  _buildLargeButton('CONTINUE', () {
                                    Navigator.pop(context);
                                  }),
                                  const SizedBox(height: 12),
                                ],
                                _buildLargeButton('BACK', () {
                                  Navigator.pop(context);
                                }, isTransparent: true),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLargeButton(
    String title,
    VoidCallback onTap, {
    bool isTransparent = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        height: 65,
        decoration: BoxDecoration(
          color: isTransparent ? Colors.transparent : const Color(0xFF2DCED7),
          borderRadius: BorderRadius.circular(20),
          border: isTransparent ? Border.all(color: Colors.white24) : null,
          boxShadow: [
            if (!isTransparent)
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
