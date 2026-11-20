import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../localization/app_strings.dart';
import '../localization/digits.dart';
import '../models/allah_name.dart';
import '../models/surah.dart';
import '../services/settings_service.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsService>();
    final isBn = settings.languageCode == 'bn';

    return Scaffold(
      appBar: AppBar(title: Text(context.tr('more'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.menu_book),
                  title: Text(context.tr('qa_surahs')),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const ShortSurahsPage())),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.auto_awesome),
                  title: Text(context.tr('qa_names')),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const AllahNamesPage())),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.checklist),
                  title: Text(context.tr('qa_tracker')),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const SalatTrackerPage())),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.calculate),
                  title: Text(context.tr('qa_zakat')),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const ZakatCalculatorPage())),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.workspace_premium, color: Color(0xFFB8860B)),
                  title: Text(context.tr('qa_pro')),
                  subtitle: Text(isBn
                      ? 'বিজ্ঞাপন বন্ধ করুন ও অ্যাপ মেইনটেন্যান্সে সহায়তা করুন'
                      : 'Remove ads & support app maintenance'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const ProSupportPage())),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.tr('theme'),
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  SegmentedButton<ThemeMode>(
                    segments: [
                      ButtonSegment(
                          value: ThemeMode.light, label: Text(context.tr('light'))),
                      ButtonSegment(
                          value: ThemeMode.dark, label: Text(context.tr('dark'))),
                      ButtonSegment(
                          value: ThemeMode.system, label: Text(context.tr('system'))),
                    ],
                    selected: {settings.themeMode},
                    onSelectionChanged: (s) => settings.setThemeMode(s.first),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: ListTile(
              title: Text(context.tr('language')),
              trailing: TextButton(
                onPressed: settings.toggleLanguage,
                child: Text(context.tr('switch_language')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShortSurahsPage extends StatelessWidget {
  const ShortSurahsPage({super.key});

  Future<List<Surah>> _load() async {
    final raw = await rootBundle.loadString('assets/data/short_surahs.json');
    final map = json.decode(raw) as Map<String, dynamic>;
    final items = (map['items'] as List).cast<Map<String, dynamic>>();
    return items.map(Surah.fromJson).where((s) => s.verified).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isBn = context.watch<SettingsService>().languageCode == 'bn';
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('qa_surahs'))),
      body: FutureBuilder<List<Surah>>(
        future: _load(),
        builder: (ctx, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final list = snap.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            itemBuilder: (c, i) {
              final s = list[i];
              return Card(
                child: ExpansionTile(
                  leading: CircleAvatar(child: Text(context.digits(s.number))),
                  title: Text(isBn ? s.nameBn : s.nameEn),
                  subtitle: Text(s.nameArabic),
                  children: [
                    for (int a = 0; a < s.ayahsArabic.length; a++)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(s.ayahsArabic[a],
                                textDirection: TextDirection.rtl,
                                style: const TextStyle(fontSize: 22, height: 1.9)),
                            const SizedBox(height: 6),
                            Text(isBn
                                ? (a < s.translationBn.length ? s.translationBn[a] : '')
                                : (a < s.translationEn.length ? s.translationEn[a] : '')),
                            const Divider(),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class AllahNamesPage extends StatelessWidget {
  const AllahNamesPage({super.key});

  Future<List<AllahName>> _load() async {
    try {
      final raw = await rootBundle.loadString('assets/data/allah_names.json');
      final map = json.decode(raw) as Map<String, dynamic>;
      final items = (map['items'] as List? ?? []).cast<Map<String, dynamic>>();
      return items.map(AllahName.fromJson).where((n) => n.verified).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBn = context.watch<SettingsService>().languageCode == 'bn';
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('qa_names'))),
      body: FutureBuilder<List<AllahName>>(
        future: _load(),
        builder: (ctx, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final list = snap.data!;
          if (list.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  isBn
                      ? 'assets/data/allah_names.json ফাইলে ৯৯টি নাম যুক্ত করলে এখানে দেখা যাবে।'
                      : 'Add verified 99 Names in assets/data/allah_names.json.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            itemBuilder: (c, i) {
              final n = list[i];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(child: Text(context.digits(n.number))),
                  title: Text(n.transliteration),
                  subtitle: Text(isBn ? n.bn : n.en),
                  trailing: Text(n.arabic, style: const TextStyle(fontSize: 22)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class SalatTrackerPage extends StatefulWidget {
  const SalatTrackerPage({super.key});

  @override
  State<SalatTrackerPage> createState() => _SalatTrackerPageState();
}

class _SalatTrackerPageState extends State<SalatTrackerPage> {
  final Map<String, bool> _done = {
    'fajr': false,
    'dhuhr': false,
    'asr': false,
    'maghrib': false,
    'isha': false,
  };

  String get _todayKey {
    final n = DateTime.now();
    return 'salat_${n.year}_${n.month}_${n.day}';
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      for (final k in _done.keys) {
        _done[k] = prefs.getBool('${_todayKey}_$k') ?? false;
      }
    });
  }

  Future<void> _toggle(String k, bool v) async {
    setState(() => _done[k] = v);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('${_todayKey}_$k', v);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('qa_tracker'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final k in _done.keys)
            Card(
              child: CheckboxListTile(
                title: Text(context.tr(k)),
                value: _done[k],
                onChanged: (v) => _toggle(k, v ?? false),
              ),
            ),
        ],
      ),
    );
  }
}

class ZakatCalculatorPage extends StatefulWidget {
  const ZakatCalculatorPage({super.key});

  @override
  State<ZakatCalculatorPage> createState() => _ZakatCalculatorPageState();
}

class _ZakatCalculatorPageState extends State<ZakatCalculatorPage> {
  final _cashCtrl = TextEditingController();
  final _goldCtrl = TextEditingController();
  final _debtCtrl = TextEditingController();
  double _zakat = 0;

  void _calculate() {
    final cash = double.tryParse(_cashCtrl.text) ?? 0;
    final gold = double.tryParse(_goldCtrl.text) ?? 0;
    final debt = double.tryParse(_debtCtrl.text) ?? 0;
    final net = (cash + gold - debt).clamp(0, double.infinity);
    setState(() => _zakat = net * 0.025);
  }

  @override
  Widget build(BuildContext context) {
    final isBn = context.watch<SettingsService>().languageCode == 'bn';
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('qa_zakat'))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _cashCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: isBn ? 'নগদ টাকা ও ব্যাংক ব্যালেন্স' : 'Cash & Bank Balance',
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _goldCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: isBn ? 'স্বর্ণ ও রুপার বর্তমান মূল্য' : 'Gold & Silver Value',
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _debtCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: isBn ? 'তাৎক্ষণিক ঋণ (বাদ যাবে)' : 'Immediate Liabilities/Debt',
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _calculate,
            child: Text(isBn ? 'যাকাত হিসাব করুন (২.৫%)' : 'Calculate Zakat (2.5%)'),
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '${isBn ? 'প্রদেয় আনুমানিক যাকাত:' : 'Estimated Zakat:'} ${context.digits(_zakat.toStringAsFixed(2))}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProSupportPage extends StatelessWidget {
  const ProSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isBn = context.watch<SettingsService>().languageCode == 'bn';
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('qa_pro'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.workspace_premium, size: 56, color: Color(0xFFB8860B)),
                const SizedBox(height: 12),
                Text(
                  isBn ? 'নূর প্রো (বিজ্ঞাপনমুক্ত সংস্করণ)' : 'Noor Pro (Ad-Free Experience)',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  isBn
                      ? 'এই অ্যাপটি সাদাকায়ে জারিয়ার নিয়তে তৈরি। প্রো সাবস্ক্রিপশন নিলে সব বিজ্ঞাপন বন্ধ থাকবে এবং অ্যাপের সার্ভার ও ডেভেলপমেন্ট খরচ পরিচালনায় সহায়তা হবে।'
                      : 'Built with the intention of Sadaqah Jariyah. Subscribing removes all ads and supports ongoing app maintenance.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(isBn
                          ? 'Google Play Console-এ প্রোডাক্ট আইডি সেট করার পর পেমেন্ট চালু হবে।'
                          : 'Billing activates after configuring Product ID in Google Play Console.'),
                    ));
                  },
                  child: Text(isBn ? 'সাবস্ক্রাইব করুন (Google Play)' : 'Subscribe via Google Play'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
