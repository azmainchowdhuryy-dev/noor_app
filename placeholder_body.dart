import 'package:flutter/material.dart';
import '../localization/app_strings.dart';

/// স্ক্রিন বানানো না হওয়া পর্যন্ত ব্যবহারের জন্য।
class PlaceholderBody extends StatelessWidget {
  const PlaceholderBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(24),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(context.tr('coming_soon'),
              style: Theme.of(context).textTheme.titleMedium),
        ),
      ),
    );
  }
}
