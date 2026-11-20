/// তারিখের নামগুলো (বার, মাস)। ভাষা: 'bn' বা 'en'
class DateNames {
  static const _weekdays = {
    'bn': [
      'সোমবার', 'মঙ্গলবার', 'বুধবার', 'বৃহস্পতিবার',
      'শুক্রবার', 'শনিবার', 'রবিবার'
    ],
    'en': [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday'
    ],
  };

  static const _gregorianMonths = {
    'bn': [
      'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
      'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর'
    ],
    'en': [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ],
  };

  static const _banglaMonths = {
    'bn': [
      'বৈশাখ', 'জ্যৈষ্ঠ', 'আষাঢ়', 'শ্রাবণ', 'ভাদ্র', 'আশ্বিন',
      'কার্তিক', 'অগ্রহায়ণ', 'পৌষ', 'মাঘ', 'ফাল্গুন', 'চৈত্র'
    ],
    'en': [
      'Boishakh', 'Joishtho', 'Asharh', 'Srabon', 'Bhadro', 'Ashwin',
      'Kartik', 'Ogrohayon', 'Poush', 'Magh', 'Falgun', 'Choitro'
    ],
  };

  static const _hijriMonths = {
    'bn': [
      'মুহাররম', 'সফর', 'রবিউল আউয়াল', 'রবিউস সানি',
      'জমাদিউল আউয়াল', 'জমাদিউস সানি', 'রজব', 'শাবান',
      'রমজান', 'শাওয়াল', 'জিলকদ', 'জিলহজ'
    ],
    'en': [
      'Muharram', 'Safar', "Rabi' al-awwal", "Rabi' al-thani",
      'Jumada al-awwal', 'Jumada al-thani', 'Rajab', "Sha'ban",
      'Ramadan', 'Shawwal', "Dhu al-Qi'dah", 'Dhu al-Hijjah'
    ],
  };

  /// weekday: DateTime.weekday (1 = সোমবার ... 7 = রবিবার)
  static String weekday(String lang, int weekday) =>
      _weekdays[lang]![weekday - 1];

  /// month: 1-12
  static String gregorianMonth(String lang, int month) =>
      _gregorianMonths[lang]![month - 1];

  /// month: 1-12 (১ = বৈশাখ)
  static String banglaMonth(String lang, int month) =>
      _banglaMonths[lang]![month - 1];

  /// month: 1-12 (১ = মুহাররম)
  static String hijriMonth(String lang, int month) =>
      _hijriMonths[lang]![month - 1];
}
