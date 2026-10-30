import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../data.dart';
import '../hijri.dart';
import '../l10n.dart';
import '../prayer.dart';
import '../state.dart';
import '../ui.dart';
import 'home.dart' show hijriLabel;

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final tiles = <_Tile>[
      _Tile(t('names'), Icons.auto_awesome, const [C.green, C.green], (_) => const NamesPage()),
      _Tile(t('nawawi'), Icons.menu_book, const [C.purple, C.purple], (_) => const HadithListPage()),
      _Tile(t('qibla'), Icons.explore, const [C.blue, C.blue2], (_) => const QiblaPage()),
      _Tile(t('tracker'), Icons.task_alt, const [C.pink, C.pink], (_) => const TrackerPage()),
      _Tile(t('calendar'), Icons.calendar_month, const [C.indigo, C.purple], (_) => const CalendarPage()),
      _Tile(t('zakat'), Icons.calculate, const [C.green, C.blue], (_) => const ZakatPage()),
      _Tile(t('prayerTimes'), Icons.access_time, const [C.blue, C.green], (_) => const LocationPage()),
      _Tile(t('settings'), Icons.settings, const [C.purple, C.pink], (_) => const SettingsPage()),
    ];
    return HeroPage(
      hero: HeroBand(title: t('more'), subtitle: '${t('appName')} · ${hijriLabel(s)}', colors: const [C.purple, C.pink]),
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.35,
          children: [
            for (final tile in tiles)
              AppCard(
                gradient: LinearGradient(colors: tile.colors),
                padding: const EdgeInsets.all(16),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: tile.page)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Icon(tile.icon, color: Colors.white, size: 30),
                  Text(tile.title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800, height: 1.3)),
                ]),
              ),
          ],
        ),
        AppCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(t('reminders'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(t('remindersSub'), style: TextStyle(color: C.muted(context))),
            const SizedBox(height: 12),
            SegmentedButton<int>(
              showSelectedIcon: false,
              segments: [
                for (final (i, k) in const [(0, 'remOff'), (1, 'remRare'), (2, 'remLow'), (3, 'remMid'), (4, 'remHigh')])
                  ButtonSegment(value: i, label: FittedBox(child: Text(t(k)))),
              ],
              selected: {s.reminderLevel},
              onSelectionChanged: (v) => s.setReminderLevel(v.first),
            ),
          ]),
        ),
        AppCard(
          color: C.cream(context),
          child: Text(t('sources'), style: TextStyle(fontSize: 12.5, color: C.muted(context), height: 1.6)),
        ),
      ],
    );
  }
}

class _Tile {
  final String title;
  final IconData icon;
  final List<Color> colors;
  final WidgetBuilder page;
  _Tile(this.title, this.icon, this.colors, this.page);
}

// ---------------- Names of Allah ----------------
class NamesPage extends StatelessWidget {
  const NamesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final deep = C.deep(context);
    return SubPage(
      title: t('names'),
      color: C.green,
      body: GridView.builder(
        padding: const EdgeInsets.all(14),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 200, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1.05),
        itemCount: Data.names.length,
        itemBuilder: (context, i) {
          final n = Data.names[i];
          final meaning = currentLang == 'ar' ? null : n.meaning[currentLang];
          return AppCard(
            padding: const EdgeInsets.all(10),
            onTap: () => showModalBottomSheet(
              context: context,
              showDragHandle: true,
              builder: (_) => Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(n.ar, textDirection: TextDirection.rtl, style: naskhStyle(40, color: deep, weight: FontWeight.w600, height: 1.6)),
                  Text(n.tl, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text(n.meaning[currentLang == 'ar' ? 'en' : currentLang]!, textAlign: TextAlign.center, style: TextStyle(fontSize: 17, color: C.muted(context))),
                ]),
              ),
            ),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(arNum(i + 1), style: TextStyle(color: C.muted(context), fontSize: 12, fontWeight: FontWeight.w700)),
              FittedBox(child: Text(n.ar, textDirection: TextDirection.rtl, style: naskhStyle(26, color: deep, weight: FontWeight.w600, height: 1.6))),
              Text(n.tl, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              if (meaning != null) Text(meaning, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: C.muted(context))),
            ]),
          );
        },
      ),
    );
  }
}

