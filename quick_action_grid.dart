import 'package:flutter/material.dart';

import '../data/quick_actions.dart';
import '../localization/app_strings.dart';
import '../models/quick_action.dart';
import '../screens/more_screen.dart';

/// ৩ কলামের কুইক অ্যাকশন গ্রিড। তালিকা আসে data/quick_actions.dart থেকে।
class QuickActionGrid extends StatelessWidget {
  final void Function(int tabIndex) onOpenTab;
  const QuickActionGrid({super.key, required this.onOpenTab});

  void _onTap(BuildContext context, QuickAction action) {
    final tab = action.targetTab;
    if (tab != null) {
      onOpenTab(tab);
      return;
    }

    Widget? destination;
    switch (action.id) {
      case 'surahs':
        destination = const ShortSurahsPage();
        break;
      case 'names':
        destination = const AllahNamesPage();
        break;
      case 'tracker':
        destination = const SalatTrackerPage();
        break;
      case 'zakat':
        destination = const ZakatCalculatorPage();
        break;
      case 'pro':
        destination = const ProSupportPage();
        break;
      default:
        destination = null;
    }

    if (destination != null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => destination!));
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(context.tr('coming_soon'))));
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: kQuickActions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 108,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, i) {
        final action = kQuickActions[i];
        return _ActionTile(
          action: action,
          onTap: () => _onTap(context, action),
        );
      },
    );
  }
}

class _ActionTile extends StatelessWidget {
  final QuickAction action;
  final VoidCallback onTap;
  const _ActionTile({required this.action, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = action.highlight ? const Color(0xFFB8860B) : scheme.primary;

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(action.icon, color: color, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                context.tr(action.labelKey),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
