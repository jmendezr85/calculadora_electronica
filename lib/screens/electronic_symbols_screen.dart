import 'package:flutter/material.dart';

class ElectronicSymbolsScreen extends StatelessWidget {
  const ElectronicSymbolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Símbolos Electrónicos'),
        centerTitle: true,
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Símbolos Esquemáticos Comunes',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 20),
            _buildSymbolCard(
              context,
              'Resistencia Fija',
              'Representa un componente que opone una resistencia fija al paso de la corriente.',
              ResistorSymbolPainter(),
            ),
            _buildSymbolCard(
              context,
              'Capacitor Fijo (Polarizado)',
              'Almacena energía en un campo eléctrico. La banda indica polaridad negativa.',
              CapacitorPolarizedSymbolPainter(),
            ),
            _buildSymbolCard(
              context,
              'Capacitor Fijo (No Polarizado)',
              'Almacena energía en un campo eléctrico. No tiene polaridad específica.',
              CapacitorNonPolarizedSymbolPainter(),
            ),
            _buildSymbolCard(
              context,
              'Inductor',
              'Almacena energía en un campo magnético, oponiéndose a cambios en la corriente.',
              InductorSymbolPainter(),
            ),
            _buildSymbolCard(
              context,
              'Diodo',
              'Permite el flujo de corriente en una sola dirección.',
              DiodeSymbolPainter(),
            ),
            _buildSymbolCard(
              context,
              'LED (Diodo Emisor de Luz)',
              'Diodo que emite luz cuando la corriente pasa a través de él.',
              LEDSymbolPainter(),
            ),
            _buildSymbolCard(
              context,
              'Transistor NPN',
              'Amplifica o conmuta señales electrónicas. La flecha indica la dirección de la corriente en el emisor.',
              TransistorNPNBJT(),
            ),
            _buildSymbolCard(
              context,
              'Transistor PNP',
              'Amplifica o conmuta señales electrónicas. La flecha indica la dirección de la corriente en el emisor.',
              TransistorPNPBJT(),
            ),
            _buildSymbolCard(
              context,
              'Tierra (Ground)',
              'Punto de referencia de potencial cero en un circuito.',
              GroundSymbolPainter(),
            ),
            _buildSymbolCard(
              context,
              'Fuente de Voltaje DC',
              'Suministra un voltaje constante de corriente continua.',
              DCVoltageSourceSymbolPainter(),
            ),
            _buildSymbolCard(
              context,
              'Fuente de Voltaje AC',
              'Suministra un voltaje alterno sinusoidal.',
              ACVoltageSourceSymbolPainter(),
            ),
            _buildSymbolCard(
              context,
              'Interruptor (Switch)',
              'Abre o cierra un circuito, permitiendo o interrumpiendo el flujo de corriente.',
              SwitchSymbolPainter(),
            ),
            _buildSymbolCard(
              context,
              'Punto de Unión (Junction)',
              'Indica una conexión eléctrica entre dos o más cables.',
              JunctionSymbolPainter(),
            ),
            _buildSymbolCard(
              context,
              'Voltímetro',
              'Mide la diferencia de potencial (voltaje) entre dos puntos en un circuito.',
              VoltmeterSymbolPainter(),
            ),
            _buildSymbolCard(
              context,
              'Amperímetro',
              'Mide la corriente eléctrica que fluye a través de un punto en un circuito.',
              AmmeterSymbolPainter(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSymbolCard(
    BuildContext context,
    String title,
    String description,
    CustomPainter painter,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 100, // Tamaño fijo para el dibujo del símbolo
              height: 80,
              child: CustomPaint(painter: painter),
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// --- CLASES PARA DIBUJAR SÍMBOLOS ---

// Base para dibujar un símbolo
abstract class BaseSymbolPainter extends CustomPainter {
  final Paint _paint = Paint()
    ..color = Colors
        .black // Color por defecto para los dibujos
    ..strokeWidth = 2.0
    ..style = PaintingStyle.stroke
    ..isAntiAlias = true;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Resistencia Fija
class ResistorSymbolPainter extends BaseSymbolPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Escalar para ajustar al tamaño del contenedor
    final scaleX = size.width / 100;
    final scaleY = size.height / 80;
    canvas.scale(scaleX, scaleY);

    final path = Path();
    path.moveTo(0, 40);
    path.lineTo(20, 40);
    path.lineTo(27, 20);
    path.lineTo(37, 60);
    path.lineTo(47, 20);
    path.lineTo(57, 60);
    path.lineTo(67, 20);
    path.lineTo(73, 40);
    path.lineTo(100, 40);
    canvas.drawPath(path, _paint);
  }
}

// Capacitor Fijo (Polarizado)
class CapacitorPolarizedSymbolPainter extends BaseSymbolPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 100;
    final scaleY = size.height / 80;
    canvas.scale(scaleX, scaleY);

    // Líneas de conexión
    canvas.drawLine(const Offset(0, 40), const Offset(40, 40), _paint);
    canvas.drawLine(const Offset(60, 40), const Offset(100, 40), _paint);

    // Placas
    canvas.drawLine(
      const Offset(40, 15),
      const Offset(40, 65),
      _paint,
    ); // Placa positiva
    canvas.drawLine(
      const Offset(60, 15),
      const Offset(60, 65),
      _paint,
    ); // Placa negativa

    // Símbolo de polaridad (+)
    canvas.drawLine(const Offset(35, 30), const Offset(45, 30), _paint);
    canvas.drawLine(const Offset(40, 25), const Offset(40, 35), _paint);
  }
}

// Capacitor Fijo (No Polarizado)
class CapacitorNonPolarizedSymbolPainter extends BaseSymbolPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 100;
    final scaleY = size.height / 80;
    canvas.scale(scaleX, scaleY);

