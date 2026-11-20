import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../data/hadith_repository.dart';
import '../localization/app_strings.dart';
import '../models/dua.dart';
import '../models/hadith.dart';
import '../services/bookmark_service.dart';
import '../services/settings_service.dart';

class HadisDuaScreen extends StatefulWidget {
  const HadisDuaScreen({super.key});

  @override
  State<HadisDuaScreen> createState() => _HadisDuaScreenState();
}

class _HadisDuaScreenState extends State<HadisDuaScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 2, vsync: this);
  List<Hadith> _hadiths = [];
  List<Dua> _duas = [];
  String _query = '';
  bool _onlyBookmarked = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final hadiths = await HadithRepository().loadAll();
    List<Dua> duas = [];
    try {
      final raw = await rootBundle.loadString('assets/data/duas.json');
      final map = json.decode(raw) as Map<String, dynamic>;
      final items = (map['items'] as List? ?? []).cast<Map<String, dynamic>>();
      duas = items.map(Dua.fromJson).where((d) => d.verified).toList();
    } catch (_) {}
    if (!mounted) return;
    setState(() {
      _hadiths = hadiths;
      _duas = duas;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isBn = context.watch<SettingsService>().languageCode == 'bn';
    final bookmarks = context.watch<BookmarkService>();

    final filteredHadiths = _hadiths.where((h) {
      if (_onlyBookmarked && !bookmarks.isBookmarked(h.id)) return false;
      if (_query.isEmpty) return true;
      final q = _query.toLowerCase();
      return h.bn.toLowerCase().contains(q) ||
          h.en.toLowerCase().contains(q) ||
          h.reference.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('hadis_dua')),
        bottom: TabBar(
          controller: _tabs,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: isBn ? 'হাদিস (${filteredHadiths.length})' : 'Hadis (${filteredHadiths.length})'),
            Tab(text: isBn ? 'মাসনুন দোয়া (${_duas.length})' : 'Masnoon Dua (${_duas.length})'),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabs,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: isBn ? 'হাদিস খুঁজুন...' : 'Search hadis...',
                                prefixIcon: const Icon(Icons.search),
                                isDense: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              onChanged: (v) => setState(() => _query = v),
                            ),
                          ),
                          const SizedBox(width: 8),
                          FilterChip(
                            label: Text(isBn ? 'সেভ করা' : 'Saved'),
                            selected: _onlyBookmarked,
                            onSelected: (v) => setState(() => _onlyBookmarked = v),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: filteredHadiths.length,
                        itemBuilder: (ctx, i) {
                          final h = filteredHadiths[i];
                          final text = isBn ? h.bn : h.en;
                          final saved = bookmarks.isBookmarked(h.id);
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (h.arabic.isNotEmpty)
                                    Text(h.arabic,
                                        textDirection: TextDirection.rtl,
                                        style: const TextStyle(fontSize: 20, height: 1.8)),
                                  const SizedBox(height: 8),
                                  Text(text),
                                  const SizedBox(height: 8),
                                  Text(h.reference,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Theme.of(context).colorScheme.primary)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: Icon(saved
                                            ? Icons.bookmark
                                            : Icons.bookmark_border),
                                        onPressed: () => bookmarks.toggle(h.id),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.share),
                                        onPressed: () => Share.share(
                                            '${h.arabic}\n\n$text\n\n— ${h.reference}'),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                _duas.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            isBn
                                ? 'assets/data/duas.json ফাইলে যাচাইকৃত দোয়া যুক্ত করলে এখানে দেখা যাবে।'
                                : 'Add verified duas in assets/data/duas.json to display here.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _duas.length,
                        itemBuilder: (ctx, i) {
                          final d = _duas[i];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(d.title,
                                      style: const TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  Text(d.arabic,
                                      textDirection: TextDirection.rtl,
                                      style: const TextStyle(fontSize: 22, height: 1.8)),
                                  if (d.transliteration.isNotEmpty) ...[
                                    const SizedBox(height: 6),
                                    Text(d.transliteration,
                                        style: const TextStyle(fontStyle: FontStyle.italic)),
                                  ],
                                  const SizedBox(height: 6),
                                  Text(isBn ? d.bn : d.en),
                                  if (d.reference.isNotEmpty) ...[
                                    const SizedBox(height: 6),
                                    Text(d.reference,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context).colorScheme.primary)),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ),
    );
  }
}
