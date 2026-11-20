import 'package:flutter/material.dart';
import '../models/quick_action.dart';

/// নতুন ফিচার এলে শুধু এখানে একটি লাইন যোগ করলেই গ্রিডে দেখা যাবে।
/// ট্যাব নম্বর: 0 হোম, 1 হাদিস ও দোয়া, 2 তাসবিহ, 3 আরও
const List<QuickAction> kQuickActions = [
  QuickAction(
      id: 'counter',
      icon: Icons.touch_app,
      labelKey: 'qa_counter',
      targetTab: 2),
  QuickAction(id: 'qibla', icon: Icons.explore, labelKey: 'qa_qibla'),
  QuickAction(id: 'names', icon: Icons.auto_awesome, labelKey: 'qa_names'),
  QuickAction(id: 'surahs', icon: Icons.menu_book, labelKey: 'qa_surahs'),
  QuickAction(
      id: 'dua',
      icon: Icons.wb_twilight,
      labelKey: 'qa_dua',
      targetTab: 1),
  QuickAction(id: 'ramadan', icon: Icons.nights_stay, labelKey: 'qa_ramadan'),
  QuickAction(id: 'tracker', icon: Icons.checklist, labelKey: 'qa_tracker'),
  QuickAction(id: 'zakat', icon: Icons.calculate, labelKey: 'qa_zakat'),
  QuickAction(
      id: 'pro',
      icon: Icons.workspace_premium,
      labelKey: 'qa_pro',
      highlight: true),
];
