import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart'; // <--- Importa el paquete 'provider'

// Importa la nueva pantalla principal del dashboard que manejará las pestañas
import 'package:calculadora_electronica/screens/main_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(
    // <--- ¡IMPORTANTE! Envuelve MyApp con ChangeNotifierProvider
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(prefs: prefs),
      child:
          const MyApp(), // MyApp ya no necesita 'prefs' directamente si se usa Provider
    ),
  );
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
  // final SharedPreferences prefs; // <--- Esta propiedad ya no es necesaria aquí

  const MyApp({super.key}); // <--- Constructor sin 'prefs'

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // ThemeProvider ahora se obtiene del contexto a través de Provider
  // late final ThemeProvider _themeProvider; // <--- ELIMINA ESTA LÍNEA

  @override
  void initState() {
    super.initState();
    // Ya no inicializamos _themeProvider aquí
  }

  @override
  Widget build(BuildContext context) {
    // <--- ¡IMPORTANTE! Obtenemos ThemeProvider usando Provider.of
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Calculadora Electrónica',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode, // Usa el themeProvider obtenido
      theme: ThemeData(
        // Colores para el modo claro
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue, // Usamos azul para un look más "tecnológico"
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        // Colores para el modo oscuro
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue, // Misma semilla, pero con brillo oscuro
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        // Personalización para el AppBar en modo oscuro
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[900],
          foregroundColor: Colors.white,
        ),
      ),
      home: const MainDashboardScreen(),
    );
  }
}
