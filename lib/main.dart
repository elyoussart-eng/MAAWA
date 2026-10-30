import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:timezone/data/latest.dart' as tzdata;

import 'data.dart';
import 'l10n.dart';
import 'notify.dart';
import 'state.dart';
import 'ui.dart';
import 'screens/home.dart';
import 'screens/quran.dart';
import 'screens/adhkar.dart';
import 'screens/tasbih.dart';
import 'screens/more.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tzdata.initializeTimeZones();
  await Data.load();
  final state = await AppState.load();
  await Notif.init();
  if (state.adhanNotif) unawaited(state.rescheduleAdhan());
  runApp(AppScope(state: state, child: const MaawaApp()));
}

class MaawaApp extends StatelessWidget {
  const MaawaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: t('appName'),
      locale: Locale(s.lang),
      supportedLocales: kLangs.map((l) => Locale(l)).toList(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      themeMode: s.themeMode,
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      home: const Shell(),
    );
  }
}

/// Lets any screen switch tabs (for example the home shortcuts).
class ShellNav {
  static void Function(int tab, {String? adhkarCat})? go;
}

class Shell extends StatefulWidget {
  const Shell({super.key});
  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> with WidgetsBindingObserver {
  int _tab = 0;
  Timer? _remTimer;
  Timer? _hideTimer;
  int? _bubble; // index into kTasbihPhrases
  int _remLevel = -1;
  final _rnd = math.Random();

  static const _remMinutes = [0, 30, 15, 5, 2];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ShellNav.go = (tab, {adhkarCat}) {
      if (adhkarCat != null) {
        AdhkarScreen.requested.value = null;
        AdhkarScreen.requested.value = adhkarCat;
      }
      setState(() => _tab = tab);
    };
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _remTimer?.cancel();
    _hideTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final s = AppScope.read(context);
      if (s.adhanNotif) s.rescheduleAdhan();
      setState(() {});
    }
  }

  void _scheduleReminders(int level) {
    if (level == _remLevel) return;
    _remLevel = level;
    _remTimer?.cancel();
    final m = _remMinutes[level.clamp(0, 4).toInt()];
    if (m == 0) return;
    _remTimer = Timer.periodic(Duration(minutes: m), (_) => _showBubble());
  }

  void _showBubble() {
    if (!mounted) return;
    setState(() => _bubble = _rnd.nextInt(kTasbihPhrases.length));
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 9), () {
      if (mounted) setState(() => _bubble = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    _scheduleReminders(s.reminderLevel);
    final pages = [
      const HomeScreen(),
      const QuranScreen(),
      const AdhkarScreen(),
      const TasbihScreen(),
      const MoreScreen(),
    ];
    return Scaffold(
      body: Stack(children: [
        IndexedStack(index: _tab, children: pages),
        if (_bubble != null)
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 24,
            right: 24,
            child: Center(
              child: Material(
                color: C.cream(context),
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22), side: BorderSide(color: C.creamLine(context), width: 2)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: () {
                    s.countPhrase(_bubble!);
                    setState(() => _bubble = null);
                    toast(context, t('accepted'));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Text(kTasbihPhrases[_bubble!], textDirection: TextDirection.rtl, style: naskhStyle(21, weight: FontWeight.w600)),
                      Text(t('tapIfSaid'), style: TextStyle(fontSize: 12, color: C.muted(context), fontWeight: FontWeight.w700)),
                    ]),
                  ),
                ),
              ),
            ),
          ),
      ]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home), label: t('home')),
          NavigationDestination(icon: const Icon(Icons.menu_book_outlined), selectedIcon: const Icon(Icons.menu_book), label: t('quran')),
          NavigationDestination(icon: const Icon(Icons.bookmark_outline), selectedIcon: const Icon(Icons.bookmark), label: t('adhkar')),
          NavigationDestination(icon: const Icon(Icons.touch_app_outlined), selectedIcon: const Icon(Icons.touch_app), label: t('tasbih')),
          NavigationDestination(icon: const Icon(Icons.apps), selectedIcon: const Icon(Icons.apps), label: t('more')),
        ],
      ),
    );
  }
}
