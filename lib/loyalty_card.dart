import 'package:flutter/material.dart';

class LoyaltyCard extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isStatic;

  const LoyaltyCard({super.key, this.onTap, this.isStatic = false});

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      width: double.infinity,
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        image: const DecorationImage(
          image: AssetImage(
            'Assets/7b4e6425c9208a66e5e9ba2f27df19d45582017c.jpg',
          ),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'CASHBACK:',
                        style: TextStyle(
                          fontFamily: 'BalooTamma',
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Text(
                        '1%',
                        style: TextStyle(
                          fontFamily: 'BalooTamma',
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Image.asset(
                    'Assets/1_LVL.png',
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'NEXT LEVEL',
                        style: TextStyle(
                          fontFamily: 'BalooTamma',
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        'LVL 2',
                        style: TextStyle(
                          fontFamily: 'BalooTamma',
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Progress Bar
                  Container(
                    width: double.infinity,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 2,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return Container(
                              width: constraints.maxWidth * 0.0, // 0%
                              height: 30,
                              decoration: BoxDecoration(
                                color: const Color(0xFF2DCED7),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF2DCED7,
                                    ).withOpacity(0.5),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                '0%',
                                style: TextStyle(
                                  fontFamily: 'BalooTamma',
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            );
                          },
                        ),
                        const Positioned(
                          left: 15,
                          child: Text(
                            '0%',
                            style: TextStyle(
                              fontFamily: 'BalooTamma',
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        const Positioned(
                          right: 15,
                          child: Text(
                            '500',
                            style: TextStyle(
                              fontFamily: 'BalooTamma',
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
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

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: card,
      );
    }
    return card;
  }
}
