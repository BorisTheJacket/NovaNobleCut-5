import 'package:flutter/material.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  bool _isServicesTab = true;

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
                      'SERVICES',
                      style: TextStyle(
                        fontFamily: 'BalooTamma',
                        color: Colors.white,
                        fontSize: 42,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // Tabs
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildTab('SERVICES', _isServicesTab, () {
                          setState(() => _isServicesTab = true);
                        }),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTab('HAIRDRESSER', !_isServicesTab, () {
                          setState(() => _isServicesTab = false);
                        }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: _isServicesTab ? _buildServicesList() : _buildHairdresserList(),
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

  Widget _buildTab(String title, bool isActive, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF2DCED7)
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'BalooTamma',
            color: isActive ? Colors.white : Colors.white60,
            fontSize: 22,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildServicesList() {
    final services = [
      'Haircut',
      'Beard Trim',
      'Hair Coloring',
      'Blow Dry',
      'Hair Wash',
      'Highlights',
      'Shaving',
      'Scalp Massage',
    ];

    return ListView.builder(
      itemCount: services.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              services[index],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'BalooTamma',
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHairdresserList() {
    return ListView(
      children: [
        _buildPatchedImage('Assets/ChatGPT Image 7 мая 2026 г., 06_43_26 1.png'),
        const SizedBox(height: 10),
        _buildPatchedImage('Assets/ChatGPT Image 7 мая 2026 г., 06_39_56 1.png'),
      ],
    );
  }

  Widget _buildPatchedImage(String assetPath) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(assetPath, fit: BoxFit.contain),
            // The "Client" text is located roughly under the name.
            // We overlay a small dark container to "blur/patch" it.
            Positioned(
              left: constraints.maxWidth * 0.32,
              top: constraints.maxWidth * 0.22, // Approximate vertical position in 2:1 aspect ratio
              child: Container(
                width: constraints.maxWidth * 0.15,
                height: constraints.maxWidth * 0.05,
                decoration: BoxDecoration(
                  color: const Color(0xFF050B18), // Very dark blue/black matching the card
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        );
      },
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
