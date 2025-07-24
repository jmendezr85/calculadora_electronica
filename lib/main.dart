import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Asegúrate de que esta importación esté aquí
import 'package:calculadora_electronica/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

// DEFINICIÓN DE LA CLASE THEMEPROVIDER
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode =
      ThemeMode.system; // Por defecto, usa el tema del sistema

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final int? themeIndex = prefs.getInt('themeMode');
    if (themeIndex != null) {
      _themeMode = ThemeMode.values[themeIndex];
      notifyListeners(); // Notifica a los oyentes que el tema ha cambiado
    }
  }

  Future<void> toggleTheme(bool isDarkMode) async {
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', _themeMode.index);
    notifyListeners(); // Notifica a los oyentes que el tema ha cambiado
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeProvider _themeProvider = ThemeProvider();

  @override
  void initState() {
    super.initState();
    _themeProvider.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    _themeProvider.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    setState(() {}); // Reconstruye el widget para aplicar el nuevo tema
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora Electrónica',
      debugShowCheckedModeBanner: false,
      themeMode:
          _themeProvider.themeMode, // Usa el tema actual del ThemeProvider
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      home: HomeScreen(themeProvider: _themeProvider),
    );
  }
}
