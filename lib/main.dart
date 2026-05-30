// MAIN ENTRY POINT
// Setup MultiProvider:
//   1. Repositories diinject sebagai Provider biasa
//   2. ViewModels diinject sebagai ChangeNotifierProvider yang
//      mengonsumsi Repository dari atas
// View kemudian membaca ViewModel via Consumer / context.watch.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'repositories/auth_repository.dart';
import 'repositories/chat_repository.dart';
import 'repositories/consultation_repository.dart';
import 'repositories/milestone_repository.dart';
import 'repositories/reference_repository.dart';
import 'repositories/squad_repository.dart';
import 'repositories/wellness_repository.dart';
import 'viewmodels/viewmodels.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi locale Indonesia untuk DateFormat
  await initializeDateFormatting('id_ID', null);

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const SkripsiKitaApp());
}

class SkripsiKitaApp extends StatelessWidget {
  const SkripsiKitaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ===== REPOSITORIES =====
        // Repositories adalah singleton biasa, tidak perlu notify listener.
        Provider(create: (_) => AuthRepository()),
        Provider(create: (_) => MilestoneRepository()),
        Provider(create: (_) => ConsultationRepository()),
        Provider(create: (_) => ReferenceRepository()),
        Provider(create: (_) => SquadRepository()),
        Provider(create: (_) => WellnessRepository()),
        Provider(create: (_) => ChatRepository()),

        // ===== VIEWMODELS =====
        // ViewModels mendapat Repository dari Provider di atas (via ctx.read).
        ChangeNotifierProvider(
          create: (ctx) => AuthViewModel(ctx.read<AuthRepository>()),
        ),
        ChangeNotifierProvider(
          create: (ctx) => TimelineViewModel(ctx.read<MilestoneRepository>()),
        ),
        ChangeNotifierProvider(
          create: (ctx) =>
              ConsultationViewModel(ctx.read<ConsultationRepository>()),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ReferenceViewModel(ctx.read<ReferenceRepository>()),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SquadViewModel(ctx.read<SquadRepository>()),
        ),
        ChangeNotifierProvider(
          create: (ctx) => WellnessViewModel(ctx.read<WellnessRepository>()),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SkripsiBotViewModel(ctx.read<ChatRepository>()),
        ),
      ],
      child: Builder(
        builder: (context) {
          // Router butuh AuthViewModel untuk auth guards.
          final authVm = context.watch<AuthViewModel>();
          final router = AppRouter.router(authVm);
          return MaterialApp.router(
            title: 'SkripsiKita',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            routerConfig: router,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('id', 'ID'),
              Locale('en', 'US'),
            ],
            locale: const Locale('id', 'ID'),
          );
        },
      ),
    );
  }
}