    // Líneas de conexión
    canvas.drawLine(const Offset(0, 40), const Offset(40, 40), _paint);
    canvas.drawLine(const Offset(60, 40), const Offset(100, 40), _paint);

    // Placas
    canvas.drawLine(const Offset(40, 15), const Offset(40, 65), _paint);
    canvas.drawLine(const Offset(60, 15), const Offset(60, 65), _paint);
  }
}

// Inductor
class InductorSymbolPainter extends BaseSymbolPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 100;
    final scaleY = size.height / 80;
    canvas.scale(scaleX, scaleY);

    final path = Path();
    path.moveTo(0, 40);
    path.lineTo(20, 40);
    for (int i = 0; i < 4; i++) {
      path.arcToPoint(
        Offset(30.0 + i * 10, 40),
        radius: const Radius.circular(5),
        largeArc: false,
        clockwise: false,
      );
    }
    path.lineTo(100, 40);
    canvas.drawPath(path, _paint);
  }
}

// Diodo
class DiodeSymbolPainter extends BaseSymbolPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 100;
    final scaleY = size.height / 80;
    canvas.scale(scaleX, scaleY);

    // Líneas de conexión
    canvas.drawLine(const Offset(0, 40), const Offset(40, 40), _paint);
    canvas.drawLine(const Offset(60, 40), const Offset(100, 40), _paint);

    // Triángulo (Ánodo)
    final trianglePath = Path();
    trianglePath.moveTo(40, 20);
    trianglePath.lineTo(60, 40);
    trianglePath.lineTo(40, 60);
    trianglePath.close();
    canvas.drawPath(trianglePath, _paint);

    // Línea de Cátodo
    canvas.drawLine(const Offset(60, 20), const Offset(60, 60), _paint);
  }
}

// LED (Diodo Emisor de Luz)
class LEDSymbolPainter extends BaseSymbolPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 100;
    final scaleY = size.height / 80;
    canvas.scale(scaleX, scaleY);

    // Diodo base
    canvas.drawLine(const Offset(0, 40), const Offset(40, 40), _paint);
    canvas.drawLine(const Offset(60, 40), const Offset(100, 40), _paint);
    final trianglePath = Path();
    trianglePath.moveTo(40, 20);
    trianglePath.lineTo(60, 40);
    trianglePath.lineTo(40, 60);
    trianglePath.close();
    canvas.drawPath(trianglePath, _paint);
    canvas.drawLine(const Offset(60, 20), const Offset(60, 60), _paint);

    // Flechas de luz
    final arrowPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    // Flecha 1
    canvas.drawLine(const Offset(65, 30), const Offset(75, 20), arrowPaint);
    canvas.drawLine(const Offset(75, 20), const Offset(70, 20), arrowPaint);
    canvas.drawLine(const Offset(75, 20), const Offset(75, 25), arrowPaint);

    // Flecha 2
    canvas.drawLine(const Offset(70, 45), const Offset(80, 35), arrowPaint);
    canvas.drawLine(const Offset(80, 35), const Offset(75, 35), arrowPaint);
    canvas.drawLine(const Offset(80, 35), const Offset(80, 40), arrowPaint);
  }
}

