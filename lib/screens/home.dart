import 'dart:async';

import 'package:flutter/material.dart';

import '../data.dart';
import '../hijri.dart';
import '../l10n.dart';
import '../main.dart';
import '../prayer.dart';
import '../state.dart';
import '../ui.dart';

String hijriLabel(AppState s, [DateTime? when]) {
  final h = hijriOf(when ?? s.nowHere(), s.hijriAdjust);
  final m = tl('hijriMonths')[h.m - 1];
  return currentLang == 'ar' ? '${arNum(h.d)} $m ${arNum(h.y)} هـ' : '${h.d} $m ${h.y} AH';
}

bool isMorningNow() {
  final h = DateTime.now().hour;
  return h >= 3 && h < 15;
}

const List<List<int>> kDailyAyat = [
  [2, 186], [13, 28], [94, 6], [65, 3], [2, 286], [39, 53], [3, 139], [20, 114], [40, 60], [29, 69], [16, 97], [2, 152],
  [2, 45], [11, 88], [3, 173], [8, 46], [14, 7], [33, 41], [25, 74], [59, 18], [28, 24], [64, 11], [3, 8], [57, 4],
];

int get _dayIndex => DateTime.now().difference(DateTime(2024)).inDays;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _timer;
  int _ayah = _dayIndex % kDailyAyat.length;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final morning = isMorningNow();
    final times = s.todayTimes;
    final next = s.nextPrayer();
    final left = next.$2.difference(DateTime.now().toUtc());
    String two(int n) => n.toString().padLeft(2, '0');
    final countdown = left.isNegative ? '00:00:00' : '${two(left.inHours)}:${two(left.inMinutes % 60)}:${two(left.inSeconds % 60)}';
    final deep = C.deep(context);
    final accent = morning ? deep : C.purple;

    return HeroPage(
      hero: HeroBand(
        title: t('appName'),
        subtitle: '${hijriLabel(s)} · ${s.placeName}',
        colors: const [C.green, C.green],
      ),
      children: [
        // greeting
        AppCard(
          onTap: () => ShellNav.go?.call(2, adhkarCat: morning ? 'morning' : 'evening'),
          child: Row(children: [
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(t(morning ? 'goodMorning' : 'goodEvening'), style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: accent)),
                const SizedBox(height: 2),
                Text(t(morning ? 'morningSub' : 'eveningSub'), style: TextStyle(color: C.muted(context))),
                const SizedBox(height: 10),
                CircleAvatar(radius: 18, backgroundColor: morning ? C.green : C.purple, child: const Icon(Icons.arrow_forward, color: Colors.white, size: 20)),
              ]),
            ),
            Icon(morning ? Icons.wb_sunny_rounded : Icons.nightlight_round, size: 72, color: morning ? C.yellow : C.purple),
          ]),
        ),
        // quick buttons
        Row(children: [
          Expanded(
            child: _QuickButton(
              label: catName(morning ? 'evening' : 'morning'),
              icon: morning ? Icons.nightlight_round : Icons.wb_sunny_rounded,
              colors: morning ? const [C.purple, C.purple] : const [C.green, C.green],
              onTap: () => ShellNav.go?.call(2, adhkarCat: morning ? 'evening' : 'morning'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _QuickButton(label: t('tasbih'), icon: Icons.touch_app, colors: const [C.blue, C.blue2], onTap: () => ShellNav.go?.call(3)),
          ),
        ]),
        // stats
        Row(children: [
          Expanded(child: _Stat(value: s.tasbihToday - s.istighfarToday, label: t('statsTasbih'), color: deep)),
          const SizedBox(width: 10),
          Expanded(child: _Stat(value: s.istighfarToday, label: t('statsIstighfar'), color: C.pink)),
          const SizedBox(width: 10),
          Expanded(child: _Stat(value: s.adhkarDoneToday, label: t('statsAdhkar'), color: C.purple)),
        ]),
        // prayer times
        AppCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(t('nextPrayer'), style: TextStyle(color: C.muted(context), fontWeight: FontWeight.w500)),
                  Text(t(next.$1), style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: deep, height: 1.2)),
                  Text(t('at', {'t': s.hm(next.$2)}), style: TextStyle(color: C.muted(context))),
                ]),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(color: C.sunk(context), borderRadius: BorderRadius.circular(16)),
                child: Text(countdown,
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, fontFeatures: [FontFeature.tabularFigures()])),
              ),
            ]),
            const SizedBox(height: 14),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.45,
              children: [
                for (final k in kPrayerKeys)
                  Container(
                    decoration: BoxDecoration(
                      color: (k == next.$1 && next.$3) ? C.green : C.sunk(context),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Text(t(k),
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: (k == next.$1 && next.$3) ? Colors.white70 : C.muted(context))),
                      Text(s.hm(times[k]!),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: (k == next.$1 && next.$3) ? Colors.white : null,
                              fontFeatures: const [FontFeature.tabularFigures()])),
                    ]),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            Text(t('myPrayers'), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (var i = 0; i < 5; i++)
                FilterChip(
                  label: Text(t(kFardKeys[i])),
                  selected: s.trackerOf(DateTime.now())[i],
                  onSelected: (_) => s.togglePrayer(DateTime.now(), i),
                  selectedColor: C.green.withOpacity(0.25),
                  checkmarkColor: deep,
                ),
            ]),
          ]),
        ),
        // gratitude
        AppCard(
          gradient: const LinearGradient(colors: [C.pink, C.purple]),
          child: Column(children: [
            Text(t('thanksTitle'), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w700)),
            Text(tl('thanks')[_dayIndex % 12],
                textAlign: TextAlign.center,
                style: const TextStyle(color: C.yellow, fontSize: 42, fontWeight: FontWeight.w800, height: 1.3)),
          ]),
        ),
        // ayah of the day
        _AyahOfDay(index: _ayah, onNext: () => setState(() => _ayah = (_ayah + 1) % kDailyAyat.length)),
        // waqf
        AppCard(
          color: C.cream(context),
          border: Border.all(color: C.creamLine(context), width: 2),
          child: Column(children: [
            Text(t('waqfTitle'), textAlign: TextAlign.center, style: const TextStyle(color: C.pink, fontSize: 21, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(t('waqfText'), textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, height: 1.8)),
            const SizedBox(height: 8),
            Text('﴿${Data.ayahText(17, 24)}﴾', textAlign: TextAlign.center, textDirection: TextDirection.rtl, style: quranStyle(21, color: deep, height: 2.1)),
          ]),
        ),
      ],
    );
  }
}

