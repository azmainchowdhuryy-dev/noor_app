import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../localization/app_strings.dart';
import '../localization/digits.dart';
import '../services/settings_service.dart';
import '../theme/app_colors.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> {
  static const _kTotal = 'tasbih_total_count';
  static const _kPresent = 'tasbih_present_count';
  static const _kTarget = 'tasbih_target';
  static const _kVibrate = 'tasbih_vibrate';

  int _present = 0;
  int _total = 0;
  int _target = 100;
  bool _vibrate = true;
  int _selectedDhikr = 0;

  static const List<Map<String, String>> _dhikrs = [
    {
      'arabic': 'أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ',
      'bn_pron': 'আস্তাগফিরুল্লাহা ওয়া আতূবু ইলাইহি',
      'bn': 'আমি আল্লাহর নিকট ক্ষমা প্রার্থনা করছি এবং তাঁর দিকেই ফিরে আসছি।',
      'en': 'I seek forgiveness from Allah and repent to Him.',
    },
    {
      'arabic': 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ',
      'bn_pron': 'আল্লাহুম্মা সাল্লি আলা মুহাম্মাদিউ ওয়া আলা আলি মুহাম্মাদ',
      'bn': 'হে আল্লাহ! মুহাম্মাদ (সা.) ও তাঁর পরিবারবর্গের ওপর রহমত বর্ষণ করুন।',
      'en': 'O Allah, send blessings upon Muhammad and the family of Muhammad.',
    },
    {
      'arabic': 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ، سُبْحَانَ اللَّهِ الْعَظِيمِ',
      'bn_pron': 'সুবহানাল্লাহি ওয়া বিহামদিহি, সুবহানাল্লাহিল আযীম',
      'bn': 'আল্লাহ পবিত্র ও সকল প্রশংসা তাঁরই, মহান আল্লাহ অতি পবিত্র।',
      'en': 'Glory and praise be to Allah, Glory be to Allah the Supreme.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _present = prefs.getInt(_kPresent) ?? 0;
      _total = prefs.getInt(_kTotal) ?? 0;
      _target = prefs.getInt(_kTarget) ?? 100;
      _vibrate = prefs.getBool(_kVibrate) ?? true;
    });
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kPresent, _present);
    await prefs.setInt(_kTotal, _total);
    await prefs.setInt(_kTarget, _target);
    await prefs.setBool(_kVibrate, _vibrate);
  }

  void _increment() {
    if (_vibrate) HapticFeedback.lightImpact();
    setState(() {
      _present++;
      _total++;
    });
    _save();
  }

  Future<void> _confirmReset(bool resetTotal) async {
    final isBn = context.read<SettingsService>().languageCode == 'bn';
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isBn ? 'রিসেট নিশ্চিত করুন' : 'Confirm Reset'),
        content: Text(resetTotal
            ? (isBn
                ? 'আপনি কি সর্বমোট কাউন্ট (Total Count) শূন্য করতে চান?'
                : 'Reset lifetime total count to zero?')
            : (isBn
                ? 'বর্তমান সেশন কাউন্ট (Present Count) রিসেট করবেন?'
                : 'Reset current session count?')),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(isBn ? 'না' : 'Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(isBn ? 'হ্যাঁ, রিসেট' : 'Reset')),
        ],
      ),
    );
    if (ok == true) {
      setState(() {
        _present = 0;
        if (resetTotal) _total = 0;
      });
      _save();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBn = context.watch<SettingsService>().languageCode == 'bn';
    final item = _dhikrs[_selectedDhikr];
    final progress = (_present / _target).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('tasbih')),
        actions: [
          IconButton(
            tooltip: isBn ? 'ভাইব্রেশন' : 'Vibration',
            icon: Icon(_vibrate ? Icons.vibration : Icons.smartphone),
            onPressed: () {
              setState(() => _vibrate = !_vibrate);
              _save();
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SegmentedButton<int>(
            segments: [
              ButtonSegment(value: 0, label: Text(isBn ? 'ইস্তেগফার' : 'Istegfar')),
              ButtonSegment(value: 1, label: Text(isBn ? 'দরুদ' : 'Dorud')),
              ButtonSegment(value: 2, label: Text(isBn ? 'তাসবিহ' : 'Tasbih')),
            ],
            selected: {_selectedDhikr},
            onSelectionChanged: (s) => setState(() => _selectedDhikr = s.first),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(item['arabic']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 22, height: 1.8)),
                  if (isBn) ...[
                    const SizedBox(height: 6),
                    Text(item['bn_pron']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                  const SizedBox(height: 6),
                  Text(isBn ? item['bn']! : item['en']!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: [
                        Text(isBn ? 'বর্তমান কাউন্ট' : 'Present Count'),
                        const SizedBox(height: 4),
                        Text(context.digits(_present),
                            style: const TextStyle(
                                fontSize: 26, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      children: [
                        Text(isBn ? 'সর্বমোট কাউন্ট' : 'Total Count'),
                        const SizedBox(height: 4),
                        Text(context.digits(_total),
                            style: const TextStyle(
                                fontSize: 26, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [33, 100, 1000]
                .map((t) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text('${isBn ? 'টার্গেট' : 'Target'} ${context.digits(t)}'),
                        selected: _target == t,
                        onSelected: (_) {
                          setState(() => _target = t);
                          _save();
                        },
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 20),
          Center(
            child: GestureDetector(
              onTap: _increment,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 190,
                    height: 190,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 12,
                      backgroundColor: AppColors.emerald.withOpacity(0.18),
                      color: AppColors.deepGreen,
                    ),
                  ),
                  Container(
                    width: 155,
                    height: 155,
                    decoration: const BoxDecoration(
                      color: AppColors.deepGreen,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(context.digits(_present),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold)),
                        Text(isBn ? 'ট্যাপ করুন' : 'TAP',
                            style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton.icon(
                onPressed: () => _confirmReset(false),
                icon: const Icon(Icons.refresh),
                label: Text(isBn ? 'সেশন রিসেট' : 'Reset Session'),
              ),
              TextButton.icon(
                onPressed: () => _confirmReset(true),
                icon: const Icon(Icons.delete_outline),
                label: Text(isBn ? 'টোটাল রিসেট' : 'Reset Total'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
