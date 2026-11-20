import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/hadith.dart';

/// JSON ফাইল থেকে হাদিস পড়ে। শুধু verified=true গুলো ফেরত দেয়।
/// পরে ডেটা বদলালে শুধু JSON বদলাবে, কোড নয়।
class HadithRepository {
  static const _path = 'assets/data/hadiths.json';

  Future<List<Hadith>> loadAll() async {
    final raw = await rootBundle.loadString(_path);
    final map = json.decode(raw) as Map<String, dynamic>;
    final items = (map['items'] as List).cast<Map<String, dynamic>>();
    return items.map(Hadith.fromJson).where((h) => h.verified).toList();
  }

  /// প্রতিদিন একটি করে হাদিস: বছরের কত তম দিন, তা দিয়ে বাছাই।
  /// তালিকা ফাঁকা হলে null।
  static Hadith? pickDaily(List<Hadith> list, DateTime date) {
    if (list.isEmpty) return null;
    final startOfYear = DateTime.utc(date.year, 1, 1);
    final today = DateTime.utc(date.year, date.month, date.day);
    final dayOfYear = today.difference(startOfYear).inDays;
    return list[dayOfYear % list.length];
  }
}
