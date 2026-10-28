import 'package:expense_tracker/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('shows empty state and add button', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const ExpenseApp());
    await tester.pumpAndSettle();
    expect(find.text('No expenses yet'), findsOneWidget);
    expect(find.text('Add expense'), findsOneWidget);
  });
}