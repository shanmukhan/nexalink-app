import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleNotifier extends ValueNotifier<Locale?> {
  static const _localeKey = 'nexa_link_locale';

  LocaleNotifier(Locale? value) : super(value);

  static Future<LocaleNotifier> create() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_localeKey);
    return LocaleNotifier(_localeFromCode(languageCode));
  }

  static Locale? _localeFromCode(String? languageCode) {
    if (languageCode == 'te') {
      return const Locale('te');
    }
    if (languageCode == 'en') {
      return const Locale('en');
    }
    return null;
  }

  Future<void> setLocale(Locale locale) async {
    if (locale == value) return;
    value = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }
}

class LocaleProvider extends InheritedNotifier<LocaleNotifier> {
  const LocaleProvider({required LocaleNotifier notifier, required Widget child}) : super(notifier: notifier, child: child);

  static LocaleNotifier of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<LocaleProvider>();
    assert(provider != null, 'LocaleProvider not found in context');
    return provider!.notifier!;
  }
}
