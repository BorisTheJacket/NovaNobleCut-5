import 'package:flutter/material.dart';
import 'menu_screen.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'GREAT QUALITY',
      subtitle: 'This very convenient app will help you choose a hairstyle',
      image: 'Assets/trophy.png',
      isSpecial: false,
      fontFamily: 'BlackHanSans',
    ),
    OnboardingData(
      title: 'CONVENIENT SYSTEM',
      subtitle:
          'Get bonuses for visiting, take advantage of our special program',
      image: '',
      isSpecial: true,
      specialType: 'cards',
      fontFamily: 'BlackHanSans',
    ),
    OnboardingData(
      title: 'PLEASANT ATMOSPHERE',
      subtitle:
          "Spend your time productively, with us it's incredibly convenient",
      image: '',
      isSpecial: true,
      specialType: 'atmosphere',
      fontFamily: 'BalooBhai',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background
          Image.asset(
            'Assets/background.jpg',
            fit: BoxFit.cover,
          ),
          // Content
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(_pages[index]);
                  },
                ),
              ),
              // Pagination and Button Section (Static)
              _buildBottomSection(),
              const SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingData data) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Spacer(flex: 1),
          // Main Image Section
          if (!data.isSpecial)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Image.asset(
                data.image,
                height: MediaQuery.of(context).size.height * 0.4,
                fit: BoxFit.contain,
              ),
            )
          else if (data.specialType == 'cards')
            // Cards Layout
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Card 1: Top-Left (Smaller)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Image.asset(
                      'Assets/card1.png',
                      width: MediaQuery.of(context).size.width * 0.45,
                    ),
                  ),
                  // Card 2: Bottom-Right (Smaller)
                  Positioned(
                    top: 100,
                    right: 0,
                    child: Image.asset(
                      'Assets/card2.png',
                      width: MediaQuery.of(context).size.width * 0.55,
                    ),
                  ),
                ],
              ),
            )
          else
            // Atmosphere Layout (Real Photos)
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.45,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Photo 1: Top-Left (Smaller)
                  Positioned(
                    top: 10,
                    left: -60,
                    child: Transform.rotate(
                      angle: 0.6,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'Assets/atmosphere3.png',
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: 140,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  // Photo 2: Top-Right (Smaller)
                  Positioned(
                    top: 10,
                    right: -60,
                    child: Transform.rotate(
                      angle: 0.5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.asset(
                          'Assets/atmosphere2.png',
                          width: MediaQuery.of(context).size.width * 0.65,
                          height: 140,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  // Photo 3: Center (Smaller)
                  Positioned(
                    top: 260,
                    left: -100,
                    child: Transform.rotate(
                      angle: -0.4,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 30,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(
                            'Assets/atmosphere1.png',
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 160,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Stars
                  Positioned(
                    bottom: -5,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Image.asset(
                        'Assets/stars.png',
                        width: MediaQuery.of(context).size.width * 0.7,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const Spacer(),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              data.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: data.fontFamily,
                color: Colors.white,
                fontSize: 34,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Subtitle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              data.subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: data.fontFamily,
                color: const Color(0xFF00E5FF),
                fontSize: 18,
                height: 1.2,
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Column(
      children: [
        // Custom Pagination Indicator with transparent background
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              bool isActive = index == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: isActive ? 40 : 10,
                height: isActive ? 10 : 28,
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFF00E5FF) : Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 40),
        // Next Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SizedBox(
            width: double.infinity,
            height: 65,
            child: ElevatedButton(
              onPressed: () {
                if (_currentPage < _pages.length - 1) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MenuScreen()),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00E5FF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
              child: const Text(
                'NEXT',
                style: TextStyle(
                  fontFamily: 'BalooTamma',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class OnboardingData {
  final String title;
  final String subtitle;
  final String image;
  final bool isSpecial;
  final String specialType;
  final String fontFamily;

  OnboardingData({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.isSpecial,
    required this.fontFamily,
    this.specialType = '',
  });
}