// ---------------- Nawawi 40 ----------------
class HadithListPage extends StatelessWidget {
  const HadithListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SubPage(
      title: t('nawawi'),
      color: C.purple,
      body: ListView.separated(
        padding: const EdgeInsets.all(14),
        itemCount: Data.nawawi.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final h = Data.nawawi[i];
          final preview = h.ar.length > 120 ? '${h.ar.substring(0, 120)}…' : h.ar;
          return AppCard(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => HadithPage(index: i))),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text(t('hadithNum', {'n': arNum(i + 1)}), style: const TextStyle(color: C.purple, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text(preview, textDirection: TextDirection.rtl, maxLines: 3, overflow: TextOverflow.ellipsis, style: naskhStyle(16, height: 1.8)),
            ]),
          );
        },
      ),
    );
  }
}

class HadithPage extends StatelessWidget {
  final int index;
  const HadithPage({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final h = Data.nawawi[index];
    final note = t('hadithLangNote');
    return SubPage(
      title: t('hadithNum', {'n': arNum(index + 1)}),
      color: C.purple,
      body: ListView(padding: const EdgeInsets.all(16), children: [
        AppCard(
          color: C.cream(context),
          border: Border.all(color: C.creamLine(context), width: 2),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(h.ar, textDirection: TextDirection.rtl, style: naskhStyle(19, height: 2.0)),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: h.ar));
                  toast(context, t('copied'));
                },
                icon: const Icon(Icons.copy, size: 18),
                label: Text(t('copy')),
              ),
            ),
          ]),
        ),
        if (currentLang != 'ar') ...[
          const SizedBox(height: 14),
          AppCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              if (note.isNotEmpty) Text(note, style: TextStyle(color: C.muted(context), fontSize: 12.5)),
              Text(h.en, textDirection: TextDirection.ltr, style: const TextStyle(fontSize: 16, height: 1.7)),
            ]),
          ),
        ],
      ]),
    );
  }
}

// ---------------- Qibla ----------------
class QiblaPage extends StatefulWidget {
  const QiblaPage({super.key});
  @override
  State<QiblaPage> createState() => _QiblaPageState();
}

class _QiblaPageState extends State<QiblaPage> {
  StreamSubscription<MagnetometerEvent>? _mag;
  StreamSubscription<AccelerometerEvent>? _acc;
  List<double> _a = [0, 0, 9.8];
  double? _heading; // degrees from magnetic north
  bool _noSensor = false;

  @override
  void initState() {
    super.initState();
    try {
      _acc = accelerometerEventStream().listen((e) => _a = [e.x, e.y, e.z], onError: (_) => _fail());
      _mag = magnetometerEventStream().listen(_onMag, onError: (_) => _fail());
    } catch (_) {
      _noSensor = true;
    }
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _heading == null) setState(() => _noSensor = true);
    });
  }

  void _fail() {
    if (mounted) setState(() => _noSensor = true);
  }

  void _onMag(MagnetometerEvent m) {
    // Tilt-compensated azimuth, same maths as Android's SensorManager.getRotationMatrix.
    final ax = _a[0], ay = _a[1], az = _a[2];
    var hx = m.y * az - m.z * ay;
    var hy = m.z * ax - m.x * az;
    var hz = m.x * ay - m.y * ax;
    final normH = math.sqrt(hx * hx + hy * hy + hz * hz);
    if (normH < 0.1) return;
    hx /= normH;
    hy /= normH;
    hz /= normH;
    final normA = math.sqrt(ax * ax + ay * ay + az * az);
    final nax = ax / normA, nay = ay / normA, naz = az / normA;
    final my = naz * hx - nax * hz;
    var deg = math.atan2(hy, my) * 180 / math.pi;
    if (deg < 0) deg += 360;
    if (!mounted) return;
    setState(() {
      if (_heading == null) {
        _heading = deg;
      } else {
        // smooth, taking the shortest way around the circle
        var diff = deg - _heading!;
        if (diff > 180) diff -= 360;
        if (diff < -180) diff += 360;
        _heading = (_heading! + diff * 0.15) % 360;
        if (_heading! < 0) _heading = _heading! + 360;
      }
      _noSensor = false;
    });
  }

  @override
  void dispose() {
    _mag?.cancel();
    _acc?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final q = s.qibla;
    final rel = _heading == null ? q : (q - _heading!) % 360;
    final facing = _heading != null && (rel < 5 || rel > 355);
    final size = math.min(MediaQuery.of(context).size.width - 64, 320.0);

    return SubPage(
      title: t('qibla'),
      color: C.blue,
      body: ListView(padding: const EdgeInsets.all(16), children: [
        AppCard(
          child: Column(children: [
            Text(t('qiblaDeg', {'d': q.round()}), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            Text(s.placeName, style: TextStyle(color: C.muted(context))),
            const SizedBox(height: 18),
            SizedBox(
              width: size,
              height: size,
              child: Stack(alignment: Alignment.center, children: [
                Transform.rotate(
                  angle: -(_heading ?? 0) * math.pi / 180,
                  child: CustomPaint(size: Size(size, size), painter: _DialPainter(C.sunk(context), C.muted(context))),
                ),
                Transform.rotate(
                  angle: rel * math.pi / 180,
                  child: Icon(Icons.navigation, size: size * 0.42, color: facing ? C.green : C.blue2),
                ),
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(color: Theme.of(context).cardColor, shape: BoxShape.circle),
                  child: const Icon(Icons.explore, color: C.green),
                ),
              ]),
            ),
            const SizedBox(height: 16),
            if (facing) Text(t('qiblaFacing'), style: TextStyle(color: C.deep(context), fontSize: 18, fontWeight: FontWeight.w800)),
            Text(_noSensor ? t('noCompass') : t('qiblaHint'), textAlign: TextAlign.center, style: TextStyle(color: C.muted(context))),
            const SizedBox(height: 6),
            if (!_noSensor) Text(t('qiblaCalib'), textAlign: TextAlign.center, style: TextStyle(color: C.muted(context), fontSize: 12.5)),
          ]),
        ),
      ]),
    );
  }
}

