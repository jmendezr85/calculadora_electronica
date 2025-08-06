import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'package:calculadora_electronica/screens/main_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppSettings(prefs: prefs),
      child: const MyApp(),
    ),
  );
}

class AppSettings extends ChangeNotifier {
  final SharedPreferences prefs;

  AppSettings({required this.prefs}) {
    _loadSettings();
  }

  // --- Propiedades del Tema ---
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    // Guarda el tema en SharedPreferences
    if (mode == ThemeMode.dark) {
      prefs.setBool('isDarkMode', true);
    } else if (mode == ThemeMode.light) {
      prefs.setBool('isDarkMode', false);
    } else {
      prefs.remove('isDarkMode');
    }
    notifyListeners();
  }

  // --- Propiedades de las Configuraciones ---
  bool _notificationsEnabled = true;
  bool _hapticFeedback = true;
  String _selectedLanguage = 'Español';
  double _fontSize = 1.0;
  bool _professionalMode = false;

  bool get notificationsEnabled => _notificationsEnabled;
  bool get hapticFeedback => _hapticFeedback;
  String get selectedLanguage => _selectedLanguage;
  double get fontSize => _fontSize;
  bool get professionalMode => _professionalMode;

  void _loadSettings() {
    // Carga el tema
    final isDarkMode = prefs.getBool('isDarkMode');
    if (isDarkMode == true) {
      _themeMode = ThemeMode.dark;
    } else if (isDarkMode == false) {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.system;
    }

    // Carga las demás configuraciones
    _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    _hapticFeedback = prefs.getBool('hapticFeedback') ?? true;
    _selectedLanguage = prefs.getString('selectedLanguage') ?? 'Español';
    _fontSize = prefs.getDouble('fontSize') ?? 1.0;
    _professionalMode = prefs.getBool('professionalMode') ?? false;

    notifyListeners();
  }

  // Métodos para cambiar las configuraciones
  void setNotificationsEnabled(bool value) {
    _notificationsEnabled = value;
    prefs.setBool('notificationsEnabled', value);
    notifyListeners();
  }

  void setHapticFeedback(bool value) {
    _hapticFeedback = value;
    prefs.setBool('hapticFeedback', value);
    notifyListeners();
  }

  void setSelectedLanguage(String value) {
    _selectedLanguage = value;
    prefs.setString('selectedLanguage', value);
    notifyListeners();
  }

  void setFontSize(double value) {
    _fontSize = value;
    prefs.setDouble('fontSize', value);
    notifyListeners();
  }

  void setProfessionalMode(bool value) {
    _professionalMode = value;
    prefs.setBool('professionalMode', value);
    notifyListeners();
  }

  // Método para restablecer todas las configuraciones
  void resetSettings() {
    setThemeMode(ThemeMode.system);
    setNotificationsEnabled(true);
    setHapticFeedback(true);
    setSelectedLanguage('Español');
    setFontSize(1.0);
    setProfessionalMode(false);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appSettings = Provider.of<AppSettings>(context);

    return MaterialApp(
      title: 'Calculadora Electrónica',
      debugShowCheckedModeBanner: false,
      themeMode: appSettings.themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[900],
          foregroundColor: Colors.white,
        ),
      ),
      home: const MainDashboardScreen(),
    );
  }
}
