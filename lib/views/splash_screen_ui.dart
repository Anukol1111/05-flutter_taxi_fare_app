import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'taxi_fare_ui.dart';

// หน้าแรก: แสดง 3 วินาที แล้วไปหน้า TaxiFareUi
class SplashScreenUi extends StatefulWidget {
  const SplashScreenUi({super.key});

  @override
  State<SplashScreenUi> createState() => _SplashScreenUiState();
}

class _SplashScreenUiState extends State<SplashScreenUi> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TaxiFareUi()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/taxi.png', width: 200),
            const SizedBox(height: 21),
            Text(
              'Taxi Fare Calculator',
              style: GoogleFonts.kanit(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: Colors.blue[300],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'คำนวณค่าโดยสารแท็กซี่',
              style: GoogleFonts.kanit(fontSize: 18, color: Colors.blue[300]),
            ),
            const SizedBox(height: 23),
            const CircularProgressIndicator(color: Colors.amber),
          ],
        ),
      ),
    );
  }
}
