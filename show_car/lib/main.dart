import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:show_car/ui/splash_screen.dart';

void main() async {
  // Garante que os bindings estão inicializados antes de qualquer operação
  WidgetsFlutterBinding.ensureInitialized();

  // Otimização: Define orientação preferida (opcional)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Otimização: Modo de UI imersivo (opcional)
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Define cores da barra de status/navegação
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF1A1A1A),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const MyApp());
}

// Cores do tema
const Color kDarkBackground = Color(0xFF1A1A1A);
const Color kDarkSurface = Color(0xFF2D2D2D);
const Color kAccentColor = Color(0xFFFF5722); // Deep Orange

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Configurar fonte Poppins como padrão
    final baseTextTheme = GoogleFonts.poppinsTextTheme(
      ThemeData.dark().textTheme,
    );

    return MaterialApp(
      title: 'Garage',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.transparent,
        colorScheme: const ColorScheme.dark(
          surface: kDarkSurface,
          primary: kAccentColor,
          secondary: kAccentColor,
          onSurface: Colors.white,
          onPrimary: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: kAccentColor,
          foregroundColor: Colors.white,
        ),
        textTheme: baseTextTheme.copyWith(
          headlineLarge: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
          headlineMedium: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
          headlineSmall: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
          titleLarge: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
          bodyLarge: GoogleFonts.poppins(color: Colors.white70, fontSize: 16),
          bodyMedium: GoogleFonts.poppins(color: Colors.white60, fontSize: 14),
          labelLarge: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
