import 'package:flutter/material.dart';

import '../data.dart';
import '../l10n.dart';
import '../state.dart';
import '../ui.dart';

String surahMeta(int i) {
  final s = Data.quran[i];
  return '${t(s.meccan ? 'meccan' : 'medinan')} · ${t('ayahs', {'n': arNum(s.ayat.length)})}';
}

String _norm(String s) => s
    .replaceAll(RegExp('[أإآٱ]'), 'ا')
    .replaceAll(RegExp('[ً-ٰٟۖ-ۭ]'), '')
    .toLowerCase()
    .replaceAll(RegExp(r"[\s'\-]"), '');

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});
  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  String _q = '';
  Translation? _tr;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Data.translation(currentLang).then((v) {
      if (mounted && v != _tr) setState(() => _tr = v);
    });
  }

  void _open(BuildContext context, int i) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => SurahPage(index: i)));
  }

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final pct = (s.ayatRead * 100 / Data.totalAyat);
    final q = _norm(_q.trim());
    final list = <int>[];
    for (var i = 0; i < 114; i++) {
      final sr = Data.quran[i];
      final digits = q.replaceAllMapped(RegExp('[٠-٩]'), (m) => '${'٠١٢٣٤٥٦٧٨٩'.indexOf(m[0]!)}');
      if (q.isEmpty ||
          _norm(sr.name).contains(q) ||
          _norm(sr.translit).contains(q) ||
          (_tr != null && _norm(_tr!.surahNames[i]).contains(q)) ||
          '${i + 1}' == digits) {
        list.add(i);
      }
    }
    final allDone = s.readSurahs.length == 114;

    return HeroPage(
      hero: HeroBand(title: t('quran'), subtitle: t('khatmahProgress', {'p': pct.toStringAsFixed(pct < 10 ? 1 : 0)}), colors: const [C.blue, C.blue2]),
      children: [
        AppCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          child: TextField(
            decoration: InputDecoration(border: InputBorder.none, hintText: t('searchSurah'), icon: const Icon(Icons.search)),
            onChanged: (v) => setState(() => _q = v),
          ),
        ),
        if (s.lastSurah != null)
          AppCard(
            color: C.cream(context),
            onTap: () => _open(context, s.lastSurah!),
            child: Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(t('continueReading'), style: TextStyle(color: C.muted(context))),
                  Text(_title(s.lastSurah!), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                ]),
              ),
              FilledButton(onPressed: () => _open(context, s.lastSurah!), child: Text(t('continue'))),
            ]),
          ),
        AppCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(t('khatmah'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(value: s.ayatRead / Data.totalAyat, minHeight: 10, backgroundColor: C.sunk(context), color: C.green),
            ),
            const SizedBox(height: 10),
            if (allDone)
              Text(t('khatmahDone'), style: TextStyle(color: C.deep(context), fontWeight: FontWeight.w700))
            else ...[
              Text(t('khatmahPlan'), style: TextStyle(color: C.muted(context))),
              const SizedBox(height: 6),
              Wrap(spacing: 8, runSpacing: 8, children: [
                for (final d in [7, 30, 60, 90, 365])
                  Pill(label: t('days', {'n': arNum(d)}), selected: s.khatmahDays == d, onTap: () => s.setKhatmahDays(d)),
              ]),
              const SizedBox(height: 8),
              Text(t('perDay', {'n': arNum(s.khatmahPerDay)}), style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(onPressed: s.resetKhatmah, child: Text(t('resetKhatmah'))),
            ),
          ]),
        ),
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(children: [
            for (final i in list) _row(context, s, i),
          ]),
        ),
      ],
    );
  }

  String _title(int i) {
    final sr = Data.quran[i];
    if (currentLang == 'ar' || _tr == null) return 'سورة ${sr.name}';
    return '${sr.translit} · ${_tr!.surahNames[i]}';
  }

  Widget _row(BuildContext context, AppState s, int i) {
    const colors = [C.blue, C.green, C.purple, C.pink];
    final sr = Data.quran[i];
    final read = s.readSurahs.contains(i);
    return InkWell(
      onTap: () => _open(context, i),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        child: Row(children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: colors[i % 4], borderRadius: BorderRadius.circular(14)),
            child: Text('${i + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(currentLang == 'ar' ? sr.name : sr.translit,
                  style: currentLang == 'ar' ? naskhStyle(19, weight: FontWeight.w600, height: 1.5) : const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
              Text(currentLang == 'ar' || _tr == null ? surahMeta(i) : '${_tr!.surahNames[i]} · ${surahMeta(i)}',
                  style: TextStyle(fontSize: 13, color: C.muted(context))),
            ]),
          ),
          if (currentLang != 'ar') Text(sr.name, textDirection: TextDirection.rtl, style: naskhStyle(18, color: C.deep(context), height: 1.5)),
          if (read) Padding(padding: const EdgeInsetsDirectional.only(start: 8), child: Icon(Icons.check_circle, color: C.deep(context), size: 20)),
        ]),
      ),
    );
  }
}

