class Dua {
  final String id;
  final String category; // সকাল-সন্ধ্যা, ঘুম, খাওয়া, সফর...
  final String title;
  final String arabic;
  final String transliteration;
  final String bn;
  final String en;
  final String reference;
  final bool verified;

  const Dua({
    required this.id,
    required this.category,
    this.title = '',
    required this.arabic,
    this.transliteration = '',
    this.bn = '',
    this.en = '',
    this.reference = '',
    this.verified = false,
  });

  factory Dua.fromJson(Map<String, dynamic> j) => Dua(
        id: j['id'] as String,
        category: j['category'] as String? ?? '',
        title: j['title'] as String? ?? '',
        arabic: j['arabic'] as String? ?? '',
        transliteration: j['transliteration'] as String? ?? '',
        bn: j['bn'] as String? ?? '',
        en: j['en'] as String? ?? '',
        reference: j['reference'] as String? ?? '',
        verified: j['verified'] as bool? ?? false,
      );
}
