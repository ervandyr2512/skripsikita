// ============================================================================
// SMOKE TEST: SkripsiKitaApp
// ============================================================================
//
// Test paling dasar — memastikan app dapat di-instantiate tanpa crash.
// Tes lebih spesifik ada di subfolder models/, repositories/, viewmodels/,
// dan widgets/.
//
// Pola: Arrange-Act-Assert (AAA)
// ============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skripsikita/main.dart';

void main() {
  setUp(() {
    // ARRANGE (global): mock SharedPreferences agar bisa di-inject ke
    // AuthRepository tanpa error MissingPluginException.
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('SkripsiKitaApp build tanpa crash (smoke test)', (tester) async {
    // ARRANGE & ACT — bungkus dalam runAsync untuk mengizinkan Future.delayed
    // dari splash screen di-schedule. Lalu pumpAndSettle untuk menunggu
    // semua animation & timer selesai.
    await tester.runAsync(() async {
      await tester.pumpWidget(const SkripsiKitaApp());
      await tester.pump(const Duration(milliseconds: 100));
    });

    // ASSERT — tidak ada exception (kalau crash, test gagal otomatis)
    expect(tester.takeException(), isNull);
  });
}
