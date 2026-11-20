import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'services/bookmark_service.dart';
import 'services/location_service.dart';
import 'services/settings_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settings = SettingsService();
  final bookmarks = BookmarkService();
  await Future.wait([settings.load(), bookmarks.load()]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settings),
        ChangeNotifierProvider.value(value: bookmarks),
        ChangeNotifierProvider(create: (_) => LocationService()..refresh()),
      ],
      child: const NoorApp(),
    ),
  );
}