class _QuickButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback onTap;
  const _QuickButton({required this.label, required this.icon, required this.colors, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      gradient: LinearGradient(colors: colors),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      child: Row(children: [
        Expanded(child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800))),
        Icon(icon, color: Colors.white, size: 28),
      ]),
    );
  }
}

class _Stat extends StatelessWidget {
  final int value;
  final String label;
  final Color color;
  const _Stat({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      child: Column(children: [
        Text('$value', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: color, height: 1.3)),
        Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 12.5, color: C.muted(context), fontWeight: FontWeight.w700)),
      ]),
    );
  }
}

class _AyahOfDay extends StatelessWidget {
  final int index;
  final VoidCallback onNext;
  const _AyahOfDay({required this.index, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final ref = kDailyAyat[index];
    final surah = Data.quran[ref[0] - 1];
    return AppCard(
      gradient: const LinearGradient(colors: [C.blue, C.blue2]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Expanded(child: Text(t('ayahOfDay'), style: const TextStyle(color: C.yellow, fontSize: 16, fontWeight: FontWeight.w800))),
          IconButton(onPressed: onNext, icon: const Icon(Icons.refresh, color: Colors.white), tooltip: t('ayahOfDay')),
        ]),
        Text('﴿${Data.ayahText(ref[0], ref[1])}﴾',
            textAlign: TextAlign.center, textDirection: TextDirection.rtl, style: quranStyle(23, color: Colors.white, height: 2.1)),
        FutureBuilder<Translation?>(
          future: Data.translation(currentLang),
          builder: (context, snap) {
            final tr = snap.data;
            if (tr == null) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(tr.ayat[ref[0] - 1][ref[1] - 1],
                  textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.6)),
            );
          },
        ),
        const SizedBox(height: 6),
        Text(currentLang == 'ar' ? 'سورة ${surah.name} · الآية ${arNum(ref[1])}' : '${surah.translit} ${ref[0]}:${ref[1]}',
            textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 13)),
      ]),
    );
  }
}
