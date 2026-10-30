import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Surah {
  final String name; // Arabic name
  final String translit;
  final bool meccan;
  final List<String> ayat;
  Surah(this.name, this.translit, this.meccan, this.ayat);
}

class Dhikr {
  final String text;
  final int count;
  final bool quran;
  final String note;
  final bool own;
  const Dhikr(this.text, this.count, {this.quran = false, this.note = '', this.own = false});
}

class DivineName {
  final String ar, tl;
  final Map<String, String> meaning;
  DivineName(this.ar, this.tl, this.meaning);
}

class Hadith {
  final String ar, en, narrator;
  Hadith(this.ar, this.en, this.narrator);
}

class Translation {
  final List<String> surahNames;
  final List<List<String>> ayat;
  Translation(this.surahNames, this.ayat);
}

class Data {
  static late List<Surah> quran;
  static late Map<String, List<Dhikr>> adhkar;
  static late List<DivineName> names;
  static late List<Hadith> nawawi;
  static final Map<String, Translation> _tr = {};

  static int get totalAyat => quran.fold(0, (a, s) => a + s.ayat.length);
  static String get basmala => quran[0].ayat[0];

  static Future<void> load() async {
    final q = jsonDecode(await rootBundle.loadString('assets/data/quran_ar.json')) as List;
    quran = q
        .map((s) => Surah(s['n'] as String, s['t'] as String, s['m'] == 1,
            (s['a'] as List).map((e) => e as String).toList()))
        .toList();

    final a = jsonDecode(await rootBundle.loadString('assets/data/adhkar.json')) as List;
    adhkar = {
      for (final c in a)
        c['id'] as String: (c['items'] as List)
            .map((x) => Dhikr(x['t'] as String, x['n'] as int,
                quran: x['q'] == 1, note: (x['note'] ?? '') as String))
            .toList()
    };

    final n = jsonDecode(await rootBundle.loadString('assets/data/names.json')) as List;
    names = n
        .map((x) => DivineName(x['ar'] as String, x['tl'] as String, {
              for (final l in ['en', 'fr', 'ur', 'id', 'tr']) l: x[l] as String
            }))
        .toList();

    final h = jsonDecode(await rootBundle.loadString('assets/data/nawawi.json')) as List;
    nawawi = h.map((x) => Hadith(x['ar'] as String, x['en'] as String, (x['nr'] ?? '') as String)).toList();
  }

  /// Quran translation for a language other than Arabic. Loaded on first use.
  static Future<Translation?> translation(String lang) async {
    if (lang == 'ar') return null;
    if (_tr.containsKey(lang)) return _tr[lang];
    final j = jsonDecode(await rootBundle.loadString('assets/data/quran_$lang.json')) as Map<String, dynamic>;
    final tr = Translation(
      (j['names'] as List).map((e) => e as String).toList(),
      (j['a'] as List).map((s) => (s as List).map((e) => e as String).toList()).toList(),
    );
    _tr[lang] = tr;
    return tr;
  }

  static String ayahText(int surah, int from, [int? to]) =>
      quran[surah - 1].ayat.sublist(from - 1, to ?? from).join(' ');
}
