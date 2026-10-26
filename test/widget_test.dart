import 'package:flutter_test/flutter_test.dart';
import 'package:foodlence/main.dart';

void main() {
  testWidgets('FoodLence smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FoodLenceApp());
    expect(find.text('FoodLence'), findsOneWidget);
  });
}