class _DialPainter extends CustomPainter {
  final Color ring, ticks;
  _DialPainter(this.ring, this.ticks);

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.width / 2;
    canvas.drawCircle(c, r - 6, Paint()
      ..color = ring
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12);
    final tick = Paint()
      ..color = ticks
      ..strokeWidth = 2;
    for (var i = 0; i < 72; i++) {
      final a = i * 5 * math.pi / 180;
      final len = i % 18 == 0 ? 16.0 : (i % 6 == 0 ? 10.0 : 5.0);
      final p1 = c + Offset(math.sin(a), -math.cos(a)) * (r - 18);
      final p2 = c + Offset(math.sin(a), -math.cos(a)) * (r - 18 - len);
      canvas.drawLine(p1, p2, tick);
    }
    final tp = TextPainter(
      text: const TextSpan(text: 'N', style: TextStyle(color: C.pink, fontSize: 18, fontWeight: FontWeight.w800)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, c + Offset(-tp.width / 2, -(r - 40)));
  }

  @override
  bool shouldRepaint(covariant _DialPainter old) => old.ring != ring || old.ticks != ticks;
}

// ---------------- Prayer tracker ----------------
class TrackerPage extends StatelessWidget {
  const TrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final today = DateTime.now();
    final days = [for (var i = 6; i >= 0; i--) today.subtract(Duration(days: i))];
    final loc = MaterialLocalizations.of(context);
    return SubPage(
      title: t('tracker'),
      color: C.pink,
      body: ListView(padding: const EdgeInsets.all(16), children: [
        AppCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(t('myPrayers'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            Text(t('trackerSub'), style: TextStyle(color: C.muted(context))),
            const SizedBox(height: 8),
            for (var i = 0; i < 5; i++)
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: s.trackerOf(today)[i],
                onChanged: (_) => s.togglePrayer(today, i),
                title: Text(t(kFardKeys[i]), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                activeColor: C.green,
              ),
            const SizedBox(height: 6),
            Text(t('streak', {'n': s.streak}), style: TextStyle(color: C.deep(context), fontWeight: FontWeight.w800)),
          ]),
        ),
        const SizedBox(height: 14),
        AppCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(t('last7'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            for (final d in days)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(children: [
                  SizedBox(width: 110, child: Text(loc.formatShortMonthDay(d), style: TextStyle(color: C.muted(context)))),
                  for (var i = 0; i < 5; i++)
                    Expanded(
                      child: InkWell(
                        onTap: () => s.togglePrayer(d, i),
                        child: Container(
                          height: 28,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(color: s.trackerOf(d)[i] ? C.green : C.sunk(context), borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                ]),
              ),
            Row(children: [
              const SizedBox(width: 110),
              for (var i = 0; i < 5; i++)
                Expanded(child: Text(t(kFardKeys[i]), textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: C.muted(context)))),
            ]),
          ]),
        ),
      ]),
    );
  }
}

