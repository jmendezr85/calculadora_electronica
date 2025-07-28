import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importa SharedPreferences
import 'package:calculadora_electronica/main.dart'; // Asegúrate de que esto apunta a tu archivo main.dart

void main() {
  // Define un grupo de tests para la calculadora básica
  group('BasicCalculatorScreen Tests', () {
    testWidgets('BasicCalculatorScreen se inicializa con 0 en el display', (
      WidgetTester tester,
    ) async {
      // 1. Mockear SharedPreferences: Esto permite que SharedPreferences.getInstance()
      //    devuelva una instancia simulada en lugar de intentar acceder a la real.
      SharedPreferences.setMockInitialValues({});

      // 2. Construir la aplicación.
      //    Como MyApp ahora requiere 'prefs', la obtenemos de la instancia simulada.
      //    await SharedPreferences.getInstance() devolverá la instancia mockeada.
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await tester.pumpWidget(MyApp(prefs: prefs));

      // Verificar que el display inicial es "0"
      expect(find.text('0'), findsOneWidget);
      // Verificar que no hay historial visible al inicio
      expect(find.textContaining('='), findsNothing);
    });

    testWidgets('BasicCalculatorScreen realiza una suma simple', (
      WidgetTester tester,
    ) async {
      SharedPreferences.setMockInitialValues(
        {},
      ); // Mockear para esta prueba también
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await tester.pumpWidget(MyApp(prefs: prefs));

      // Toca el botón '1'
      await tester.tap(find.text('1'));
      await tester.pump(); // Reconstruye el widget para que se vea el cambio
      expect(
        find.text('1'),
        findsOneWidget,
      ); // Verifica que '1' está en el display

      // Toca el botón '+'
      await tester.tap(find.text('+'));
      await tester.pump();
      // El display debería seguir mostrando '1' o el resultado parcial (1.0 en este caso)
      expect(
        find.text('1'),
        findsOneWidget,
      ); // O podría ser '1.0' dependiendo del formato

      // Toca el botón '2'
      await tester.tap(find.text('2'));
      await tester.pump();
      expect(
        find.text('2'),
        findsOneWidget,
      ); // Verifica que '2' está en el display (entrada actual)

      // Toca el botón '='
      await tester.tap(find.text('='));
      await tester.pump();
      // Verifica que el resultado de 1 + 2 = 3 está en el display
      expect(find.text('3'), findsOneWidget);
    });

    // Puedes añadir más tests para otras operaciones o escenarios
    testWidgets('BasicCalculatorScreen maneja el borrado (backspace)', (
      WidgetTester tester,
    ) async {
      SharedPreferences.setMockInitialValues({});
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await tester.pumpWidget(MyApp(prefs: prefs));

      await tester.tap(find.text('1'));
      await tester.tap(find.text('2'));
      await tester.pump();
      expect(find.text('12'), findsOneWidget);

      await tester.tap(find.text('⌫')); // Backspace
      await tester.pump();
      expect(find.text('1'), findsOneWidget); // Debería ser '1'

      await tester.tap(find.text('⌫')); // Backspace de nuevo
      await tester.pump();
      expect(find.text('0'), findsOneWidget); // Debería volver a '0'
    });
  });
}
