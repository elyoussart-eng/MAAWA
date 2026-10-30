import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

import 'data.dart';
import 'l10n.dart';
import 'notify.dart';
import 'prayer.dart';

String dayKey(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

const List<String> kTasbihPhrases = [
  'سُبْحَانَ اللَّهِ',
  'أَسْتَغْفِرُ اللَّهَ',
  'الْحَمْدُ لِلَّهِ',
  'اللَّهُ أَكْبَرُ',
  'لَا إِلَهَ إِلَّا اللَّهُ',
  'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
  'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
  'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ',
];

class AppState extends ChangeNotifier {
  late SharedPreferences _p;

  // general
  String lang = 'ar';
  ThemeMode themeMode = ThemeMode.system;

  // location and prayer times
  bool gps = false;
  double lat = 36.7538, lng = 3.0588;
  int cityIdx = 18; // Algiers
  String methodId = 'algeria';
  int asrFactor = 1;
  bool adhanNotif = false;

  // calendar
  int hijriAdjust = 0;

  // quran
  double quranSize = 26;
  bool showTranslation = true;
  int? lastSurah;
  Set<int> readSurahs = {};
  int khatmahDays = 30;
  String khatmahStart = '';

  // adhkar
  double dhikrSize = 19;
  String progressDay = '';
  Map<String, List<int>> adhkarProgress = {};
  List<Dhikr> custom = [];
  int reminderLevel = 3;

  // tasbih
  int tPhrase = 0, tTarget = 33, tCount = 0, tRounds = 0;
  String tasbihDay = '';
  Map<int, int> tasbihBy = {};

  // prayer tracker: day -> five flags
  Map<String, List<bool>> tracker = {};

  static Future<AppState> load() async {
    final s = AppState();
    s._p = await SharedPreferences.getInstance();
    final p = s._p;
    final sys = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    s.lang = p.getString('lang') ?? (kLangs.contains(sys) ? sys : 'ar');
    setLang(s.lang);
    s.themeMode = ThemeMode.values[(p.getInt('theme') ?? 0).clamp(0, 2).toInt()];
    s.gps = p.getBool('gps') ?? false;
    s.lat = p.getDouble('lat') ?? s.lat;
    s.lng = p.getDouble('lng') ?? s.lng;
    s.cityIdx = (p.getInt('city') ?? s.cityIdx).clamp(0, kCities.length - 1).toInt();
    s.methodId = p.getString('method') ?? s.methodId;
    s.asrFactor = p.getInt('asr') ?? 1;
    s.adhanNotif = p.getBool('adhan') ?? false;
    s.hijriAdjust = p.getInt('hadj') ?? 0;
    s.quranSize = p.getDouble('qsize') ?? 26;
    s.showTranslation = p.getBool('showTr') ?? true;
    s.lastSurah = p.getInt('lastSurah');
    s.readSurahs = (p.getStringList('read') ?? []).map(int.parse).toSet();
    s.khatmahDays = p.getInt('kDays') ?? 30;
    s.khatmahStart = p.getString('kStart') ?? dayKey(DateTime.now());
    s.dhikrSize = p.getDouble('dsize') ?? 19;
    s.reminderLevel = p.getInt('rem') ?? 3;
    s.progressDay = p.getString('pDay') ?? '';
    final prog = p.getString('prog');
    if (prog != null) {
      final m = jsonDecode(prog) as Map<String, dynamic>;
      s.adhkarProgress = m.map((k, v) => MapEntry(k, (v as List).map((e) => e as int).toList()));
    }
    final cu = p.getString('custom');
    if (cu != null) {
      s.custom = (jsonDecode(cu) as List)
          .map((e) => Dhikr(e['t'] as String, e['n'] as int, own: true))
          .toList();
    }
    s.tPhrase = (p.getInt('tP') ?? 0).clamp(0, kTasbihPhrases.length - 1).toInt();
    s.tTarget = p.getInt('tT') ?? 33;
    s.tCount = p.getInt('tC') ?? 0;
    s.tRounds = p.getInt('tR') ?? 0;
    s.tasbihDay = p.getString('tDay') ?? '';
    final tb = p.getString('tBy');
    if (tb != null) {
      s.tasbihBy = (jsonDecode(tb) as Map<String, dynamic>).map((k, v) => MapEntry(int.parse(k), v as int));
    }
    final tr = p.getString('tracker');
    if (tr != null) {
      s.tracker = (jsonDecode(tr) as Map<String, dynamic>)
          .map((k, v) => MapEntry(k, (v as List).map((e) => e as bool).toList()));
    }
    s._rollDay();
    return s;
  }

  void _save() => notifyListeners();

  // ---------- general ----------
  void setLanguage(String code) {
    lang = code;
    setLang(code);
    _p.setString('lang', code);
    rescheduleAdhan();
    _save();
  }

  void setTheme(ThemeMode m) {
    themeMode = m;
    _p.setInt('theme', m.index);
    _save();
  }

  // ---------- location ----------
  City get city => kCities[cityIdx];
  String get placeName => gps ? t('myLocation') : (lang == 'ar' ? city.ar : city.en);
  CalcMethod get method => methodById(methodId);

  void setCity(int i) {
    cityIdx = i;
    gps = false;
    lat = kCities[i].lat;
    lng = kCities[i].lng;
    methodId = kCities[i].method;
    asrFactor = methodId == 'karachi' ? 2 : 1;
    _p
      ..setInt('city', i)
      ..setBool('gps', false)
      ..setDouble('lat', lat)
      ..setDouble('lng', lng)
      ..setString('method', methodId)
      ..setInt('asr', asrFactor);
    rescheduleAdhan();
    _save();
  }

  void setGps(double la, double lo) {
    gps = true;
    lat = la;
    lng = lo;
    methodId = guessMethod(la, lo);
    asrFactor = methodId == 'karachi' ? 2 : 1;
    _p
      ..setBool('gps', true)
      ..setDouble('lat', la)
      ..setDouble('lng', lo)
      ..setString('method', methodId)
      ..setInt('asr', asrFactor);
    rescheduleAdhan();
    _save();
  }

  void setMethod(String id) {
    methodId = id;
    _p.setString('method', id);
    rescheduleAdhan();
    _save();
  }

  void setAsr(int f) {
    asrFactor = f;
    _p.setInt('asr', f);
    rescheduleAdhan();
    _save();
  }

  /// "Now" on the clock of the selected place.
  DateTime nowHere() => gps ? DateTime.now() : tz.TZDateTime.now(tz.getLocation(city.tz));

  /// Converts a UTC instant to the clock of the selected place.
  DateTime toHere(DateTime utc) => gps ? utc.toLocal() : tz.TZDateTime.from(utc, tz.getLocation(city.tz));

  String hm(DateTime utc) {
    final d = toHere(utc);
    return '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }

  Map<String, DateTime> timesFor(DateTime localDay) =>
      prayerTimes(localDay.year, localDay.month, localDay.day, lat, lng, method, asrFactor);

  Map<String, DateTime> get todayTimes => timesFor(nowHere());

  /// The next obligatory prayer: (key, time, isToday).
  (String, DateTime, bool) nextPrayer() {
    final now = DateTime.now().toUtc();
    final today = todayTimes;
    for (final k in kFardKeys) {
      if (today[k]!.isAfter(now)) return (k, today[k]!, true);
    }
    final n = nowHere();
    final tomorrow = timesFor(DateTime(n.year, n.month, n.day + 1));
    return ('fajr', tomorrow['fajr']!, false);
  }

  double get qibla => qiblaBearing(lat, lng);

  // ---------- notifications ----------
  Future<bool> setAdhan(bool on) async {
    if (on) {
      final ok = await Notif.requestPermission();
      if (!ok) return false;
    }
    adhanNotif = on;
    _p.setBool('adhan', on);
    await rescheduleAdhan();
    _save();
    return true;
  }

  Future<void> rescheduleAdhan() async {
    if (!adhanNotif) {
      await Notif.cancelAll();
      return;
    }
    final n = nowHere();
    final items = <(String, String, DateTime)>[];
    for (var i = 0; i < 7; i++) {
      final times = timesFor(DateTime(n.year, n.month, n.day + i));
      for (final k in kFardKeys) {
        items.add((t(k), t('notifBody', {'p': t(k)}), times[k]!));
      }
    }
    await Notif.scheduleAll(items);
  }

  // ---------- hijri ----------
  void setHijriAdjust(int v) {
    hijriAdjust = v.clamp(-2, 2).toInt();
    _p.setInt('hadj', hijriAdjust);
    _save();
  }

  // ---------- quran ----------
  void setQuranSize(double v) {
    quranSize = v.clamp(18.0, 44.0).toDouble();
    _p.setDouble('qsize', quranSize);
    _save();
  }

  void toggleTranslation() {
    showTranslation = !showTranslation;
    _p.setBool('showTr', showTranslation);
    _save();
  }

  void openedSurah(int i) {
    lastSurah = i;
    _p.setInt('lastSurah', i);
    notifyListeners();
  }

  void markRead(int i, bool read) {
    if (read) {
      readSurahs.add(i);
    } else {
      readSurahs.remove(i);
    }
    _p.setStringList('read', readSurahs.map((e) => '$e').toList());
    _save();
  }

  int get ayatRead => readSurahs.fold(0, (a, i) => a + Data.quran[i].ayat.length);

  void setKhatmahDays(int d) {
    khatmahDays = d;
    _p.setInt('kDays', d);
    _save();
  }

  void resetKhatmah() {
    readSurahs.clear();
    khatmahStart = dayKey(DateTime.now());
    _p
      ..setStringList('read', [])
      ..setString('kStart', khatmahStart);
    _save();
  }

  int get khatmahPerDay {
    final start = DateTime.tryParse(khatmahStart) ?? DateTime.now();
    final passed = DateTime.now().difference(start).inDays;
    final left = (khatmahDays - passed).clamp(1, 100000).toInt();
    final remaining = Data.totalAyat - ayatRead;
    return (remaining / left).ceil();
  }

  // ---------- adhkar ----------
  void _rollDay() {
    final k = dayKey(DateTime.now());
    if (progressDay != k) {
      progressDay = k;
      adhkarProgress = {};
      _p.setString('pDay', k);
      _p.setString('prog', '{}');
    }
    if (tasbihDay != k) {
      tasbihDay = k;
      tasbihBy = {};
      _p.setString('tDay', k);
      _p.setString('tBy', '{}');
    }
  }

  List<Dhikr> items(String cat) => cat == 'mine' ? custom : (Data.adhkar[cat] ?? const []);

  int progressOf(String cat, int i) {
    _rollDay();
    final l = adhkarProgress[cat];
    return (l != null && i < l.length) ? l[i] : 0;
  }

  /// Counts one repetition. Returns true when this tap completed the dhikr.
  bool countDhikr(String cat, int i) {
    _rollDay();
    final x = items(cat)[i];
    final l = adhkarProgress.putIfAbsent(cat, () => []);
    while (l.length <= i) {
      l.add(0);
    }
    if (l[i] >= x.count) return false;
    l[i]++;
    _p.setString('prog', jsonEncode(adhkarProgress));
    _save();
    return l[i] >= x.count;
  }

  void resetCategory(String cat) {
    adhkarProgress.remove(cat);
    _p.setString('prog', jsonEncode(adhkarProgress));
    _save();
  }

  int get adhkarDoneToday {
    _rollDay();
    var n = 0;
    adhkarProgress.forEach((cat, l) {
      final its = items(cat);
      for (var i = 0; i < l.length && i < its.length; i++) {
        if (l[i] >= its[i].count) n++;
      }
    });
    return n;
  }

  void addCustom(String text, int count) {
    custom.add(Dhikr(text, count, own: true));
    _saveCustom();
  }

  void deleteCustom(int i) {
    custom.removeAt(i);
    adhkarProgress.remove('mine');
    _p.setString('prog', jsonEncode(adhkarProgress));
    _saveCustom();
  }

  void _saveCustom() {
    _p.setString('custom', jsonEncode(custom.map((c) => {'t': c.text, 'n': c.count}).toList()));
    _save();
  }

  void setDhikrSize(double v) {
    dhikrSize = v.clamp(15.0, 34.0).toDouble();
    _p.setDouble('dsize', dhikrSize);
    _save();
  }

  void setReminderLevel(int v) {
    reminderLevel = v;
    _p.setInt('rem', v);
    _save();
  }

  // ---------- tasbih ----------
  void _saveTasbih() {
    _p
      ..setInt('tP', tPhrase)
      ..setInt('tT', tTarget)
      ..setInt('tC', tCount)
      ..setInt('tR', tRounds)
      ..setString('tBy', jsonEncode(tasbihBy.map((k, v) => MapEntry('$k', v))));
  }

  /// Returns true when the tap completed a round.
  bool tasbihTap() {
    _rollDay();
    tCount++;
    tasbihBy[tPhrase] = (tasbihBy[tPhrase] ?? 0) + 1;
    var round = false;
    if (tCount >= tTarget) {
      tRounds++;
      round = true;
    }
    _saveTasbih();
    _save();
    return round;
  }

  void tasbihWrap() {
    if (tCount >= tTarget) {
      tCount = 0;
      _saveTasbih();
      _save();
    }
  }

  void countPhrase(int p) {
    _rollDay();
    tasbihBy[p] = (tasbihBy[p] ?? 0) + 1;
    _saveTasbih();
    _save();
  }

  void setPhrase(int p) {
    tPhrase = p;
    tCount = 0;
    tRounds = 0;
    _saveTasbih();
    _save();
  }

  void setTarget(int n) {
    tTarget = n;
    tCount = 0;
    _saveTasbih();
    _save();
  }

  void resetTasbih() {
    tCount = 0;
    tRounds = 0;
    _saveTasbih();
    _save();
  }

  int get tasbihToday {
    _rollDay();
    return tasbihBy.values.fold(0, (a, b) => a + b);
  }

  int get istighfarToday {
    _rollDay();
    return tasbihBy[1] ?? 0;
  }

  // ---------- prayer tracker ----------
  List<bool> trackerOf(DateTime d) => tracker[dayKey(d)] ?? List<bool>.filled(5, false);

  void togglePrayer(DateTime d, int i) {
    final k = dayKey(d);
    final l = List<bool>.from(tracker[k] ?? List<bool>.filled(5, false));
    l[i] = !l[i];
    tracker[k] = l;
    // keep the last 120 days only
    if (tracker.length > 120) {
      final keys = tracker.keys.toList()..sort();
      for (final old in keys.take(tracker.length - 120)) {
        tracker.remove(old);
      }
    }
    _p.setString('tracker', jsonEncode(tracker));
    _save();
  }

  int get streak {
    var n = 0;
    var d = DateTime.now();
    if (!trackerOf(d).every((e) => e)) d = d.subtract(const Duration(days: 1));
    while (trackerOf(d).every((e) => e)) {
      n++;
      d = d.subtract(const Duration(days: 1));
    }
    return n;
  }
}

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child}) : super(notifier: state);

  static AppState of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;

  /// Reads the state without subscribing to changes (for callbacks).
  static AppState read(BuildContext context) => context.getInheritedWidgetOfExactType<AppScope>()!.notifier!;
}
