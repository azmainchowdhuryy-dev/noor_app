import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../localization/app_strings.dart';
import '../services/location_service.dart';

class LocationHeader extends StatelessWidget {
  const LocationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final service = context.watch<LocationService>();
    final loc = service.current;

    String label;
    if (service.loading || loc == null) {
      label = context.tr('locating');
    } else if (loc.isFallback) {
      label = context.tr('default_location');
    } else {
      label = loc.name ?? '';
    }

    return Row(
      children: [
        Icon(Icons.location_on, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 6),
        Expanded(
          child: Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall),
        ),
        IconButton(
          tooltip: context.tr('refresh_location'),
          icon: const Icon(Icons.my_location),
          onPressed: service.loading ? null : service.refresh,
        ),
      ],
    );
  }
}
