import 'dart:async';

import 'package:flutter/material.dart';
import 'api_client.dart';
import 'cart_manager.dart';
import 'generated/app_localizations.dart';
import 'home_page.dart';
import 'locale_manager.dart';
import 'login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final localeNotifier = await LocaleNotifier.create();
  await ApiClient.instance.loadSession();
  final cartNotifier = CartNotifier();
  if (ApiClient.instance.isLoggedIn) {
    unawaited(cartNotifier.loadCart());
  }
  runApp(
    LocaleProvider(
      notifier: localeNotifier,
      child: CartProvider(
        notifier: cartNotifier,
        child: MyApp(notifier: localeNotifier),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final LocaleNotifier notifier;

  const MyApp({required this.notifier, super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale?>(
      valueListenable: notifier,
      builder: (context, locale, child) {
        return MaterialApp(
          title: 'Nexa Link',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
            useMaterial3: true,
          ),
          locale: locale,
          supportedLocales: S.supportedLocales,
          localizationsDelegates: S.localizationsDelegates,
          home: ApiClient.instance.isLoggedIn ? const HomePage() : const LoginPage(),
        );
      },
    );
  }
}
