import 'package:flutter_test/flutter_test.dart';
import 'package:skripsikita/main.dart';

void main() {
  testWidgets('SkripsiKita app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SkripsiKitaApp());
    await tester.pump(const Duration(milliseconds: 100));
  });
}
