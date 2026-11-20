import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../data/hadith_repository.dart';
import '../localization/app_strings.dart';
import '../models/hadith.dart';
import '../services/bookmark_service.dart';
import '../services/settings_service.dart';

/// প্রতিদিন ১টি করে যাচাইকৃত হাদিস। ডেটা না থাকলে সুন্দর একটি খালি-অবস্থা দেখায়।
class HadithCard extends StatefulWidget {
  const HadithCard({super.key});

  @override
  State<HadithCard> createState() => _HadithCardState();
}

class _HadithCardState extends State<HadithCard> {
  late final Future<Hadith?> _future = _load();

  Future<Hadith?> _load() async {
    try {
      final all = await HadithRepository().loadAll();
      return HadithRepository.pickDaily(all, DateTime.now());
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.format_quote, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(context.tr('daily_hadith'),
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 12),
            FutureBuilder<Hadith?>(
              future: _future,
              builder: (context, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final hadith = snap.data;
                if (hadith == null) {
                  return Text(context.tr('no_hadith_yet'),
                      style: theme.textTheme.bodyMedium);
                }
                return _HadithBody(hadith: hadith);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _HadithBody extends StatelessWidget {
  final Hadith hadith;
  const _HadithBody({required this.hadith});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = context.watch<SettingsService>().languageCode;
    final bookmarks = context.watch<BookmarkService>();
    final saved = bookmarks.isBookmarked(hadith.id);

    // নির্বাচিত ভাষার অনুবাদ; না থাকলে অন্য ভাষারটি
    final primary = lang == 'bn' ? hadith.bn : hadith.en;
    final fallback = lang == 'bn' ? hadith.en : hadith.bn;
    final translation = primary.isNotEmpty ? primary : fallback;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hadith.arabic.isNotEmpty)
          Directionality(
            textDirection: TextDirection.rtl,
            child: SizedBox(
              width: double.infinity,
              child: Text(hadith.arabic,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 22, height: 1.9)),
            ),
          ),
        if (translation.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(translation, style: theme.textTheme.bodyLarge),
        ],
        if (hadith.reference.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(hadith.reference,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.primary)),
        ],
        if (hadith.tags.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            children: [
              for (final t in hadith.tags)
                Chip(
                  label: Text(t),
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
        ],
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              tooltip: context.tr('bookmark'),
              icon: Icon(saved ? Icons.bookmark : Icons.bookmark_border),
              onPressed: () => bookmarks.toggle(hadith.id),
            ),
            IconButton(
              tooltip: context.tr('share'),
              icon: const Icon(Icons.share),
              onPressed: () {
                final text = [
                  if (hadith.arabic.isNotEmpty) hadith.arabic,
                  if (translation.isNotEmpty) translation,
                  if (hadith.reference.isNotEmpty) '— ${hadith.reference}',
                ].join('\n\n');
                Share.share(text);
              },
            ),
          ],
        ),
      ],
    );
  }
}
