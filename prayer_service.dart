import 'package:adhan/adhan.dart';

import '../models/prayer.dart';

/// নামাজের সময় হিসাব (adhan প্যাকেজ)। পদ্ধতি: University of Islamic Sciences, Karachi
/// - বাংলাদেশে বহুল ব্যবহৃত। আসরের জন্য হানাফি/শাফিয়ি আলাদা।
class PrayerService {
  static PrayerSchedule compute({
    required double latitude,
    required double longitude,
    required String madhab, // 'hanafi' বা 'shafii'
    DateTime? now,
  }) {
    final current = now ?? DateTime.now();
    final coordinates = Coordinates(latitude, longitude);
    final params = CalculationMethod.karachi.getParameters();
    params.madhab = madhab == 'shafii' ? Madhab.shafi : Madhab.hanafi;

    List<PrayerEntry> entriesFor(DateTime day) {
      final t = PrayerTimes(coordinates, DateComponents.from(day), params);
      return [
        PrayerEntry(PrayerName.fajr, t.fajr.toLocal()),
        PrayerEntry(PrayerName.dhuhr, t.dhuhr.toLocal()),
        PrayerEntry(PrayerName.asr, t.asr.toLocal()),
        PrayerEntry(PrayerName.maghrib, t.maghrib.toLocal()),
        PrayerEntry(PrayerName.isha, t.isha.toLocal()),
      ];
    }

    final today = entriesFor(current);

    // পরবর্তী ওয়াক্ত: আজকের যেটা এখনো আসেনি; না থাকলে আগামীকালের ফজর
    PrayerEntry? next;
    for (final e in today) {
      if (e.time.isAfter(current)) {
        next = e;
        break;
      }
    }
    next ??= entriesFor(current.add(const Duration(days: 1))).first;

    // বর্তমান ওয়াক্ত: যে ওয়াক্তের সময় পেরিয়েছে তার মধ্যে শেষটি
    var currentName = PrayerName.isha; // ফজরের আগে হলে আগের রাতের এশা
    for (final e in today) {
      if (!e.time.isAfter(current)) currentName = e.name;
    }

    return PrayerSchedule(today: today, next: next, current: currentName);
  }
}
