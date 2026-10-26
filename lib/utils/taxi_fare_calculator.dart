// อัตราค่าโดยสารแท็กซี่มิเตอร์ (ตาม Figma)
// กิโลเมตรแรก 35 บาท แล้วคิดเพิ่มทีละช่วง:
//   กม. 2–10 กม.ละ 6.50 | 10–20 กม.ละ 7.00 | 20–40 กม.ละ 8.00
//   40–60 กม.ละ 8.50 | 60–80 กม.ละ 9.00 | เกิน 80 กม.ละ 10.50
// รถติด คิดนาทีละ 3.00 บาท

const double firstKmFare = 35.0;
const double trafficFarePerMinute = 3.0;

// (ตั้งแต่ กม., ถึง กม., บาทต่อ กม.)
const List<(double, double, double)> fareRates = [
  (1, 10, 6.50),
  (10, 20, 7.00),
  (20, 40, 8.00),
  (40, 60, 8.50),
  (60, 80, 9.00),
  (80, double.infinity, 10.50),
];

double calculateTaxiFare({
  required double distanceKm,
  required double trafficMinutes,
}) {
  var fare = firstKmFare;
  for (final (from, to, rate) in fareRates) {
    if (distanceKm > from) {
      final km = (distanceKm < to ? distanceKm : to) - from;
      fare += km * rate;
    }
  }
  return fare + trafficMinutes * trafficFarePerMinute;
}
