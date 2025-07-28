import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Importa la nueva pantalla principal del dashboard que manejará las pestañas
import 'package:calculadora_electronica/screens/main_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode;

  ThemeProvider({required SharedPreferences prefs})
    : _themeMode =
          (prefs.getBool('isDarkMode') ??
              (WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                  Brightness.dark))
          ? ThemeMode.dark
          : ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme(bool isDarkMode) {
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    _saveThemePreference(isDarkMode);
    notifyListeners();
  }

  void _saveThemePreference(bool isDarkMode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', isDarkMode);
  }
}

class MyApp extends StatefulWidget {
  final SharedPreferences prefs;

  const MyApp({super.key, required this.prefs});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final ThemeProvider _themeProvider;

  @override
  void initState() {
    super.initState();
    _themeProvider = ThemeProvider(prefs: widget.prefs);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _themeProvider,
      builder: (context, child) {
        return MaterialApp(
          title: 'Calculadora Electrónica',
          debugShowCheckedModeBanner: false,
          themeMode: _themeProvider.themeMode,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          // La pantalla de inicio ahora es MainDashboardScreen
          home: const MainDashboardScreen(),
        );
      },
    );
  }
}
