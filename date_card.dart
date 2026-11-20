import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../localization/app_strings.dart';
import '../localization/date_names.dart';
import '../localization/digits.dart';
import '../services/date_service.dart';
import '../services/settings_service.dart';

/// ইংরেজি, বাংলা ও হিজরি তারিখ একসাথে (হিজরিতে -1/0/+1 সমন্বয়)।
class DateCard extends StatelessWidget {
  const DateCard({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsService>();
    final lang = settings.languageCode;
    final now = DateTime.now();

    final english =
        '${DateNames.weekday(lang, now.weekday)}, ${now.day} ${DateNames.gregorianMonth(lang, now.month)} ${now.year}';

    final b = DateService.bangla(now);
    final bangla =
        '${b.day} ${DateNames.banglaMonth(lang, b.month)} ${b.year}';

    final h = DateService.hijri(now, settings.hijriOffset);
    final hijri =
        '${h.hDay} ${DateNames.hijriMonth(lang, h.hMonth)} ${h.hYear} ${context.tr('hijri_suffix')}';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DateRow(
                icon: Icons.calendar_today,
                caption: context.tr('cal_english'),
                text: context.digits(english)),
            const Divider(height: 20),
            _DateRow(
                icon: Icons.event,
                caption: context.tr('cal_bangla'),
                text: context.digits(bangla)),
            const Divider(height: 20),
            _DateRow(
                icon: Icons.nightlight_round,
                caption: context.tr('cal_hijri'),
                text: context.digits(hijri)),
            const SizedBox(height: 12),
            Text(context.tr('hijri_adjust'),
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            SegmentedButton<int>(
              showSelectedIcon: false,
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
              segments: [
                ButtonSegment(value: -1, label: Text(context.digits('-1'))),
                ButtonSegment(value: 0, label: Text(context.digits('0'))),
                ButtonSegment(value: 1, label: Text(context.digits('+1'))),
              ],
              selected: {settings.hijriOffset},
              onSelectionChanged: (s) => settings.setHijriOffset(s.first),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateRow extends StatelessWidget {
  final IconData icon;
  final String caption;
  final String text;
  const _DateRow(
      {required this.icon, required this.caption, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(caption, style: theme.textTheme.bodySmall),
              Text(text,
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }
}
