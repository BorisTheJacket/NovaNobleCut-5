import 'package:flutter/material.dart';
import 'booking_manager.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _currentStep = 0;
  int? _selectedBarbershop;
  int? _selectedService;
  int? _selectedDay;
  final List<int> _availableDays = [3, 5, 8, 10, 12, 15, 17, 20, 22, 24, 27];
  TimeOfDay _selectedTime = const TimeOfDay(hour: 15, minute: 20);

  void _nextStep() {
    if (_currentStep == 2) {
      // Final selection step, save the booking
      final addresses = [
        'Rua das Palmeiras 118, Curitiba, Paraná, Brazil',
        'Avenida Rio Branco 247, Recife, Pernambuco, Brazil',
        'Travessa Monte Azul 52, Campinas, São Paulo, Brazil',
      ];
      final services = [
        'Haircut', 'Beard Trim', 'Hair Coloring', 'Blow Dry',
        'Hair Wash', 'Highlights', 'Shaving', 'Scalp Massage',
      ];

      BookingManager.addBooking(Booking(
        service: services[_selectedService ?? 0],
        address: addresses[_selectedBarbershop ?? 0],
        date: '${_selectedDay?.toString().padLeft(2, '0')}.05.2026',
        time: _selectedTime,
      ));
    }

    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _prevStep() {
    if (_currentStep == 3 || _currentStep == 0) {
      Navigator.pop(context);
    } else {
      setState(() {
        _currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentStep == 0 || _currentStep == 3,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _prevStep();
      },
      child: Scaffold(
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
                        'BOOKING PLACE',
                        style: TextStyle(
                          fontFamily: 'BalooTamma',
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Step Content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: _buildStepContent(),
                    ),
                  ),

                  // Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
                    child: Column(
                      children: [
                        if (_currentStep < 3) ...[
                          _buildContinueButton(),
                          const SizedBox(height: 12),
                        ],
                        _buildLargeButton('BACK', _prevStep),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isStepReady() {
    switch (_currentStep) {
      case 0:
        return _selectedBarbershop != null;
      case 1:
        return _selectedService != null;
      case 2:
        return _selectedDay != null;
      default:
        return true;
    }
  }

  Widget _buildContinueButton() {
    bool isActive = _isStepReady();
    return InkWell(
      onTap: isActive ? _nextStep : null,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isActive ? 1.0 : 0.5,
        child: Container(
          width: double.infinity,
          height: 65,
          decoration: BoxDecoration(
            color: const Color(0xFF2DCED7),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              if (isActive)
                BoxShadow(
                  color: const Color(0xFF2DCED7).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
            ],
          ),
          alignment: Alignment.center,
          child: const Text(
            'CONTINUE',
            style: TextStyle(
              fontFamily: 'BalooTamma',
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w400,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildBarbershopSelection();
      case 1:
        return _buildServiceSelection();
      case 2:
        return _buildDateTimeSelection();
      case 3:
        return _buildSuccessScreen();
      default:
        return const SizedBox();
    }
  }

  // STEP 1: Barbershop Selection
  Widget _buildBarbershopSelection() {
    final addresses = [
      'Rua das Palmeiras 118, Curitiba, Paraná, Brazil',
      'Avenida Rio Branco 247, Recife, Pernambuco, Brazil',
      'Travessa Monte Azul 52, Campinas, São Paulo, Brazil',
    ];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          ...List.generate(addresses.length, (index) {
            bool isSelected = _selectedBarbershop == index;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () {
                  setState(() => _selectedBarbershop = index);
                },
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF2DCED7)
                        : Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    addresses[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'BalooTamma',
                      color: isSelected ? Colors.white : Colors.white60,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset(
              'Assets/atmosphere1.png',
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  // STEP 2: Service Selection
  Widget _buildServiceSelection() {
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
        bool isSelected = _selectedService == index;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
          onTap: () {
            setState(() => _selectedService = index);
          },
            borderRadius: BorderRadius.circular(15),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF2DCED7)
                    : Colors.white.withOpacity(0.1),
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
          ),
        );
      },
    );
  }

  // STEP 3: Date & Time Selection
  Widget _buildDateTimeSelection() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Calendar
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'MAY',
                      style: TextStyle(
                        fontFamily: 'BalooTamma',
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      '2026',
                      style: TextStyle(
                        fontFamily: 'BalooTamma',
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Days of week
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) {
                    return Expanded(
                      child: Text(
                        day,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'BalooTamma',
                          color: (day == 'S') ? const Color(0xFF2DCED7) : Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                // Calendar Grid
                _buildCalendarGrid(),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'Time',
            style: TextStyle(
              fontFamily: 'BalooTamma',
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: InkWell(
              onTap: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime,
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        alwaysUse24HourFormat: true,
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.dark(
                            primary: Color(0xFF2DCED7),
                            onPrimary: Colors.white,
                            surface: Color(0xFF143F4D),
                            onSurface: Colors.white,
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF2DCED7),
                            ),
                          ),
                        ),
                        child: child!,
                      ),
                    );
                  },
                );
                if (picked != null && picked != _selectedTime) {
                  setState(() {
                    _selectedTime = picked;
                  });
                }
              },
              borderRadius: BorderRadius.circular(15),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'BalooTamma',
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    // Simplified calendar for mockup
    List<int?> days = [
      null, null, null, null, 1, 2, 3,
      4, 5, 6, 7, 8, 9, 10,
      11, 12, 13, 14, 15, 16, 17,
      18, 19, 20, 21, 22, 23, 24,
      25, 26, 27, 28, 29, null, null
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: days.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
      ),
      itemBuilder: (context, index) {
        final day = days[index];
        if (day == null) return const SizedBox();
        
        bool isSelected = day == _selectedDay;
        // Only allow future dates (today is 8, so > 8) and those in available list
        bool isAvailable = day > 8 && _availableDays.contains(day);
        
        return GestureDetector(
          onTap: isAvailable ? () => setState(() => _selectedDay = day) : null,
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Colors.red : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: Text(
              day.toString(),
              style: TextStyle(
                fontFamily: 'BalooTamma',
                color: isSelected 
                    ? Colors.white 
                    : (isAvailable ? Colors.red : Colors.black.withOpacity(0.3)),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        );
      },
    );
  }

  // STEP 4: Success Screen
  Widget _buildSuccessScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Great, your\nrecording is ready.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'BalooTamma',
            color: Colors.white,
            fontSize: 42,
            fontWeight: FontWeight.w400,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'You can see it in history',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'BalooTamma',
            color: Color(0xFF2DCED7),
            fontSize: 28,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 40),
      ],
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
