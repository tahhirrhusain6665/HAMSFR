import 'package:flutter_test/flutter_test.dart';
import 'package:humsafar/main.dart';

void main() {
  testWidgets('Humsafar app starts', (tester) async {
    await tester.pumpWidget(const HumsafarApp());
    expect(find.text('HUMSAFAR'), findsOneWidget);
  });
}
