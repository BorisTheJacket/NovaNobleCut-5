import 'package:flutter/material.dart';

class DiscountScreen extends StatelessWidget {
  const DiscountScreen({super.key});

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
                      'DISCOUNT',
                      style: TextStyle(
                        fontFamily: 'BalooTamma',
                        color: Colors.white,
                        fontSize: 42,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Column(
                      children: [
                        _buildDiscountText('20% off your first\nvisit'),
                        const SizedBox(height: 40),
                        _buildDiscountText('Bring a friend –\nboth get 15% off'),
                        const SizedBox(height: 40),
                        _buildDiscountText('Happy hours (e.g.,\n12:00 PM to 3:00\nPM are cheaper)'),
                        const SizedBox(height: 40),
                        _buildDiscountText('Every 5th haircut\nis free'),
                      ],
                    ),
                  ),
                ),

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

  Widget _buildDiscountText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontFamily: 'BalooTamma',
        color: Colors.white,
        fontSize: 34,
        fontWeight: FontWeight.w400,
        height: 1.1,
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
