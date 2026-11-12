import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:meals2/main.dart';

void main() {
  testWidgets('App opens on the categories tab', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));

    // App bar title + bottom navigation label.
    expect(find.text('Categories'), findsNWidgets(2));
    // Make sure this matches a category title in your dummy_data.dart.
    expect(find.text('Italian'), findsOneWidget);
  });
}