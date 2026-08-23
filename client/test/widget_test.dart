import 'package:flutter_test/flutter_test.dart';

import 'package:ultimate_privacy/main.dart';

void main() {
  testWidgets('foundation screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(const UltimateApp());

    expect(find.text('Foundation build'), findsOneWidget);
    expect(find.text('Backend status: Not checked'), findsOneWidget);
    expect(find.text('Check API'), findsOneWidget);
  });
}
