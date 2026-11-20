import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../services/settings_service.dart';

/// সব লেখা এখানে। নতুন লেখা যোগ করতে bn ও en দুই জায়গায় একই key দিন।
/// ব্যবহার: context.tr('home')
class AppStrings {
  static const Map<String, Map<String, String>> _values = {
    'bn': {
      'app_name': 'নূর',
      'home': 'হোম',
      'hadis_dua': 'হাদিস ও দোয়া',
      'tasbih': 'তাসবিহ',
      'more': 'আরও',
      'language': 'ভাষা',
      'switch_language': 'English',
      'theme': 'থিম',
      'light': 'লাইট',
      'dark': 'ডার্ক',
      'system': 'সিস্টেম',
      'coming_soon': 'শীঘ্রই আসছে',
      // লোকেশন
      'locating': 'লোকেশন খোঁজা হচ্ছে...',
      'default_location': 'ঢাকা (ডিফল্ট)',
      'refresh_location': 'লোকেশন আপডেট',
      // তারিখ
      'cal_english': 'ইংরেজি',
      'cal_bangla': 'বাংলা',
      'cal_hijri': 'হিজরি',
      'hijri_suffix': 'হিজরি',
      'hijri_adjust': 'হিজরি তারিখ সমন্বয় (চাঁদ দেখা অনুযায়ী)',
      // সালাত
      'prayer_times_title': 'আজকের সালাতের সময়',
      'next_prayer': 'পরবর্তী ওয়াক্ত',
      'time_left': 'বাকি',
      'now_prayer': 'এখন',
      'madhab': 'আসরের মাযহাব',
      'hanafi': 'হানাফি',
      'shafii': 'শাফিয়ি',
      'asr_note': 'শুধু আসরের সময় মাযহাব অনুযায়ী ভিন্ন হয়।',
      'fajr': 'ফজর',
      'dhuhr': 'যোহর',
      'asr': 'আসর',
      'maghrib': 'মাগরিব',
      'isha': 'এশা',
      // হাদিস
      'daily_hadith': 'দৈনিক জনপ্রিয় হাদিস',
      'no_hadith_yet':
          'যাচাইকৃত হাদিস এখনো যোগ করা হয়নি। assets/data/hadiths.json-এ যাচাইকৃত ডেটা বসালে এখানে প্রতিদিন একটি হাদিস দেখা যাবে।',
      'bookmark': 'বুকমার্ক',
      'share': 'শেয়ার',
      // কুইক অ্যাকশন
      'quick_actions': 'দ্রুত অ্যাক্সেস',
      'qa_counter': 'দরুদ ও ইস্তেগফার',
      'qa_qibla': 'কিবলা কম্পাস',
      'qa_names': 'আল্লাহর ৯৯ নাম',
      'qa_surahs': '১০টি ছোট সূরা',
      'qa_dua': 'মাসনুন দোয়া',
      'qa_ramadan': 'রমাদান ও রোজা',
      'qa_tracker': 'সালাত ট্র্যাকার',
      'qa_zakat': 'যাকাত ক্যালকুলেটর',
      'qa_pro': 'প্রো / বিজ্ঞাপন বন্ধ',
    },
    'en': {
      'app_name': 'Noor',
      'home': 'Home',
      'hadis_dua': 'Hadis & Dua',
      'tasbih': 'Tasbih',
      'more': 'More',
      'language': 'Language',
      'switch_language': 'বাংলা',
      'theme': 'Theme',
      'light': 'Light',
      'dark': 'Dark',
      'system': 'System',
      'coming_soon': 'Coming soon',
      // Location
      'locating': 'Finding location...',
      'default_location': 'Dhaka (default)',
      'refresh_location': 'Refresh location',
      // Dates
      'cal_english': 'English',
      'cal_bangla': 'Bangla',
      'cal_hijri': 'Hijri',
      'hijri_suffix': 'AH',
      'hijri_adjust': 'Hijri date adjustment (moon sighting)',
      // Prayer
      'prayer_times_title': "Today's prayer times",
      'next_prayer': 'Next prayer',
      'time_left': 'Time left',
      'now_prayer': 'Now',
      'madhab': 'Asr method',
      'hanafi': 'Hanafi',
      'shafii': "Shafi'i",
      'asr_note': 'Only the Asr time differs between the two.',
      'fajr': 'Fajr',
      'dhuhr': 'Dhuhr',
      'asr': 'Asr',
      'maghrib': 'Maghrib',
      'isha': 'Isha',
      // Hadith
      'daily_hadith': 'Daily Most Popular Hadis',
      'no_hadith_yet':
          'No verified hadis added yet. Once verified data is placed in assets/data/hadiths.json, one hadis will show here every day.',
      'bookmark': 'Bookmark',
      'share': 'Share',
      // Quick actions
      'quick_actions': 'Quick access',
      'qa_counter': 'Dorud & Istegfar',
      'qa_qibla': 'Qibla Compass',
      'qa_names': '99 Names of Allah',
      'qa_surahs': '10 Short Surahs',
      'qa_dua': 'Masnoon Dua',
      'qa_ramadan': 'Ramadan & Fasting',
      'qa_tracker': '5-Waqt Tracker',
      'qa_zakat': 'Zakat Calculator',
      'qa_pro': 'Go Pro / Remove Ads',
    },
  };

  static String get(String lang, String key) =>
      _values[lang]?[key] ?? _values['en']?[key] ?? key;
}

extension TranslateContext on BuildContext {
  /// ভাষা বদলালে এই লেখা নিজে থেকেই আপডেট হয়।
  String tr(String key) =>
      AppStrings.get(watch<SettingsService>().languageCode, key);
}
