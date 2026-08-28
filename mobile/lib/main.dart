import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/theme/theme.dart';
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

    return MaterialApp.router(
      title: 'Securo',
      debugShowCheckedModeBanner: false,
      theme: buildSecuroTheme(Brightness.light),
      darkTheme: buildSecuroTheme(Brightness.dark),
      // The web app follows the OS preference until the user overrides it in
      // settings; matching that here keeps the two installs consistent.
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
