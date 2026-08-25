import 'package:flutter/material.dart';
import 'gallery_screen.dart';

class BarbershopScreen extends StatefulWidget {
  const BarbershopScreen({super.key});

  @override
  State<BarbershopScreen> createState() => _BarbershopScreenState();
}

class _BarbershopScreenState extends State<BarbershopScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> _atmosphereImages = [
    'Assets/atmosphere1.png',
    'Assets/atmosphere2.png',
    'Assets/atmosphere3.png',
  ];

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
                                'BARBERSHOP',
                                style: TextStyle(
                                  fontFamily: 'BalooTamma',
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white,
                                  fontSize: 42,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Carousel
                          SizedBox(
                            height: 200,
                            child: PageView.builder(
                              controller: _pageController,
                              onPageChanged: (int page) {
                                setState(() {
                                  _currentPage = page;
                                });
                              },
                              itemCount: _atmosphereImages.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              GalleryScreen(initialIndex: index),
                                        ),
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(25),
                                      child: Image.asset(
                                        _atmosphereImages[index],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Pagination Dots
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _atmosphereImages.length,
                              (index) => Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentPage == index
                                      ? const Color(0xFF2DCED7)
                                      : Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),

                          // Addresses
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Column(
                              children: [
                                _buildAddressItem(
                                  'Rua das Palmeiras 118, Curitiba, Paraná, Brazil',
                                ),
                                _buildAddressItem(
                                  'Avenida Rio Branco 247, Recife, Pernambuco, Brazil',
                                ),
                                _buildAddressItem(
                                  'Travessa Monte Azul 52, Campinas, São Paulo, Brazil',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 25),

                          // Description
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.0),
                            child: Text(
                              'A unique barber experience with free coffee, relaxing lounge areas, and multiple themed rooms. Enjoy a VIP zone, gaming room, fast Wi-Fi, and a comfortable atmosphere designed for both style',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'BalooTamma',
                                color: Colors.white,
                                fontSize: 21,
                                height: 1.4,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),

                          const Spacer(),

                          // Back Button
                          Padding(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                            child: _buildBackButton(context),
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

  Widget _buildAddressItem(String address) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        '• $address',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'BalooTamma',
          color: Color(0xFF2DCED7),
          fontSize: 18,
          height: 1.2,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
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
        child: const Text(
          'BACK',
          style: TextStyle(
            fontFamily: 'BalooTamma',
            color: Colors.white,
            fontSize: 32,
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
}
