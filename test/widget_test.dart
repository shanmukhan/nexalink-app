import 'package:flutter_test/flutter_test.dart';

import 'package:nexa_link/main.dart';

void main() {
  testWidgets('shows the OTP login screen', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('NexaLink'), findsOneWidget);
    expect(find.text('Sign in to continue'), findsOneWidget);
    expect(find.text('Phone or email'), findsOneWidget);
    expect(find.text('Send OTP'), findsOneWidget);
  });
}
