import 'dart:math' as math;

class CalcMethod {
  final String id, ar, en;
  final double fajr;
  final double isha; // angle; ignored when ishaMinutes > 0
  final int ishaMinutes;
  const CalcMethod(this.id, this.ar, this.en, this.fajr, this.isha, [this.ishaMinutes = 0]);
}

const List<CalcMethod> kMethods = [
  CalcMethod('mwl', 'رابطة العالم الإسلامي', 'Muslim World League', 18, 17),
  CalcMethod('umm', 'أم القرى (مكة المكرمة)', 'Umm al-Qura (Makkah)', 18.5, 0, 90),
  CalcMethod('egypt', 'الهيئة المصرية العامة للمساحة', 'Egyptian General Authority', 19.5, 17.5),
  CalcMethod('algeria', 'وزارة الشؤون الدينية (الجزائر)', 'Ministry of Religious Affairs (Algeria)', 18, 17),
  CalcMethod('morocco', 'وزارة الأوقاف (المغرب)', 'Ministry of Habous (Morocco)', 19, 17),
  CalcMethod('karachi', 'جامعة العلوم الإسلامية (كراتشي)', 'University of Islamic Sciences, Karachi', 18, 18),
  CalcMethod('turkey', 'رئاسة الشؤون الدينية (تركيا)', 'Diyanet (Turkey)', 18, 17),
  CalcMethod('kemenag', 'وزارة الشؤون الدينية (إندونيسيا)', 'Kemenag (Indonesia)', 20, 18),
  CalcMethod('isna', 'الجمعية الإسلامية لأمريكا الشمالية', 'ISNA (North America)', 15, 15),
];

CalcMethod methodById(String id) => kMethods.firstWhere((m) => m.id == id, orElse: () => kMethods[0]);

/// A sensible default method for a position, used when the location comes from GPS.
String guessMethod(double lat, double lng) {
  bool box(double la1, double la2, double lo1, double lo2) => lat >= la1 && lat <= la2 && lng >= lo1 && lng <= lo2;
  if (box(16, 32.5, 34.5, 56)) return 'umm'; // Arabian Peninsula
  if (box(22, 31.7, 25, 35)) return 'egypt';
  if (box(27.5, 36, -13.5, -1)) return 'morocco';
  if (box(19, 37.5, -2, 12)) return 'algeria';
  if (box(36, 42.2, 26, 45)) return 'turkey';
  if (box(5, 37, 60.5, 92)) return 'karachi'; // Pakistan, India, Bangladesh
  if (box(-11, 7, 95, 141)) return 'kemenag'; // Indonesia, Malaysia
  if (box(14, 72, -170, -50)) return 'isna';
  return 'mwl';
}

/// Cities for manual selection: Arabic name, English name, lat, lng, IANA time zone, method.
class City {
  final String ar, en, tz, method;
  final double lat, lng;
  const City(this.ar, this.en, this.lat, this.lng, this.tz, this.method);
}

