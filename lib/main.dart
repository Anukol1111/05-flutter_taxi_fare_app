import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'views/splash_screen_ui.dart';

void main() {
  runApp(const FlutterTaxiFareApp());
}

class FlutterTaxiFareApp extends StatelessWidget {
  const FlutterTaxiFareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taxi Fare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // ฟอนต์หลักของแอป: Kanit
        textTheme: GoogleFonts.kanitTextTheme(),
        // ให้ขนาดปุ่ม/ช่องกรอกเท่ากันทุกแพลตฟอร์ม
        visualDensity: VisualDensity.standard,
      ),
      // หน้าแรกของแอป
      home: const SplashScreenUi(),
    );
  }
}
