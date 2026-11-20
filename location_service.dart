import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../models/app_location.dart';

/// লোকেশন পায়। অনুমতি না দিলে বা GPS বন্ধ থাকলে ঢাকা ধরে নেয়।
class LocationService extends ChangeNotifier {
  static const AppLocation fallback = AppLocation(
    latitude: 23.8103,
    longitude: 90.4125,
    isFallback: true,
  );

  AppLocation? current;
  bool loading = false;

  Future<void> refresh() async {
    loading = true;
    notifyListeners();
    current = await _fetch();
    loading = false;
    notifyListeners();
  }

  Future<AppLocation> _fetch() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return fallback;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return fallback;
      }

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
      ).timeout(const Duration(seconds: 12));

      var name = '';
      try {
        final marks =
            await placemarkFromCoordinates(pos.latitude, pos.longitude);
        if (marks.isNotEmpty) {
          final m = marks.first;
          final parts = <String>[
            if ((m.locality ?? '').isNotEmpty) m.locality!,
            if ((m.administrativeArea ?? '').isNotEmpty) m.administrativeArea!,
          ];
          name = parts.join(', ');
        }
      } catch (_) {
        // নাম না পেলে নিচে স্থানাঙ্ক দেখানো হবে
      }
      if (name.isEmpty) {
        name =
            '${pos.latitude.toStringAsFixed(2)}, ${pos.longitude.toStringAsFixed(2)}';
      }
      return AppLocation(
          latitude: pos.latitude, longitude: pos.longitude, name: name);
    } catch (_) {
      return fallback;
    }
  }
}
