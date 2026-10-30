import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n.dart';
import '../state.dart';
import '../ui.dart';

const List<Color> _ringColors = [C.pink, C.purple, C.blue];
const List<int> _targets = [33, 99, 100, 1000];

class TasbihScreen extends StatelessWidget {
  const TasbihScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final color = _ringColors[s.tPhrase % 3];
    final size = math.min(MediaQuery.of(context).size.width * 0.72, 280.0);

    return HeroPage(
      hero: HeroBand(title: t('tasbih'), subtitle: t('tapToCount'), colors: const [C.purple, C.indigo]),
      children: [
        AppCard(
          child: Column(children: [
            Text(kTasbihPhrases[s.tPhrase], textDirection: TextDirection.rtl, textAlign: TextAlign.center, style: naskhStyle(26, color: color, weight: FontWeight.w600, height: 1.6)),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: () {
                final round = s.tasbihTap();
                if (round) {
                  HapticFeedback.heavyImpact();
                  Timer(const Duration(milliseconds: 450), s.tasbihWrap);
                } else {
                  HapticFeedback.selectionClick();
                }
              },
              child: SizedBox(
                width: size,
                height: size,
                child: Stack(alignment: Alignment.center, children: [
                  SizedBox(
                    width: size,
                    height: size,
                    child: CircularProgressIndicator(
                      value: (s.tCount / s.tTarget).clamp(0.0, 1.0).toDouble(),
                      strokeWidth: 12,
                      backgroundColor: C.sunk(context),
                      color: color,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                  Container(
                    width: size * 0.74,
                    height: size * 0.74,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 24, offset: const Offset(0, 8))],
                    ),
                    alignment: Alignment.center,
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Text('${s.tCount}', style: const TextStyle(fontSize: 60, fontWeight: FontWeight.w800, height: 1)),
                      Text(t('of', {'n': s.tTarget}), style: TextStyle(color: C.muted(context), fontWeight: FontWeight.w700)),
                    ]),
                  ),
                ]),
              ),
            ),
            const SizedBox(height: 18),
            Wrap(alignment: WrapAlignment.center, spacing: 8, runSpacing: 8, children: [
              for (var i = 0; i < kTasbihPhrases.length; i++)
                Pill(
                  label: kTasbihPhrases[i],
                  selected: i == s.tPhrase,
                  selectedColor: _ringColors[i % 3],
                  style: naskhStyle(15, height: 1.4),
                  onTap: () => s.setPhrase(i),
                ),
            ]),
            const SizedBox(height: 14),
            Wrap(alignment: WrapAlignment.center, spacing: 8, children: [
              for (final n in _targets) Pill(label: '$n', selected: n == s.tTarget, onTap: () => s.setTarget(n)),
            ]),
            const SizedBox(height: 12),
            Text('${t('rounds', {'n': s.tRounds})}   ·   ${t('todayTotal', {'n': s.tasbihToday})}', style: TextStyle(color: C.muted(context))),
            TextButton(onPressed: s.resetTasbih, child: Text(t('resetCounter'))),
          ]),
        ),
      ],
    );
  }
}
