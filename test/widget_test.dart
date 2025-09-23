import 'package:calculadora_electronica/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('App Basic Tests', () {
    testWidgets('MyApp se inicia sin errores', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});

      final settings = AppSettings();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      await tester.pumpWidget(
        ChangeNotifierProvider<AppSettings>.value(
          value: settings,
          child: const MyApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Verificar que la aplicación se inicia correctamente
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('AppSettings se inicializa correctamente', (
      WidgetTester tester,
    ) async {
      SharedPreferences.setMockInitialValues({});

      final settings = AppSettings();
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(settings.isReady, true);
      expect(settings.themeMode, ThemeMode.system);
      expect(settings.fontSize, 1.0);
    });
  });

  group('AppSettings Unit Tests', () {
    test('Valores por defecto', () async {
      SharedPreferences.setMockInitialValues({});

      final settings = AppSettings();
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(settings.themeMode, ThemeMode.system);
      expect(settings.fontSize, 1.0);
      expect(settings.professionalMode, false);
      expect(settings.hapticFeedback, true);
      expect(settings.selectedLanguage, 'es');
    });

    test('Cambio de tema funciona', () async {
      SharedPreferences.setMockInitialValues({});

      final settings = AppSettings();
      await Future<void>.delayed(const Duration(milliseconds: 100));

      settings.setThemeMode(ThemeMode.dark);
      expect(settings.themeMode, ThemeMode.dark);
    });

    test('Cambio de tamaño de fuente funciona', () async {
      SharedPreferences.setMockInitialValues({});

      final settings = AppSettings();
      await Future<void>.delayed(const Duration(milliseconds: 100));

      settings.setFontSize(1.2);
      expect(settings.fontSize, 1.2);
    });

    test('Cambio de idioma funciona', () async {
      SharedPreferences.setMockInitialValues({});

      final settings = AppSettings();
      await Future<void>.delayed(const Duration(milliseconds: 100));

      settings.setSelectedLanguage('en');
      expect(settings.selectedLanguage, 'en');
    });
  });

  group('Integration Tests', () {
    test('Configuración persiste', () async {
      SharedPreferences.setMockInitialValues({});

      final settings1 = AppSettings();
      await Future<void>.delayed(const Duration(milliseconds: 100));

      settings1
        ..setThemeMode(ThemeMode.dark)
        ..setFontSize(1.1);

      final settings2 = AppSettings();
      await Future<void>.delayed(const Duration(milliseconds: 100));

      expect(settings2.themeMode, ThemeMode.dark);
      expect(settings2.fontSize, 1.1);
    });

    test('Reset de configuración funciona', () async {
      SharedPreferences.setMockInitialValues({});

      final settings = AppSettings();
      await Future<void>.delayed(const Duration(milliseconds: 100));

      settings
        ..setThemeMode(ThemeMode.dark)
        ..setFontSize(1.2);

      await settings.resetToDefaults();

      expect(settings.themeMode, ThemeMode.system);
      expect(settings.fontSize, 1.0);
    });
  });

  // Test simple de que la aplicación carga
  testWidgets('Aplicación carga sin excepciones', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    final settings = AppSettings();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Esto debería ejecutarse sin lanzar excepciones
    await tester.pumpWidget(
      ChangeNotifierProvider<AppSettings>.value(
        value: settings,
        child: const MyApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Si llegamos aquí, la aplicación cargó correctamente
    expect(true, true);
  });
}
