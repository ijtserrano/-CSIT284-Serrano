import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/main.dart';

void main() {
  testWidgets('shows starter expenses and add button', (tester) async {
    await tester.pumpWidget(const ExpenseApp());
    await tester.pumpAndSettle();
    expect(find.text('Flutter Course'), findsOneWidget);
    expect(find.text('Add expense'), findsOneWidget);
  });
}
