import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_localizations.dart';
import 'screens/settings_screen.dart';
import 'screens/main_dashboard_screen.dart';

/// =============================================================
/// AppSettings: estado global + persistencia (SharedPreferences)
/// =============================================================
class AppSettings extends ChangeNotifier {
  late SharedPreferences _prefs;
  bool _ready = false;

  // Preferencias
  ThemeMode _themeMode = ThemeMode.system;
  double _fontSize = 1.0; // 1.0 = 100%
  bool _professionalMode = false;
  bool _hapticFeedback = true;
  String _selectedLanguage = 'es';

  // Color semilla (tema). Guardamos ARGB 32 bits como int.
  int _seedColorValue = 0xFF1867FF; // azul por defecto

  AppSettings() {
    _init();
  }

  Future<void> _init() async {
    try {
      _prefs = await SharedPreferences.getInstance();

      _themeMode = ThemeMode
          .values[_prefs.getInt('themeMode') ?? ThemeMode.system.index];
      _fontSize = _prefs.getDouble('fontSize') ?? 1.0;
      _professionalMode = _prefs.getBool('professionalMode') ?? false;
      _hapticFeedback = _prefs.getBool('hapticFeedback') ?? true;
      _selectedLanguage = _prefs.getString('selectedLanguage') ?? 'es';
      _seedColorValue = _prefs.getInt('seedColor') ?? 0xFF1867FF;
    } catch (e, st) {
      // Si algo falla, deja valores por defecto y registra el error.
      debugPrint('AppSettings init error: $e\n$st');
    }
    _ready = true;
    notifyListeners();
  }

  bool get isReady => _ready;

  // ==================== Tema ====================
  ThemeMode get themeMode => _themeMode;
  void setThemeMode(ThemeMode m) {
    _themeMode = m;
    _prefs.setInt('themeMode', m.index);
    notifyListeners();
  }

  // Getter Color semilla (como Color)
  Color get seedColor => Color(_seedColorValue);

  // Setter compatible con nuevos canales (.a/.r/.g/.b: 0..1)
  void setSeedColor(Color c) {
    final a = (c.a * 255.0).round() & 0xff;
    final r = (c.r * 255.0).round() & 0xff;
    final g = (c.g * 255.0).round() & 0xff;
    final b = (c.b * 255.0).round() & 0xff;
    final argb = (a << 24) | (r << 16) | (g << 8) | b;
    if (argb == _seedColorValue) return;
    _seedColorValue = argb;
    _prefs.setInt('seedColor', _seedColorValue);
    notifyListeners();
  }

  // Paleta sugerida (para la rejilla)
  List<Color> get availableSeedColors => const [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.indigo,
    Colors.pink,
    Colors.brown,
    Colors.cyan,
  ];

  // ==================== Tipografía ====================
  double get textScale => _fontSize;
  void setTextScale(double v) => setFontSize(v);

  double get fontSize => _fontSize;
  void setFontSize(double v) {
    if (v < 0.85) v = 0.85;
    if (v > 1.25) v = 1.25;
    _fontSize = v;
    _prefs.setDouble('fontSize', v);
    notifyListeners();
  }

  // ==================== Funcionalidad ====================
  bool get professionalMode => _professionalMode;
  void setProfessionalMode(bool v) {
    _professionalMode = v;
    _prefs.setBool('professionalMode', v);
    notifyListeners();
  }

  bool get hapticFeedback => _hapticFeedback;
  void setHapticFeedback(bool v) {
    _hapticFeedback = v;
    _prefs.setBool('hapticFeedback', v);
    notifyListeners();
  }

  // ==================== Idioma ====================
  String get selectedLanguage => _selectedLanguage;
  void setLanguage(String code) => setSelectedLanguage(code);
  void setSelectedLanguage(String code) {
    _selectedLanguage = code;
    _prefs.setString('selectedLanguage', code);
    notifyListeners();
  }

  // ==================== Restablecer ====================
  Future<void> resetToDefaults() async {
    _themeMode = ThemeMode.system;
    _fontSize = 1.0;
    _professionalMode = false;
    _hapticFeedback = true;
    _selectedLanguage = 'es';
    _seedColorValue = 0xFF1867FF;

    await _prefs.setInt('themeMode', _themeMode.index);
    await _prefs.setDouble('fontSize', _fontSize);
    await _prefs.setBool('professionalMode', _professionalMode);
    await _prefs.setBool('hapticFeedback', _hapticFeedback);
    await _prefs.setString('selectedLanguage', _selectedLanguage);
    await _prefs.setInt('seedColor', _seedColorValue);

    notifyListeners();
  }
}

// =============================================================
// main() y MyApp
// =============================================================
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Si algo revienta en el primer frame, lo verás en la consola.
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Flutter error: ${details.exceptionAsString()}');
    if (details.stack != null) debugPrint(details.stack.toString());
  };

  runApp(
    ChangeNotifierProvider(create: (_) => AppSettings(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettings>(
      builder: (context, settings, _) {
        final seed = settings.seedColor;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Calculadora Electrónica',

          // Tema
          themeMode: settings.themeMode,
          theme: _buildTheme(Brightness.light, seed),
          darkTheme: _buildTheme(Brightness.dark, seed),

          // Idioma
          locale: Locale(settings.selectedLanguage),
          supportedLocales: const [Locale('es'), Locale('en')],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],

          // Escalado global de texto (evita el assert de TextStyle)
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(settings.fontSize)),
              child: child ?? const SizedBox.shrink(),
            );
          },

          // Rutas
          routes: {'/settings': (_) => const SettingsScreen()},

          // MOSTRAR Splash mientras AppSettings termina de cargar
          home: settings.isReady
              ? const MainDashboardScreen()
              : const _BootSplash(),
        );
      },
    );
  }
}

class _BootSplash extends StatelessWidget {
  const _BootSplash();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: cs.primary),
            const SizedBox(height: 12),
            Text('Iniciando…', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

ThemeData _buildTheme(Brightness brightness, Color seed) {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: brightness),
  );

  final cs = base.colorScheme;

  return base.copyWith(
    appBarTheme: AppBarTheme(
      backgroundColor: cs.primary,
      foregroundColor: cs.onPrimary,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: cs.primary,
      foregroundColor: cs.onPrimary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: cs.primary),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((_) => cs.primary),
      trackColor: WidgetStateProperty.resolveWith(
        (_) => cs.primary.withValues(alpha: 0.35),
      ),
    ),
    sliderTheme: base.sliderTheme.copyWith(
      activeTrackColor: cs.primary,
      thumbColor: cs.primary,
      overlayColor: cs.primary.withValues(alpha: 0.12),
    ),
  );
}
