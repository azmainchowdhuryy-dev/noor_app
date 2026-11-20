import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../services/settings_service.dart';

const _bnDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];

/// বাংলা ভাষায় 0-9 কে ০-৯ বানায়।
String localizeDigits(String input, String lang) {
  if (lang != 'bn') return input;
  return input.replaceAllMapped(
    RegExp(r'[0-9]'),
    (m) => _bnDigits[int.parse(m[0]!)],
  );
}

extension DigitsContext on BuildContext {
  /// ব্যবহার: context.digits('12:30') -> বাংলায় ১২:৩০
  String digits(Object value) =>
      localizeDigits(value.toString(), watch<SettingsService>().languageCode);
}
