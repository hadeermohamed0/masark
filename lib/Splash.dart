import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/scheduler.dart';
import 'package:testm/privacy.dart';

const Color primaryColor = Color(0xFF05183F);

class SplashScreen extends StatefulWidget {
  static const String screenRoute = 'splash_screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.1, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.bounceIn, // منحنى يعطي تأثير ارتداد
      ),
    );

    _animationController.forward();

    // الانتقال إلى الشاشة التالية بعد فترة زمنية معينة
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(seconds: 5), () {
        Navigator.pushReplacementNamed(context, '/home'); // الانتقال بعد انتهاء الرسوم المتحركة
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // الحصول على عرض الشاشة وارتفاعها
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            width: screenWidth * 0.50, // نسبة من عرض الشاشة
            height: screenWidth * 0.50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(screenWidth * 0.25), // نسبة من العرض
              color: primaryColor.withOpacity(.1),
            ),
            alignment: Alignment.center,
            child: Container(
              // استخدام نسبة لتحديد العرض والارتفاع
              width: screenWidth * 0.48, // نسبة من عرض الشاشة
              height: screenWidth * 0.48, // نفس النسبة
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(screenWidth * 0.25), // نسبة من العرض
                color: primaryColor,
              ),
              alignment: Alignment.center,
              child: Text(
                "Masark",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.08, // نسبة من العرض
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
