// ============================================================================
// WIDGET TEST: LoginScreen
// ============================================================================
//
// Menguji UI behavior:
//  - Render field email & password
//  - Validator menampilkan pesan error untuk input kosong / invalid
//  - Toggle visibility password
//
// Pola: Arrange-Act-Assert (AAA)
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skripsikita/features/auth/login_screen.dart';
import 'package:skripsikita/repositories/auth_repository.dart';
import 'package:skripsikita/viewmodels/auth_viewmodel.dart';

void main() {
  // Setup global: mock SharedPreferences agar AuthRepository tidak crash.
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Widget _wrapWithProvider(Widget child) {
    return MaterialApp(
      home: MultiProvider(
        providers: [
          Provider(create: (_) => AuthRepository()),
          ChangeNotifierProvider(
            create: (ctx) => AuthViewModel(ctx.read<AuthRepository>()),
          ),
        ],
        child: child,
      ),
    );
  }

  group('LoginScreen — Rendering', () {
    testWidgets('menampilkan judul "Selamat datang kembali"', (tester) async {
      // ARRANGE & ACT
      await tester.pumpWidget(_wrapWithProvider(const LoginScreen()));

      // ASSERT
      expect(find.textContaining('Selamat datang kembali'), findsOneWidget);
    });

    testWidgets('menampilkan field email & password', (tester) async {
      // ARRANGE & ACT
      await tester.pumpWidget(_wrapWithProvider(const LoginScreen()));

      // ASSERT
      expect(find.text('Email kampus'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('menampilkan tombol Masuk', (tester) async {
      // ARRANGE & ACT
      await tester.pumpWidget(_wrapWithProvider(const LoginScreen()));

      // ASSERT
      expect(find.widgetWithText(ElevatedButton, 'Masuk'), findsOneWidget);
    });

    testWidgets('menampilkan tombol Daftar sekarang di bawah', (tester) async {
      // ARRANGE & ACT
      await tester.pumpWidget(_wrapWithProvider(const LoginScreen()));

      // ASSERT
      expect(find.text('Daftar sekarang'), findsOneWidget);
    });
  });

  group('LoginScreen — Form validation', () {
    testWidgets('email kosong → muncul error "Email wajib diisi"',
        (tester) async {
      // ARRANGE
      await tester.pumpWidget(_wrapWithProvider(const LoginScreen()));
      // Kosongkan field email
      await tester.enterText(find.byType(TextFormField).at(0), '');

      // ACT — submit form
      await tester.tap(find.widgetWithText(ElevatedButton, 'Masuk'));
      await tester.pump(); // trigger validator

      // ASSERT
      expect(find.text('Email wajib diisi'), findsOneWidget);
    });

    testWidgets('email tanpa @ → muncul error "Format email tidak valid"',
        (tester) async {
      // ARRANGE
      await tester.pumpWidget(_wrapWithProvider(const LoginScreen()));
      await tester.enterText(find.byType(TextFormField).at(0), 'tidakvalid');

      // ACT
      await tester.tap(find.widgetWithText(ElevatedButton, 'Masuk'));
      await tester.pump();

      // ASSERT
      expect(find.text('Format email tidak valid'), findsOneWidget);
    });

    testWidgets('password < 6 karakter → muncul error', (tester) async {
      // ARRANGE
      await tester.pumpWidget(_wrapWithProvider(const LoginScreen()));
      await tester.enterText(find.byType(TextFormField).at(0), 'a@b.com');
      await tester.enterText(find.byType(TextFormField).at(1), '12345');

      // ACT
      await tester.tap(find.widgetWithText(ElevatedButton, 'Masuk'));
      await tester.pump();

      // ASSERT
      expect(find.text('Password minimal 6 karakter'), findsOneWidget);
    });

    testWidgets('input valid tidak menampilkan error sebelum submit', (tester) async {
      // ARRANGE
      await tester.pumpWidget(_wrapWithProvider(const LoginScreen()));

      // ACT — isi field dengan input valid, lalu tap di luar form
      // (tidak submit, untuk hindari async timer dari login flow).
      await tester.enterText(find.byType(TextFormField).at(0), 'rina@uc.ac.id');
      await tester.enterText(find.byType(TextFormField).at(1), 'password123');
      await tester.pump();

      // ASSERT — tidak ada error message di UI
      expect(find.text('Email wajib diisi'), findsNothing);
      expect(find.text('Password wajib diisi'), findsNothing);
      expect(find.text('Format email tidak valid'), findsNothing);
      expect(find.text('Password minimal 6 karakter'), findsNothing);
    });
  });

  group('LoginScreen — Password visibility toggle', () {
    testWidgets('icon mata "visibility_off" muncul awalnya (password tersembunyi)',
        (tester) async {
      // ARRANGE & ACT
      await tester.pumpWidget(_wrapWithProvider(const LoginScreen()));

      // ASSERT — kondisi awal: icon "visibility_off_rounded" ditampilkan
      expect(find.byIcon(Icons.visibility_off_rounded), findsOneWidget);
      expect(find.byIcon(Icons.visibility_rounded), findsNothing);
    });

    testWidgets('tap icon mata → toggle ke icon "visibility" (password terlihat)',
        (tester) async {
      // ARRANGE
      await tester.pumpWidget(_wrapWithProvider(const LoginScreen()));

      // ACT
      await tester.tap(find.byIcon(Icons.visibility_off_rounded));
      await tester.pump();

      // ASSERT — icon berubah ke visibility_rounded
      expect(find.byIcon(Icons.visibility_rounded), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off_rounded), findsNothing);
    });
  });
}
