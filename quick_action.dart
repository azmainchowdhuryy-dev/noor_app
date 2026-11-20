import 'package:flutter/material.dart';

/// কুইক অ্যাকশন গ্রিডের একটি ঘর।
/// targetTab != null হলে ওই ট্যাবে যাবে, না হলে "শীঘ্রই আসছে" দেখাবে।
class QuickAction {
  final String id;
  final IconData icon;
  final String labelKey;
  final int? targetTab;
  final bool highlight;

  const QuickAction({
    required this.id,
    required this.icon,
    required this.labelKey,
    this.targetTab,
    this.highlight = false,
  });
}