// ---------------- Hijri calendar ----------------
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  int _offset = 0; // months from the current Hijri month

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final now = DateTime.now();
    final today = hijriOf(now, s.hijriAdjust);
    var y = today.y, m = today.m + _offset;
    while (m > 12) {
      m -= 12;
      y++;
    }
    while (m < 1) {
      m += 12;
      y--;
    }
    final len = monthLength(y, m);
    final firstJdn = jdnFromHijri(y, m, 1) - s.hijriAdjust;
    final firstDate = dateOfJdn(firstJdn);
    final loc = MaterialLocalizations.of(context);
    final lead = (firstDate.weekday % 7 - loc.firstDayOfWeekIndex) % 7; // Sunday = 0
    final weekdays = [for (var i = 0; i < 7; i++) loc.narrowWeekdays[(i + loc.firstDayOfWeekIndex) % 7]];
    final months = tl('hijriMonths');
    final todayJdn = jdnOf(now);
    final events = upcomingEvents(now, s.hijriAdjust);
    final evNames = tl('events');

    return SubPage(
      title: t('calendar'),
      color: C.indigo,
      body: ListView(padding: const EdgeInsets.all(16), children: [
        AppCard(
          child: Column(children: [
            Row(children: [
              IconButton(onPressed: () => setState(() => _offset--), icon: const Icon(Icons.chevron_left)),
              Expanded(
                child: Column(children: [
                  Text('${months[m - 1]} ${arNum(y)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                  Text(loc.formatMonthYear(firstDate), style: TextStyle(color: C.muted(context), fontSize: 13)),
                ]),
              ),
              IconButton(onPressed: () => setState(() => _offset++), icon: const Icon(Icons.chevron_right)),
            ]),
            const SizedBox(height: 8),
            Row(children: [for (final w in weekdays) Expanded(child: Text(w, textAlign: TextAlign.center, style: TextStyle(color: C.muted(context), fontWeight: FontWeight.w700)))]),
            const SizedBox(height: 6),
            GridView.count(
              crossAxisCount: 7,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              children: [
                for (var i = 0; i < lead; i++) const SizedBox.shrink(),
                for (var d = 1; d <= len; d++)
                  Builder(builder: (context) {
                    final g = dateOfJdn(firstJdn + d - 1);
                    final isToday = firstJdn + d - 1 == todayJdn;
                    final isEvent = kEvents.any((e) => e[0] == m && e[1] == d);
                    return Container(
                      decoration: BoxDecoration(
                        color: isToday ? C.green : (isEvent ? C.yellow.withOpacity(0.35) : C.sunk(context)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Text(arNum(d), style: TextStyle(fontWeight: FontWeight.w800, color: isToday ? Colors.white : null)),
                        Text('${g.day}', style: TextStyle(fontSize: 10, color: isToday ? Colors.white70 : C.muted(context))),
                      ]),
                    );
                  }),
              ],
            ),
          ]),
        ),
        const SizedBox(height: 14),
        AppCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(t('events'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            for (final e in events)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(backgroundColor: C.yellow, child: Icon(Icons.star, color: Colors.white)),
                title: Text(evNames[e.index], style: const TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Text(loc.formatFullDate(e.date)),
                trailing: Text(e.daysLeft == 0 ? t('today') : t('inDays', {'n': e.daysLeft}), style: TextStyle(color: C.deep(context), fontWeight: FontWeight.w700)),
              ),
          ]),
        ),
        const SizedBox(height: 14),
        AppCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(t('hijriAdjust'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            SegmentedButton<int>(
              showSelectedIcon: false,
              segments: [for (final v in [-2, -1, 0, 1, 2]) ButtonSegment(value: v, label: Text(v > 0 ? '+$v' : '$v'))],
              selected: {s.hijriAdjust},
              onSelectionChanged: (v) => s.setHijriAdjust(v.first),
            ),
            const SizedBox(height: 8),
            Text(hijriLabel(s), style: const TextStyle(fontWeight: FontWeight.w700)),
            Text(t('hijriNote'), style: TextStyle(color: C.muted(context), fontSize: 12.5)),
          ]),
        ),
      ]),
    );
  }
}

