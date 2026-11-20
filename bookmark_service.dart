import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// হাদিস বুকমার্ক (id দিয়ে)। পরে দোয়ার জন্যও একই ধরনের সার্ভিস বানানো যাবে।
class BookmarkService extends ChangeNotifier {
  static const _key = 'bookmarked_hadith_ids';
  final Set<String> _ids = {};

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _ids
      ..clear()
      ..addAll(prefs.getStringList(_key) ?? const []);
  }

  bool isBookmarked(String id) => _ids.contains(id);

  Future<void> toggle(String id) async {
    if (!_ids.remove(id)) _ids.add(id);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, _ids.toList());
  }
}
