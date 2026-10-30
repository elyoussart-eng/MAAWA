import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'l10n.dart';

class C {
  static const green = Color(0xFF44AD48);
  static const greenDeep = Color(0xFF2F8A34);
  static const purple = Color(0xFF8E5BD6);
  static const blue = Color(0xFF2FB0E3);
  static const blue2 = Color(0xFF4E79E6);
  static const indigo = Color(0xFF5560D9);
  static const pink = Color(0xFFEE5A9B);
  static const yellow = Color(0xFFFFD62E);
  static const creamL = Color(0xFFFFF8D6);
  static const creamLineL = Color(0xFFEEDF9C);
  static const creamD = Color(0xFF25231A);
  static const creamLineD = Color(0xFF3B3723);

  static bool dark(BuildContext c) => Theme.of(c).brightness == Brightness.dark;
  static Color cream(BuildContext c) => dark(c) ? creamD : creamL;
  static Color creamLine(BuildContext c) => dark(c) ? creamLineD : creamLineL;
  static Color sunk(BuildContext c) => dark(c) ? const Color(0xFF242B34) : const Color(0xFFEEF0F4);
  static Color muted(BuildContext c) => dark(c) ? const Color(0xFF9AA3AF) : const Color(0xFF6B7280);
  static Color deep(BuildContext c) => dark(c) ? const Color(0xFF7BD67F) : greenDeep;
}

TextStyle quranStyle(double size, {Color? color, double height = 2.0}) {
  try {
    return GoogleFonts.getFont('Amiri Quran', fontSize: size, height: height, color: color);
  } catch (_) {
    return GoogleFonts.amiri(fontSize: size, height: height, color: color);
  }
}

TextStyle naskhStyle(double size, {Color? color, double height = 1.9, FontWeight? weight}) =>
    GoogleFonts.notoNaskhArabic(fontSize: size, height: height, color: color, fontWeight: weight);

ThemeData buildTheme(Brightness b) {
  final dark = b == Brightness.dark;
  final base = ThemeData(
    useMaterial3: true,
    brightness: b,
    colorScheme: ColorScheme.fromSeed(seedColor: C.green, brightness: b, primary: dark ? const Color(0xFF5DC15A) : C.green),
    scaffoldBackgroundColor: dark ? const Color(0xFF101418) : const Color(0xFFF1F3F6),
    cardColor: dark ? const Color(0xFF1A1F26) : Colors.white,
  );
  return base.copyWith(
    textTheme: GoogleFonts.tajawalTextTheme(base.textTheme),
    appBarTheme: const AppBarTheme(centerTitle: false),
  );
}

/// White rounded card used across the app.
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final Gradient? gradient;
  final Border? border;
  final VoidCallback? onTap;
  const AppCard({super.key, required this.child, this.padding = const EdgeInsets.all(18), this.color, this.gradient, this.border, this.onTap});

  @override
  Widget build(BuildContext context) {
    final box = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? (color ?? Theme.of(context).cardColor) : null,
        gradient: gradient,
        border: border,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(C.dark(context) ? 0.25 : 0.06), blurRadius: 20, offset: const Offset(0, 6))],
      ),
      child: child,
    );
    if (onTap == null) return box;
    return Material(
      color: Colors.transparent,
      child: InkWell(borderRadius: BorderRadius.circular(22), onTap: onTap, child: box),
    );
  }
}

/// Coloured header band with rounded bottom corners and decorative circles.
class HeroBand extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Color> colors;
  final Widget? leading;
  final List<Widget> actions;
  final double extraBottom;
  const HeroBand({super.key, required this.title, this.subtitle, required this.colors, this.leading, this.actions = const [], this.extraBottom = 56});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors.length == 1 ? [colors[0], colors[0]] : colors),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(34)),
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          PositionedDirectional(end: 80, top: -60, child: _dot(110, C.pink.withOpacity(0.8))),
          PositionedDirectional(end: -26, bottom: extraBottom - 30, child: _dot(84, C.yellow.withOpacity(0.9))),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(18, top + 12, 18, extraBottom + 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  if (leading != null) leading!,
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(title, style: const TextStyle(color: Colors.white, fontSize: 27, fontWeight: FontWeight.w800, height: 1.25)),
                      if (subtitle != null && subtitle!.isNotEmpty)
                        Text(subtitle!, style: TextStyle(color: Colors.white.withOpacity(0.92), fontSize: 15)),
                    ]),
                  ),
                  ...actions,
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(double s, Color c) => Container(width: s, height: s, decoration: BoxDecoration(color: c, shape: BoxShape.circle));
}

/// Page layout: hero band, then content that overlaps its bottom edge.
class HeroPage extends StatelessWidget {
  final HeroBand hero;
  final List<Widget> children;
  final ScrollController? controller;
  const HeroPage({super.key, required this.hero, required this.children, this.controller});

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) items.add(const SizedBox(height: 14));
      items.add(children[i]);
    }
    return ListView(
      controller: controller,
      padding: EdgeInsets.zero,
      children: [
        hero,
        Transform.translate(
          offset: Offset(0, -hero.extraBottom),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: items),
          ),
        ),
      ],
    );
  }
}

/// Simple sub-page with a coloured app bar.
class SubPage extends StatelessWidget {
  final String title;
  final Color color;
  final Widget body;
  const SubPage({super.key, required this.title, required this.color, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
      body: body,
    );
  }
}

class Pill extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color? selectedColor;
  final TextStyle? style;
  const Pill({super.key, required this.label, required this.selected, required this.onTap, this.selectedColor, this.style});

  @override
  Widget build(BuildContext context) {
    final sel = selectedColor ?? C.yellow;
    return Material(
      color: selected ? sel : Theme.of(context).cardColor,
      shape: StadiumBorder(side: BorderSide(color: selected ? sel : C.sunk(context), width: 2)),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(label,
              style: (style ?? const TextStyle()).copyWith(
                fontWeight: FontWeight.w700,
                color: selected ? (sel == C.yellow ? const Color(0xFF4A3B00) : Colors.white) : C.muted(context),
              )),
        ),
      ),
    );
  }
}

void toast(BuildContext context, String msg) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating, duration: const Duration(milliseconds: 1600)));
}

String arNum(int n) {
  if (currentLang != 'ar') return '$n';
  const d = '٠١٢٣٤٥٦٧٨٩';
  return '$n'.split('').map((c) => d[int.parse(c)]).join();
}