// ---------------- Zakat ----------------
class ZakatPage extends StatefulWidget {
  const ZakatPage({super.key});
  @override
  State<ZakatPage> createState() => _ZakatPageState();
}

class _ZakatPageState extends State<ZakatPage> {
  final _f = {for (final k in ['cash', 'goods', 'gold', 'silver', 'goldPrice', 'silverPrice', 'debts']) k: TextEditingController()};

  double _v(String k) => double.tryParse(_f[k]!.text.replaceAll(',', '.').replaceAll(' ', '')) ?? 0;

  @override
  void dispose() {
    for (final c in _f.values) {
      c.dispose();
    }
    super.dispose();
  }

  String _money(double v) {
    final s = v.toStringAsFixed(2);
    final parts = s.split('.');
    final b = StringBuffer();
    final int0 = parts[0];
    for (var i = 0; i < int0.length; i++) {
      if (i > 0 && (int0.length - i) % 3 == 0) b.write(' ');
      b.write(int0[i]);
    }
    return '${b.toString()}.${parts[1]}';
  }

  @override
  Widget build(BuildContext context) {
    final gp = _v('goldPrice'), sp = _v('silverPrice');
    final total = _v('cash') + _v('goods') + _v('gold') * gp + _v('silver') * sp - _v('debts');
    final nisab = gp > 0 ? 85 * gp : (sp > 0 ? 595 * sp : 0.0);
    final due = nisab > 0 && total >= nisab ? total * 0.025 : 0.0;

    Widget field(String k, String label) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: TextField(
            controller: _f[k],
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9., ]'))],
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: label,
              filled: true,
              fillColor: C.sunk(context),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            ),
          ),
        );

    return SubPage(
      title: t('zakat'),
      color: C.green,
      body: ListView(padding: const EdgeInsets.all(16), children: [
        AppCard(
          child: Column(children: [
            field('cash', t('zakatCash')),
            field('goods', t('zakatGoods')),
            field('gold', t('zakatGold')),
            field('silver', t('zakatSilver')),
            field('goldPrice', t('zakatGoldPrice')),
            field('silverPrice', t('zakatSilverPrice')),
            field('debts', t('zakatDebts')),
          ]),
        ),
        const SizedBox(height: 14),
        AppCard(
          gradient: const LinearGradient(colors: [C.green, C.blue]),
          child: DefaultTextStyle.merge(
            style: const TextStyle(color: Colors.white),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text('${t('zakatTotal')}: ${_money(total < 0 ? 0 : total)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              Text('${t('zakatNisab')}: ${nisab > 0 ? _money(nisab) : '—'}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              if (nisab == 0)
                Text(t('zakatPriceNeeded'))
              else if (due == 0)
                Text(t('zakatBelow'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))
              else ...[
                Text(t('zakatDue'), style: const TextStyle(fontSize: 15)),
                Text(_money(due), style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: C.yellow)),
              ],
            ]),
          ),
        ),
        const SizedBox(height: 14),
        Text(t('zakatNote'), style: TextStyle(color: C.muted(context), height: 1.6)),
      ]),
    );
  }
}

// ---------------- Location and prayer settings ----------------
class LocationPage extends StatefulWidget {
  const LocationPage({super.key});
  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  bool _busy = false;
  String _q = '';

