import 'package:hijri/hijri_calendar.dart';

class BanglaDate {
  final int day;
  final int month; // 1-12 (১ = বৈশাখ)
  final int year;
  const BanglaDate(this.day, this.month, this.year);
}

class DateService {
  /// বাংলাদেশের সংশোধিত বাংলা পঞ্জিকা (মাস শুরুর ইংরেজি তারিখ [মাস, দিন])।
  /// বৈশাখ ... চৈত্র। ফাল্গুন লিপ ইয়ারে ৩১ দিন - এটি স্বয়ংক্রিয়ভাবে মিলে যায়।
  static const List<List<int>> _starts = [
    [4, 14], [5, 15], [6, 15], [7, 16], [8, 16], [9, 16],
    [10, 16], [11, 15], [12, 15], [1, 14], [2, 13], [3, 15],
  ];

  static BanglaDate bangla(DateTime date) {
    final d = DateTime.utc(date.year, date.month, date.day);

    DateTime? best;
    var bestIndex = 0;
    for (final y in [d.year - 1, d.year]) {
      for (var i = 0; i < 12; i++) {
        final s = DateTime.utc(y, _starts[i][0], _starts[i][1]);
        if (!s.isAfter(d) && (best == null || s.isAfter(best))) {
          best = s;
          bestIndex = i;
        }
      }
    }
    final day = d.difference(best!).inDays + 1;
    final newYear = DateTime.utc(d.year, 4, 14);
    final year = d.isBefore(newYear) ? d.year - 594 : d.year - 593;
    return BanglaDate(day, bestIndex + 1, year);
  }

  /// offset: -1 / 0 / +1 (চাঁদ দেখার পার্থক্য অনুযায়ী)
  static HijriCalendar hijri(DateTime date, int offset) {
    return HijriCalendar.fromDate(date.add(Duration(days: offset)));
  }
}
