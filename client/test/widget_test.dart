import 'package:flutter_test/flutter_test.dart';

import 'package:ultimate_privacy/main.dart';

void main() {
  testWidgets('Google login screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(const UltimateApp());

    expect(find.text('Ultimate Privacy'), findsOneWidget);
    expect(
      find.text(
        'Private communication and file sharing, designed around security and user control.',
      ),
      findsOneWidget,
    );
    expect(find.text('Continue with Google'), findsOneWidget);
  });
}
