import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/ride_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(
    ChangeNotifierProvider(
      create: (_) => RideProvider(),
      child: const CRNApp(),
    ),
  );
}

class CRNApp extends StatelessWidget {
  const CRNApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connected Ride Network',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary:    const Color(0xFFE53935),
          secondary:  const Color(0xFFFF7043),
          surface:    const Color(0xFF0D0D0D),
        ),
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: const Color(0xFF141414),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          iconTheme: WidgetStateProperty.all(
            const IconThemeData(color: Colors.white54),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D0D0D),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