// Transistor NPN
class TransistorNPNBJT extends BaseSymbolPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 100;
    final scaleY = size.height / 80;
    canvas.scale(scaleX, scaleY);

    // Base (línea horizontal)
    canvas.drawLine(const Offset(0, 40), const Offset(30, 40), _paint);

    // Colecor (línea vertical superior)
    canvas.drawLine(const Offset(50, 0), const Offset(50, 30), _paint);

    // Emisor (línea vertical inferior con flecha)
    canvas.drawLine(const Offset(50, 50), const Offset(50, 80), _paint);

    // Círculo
    canvas.drawCircle(const Offset(50, 40), 40, _paint);

    // Conexión del colector a la base
    canvas.drawLine(const Offset(50, 30), const Offset(30, 40), _paint);

    // Conexión del emisor a la base (línea inclinada)
    canvas.drawLine(const Offset(30, 40), const Offset(50, 50), _paint);

    // Flecha del emisor (saliente para NPN)
    final arrowPath = Path();
    arrowPath.moveTo(50, 60); // Punto base de la flecha en el emisor
    arrowPath.lineTo(45, 55); // Una punta
    arrowPath.moveTo(50, 60);
    arrowPath.lineTo(55, 55); // Otra punta
    canvas.drawPath(arrowPath, _paint);
  }
}

// Transistor PNP
class TransistorPNPBJT extends BaseSymbolPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 100;
    final scaleY = size.height / 80;
    canvas.scale(scaleX, scaleY);

    // Base (línea horizontal)
    canvas.drawLine(const Offset(0, 40), const Offset(30, 40), _paint);

    // Colecor (línea vertical superior)
    canvas.drawLine(const Offset(50, 0), const Offset(50, 30), _paint);

    // Emisor (línea vertical inferior con flecha)
    canvas.drawLine(const Offset(50, 50), const Offset(50, 80), _paint);

    // Círculo
    canvas.drawCircle(const Offset(50, 40), 40, _paint);

    // Conexión del colector a la base
    canvas.drawLine(const Offset(50, 30), const Offset(30, 40), _paint);

    // Conexión del emisor a la base (línea inclinada)
    canvas.drawLine(const Offset(30, 40), const Offset(50, 50), _paint);

    // Flecha del emisor (entrante para PNP)
    final arrowPath = Path();
    arrowPath.moveTo(45, 60); // Punta de la flecha
    arrowPath.lineTo(50, 55); // Centro de la flecha
    arrowPath.lineTo(55, 60); // Otra punta
    arrowPath.close(); // Cierra el triángulo
    _paint.style = PaintingStyle.fill; // Rellena la flecha
    canvas.drawPath(arrowPath, _paint);
    _paint.style =
        PaintingStyle.stroke; // Vuelve a stroke para el resto del dibujo
  }
}

// Símbolo de Tierra (Ground)
class GroundSymbolPainter extends BaseSymbolPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 100;
    final scaleY = size.height / 80;
    canvas.scale(scaleX, scaleY);

    canvas.drawLine(
      const Offset(50, 0),
      const Offset(50, 40),
      _paint,
    ); // Línea vertical
    canvas.drawLine(
      const Offset(25, 40),
      const Offset(75, 40),
      _paint,
    ); // Línea más larga
    canvas.drawLine(
      const Offset(35, 50),
      const Offset(65, 50),
      _paint,
    ); // Línea media
    canvas.drawLine(
      const Offset(45, 60),
      const Offset(55, 60),
      _paint,
    ); // Línea corta
  }
}

// Fuente de Voltaje DC
class DCVoltageSourceSymbolPainter extends BaseSymbolPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 100;
    final scaleY = size.height / 80;
    canvas.scale(scaleX, scaleY);

    canvas.drawLine(
      const Offset(0, 40),
      const Offset(30, 40),
      _paint,
    ); // Línea izquierda
    canvas.drawLine(
      const Offset(70, 40),
      const Offset(100, 40),
      _paint,
    ); // Línea derecha

    // Placa larga (+)
    canvas.drawLine(const Offset(40, 20), const Offset(40, 60), _paint);
    // Placa corta (-)
    canvas.drawLine(const Offset(60, 30), const Offset(60, 50), _paint);

    // Símbolo de polaridad (+)
    canvas.drawLine(const Offset(35, 25), const Offset(45, 25), _paint);
    canvas.drawLine(const Offset(40, 20), const Offset(40, 30), _paint);

    // Símbolo de polaridad (-)
    canvas.drawLine(const Offset(55, 35), const Offset(65, 35), _paint);
  }
}