class SurahPage extends StatefulWidget {
  final int index;
  const SurahPage({super.key, required this.index});
  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  Translation? _tr;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) AppScope.read(context).openedSurah(widget.index);
    });
    Data.translation(currentLang).then((v) {
      if (mounted) setState(() => _tr = v);
    });
  }

  void _go(int i) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => SurahPage(index: i)));
  }

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final i = widget.index;
    final sr = Data.quran[i];
    final showTr = _tr != null && s.showTranslation;
    final deep = C.deep(context);
    final read = s.readSurahs.contains(i);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: C.blue,
        foregroundColor: Colors.white,
        title: Text(currentLang == 'ar' ? 'سورة ${sr.name}' : sr.translit, style: const TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          if (_tr != null)
            IconButton(
              tooltip: t('translation'),
              onPressed: s.toggleTranslation,
              icon: Icon(Icons.translate, color: s.showTranslation ? C.yellow : Colors.white),
            ),
          IconButton(onPressed: () => s.setQuranSize(s.quranSize - 2), icon: const Icon(Icons.zoom_out)),
          IconButton(onPressed: () => s.setQuranSize(s.quranSize + 2), icon: const Icon(Icons.zoom_in)),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        itemCount: sr.ayat.length + 2,
        itemBuilder: (context, k) {
          if (k == 0) {
            return Column(children: [
              AppCard(
                color: C.cream(context),
                border: Border.all(color: C.creamLine(context), width: 2),
                child: Column(children: [
                  Text('سورة ${sr.name}', textDirection: TextDirection.rtl, style: naskhStyle(26, color: deep, weight: FontWeight.w600, height: 1.6)),
                  if (_tr != null) Text('${sr.translit} · ${_tr!.surahNames[i]}', style: TextStyle(color: C.muted(context))),
                  Text(surahMeta(i), style: TextStyle(color: C.muted(context), fontSize: 13)),
                  if (i != 0 && i != 8) ...[
                    const SizedBox(height: 8),
                    Text(Data.basmala, textDirection: TextDirection.rtl, style: quranStyle(s.quranSize, color: deep)),
                  ],
                ]),
              ),
              const SizedBox(height: 12),
            ]);
          }
          if (k == sr.ayat.length + 1) {
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                FilledButton.icon(
                  style: FilledButton.styleFrom(backgroundColor: read ? deep : C.green, padding: const EdgeInsets.symmetric(vertical: 14)),
                  onPressed: () => s.markRead(i, !read),
                  icon: Icon(read ? Icons.check_circle : Icons.check_circle_outline),
                  label: Text(read ? t('surahDone') : t('markRead'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                ),
                const SizedBox(height: 12),
                Row(children: [
                  if (i > 0) Expanded(child: OutlinedButton(onPressed: () => _go(i - 1), child: Text(currentLang == 'ar' ? Data.quran[i - 1].name : Data.quran[i - 1].translit))),
                  if (i > 0 && i < 113) const SizedBox(width: 12),
                  if (i < 113) Expanded(child: FilledButton(onPressed: () => _go(i + 1), child: Text(currentLang == 'ar' ? Data.quran[i + 1].name : Data.quran[i + 1].translit))),
                ]),
              ]),
            );
          }
          final a = k - 1;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(18)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text.rich(
                TextSpan(children: [
                  TextSpan(text: sr.ayat[a]),
                  TextSpan(text: ' ﴿${_arDigits(a + 1)}﴾', style: TextStyle(color: deep)),
                ]),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: quranStyle(s.quranSize, height: 2.1),
              ),
              if (showTr)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text('${a + 1}. ${_tr!.ayat[i][a]}',
                      textDirection: currentLang == 'ur' ? TextDirection.rtl : TextDirection.ltr,
                      style: TextStyle(fontSize: 15, height: 1.6, color: C.muted(context))),
                ),
            ]),
          );
        },
      ),
    );
  }
}

String _arDigits(int n) {
  const d = '٠١٢٣٤٥٦٧٨٩';
  return '$n'.split('').map((c) => d[int.parse(c)]).join();
}
