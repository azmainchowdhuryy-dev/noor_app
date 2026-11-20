/// একটি হাদিসের কাঠামো। টেক্সট শুধু যাচাইকৃত উৎস থেকে JSON-এ বসবে।
class Hadith {
  final String id;
  final String arabic;
  final String bn;
  final String en;
  final String reference; // গ্রন্থের নাম + নম্বর
  final String category;
  final List<String> tags;
  final bool verified; // true হলে তবেই অ্যাপে দেখানো হবে

  const Hadith({
    required this.id,
    required this.arabic,
    required this.bn,
    required this.en,
    required this.reference,
    required this.category,
    this.tags = const [],
    this.verified = false,
  });

  factory Hadith.fromJson(Map<String, dynamic> j) => Hadith(
        id: j['id'] as String,
        arabic: j['arabic'] as String? ?? '',
        bn: j['bn'] as String? ?? '',
        en: j['en'] as String? ?? '',
        reference: j['reference'] as String? ?? '',
        category: j['category'] as String? ?? '',
        tags: List<String>.from(j['tags'] ?? const []),
        verified: j['verified'] as bool? ?? false,
      );
}