// Fuente de Voltaje AC
class ACVoltageSourceSymbolPainter extends BaseSymbolPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 100;
    final scaleY = size.height / 80;
    canvas.scale(scaleX, scaleY);

    canvas.drawLine(
      const Offset(0, 40),
      const Offset(20, 40),
      _paint,
    ); // Línea izquierda
    canvas.drawLine(
      const Offset(80, 40),
      const Offset(100, 40),
      _paint,
    ); // Línea derecha

    // Círculo
    canvas.drawCircle(const Offset(50, 40), 30, _paint);

    // Onda sinusoidal
    final path = Path();
    path.moveTo(30, 40); // Inicia en el borde izquierdo del círculo
    path.arcToPoint(
      const Offset(70, 40),
      radius: const Radius.circular(20),
      largeArc: true,
      clockwise: false,
    );
    canvas.drawPath(path, _paint);
  }
}

// Interruptor (Switch)
class SwitchSymbolPainter extends BaseSymbolPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 100;
    final scaleY = size.height / 80;
    canvas.scale(scaleX, scaleY);

    canvas.drawLine(
      const Offset(0, 40),
      const Offset(30, 40),
      _paint,
    ); // Línea izquierda
    canvas.drawLine(
      const Offset(70, 40),
      const Offset(100, 40),
      _paint,
    ); // Línea derecha

    // Barra del interruptor
    canvas.drawLine(
      const Offset(30, 40),
      const Offset(60, 20),
      _paint,
    ); // Posición abierta
    canvas.drawCircle(
      const Offset(30, 40),
      3,
      _paint..style = PaintingStyle.fill,
    ); // Pivote
    canvas.drawCircle(
      const Offset(70, 40),
      3,
      _paint..style = PaintingStyle.fill,
    ); // Contacto
    _paint.style = PaintingStyle.stroke; // Reset style
  }
}

// Punto de Unión (Junction)
class JunctionSymbolPainter extends BaseSymbolPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 100;
    final scaleY = size.height / 80;
    canvas.scale(scaleX, scaleY);

    // Líneas
    canvas.drawLine(const Offset(0, 40), const Offset(40, 40), _paint);
    canvas.drawLine(const Offset(40, 40), const Offset(40, 0), _paint);
    canvas.drawLine(const Offset(40, 40), const Offset(40, 80), _paint);
    canvas.drawLine(const Offset(40, 40), const Offset(100, 40), _paint);

    // Punto de unión (relleno)
    _paint.style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(40, 40), 5, _paint);
    _paint.style = PaintingStyle.stroke; // Reset style
  }
}

// Voltímetro
class VoltmeterSymbolPainter extends BaseSymbolPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 100;
    final scaleY = size.height / 80;
    canvas.scale(scaleX, scaleY);

    // Círculo exterior
    canvas.drawCircle(const Offset(50, 40), 30, _paint);

    // Líneas de conexión
    canvas.drawLine(const Offset(0, 40), const Offset(20, 40), _paint);
    canvas.drawLine(const Offset(80, 40), const Offset(100, 40), _paint);

    // Letra 'V' dentro del círculo
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'V',
        style: TextStyle(
          color: Colors.black,
          fontSize:
              30 / scaleY, // Ajusta el tamaño de la fuente para que se vea bien
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(50 - textPainter.width / 2, 40 - textPainter.height / 2),
    );
  }
}

// Amperímetro
class AmmeterSymbolPainter extends BaseSymbolPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 100;
    final scaleY = size.height / 80;
    canvas.scale(scaleX, scaleY);

    // Círculo exterior
    canvas.drawCircle(const Offset(50, 40), 30, _paint);

    // Líneas de conexión
    canvas.drawLine(const Offset(0, 40), const Offset(20, 40), _paint);
    canvas.drawLine(const Offset(80, 40), const Offset(100, 40), _paint);

    // Letra 'A' dentro del círculo
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'A',
        style: TextStyle(
          color: Colors.black,
          fontSize: 30 / scaleY, // Ajusta el tamaño de la fuente
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(50 - textPainter.width / 2, 40 - textPainter.height / 2),
    );
  }
}
