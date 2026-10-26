import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/taxi_fare_calculator.dart';

// หน้าคำนวณค่าโดยสารแท็กซี่
class TaxiFareUi extends StatefulWidget {
  const TaxiFareUi({super.key});

  @override
  State<TaxiFareUi> createState() => _TaxiFareUiState();
}

class _TaxiFareUiState extends State<TaxiFareUi> {
  final _distanceCtrl = TextEditingController();
  final _trafficCtrl = TextEditingController();

  double _fare = 0;

  @override
  void dispose() {
    _distanceCtrl.dispose();
    _trafficCtrl.dispose();
    super.dispose();
  }

  // แถบแจ้งเตือนสีแดงด้านล่าง
  void _showWarning(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Row(
            children: [
              const Icon(Icons.warning, color: Colors.amber),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: GoogleFonts.kanit(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
  }

  void _calculate() {
    final distanceText = _distanceCtrl.text.trim();
    final trafficText = _trafficCtrl.text.trim();
    if (distanceText.isEmpty || trafficText.isEmpty) {
      _showWarning('กรุณากรอกข้อมูลให้ครบถ้วน');
      return;
    }
    final distance = double.tryParse(distanceText);
    final traffic = double.tryParse(trafficText);
    if (distance == null || traffic == null || distance <= 0 || traffic < 0) {
      _showWarning('กรุณากรอกตัวเลขให้ถูกต้อง');
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() {
      _fare = calculateTaxiFare(distanceKm: distance, trafficMinutes: traffic);
    });
  }

  void _cancel() {
    _distanceCtrl.clear();
    _trafficCtrl.clear();
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    setState(() => _fare = 0);
  }

  Widget _label(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: GoogleFonts.kanit(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _field(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _button(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        text,
        style: GoogleFonts.kanit(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        centerTitle: true,
        title: Text(
          'Taxi Fare',
          style: GoogleFonts.kanit(fontSize: 22, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(40, 40, 40, 30),
        child: Column(
          children: [
            Image.asset('assets/images/taxi.png', width: 200),
            const SizedBox(height: 20),
            Text(
              'คำนวณค่าโดยสารแท็กซี่',
              style: GoogleFonts.kanit(
                fontSize: 23.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 19),
            _label('ระยะทาง (กิโลเมตร) 🛣️'),
            const SizedBox(height: 10),
            _field(_distanceCtrl, 'กรุณากรอกระยะทาง'),
            const SizedBox(height: 20),
            _label('เวลารถติด (นาที) ⏰'),
            const SizedBox(height: 10),
            _field(_trafficCtrl, 'กรุณากรอกเวลารถติด'),
            const SizedBox(height: 30),
            _button('คำนวณค่าโดยสาร', Colors.amber, _calculate),
            const SizedBox(height: 14),
            _button('ยกเลิก', Colors.grey, _cancel),
            const SizedBox(height: 14),
            // กล่องแสดงค่าโดยสาร
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 26),
              decoration: BoxDecoration(
                color: Colors.amber[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    'ค่าโดยสารแท็กซี่',
                    style: GoogleFonts.kanit(
                      fontSize: 18,
                      color: Colors.grey[800],
                    ),
                  ),
                  Text(
                    _fare.toStringAsFixed(2),
                    style: GoogleFonts.kanit(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  Text(
                    'บาท',
                    style: GoogleFonts.kanit(
                      fontSize: 16,
                      color: Colors.grey[800],
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
}