const List<City> kCities = [
  City('مكة المكرمة', 'Makkah', 21.4225, 39.8262, 'Asia/Riyadh', 'umm'),
  City('المدينة المنورة', 'Madinah', 24.4686, 39.6142, 'Asia/Riyadh', 'umm'),
  City('الرياض', 'Riyadh', 24.7136, 46.6753, 'Asia/Riyadh', 'umm'),
  City('جدة', 'Jeddah', 21.5433, 39.1728, 'Asia/Riyadh', 'umm'),
  City('دبي', 'Dubai', 25.2048, 55.2708, 'Asia/Dubai', 'umm'),
  City('الدوحة', 'Doha', 25.2854, 51.531, 'Asia/Qatar', 'umm'),
  City('الكويت', 'Kuwait City', 29.3759, 47.9774, 'Asia/Kuwait', 'umm'),
  City('مسقط', 'Muscat', 23.588, 58.3829, 'Asia/Muscat', 'umm'),
  City('عمّان', 'Amman', 31.9539, 35.9106, 'Asia/Amman', 'mwl'),
  City('القدس', 'Al-Quds', 31.7683, 35.2137, 'Asia/Jerusalem', 'mwl'),
  City('دمشق', 'Damascus', 33.5138, 36.2765, 'Asia/Damascus', 'mwl'),
  City('بيروت', 'Beirut', 33.8938, 35.5018, 'Asia/Beirut', 'mwl'),
  City('بغداد', 'Baghdad', 33.3152, 44.3661, 'Asia/Baghdad', 'mwl'),
  City('القاهرة', 'Cairo', 30.0444, 31.2357, 'Africa/Cairo', 'egypt'),
  City('الإسكندرية', 'Alexandria', 31.2001, 29.9187, 'Africa/Cairo', 'egypt'),
  City('الخرطوم', 'Khartoum', 15.5007, 32.5599, 'Africa/Khartoum', 'egypt'),
  City('طرابلس', 'Tripoli', 32.8872, 13.1913, 'Africa/Tripoli', 'mwl'),
  City('تونس', 'Tunis', 36.8065, 10.1815, 'Africa/Tunis', 'mwl'),
  City('الجزائر العاصمة', 'Algiers', 36.7538, 3.0588, 'Africa/Algiers', 'algeria'),
  City('وهران', 'Oran', 35.6971, -0.6308, 'Africa/Algiers', 'algeria'),
  City('قسنطينة', 'Constantine', 36.365, 6.6147, 'Africa/Algiers', 'algeria'),
  City('عنابة', 'Annaba', 36.9, 7.7667, 'Africa/Algiers', 'algeria'),
  City('سطيف', 'Setif', 36.19, 5.41, 'Africa/Algiers', 'algeria'),
  City('ورقلة', 'Ouargla', 31.95, 5.325, 'Africa/Algiers', 'algeria'),
  City('الدار البيضاء', 'Casablanca', 33.5731, -7.5898, 'Africa/Casablanca', 'morocco'),
  City('الرباط', 'Rabat', 34.0209, -6.8416, 'Africa/Casablanca', 'morocco'),
  City('نواكشوط', 'Nouakchott', 18.0735, -15.9582, 'Africa/Nouakchott', 'mwl'),
  City('داكار', 'Dakar', 14.7167, -17.4677, 'Africa/Dakar', 'mwl'),
  City('لاغوس', 'Lagos', 6.5244, 3.3792, 'Africa/Lagos', 'mwl'),
  City('إسطنبول', 'Istanbul', 41.0082, 28.9784, 'Europe/Istanbul', 'turkey'),
  City('أنقرة', 'Ankara', 39.9334, 32.8597, 'Europe/Istanbul', 'turkey'),
  City('طهران', 'Tehran', 35.6892, 51.389, 'Asia/Tehran', 'mwl'),
  City('كراتشي', 'Karachi', 24.8607, 67.0011, 'Asia/Karachi', 'karachi'),
  City('لاهور', 'Lahore', 31.5204, 74.3587, 'Asia/Karachi', 'karachi'),
  City('إسلام آباد', 'Islamabad', 33.6844, 73.0479, 'Asia/Karachi', 'karachi'),
  City('دلهي', 'Delhi', 28.6139, 77.209, 'Asia/Kolkata', 'karachi'),
  City('دكا', 'Dhaka', 23.8103, 90.4125, 'Asia/Dhaka', 'karachi'),
  City('جاكرتا', 'Jakarta', -6.2088, 106.8456, 'Asia/Jakarta', 'kemenag'),
  City('كوالالمبور', 'Kuala Lumpur', 3.139, 101.6869, 'Asia/Kuala_Lumpur', 'kemenag'),
  City('سنغافورة', 'Singapore', 1.3521, 103.8198, 'Asia/Singapore', 'kemenag'),
  City('لندن', 'London', 51.5074, -0.1278, 'Europe/London', 'mwl'),
  City('باريس', 'Paris', 48.8566, 2.3522, 'Europe/Paris', 'mwl'),
  City('مرسيليا', 'Marseille', 43.2965, 5.3698, 'Europe/Paris', 'mwl'),
  City('ليون', 'Lyon', 45.764, 4.8357, 'Europe/Paris', 'mwl'),
  City('بروكسل', 'Brussels', 50.8503, 4.3517, 'Europe/Brussels', 'mwl'),
  City('برلين', 'Berlin', 52.52, 13.405, 'Europe/Berlin', 'mwl'),
  City('أمستردام', 'Amsterdam', 52.3676, 4.9041, 'Europe/Amsterdam', 'mwl'),
  City('مدريد', 'Madrid', 40.4168, -3.7038, 'Europe/Madrid', 'mwl'),
  City('موسكو', 'Moscow', 55.7558, 37.6173, 'Europe/Moscow', 'mwl'),
  City('نيويورك', 'New York', 40.7128, -74.006, 'America/New_York', 'isna'),
  City('تورونتو', 'Toronto', 43.6532, -79.3832, 'America/Toronto', 'isna'),
  City('مونتريال', 'Montreal', 45.5019, -73.5674, 'America/Toronto', 'isna'),
  City('شيكاغو', 'Chicago', 41.8781, -87.6298, 'America/Chicago', 'isna'),
  City('لوس أنجلوس', 'Los Angeles', 34.0522, -118.2437, 'America/Los_Angeles', 'isna'),
  City('سيدني', 'Sydney', -33.8688, 151.2093, 'Australia/Sydney', 'mwl'),
];

const List<String> kPrayerKeys = ['fajr', 'sunrise', 'dhuhr', 'asr', 'maghrib', 'isha'];
const List<String> kFardKeys = ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha'];

