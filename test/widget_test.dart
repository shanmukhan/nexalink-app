import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexa_link/locale_manager.dart';
import 'package:nexa_link/main.dart';

void main() {
  testWidgets('shows the OTP login screen', (tester) async {
    final notifier = LocaleNotifier(const Locale('en'));
    await tester.pumpWidget(LocaleProvider(
      notifier: notifier,
      child: MyApp(notifier: notifier),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Login to continue with your wallet, rewards, and referrals.'), findsOneWidget);
    expect(find.text('Phone or email'), findsOneWidget);
    expect(find.text('Send OTP'), findsOneWidget);
    expect(find.text('Language:'), findsOneWidget);
  });
}
