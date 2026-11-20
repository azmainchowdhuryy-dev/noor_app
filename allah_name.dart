class AllahName {
  final int number; // ১-৯৯
  final String arabic;
  final String transliteration;
  final String bn;
  final String en;
  final bool verified;

  const AllahName({
    required this.number,
    required this.arabic,
    this.transliteration = '',
    this.bn = '',
    this.en = '',
    this.verified = false,
  });

  factory AllahName.fromJson(Map<String, dynamic> j) => AllahName(
        number: j['number'] as int,
        arabic: j['arabic'] as String? ?? '',
        transliteration: j['transliteration'] as String? ?? '',
        bn: j['bn'] as String? ?? '',
        en: j['en'] as String? ?? '',
        verified: j['verified'] as bool? ?? false,
      );
}
