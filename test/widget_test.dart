import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_taxi_fare_app/main.dart';
import 'package:flutter_taxi_fare_app/utils/taxi_fare_calculator.dart';

void main() {
  // ไม่ให้ google_fonts โหลดฟอนต์จากอินเทอร์เน็ตตอนรันเทสต์
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  double fare(double km, [double minutes = 0]) =>
      calculateTaxiFare(distanceKm: km, trafficMinutes: minutes);

  test('first km is 35 baht (minimum fare)', () {
    expect(fare(0.5), 35);
    expect(fare(1), 35);
  });

  test('each distance band adds its own rate', () {
    expect(fare(10), 93.5); // 35 + 9 × 6.50
    expect(fare(20), 163.5); // + 10 × 7.00
    expect(fare(40), 323.5); // + 20 × 8.00
    expect(fare(60), 493.5); // + 20 × 8.50
    expect(fare(80), 673.5); // + 20 × 9.00
    expect(fare(100), 883.5); // + 20 × 10.50
    expect(fare(2.5), closeTo(44.75, 1e-9)); // 35 + 1.5 × 6.50
  });

  test('traffic adds 3 baht per minute', () {
    expect(fare(1, 10), 65);
    expect(fare(25, 7), 224.5); // 35 + 58.5 + 70 + 40 + 21
  });

  testWidgets('Splash → TaxiFareUi: warning, calculate and cancel', (
    tester,
  ) async {
    // ขนาดจอ Samsung Galaxy S20 Ultra (412 x 915)
    tester.view.physicalSize = const Size(1442, 3202);
    tester.view.devicePixelRatio = 3.5;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const FlutterTaxiFareApp());
    expect(find.text('Taxi Fare Calculator'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    expect(find.text('Taxi Fare'), findsOneWidget);

    // กดคำนวณโดยไม่กรอก: มีแถบแจ้งเตือน
    await tester.tap(find.text('คำนวณค่าโดยสาร'));
    await tester.pump();
    expect(find.text('กรุณากรอกข้อมูลให้ครบถ้วน'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), '25');
    await tester.enterText(find.byType(TextField).at(1), '7');
    await tester.tap(find.text('คำนวณค่าโดยสาร'));
    await tester.pumpAndSettle();
    expect(find.text('224.50'), findsOneWidget);

    await tester.tap(find.text('ยกเลิก'));
    await tester.pumpAndSettle();
    expect(find.text('0.00'), findsOneWidget);
    expect(find.text('25'), findsNothing);
  });
}
