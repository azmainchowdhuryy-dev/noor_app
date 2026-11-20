import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../localization/app_strings.dart';
import '../services/location_service.dart';
import '../services/settings_service.dart';
import '../widgets/date_card.dart';
import '../widgets/hadith_card.dart';
import '../widgets/location_header.dart';
import '../widgets/prayer_card.dart';
import '../widgets/quick_action_grid.dart';
import '../widgets/section_title.dart';

class HomeScreen extends StatelessWidget {
  /// অন্য ট্যাবে যাওয়ার জন্য (MainShell থেকে আসে)
  final void Function(int tabIndex) onOpenTab;
  const HomeScreen({super.key, required this.onOpenTab});

  @override
  Widget build(BuildContext context) {
    final settings = context.read<SettingsService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('app_name')),
        actions: [
          // Light/Dark দ্রুত পরিবর্তন
          IconButton(
            tooltip: context.tr('theme'),
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => settings
                .setThemeMode(isDark ? ThemeMode.light : ThemeMode.dark),
          ),
          // বাংলা/ইংরেজি সুইচ
          TextButton(
            onPressed: settings.toggleLanguage,
            child: Text(context.tr('switch_language'),
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<LocationService>().refresh(),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            const LocationHeader(),
            const SizedBox(height: 4),
            const DateCard(),
            SectionTitle(context.tr('prayer_times_title')),
            const PrayerCard(),
            SectionTitle(context.tr('daily_hadith')),
            const HadithCard(),
            SectionTitle(context.tr('quick_actions')),
            QuickActionGrid(onOpenTab: onOpenTab),
          ],
        ),
      ),
    );
  }
}
