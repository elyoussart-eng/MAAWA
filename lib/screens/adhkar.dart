import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data.dart';
import '../l10n.dart';
import '../state.dart';
import '../ui.dart';
import 'home.dart' show isMorningNow;

const List<String> kCats = ['morning', 'evening', 'prayer', 'sleep', 'wake', 'mosque', 'duas', 'parents', 'mine'];

const Map<String, List<Color>> kCatColors = {
  'morning': [C.green, C.green],
  'evening': [C.purple, C.purple],
  'prayer': [C.blue, C.blue2],
  'sleep': [C.indigo, C.purple],
  'wake': [C.blue, C.green],
  'mosque': [C.green, C.blue],
  'duas': [C.purple, C.pink],
  'parents': [C.pink, C.purple],
  'mine': [C.pink, C.pink],
};

class AdhkarScreen extends StatefulWidget {
  const AdhkarScreen({super.key});
  static final ValueNotifier<String?> requested = ValueNotifier(null);
  @override
  State<AdhkarScreen> createState() => _AdhkarScreenState();
}

class _AdhkarScreenState extends State<AdhkarScreen> {
  String _cat = isMorningNow() ? 'morning' : 'evening';
  final _text = TextEditingController();
  final _count = TextEditingController(text: '1');

  @override
  void initState() {
    super.initState();
    AdhkarScreen.requested.addListener(_onRequest);
  }

  void _onRequest() {
    final c = AdhkarScreen.requested.value;
    if (c != null && mounted) setState(() => _cat = c);
  }

  @override
  void dispose() {
    AdhkarScreen.requested.removeListener(_onRequest);
    _text.dispose();
    _count.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    final items = s.items(_cat);
    final done = [for (var i = 0; i < items.length; i++) s.progressOf(_cat, i) >= items[i].count].where((e) => e).length;

    return HeroPage(
      hero: HeroBand(title: catName(_cat), subtitle: t('adhkar'), colors: kCatColors[_cat]!),
      children: [
        AppCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            SizedBox(
              height: 42,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: kCats.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) => Pill(label: catName(kCats[i]), selected: kCats[i] == _cat, onTap: () => setState(() => _cat = kCats[i])),
              ),
            ),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: Text(t('progress', {'d': done, 'n': items.length}), style: TextStyle(color: C.muted(context)))),
              IconButton(onPressed: () => s.setDhikrSize(s.dhikrSize - 2), icon: const Icon(Icons.zoom_out)),
              IconButton(onPressed: () => s.setDhikrSize(s.dhikrSize + 2), icon: const Icon(Icons.zoom_in)),
              TextButton(onPressed: () => s.resetCategory(_cat), child: Text(t('restart'))),
            ]),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(value: items.isEmpty ? 0 : done / items.length, minHeight: 8, backgroundColor: C.sunk(context), color: C.green),
            ),
          ]),
        ),
        if (_cat == 'mine') _addForm(context, s),
        if (items.isEmpty)
          AppCard(child: Text(t('emptyMine'), textAlign: TextAlign.center, style: TextStyle(color: C.muted(context)))),
        for (var i = 0; i < items.length; i++) _card(context, s, items[i], i),
      ],
    );
  }

  Widget _addForm(BuildContext context, AppState s) {
    return AppCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(t('addDhikr'), style: TextStyle(color: C.muted(context), fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: _text,
          minLines: 2,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: t('dhikrHint'),
            filled: true,
            fillColor: C.sunk(context),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 10),
        Row(children: [
          Text(t('times'), style: TextStyle(color: C.muted(context))),
          const SizedBox(width: 10),
          SizedBox(
            width: 90,
            child: TextField(
              controller: _count,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                filled: true,
                fillColor: C.sunk(context),
                isDense: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
          const Spacer(),
          FilledButton(
            onPressed: () {
              final txt = _text.text.trim();
              if (txt.isEmpty) {
                toast(context, t('dhikrHint'));
                return;
              }
              final n = (int.tryParse(_count.text) ?? 1).clamp(1, 1000).toInt();
              s.addCustom(txt, n);
              _text.clear();
              _count.text = '1';
              FocusScope.of(context).unfocus();
              toast(context, t('added'));
            },
            child: Text(t('add')),
          ),
        ]),
      ]),
    );
  }

  Widget _card(BuildContext context, AppState s, Dhikr x, int i) {
    final c = s.progressOf(_cat, i);
    final complete = c >= x.count;
    final deep = C.deep(context);
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: complete ? 0.6 : 1,
      child: Container(
        decoration: BoxDecoration(
          color: C.cream(context),
          border: Border.all(color: C.creamLine(context), width: 2),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              if (x.note.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(noteText(x.note), style: TextStyle(fontSize: 13, color: C.muted(context), fontWeight: FontWeight.w700)),
                ),
              Text(
                x.text,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: x.quran ? quranStyle(s.dhikrSize + 2, height: 2.2) : naskhStyle(s.dhikrSize, height: 2.0),
              ),
            ]),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            decoration: BoxDecoration(color: complete ? deep : C.green, borderRadius: BorderRadius.circular(16)),
            child: Row(children: [
              Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    final finished = s.countDhikr(_cat, i);
                    HapticFeedback.lightImpact();
                    if (finished) HapticFeedback.mediumImpact();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(complete ? t('done') : t('repeat'),
                          style: TextStyle(color: complete && C.dark(context) ? Colors.black : Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                      const SizedBox(width: 8),
                      Container(
                        constraints: const BoxConstraints(minWidth: 28),
                        height: 28,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 2), borderRadius: BorderRadius.circular(99)),
                        child: Text(complete ? '✓' : '${x.count - c}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                      ),
                    ]),
                  ),
                ),
              ),
              Container(width: 1, height: 26, color: Colors.white54),
              TextButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: x.text));
                  toast(context, t('copied'));
                },
                child: Text(t('copy'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
              ),
              if (x.own) ...[
                Container(width: 1, height: 26, color: Colors.white54),
                TextButton(
                  onPressed: () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        content: Text(t('deleteQ')),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(t('cancel'))),
                          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(t('delete'))),
                        ],
                      ),
                    );
                    if (ok == true) s.deleteCustom(i);
                  },
                  child: Text(t('delete'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                ),
              ],
            ]),
          ),
        ]),
      ),
    );
  }
}
