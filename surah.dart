class Surah {
  final int number; // কুরআনে সূরার ক্রমিক নম্বর
  final String nameArabic;
  final String nameBn;
  final String nameEn;
  final List<String> ayahsArabic;
  final List<String> transliteration;
  final List<String> translationBn;
  final List<String> translationEn;
  final String audioAsset; // অডিও ফাইলের পথ (পরে)
  final bool verified;

  const Surah({
    required this.number,
    required this.nameArabic,
    this.nameBn = '',
    this.nameEn = '',
    this.ayahsArabic = const [],
    this.transliteration = const [],
    this.translationBn = const [],
    this.translationEn = const [],
    this.audioAsset = '',
    this.verified = false,
  });

  factory Surah.fromJson(Map<String, dynamic> j) => Surah(
        number: j['number'] as int,
        nameArabic: j['name_arabic'] as String? ?? '',
        nameBn: j['name_bn'] as String? ?? '',
        nameEn: j['name_en'] as String? ?? '',
        ayahsArabic: List<String>.from(j['ayahs_arabic'] ?? const []),
        transliteration: List<String>.from(j['transliteration'] ?? const []),
        translationBn: List<String>.from(j['translation_bn'] ?? const []),
        translationEn: List<String>.from(j['translation_en'] ?? const []),
        audioAsset: j['audio_asset'] as String? ?? '',
        verified: j['verified'] as bool? ?? false,
      );
}