double _rad(double d) => d * math.pi / 180;
double _deg(double r) => r * 180 / math.pi;
double _sin(double d) => math.sin(_rad(d));
double _cos(double d) => math.cos(_rad(d));
double _tan(double d) => math.tan(_rad(d));
double _asin(double x) => _deg(math.asin(x));
double _acos(double x) => _deg(math.acos(x));
double _atan2(double y, double x) => _deg(math.atan2(y, x));
double _acot(double x) => _deg(math.atan(1 / x));
double _fix(double a, double b) {
  a = a - b * (a / b).floorToDouble();
  return a < 0 ? a + b : a;
}

double _julian(int y, int m, int d) {
  if (m <= 2) {
    y -= 1;
    m += 12;
  }
  final a = (y / 100).floor();
  final b = 2 - a + (a / 4).floor();
  return (365.25 * (y + 4716)).floorToDouble() + (30.6001 * (m + 1)).floorToDouble() + d + b - 1524.5;
}

class _Sun {
  final double decl, eqt;
  _Sun(this.decl, this.eqt);
}

_Sun _sunPos(double jd) {
  final dd = jd - 2451545;
  final g = _fix(357.529 + 0.98560028 * dd, 360);
  final q = _fix(280.459 + 0.98564736 * dd, 360);
  final l = _fix(q + 1.915 * _sin(g) + 0.020 * _sin(2 * g), 360);
  final e = 23.439 - 0.00000036 * dd;
  final ra = _atan2(_cos(e) * _sin(l), _cos(l)) / 15;
  return _Sun(_asin(_sin(e) * _sin(l)), q / 15 - _fix(ra, 24));
}

/// Prayer times for the civil date [y]-[m]-[d] at [lat],[lng], returned as UTC instants.
/// [asrFactor] is 1 (standard) or 2 (Hanafi).
Map<String, DateTime> prayerTimes(int y, int m, int d, double lat, double lng, CalcMethod method, int asrFactor) {
  final jd = _julian(y, m, d) - lng / (15 * 24);
  double mid(double t) => _fix(12 - _sunPos(jd + t).eqt, 24);
  double angleT(double ang, double t, bool ccw) {
    final decl = _sunPos(jd + t).decl;
    final tt = _acos((-_sin(ang) - _sin(decl) * _sin(lat)) / (_cos(decl) * _cos(lat))) / 15;
    return mid(t) + (ccw ? -tt : tt);
  }

  double asrT(int f, double t) {
    final decl = _sunPos(jd + t).decl;
    return angleT(-_acot(f + _tan((lat - decl).abs())), t, false);
  }

  var h = <String, double>{'fajr': 5, 'sunrise': 6, 'dhuhr': 12, 'asr': 13, 'sunset': 18, 'isha': 18};
  for (var i = 0; i < 2; i++) {
    final p = h.map((k, v) => MapEntry(k, v / 24));
    h = {
      'fajr': angleT(method.fajr, p['fajr']!, true),
      'sunrise': angleT(0.833, p['sunrise']!, true),
      'dhuhr': mid(p['dhuhr']!),
      'asr': asrT(asrFactor, p['asr']!),
      'sunset': angleT(0.833, p['sunset']!, false),
      'isha': method.ishaMinutes > 0 ? 0 : angleT(method.isha, p['isha']!, false),
    };
  }
  h['maghrib'] = h['sunset']!;
  if (method.ishaMinutes > 0) h['isha'] = h['maghrib']! + method.ishaMinutes / 60;

  // High-latitude safety: never let Fajr/Isha drift further than the angle-based night portion.
  final night = _fix(h['sunrise']! - h['sunset']!, 24);
  final fp = method.fajr / 60 * night;
  if (h['fajr']!.isNaN || _fix(h['sunrise']! - h['fajr']!, 24) > fp) h['fajr'] = h['sunrise']! - fp;
  if (method.ishaMinutes == 0) {
    final ip = method.isha / 60 * night;
    if (h['isha']!.isNaN || _fix(h['isha']! - h['sunset']!, 24) > ip) h['isha'] = h['sunset']! + ip;
  }

  final base = DateTime.utc(y, m, d);
  final out = <String, DateTime>{};
  for (final k in kPrayerKeys) {
    final hours = h[k]! - lng / 15;
    final ms = (hours * 3600000).round();
    final t = base.add(Duration(milliseconds: ms));
    // round to the nearest minute
    out[k] = DateTime.fromMillisecondsSinceEpoch(((t.millisecondsSinceEpoch + 30000) ~/ 60000) * 60000, isUtc: true);
  }
  return out;
}

/// Bearing to the Kaaba in degrees clockwise from true north.
double qiblaBearing(double lat, double lng) {
  const kLat = 21.4225, kLng = 39.8262;
  return _fix(_atan2(_sin(kLng - lng), _cos(lat) * _tan(kLat) - _sin(lat) * _cos(kLng - lng)), 360);
}
