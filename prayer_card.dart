import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../localization/app_strings.dart';
import '../localization/digits.dart';
import '../models/app_location.dart';
import '../models/prayer.dart';
import '../services/location_service.dart';
import '../services/prayer_service.dart';
import '../services/settings_service.dart';
import '../theme/app_colors.dart';

/// বর্তমান/পরবর্তী ওয়াক্ত, কাউন্টডাউন, ৫ ওয়াক্তের তালিকা ও মাযহাব অপশন।
class PrayerCard extends StatefulWidget {
  const PrayerCard({super.key});

  @override
  State<PrayerCard> createState() => _PrayerCardState();
}

class _PrayerCardState extends State<PrayerCard> {
  Timer? _timer;
  DateTime _now = DateTime.now();

  // হিসাব ক্যাশ করা আছে, শুধু দরকারে আবার করা হয়
  PrayerSchedule? _schedule;
  double? _lat;
  double? _lng;
  String? _madhab;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  PrayerSchedule _scheduleFor(AppLocation loc, String madhab) {
    final s = _schedule;
    final stale = s == null ||
        _lat != loc.latitude ||
        _lng != loc.longitude ||
        _madhab != madhab ||
        !_now.isBefore(s.next.time) || // ওয়াক্ত শুরু হয়ে গেছে
        s.today.first.time.day != _now.day; // নতুন দিন
    if (stale) {
      _schedule = PrayerService.compute(
        latitude: loc.latitude,
        longitude: loc.longitude,
        madhab: madhab,
        now: _now,
      );
      _lat = loc.latitude;
      _lng = loc.longitude;
      _madhab = madhab;
    }
    return _schedule!;
  }

  String _formatTime(DateTime t) {
    final h12 = t.hour % 12 == 0 ? 12 : t.hour % 12;
    final mm = t.minute.toString().padLeft(2, '0');
    final suffix = t.hour < 12 ? 'AM' : 'PM';
    return '${h12.toString().padLeft(2, '0')}:$mm $suffix';
  }

  String _formatCountdown(Duration d) {
    if (d.isNegative) d = Duration.zero;
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsService>();
    final loc =
        context.watch<LocationService>().current ?? LocationService.fallback;
    final schedule = _scheduleFor(loc, settings.madhab);
    final next = schedule.next;
    final remaining = next.time.difference(_now);
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ---- উপরের সবুজ অংশ: পরবর্তী ওয়াক্ত ও কাউন্টডাউন ----
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.deepGreen, AppColors.emerald],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${context.tr('now_prayer')}: ${context.tr(schedule.current.name)}',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 10),
                Text(context.tr('next_prayer'),
                    style: const TextStyle(color: Colors.white70)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(context.tr(next.name.name),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(width: 12),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(context.digits(_formatTime(next.time)),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${context.tr('time_left')}  ${context.digits(_formatCountdown(remaining))}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),

          // ---- ৫ ওয়াক্তের তালিকা ----
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Column(
              children: [
                for (final e in schedule.today)
                  _PrayerRow(
                    label: context.tr(e.name.name),
                    time: context.digits(_formatTime(e.time)),
                    isNext: e.name == next.name,
                    isCurrent: e.name == schedule.current,
                  ),
              ],
            ),
          ),

          // ---- মাযহাব অপশন ----
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.tr('madhab'), style: theme.textTheme.bodySmall),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  showSelectedIcon: false,
                  style:
                      const ButtonStyle(visualDensity: VisualDensity.compact),
                  segments: [
                    ButtonSegment(
                        value: 'hanafi', label: Text(context.tr('hanafi'))),
                    ButtonSegment(
                        value: 'shafii', label: Text(context.tr('shafii'))),
                  ],
                  selected: {settings.madhab},
                  onSelectionChanged: (s) => settings.setMadhab(s.first),
                ),
                const SizedBox(height: 6),
                Text(context.tr('asr_note'), style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrayerRow extends StatelessWidget {
  final String label;
  final String time;
  final bool isNext;
  final bool isCurrent;

  const _PrayerRow({
    required this.label,
    required this.time,
    required this.isNext,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isNext ? scheme.primaryContainer.withOpacity(0.6) : null,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            isCurrent ? Icons.radio_button_checked : Icons.radio_button_off,
            size: 18,
            color: isCurrent ? scheme.primary : scheme.outline,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label,
                style: TextStyle(
                    fontWeight: isNext ? FontWeight.bold : FontWeight.normal)),
          ),
          Text(time,
              style: TextStyle(
                  fontWeight: isNext ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
