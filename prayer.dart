/// enum-এর .name হলো localization key: fajr, dhuhr, asr, maghrib, isha
enum PrayerName { fajr, dhuhr, asr, maghrib, isha }

class PrayerEntry {
  final PrayerName name;
  final DateTime time;
  const PrayerEntry(this.name, this.time);
}

class PrayerSchedule {
  final List<PrayerEntry> today; // আজকের ৫ ওয়াক্ত
  final PrayerEntry next; // পরবর্তী ওয়াক্ত (দরকারে আগামীকালের ফজর)
  final PrayerName current; // এখন যে ওয়াক্ত চলছে
  const PrayerSchedule({
    required this.today,
    required this.next,
    required this.current,
  });
}