  Future<void> _locate(AppState s) async {
    setState(() => _busy = true);
    try {
      if (!await Geolocator.isLocationServiceEnabled()) throw 'off';
      var p = await Geolocator.checkPermission();
      if (p == LocationPermission.denied) p = await Geolocator.requestPermission();
      if (p == LocationPermission.denied || p == LocationPermission.deniedForever) throw 'denied';
      Position? pos;
      try {
        pos = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(accuracy: LocationAccuracy.low, timeLimit: Duration(seconds: 20)));
      } catch (_) {
        pos = await Geolocator.getLastKnownPosition();
      }
      if (pos == null) throw 'none';
      s.setGps(pos.latitude, pos.longitude);
    } catch (_) {
      if (mounted) toast(context, t('locationFailed'));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final q = _q.trim().toLowerCase();
    final cities = [
      for (var i = 0; i < kCities.length; i++)
        if (q.isEmpty || kCities[i].ar.contains(q) || kCities[i].en.toLowerCase().contains(q)) i
    ];
    return SubPage(
      title: t('prayerTimes'),
      color: C.blue,
      body: ListView(padding: const EdgeInsets.all(16), children: [
        AppCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(s.placeName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            Text('${s.lat.toStringAsFixed(3)}, ${s.lng.toStringAsFixed(3)}', textDirection: TextDirection.ltr, style: TextStyle(color: C.muted(context))),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _busy ? null : () => _locate(s),
              icon: _busy ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.my_location),
              label: Text(_busy ? t('locating') : t('useGps')),
            ),
            const SizedBox(height: 16),
            Text(t('method'), style: TextStyle(color: C.muted(context), fontWeight: FontWeight.w600)),
            DropdownButton<String>(
              isExpanded: true,
              value: s.methodId,
              items: [for (final m in kMethods) DropdownMenuItem(value: m.id, child: Text(currentLang == 'ar' ? m.ar : m.en, overflow: TextOverflow.ellipsis))],
              onChanged: (v) {
                if (v != null) s.setMethod(v);
              },
            ),
            const SizedBox(height: 8),
            Text(t('asrMethod'), style: TextStyle(color: C.muted(context), fontWeight: FontWeight.w600)),
            DropdownButton<int>(
              isExpanded: true,
              value: s.asrFactor,
              items: [
                DropdownMenuItem(value: 1, child: Text(t('asrStd'), overflow: TextOverflow.ellipsis)),
                DropdownMenuItem(value: 2, child: Text(t('asrHanafi'))),
              ],
              onChanged: (v) {
                if (v != null) s.setAsr(v);
              },
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: s.adhanNotif,
              title: Text(t('adhanNotif'), style: const TextStyle(fontWeight: FontWeight.w700)),
              onChanged: (v) async {
                final ok = await s.setAdhan(v);
                if (!ok && context.mounted) toast(context, t('notifDenied'));
              },
            ),
            Text(t('timesNote'), style: TextStyle(color: C.muted(context), fontSize: 12.5)),
          ]),
        ),
        const SizedBox(height: 14),
        AppCard(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            TextField(
              decoration: InputDecoration(border: InputBorder.none, hintText: t('searchCity'), icon: const Icon(Icons.search)),
              onChanged: (v) => setState(() => _q = v),
            ),
            for (final i in cities)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(currentLang == 'ar' ? kCities[i].ar : kCities[i].en),
                subtitle: Text(currentLang == 'ar' ? kCities[i].en : kCities[i].ar),
                trailing: (!s.gps && s.cityIdx == i) ? Icon(Icons.check_circle, color: C.deep(context)) : null,
                onTap: () => s.setCity(i),
              ),
          ]),
        ),
      ]),
    );
  }
}

// ---------------- Settings ----------------
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    return SubPage(
      title: t('settings'),
      color: C.purple,
      body: ListView(padding: const EdgeInsets.all(16), children: [
        AppCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(t('language'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            for (var i = 0; i < kLangs.length; i++)
              RadioListTile<String>(
                contentPadding: EdgeInsets.zero,
                value: kLangs[i],
                groupValue: s.lang,
                onChanged: (v) => s.setLanguage(v!),
                title: Text(kLangNames[i], style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
          ]),
        ),
        const SizedBox(height: 14),
        AppCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(t('theme'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 10),
            SegmentedButton<ThemeMode>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(value: ThemeMode.system, label: Text(t('themeSystem'))),
                ButtonSegment(value: ThemeMode.light, label: Text(t('themeLight'))),
                ButtonSegment(value: ThemeMode.dark, label: Text(t('themeDark'))),
              ],
              selected: {s.themeMode},
              onSelectionChanged: (v) => s.setTheme(v.first),
            ),
          ]),
        ),
        const SizedBox(height: 14),
        AppCard(
          color: C.cream(context),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(t('about'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(t('waqfText'), style: const TextStyle(height: 1.7)),
            const SizedBox(height: 8),
            Text(t('sources'), style: TextStyle(color: C.muted(context), fontSize: 12.5, height: 1.6)),
          ]),
        ),
      ]),
    );
  }
}
