import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'localization/app_strings.dart';
import 'screens/main_shell.dart';
import 'services/settings_service.dart';
import 'theme/app_theme.dart';

class NoorApp extends StatelessWidget {
  const NoorApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsService>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.get(settings.languageCode, 'app_name'),
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: settings.themeMode,
      home: const MainShell(),
    );
  }
}
