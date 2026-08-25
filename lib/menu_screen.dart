import 'package:flutter/material.dart';
import 'barbershop_screen.dart';
import 'loyalty_card.dart';
import 'cashback_details_sheet.dart';
import 'booking_screen.dart';
import 'history_screen.dart';
import 'services_screen.dart';
import 'discount_screen.dart';
import 'feedback_screen.dart';
import 'qr_scanner_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool _isCashbackExpanded = false;
  final GlobalKey _cardKey = GlobalKey();

  void _toggleCashback() {
    setState(() {
      _isCashbackExpanded = !_isCashbackExpanded;
    });
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // Header: HOME and QR
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'HOME',
                          style: TextStyle(
                            fontFamily: 'BalooTamma',
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 42,
                            letterSpacing: 1.0,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const QrScannerScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            child: Image.asset(
                              'Assets/ChatGPT Image 7 мая 2026 г., 05_05_54 2.png',
                              width: 48,
                              height: 48,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),

                    // Loyalty Card placeholder to keep space
                    Opacity(
                      opacity: _isCashbackExpanded ? 0 : 1,
                      child: LoyaltyCard(
                        key: _cardKey,
                        onTap: _toggleCashback,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Main Buttons
                    _buildLargeButton('BARBERSHOP', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BarbershopScreen(),
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                    _buildLargeButton('BOOKING PLACE', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BookingScreen(),
                        ),
                      );
                    }),

                    const SizedBox(height: 25),

                    // Grid Buttons
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        bottom: 10,
                      ),
                      child: GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1.5,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          _buildGridButton('Assets/Group 5.png', () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DiscountScreen(),
                              ),
                            );
                          }),
                          _buildGridButton('Assets/Group 12.png', () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HistoryScreen(),
                              ),
                            );
                          }),
                          _buildGridButton('Assets/Group 14.png', () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ServicesScreen(),
                              ),
                            );
                          }),
                          _buildGridButton('Assets/Group 15.png', () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FeedbackScreen(),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ),
          ),

          // Dimming Overlay
          IgnorePointer(
            ignoring: !_isCashbackExpanded,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _isCashbackExpanded ? 1.0 : 0.0,
              child: GestureDetector(
                onTap: _toggleCashback,
                child: Container(
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
            ),
          ),

          // Promoted Card and Bottom Sheet
          _buildExpandedView(),
        ],
      ),
    );
  }

  Widget _buildExpandedView() {
    // Get card position
    RenderBox? renderBox;
    if (_cardKey.currentContext != null) {
      renderBox = _cardKey.currentContext!.findRenderObject() as RenderBox?;
    }
    final position = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;

    return IgnorePointer(
      ignoring: !_isCashbackExpanded,
      child: Stack(
        children: [
          // The card itself at its original position but on top of dimming
          if (_isCashbackExpanded)
            Positioned(
              top: position.dy,
              left: 24,
              right: 24,
              child: const LoyaltyCard(isStatic: true),
            ),

          // Bottom Sheet sliding up
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutQuart,
            bottom: _isCashbackExpanded ? 0 : -MediaQuery.of(context).size.height,
            left: 0,
            right: 0,
            child: CashbackDetailsSheet(onBack: _toggleCashback),
          ),
        ],
      ),
    );
  }


  Widget _buildLargeButton(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        height: 65,
        decoration: BoxDecoration(
          color: const Color(0xFF2DCED7),
          borderRadius: BorderRadius.circular(18),
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
            fontSize: 28,
            fontWeight: FontWeight.w400,
            letterSpacing: 1.2,
            shadows: [
              Shadow(
                color: Colors.black26,
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridButton(String imagePath, VoidCallback onTap) {
    Widget button = Center(child: Image.asset(imagePath, fit: BoxFit.contain));

    // Specifically increase size and lift Services button
    if (imagePath.contains('Group 14')) {
      button = Transform.translate(
        offset: const Offset(0, -12),
        child: Transform.scale(scale: 1.15, child: button),
      );
    }

    return InkWell(onTap: onTap, child: button);
  }
}
