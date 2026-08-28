import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/theme/theme.dart';
import 'core/theme/theme_controller.dart';
import 'router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // DateFormat throws LocaleDataException until locale tables are loaded;
  // formatMoney/formatDate run as early as the login screen, so this has to
  // happen before runApp.
  await initializeDateFormatting();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const ProviderScope(child: SecuroApp()));
}

class SecuroApp extends ConsumerWidget {
  const SecuroApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Securo',
      debugShowCheckedModeBanner: false,
      theme: buildSecuroTheme(Brightness.light),
      darkTheme: buildSecuroTheme(Brightness.dark),
      // Follows the OS by default; overridable in Settings → Appearance,
      // same choice the web app's own light/dark toggle offers.
      themeMode: themeMode,
      routerConfig: router,
      // Dynamic Type is respected (layouts use relative sizing, not fixed
      // px), but clamped: an unclamped 200%+ accessibility text size can
      // blow apart a dense finance-app layout in ways a reading app's
      // single text column never hits. Mirrors `Responsive.textScale`'s
      // clamp so every screen agrees on the ceiling.
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaler: TextScaler.linear(
            MediaQuery.textScalerOf(context).scale(1).clamp(0.9, 1.35),
          ),
        ),
        child: child!,
      ),
    );
  }
}
