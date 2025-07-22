import 'package:flutter/material.dart';

class ResistorColorCodeScreen extends StatefulWidget {
  const ResistorColorCodeScreen({super.key});

  @override
  State<ResistorColorCodeScreen> createState() =>
      _ResistorColorCodeScreenState();
}

class _ResistorColorCodeScreenState extends State<ResistorColorCodeScreen> {
  final Map<String, int> _bandValue = {
    'Negro': 0,
    'Marrón': 1,
    'Rojo': 2,
    'Naranja': 3,
    'Amarillo': 4,
    'Verde': 5,
    'Azul': 6,
    'Violeta': 7,
    'Gris': 8,
    'Blanco': 9,
  };

  final Map<String, double> _multiplierValue = {
    'Negro': 1,
    'Marrón': 10,
    'Rojo': 100,
    'Naranja': 1000,
    'Amarillo': 10000,
    'Verde': 100000,
    'Azul': 1000000,
    'Violeta': 10000000,
    'Gris': 100000000,
    'Blanco': 1000000000,
    'Oro': 0.1,
    'Plata': 0.01,
  };

  final Map<String, String> _toleranceValue = {
    'Marrón': '±1%',
    'Rojo': '±2%',
    'Verde': '±0.5%',
    'Azul': '±0.25%',
    'Violeta': '±0.1%',
    'Gris': '±0.05%',
    'Oro': '±5%',
    'Plata': '±10%',
  };

  final List<String> _band1Colors = [
    'Marrón',
    'Rojo',
    'Naranja',
    'Amarillo',
    'Verde',
    'Azul',
    'Violeta',
    'Gris',
    'Blanco',
  ];

  final List<String> _band2Colors = [
    'Negro',
    'Marrón',
    'Rojo',
    'Naranja',
    'Amarillo',
    'Verde',
    'Azul',
    'Violeta',
    'Gris',
    'Blanco',
  ];

  final List<String> _band3Colors = [
    'Negro',
    'Marrón',
    'Rojo',
    'Naranja',
    'Amarillo',
    'Verde',
    'Azul',
    'Violeta',
    'Gris',
    'Blanco',
  ];

  final List<String> _multiplierColors = [
    'Negro',
    'Marrón',
    'Rojo',
    'Naranja',
    'Amarillo',
    'Verde',
    'Azul',
    'Violeta',
    'Gris',
    'Blanco',
    'Oro',
    'Plata',
  ];

  final List<String> _toleranceColors = [
    'Marrón',
    'Rojo',
    'Verde',
    'Azul',
    'Violeta',
    'Gris',
    'Oro',
    'Plata',
  ];

  String? _selectedBand1;
  String? _selectedBand2;
  String? _selectedMultiplier;
  String? _selectedTolerance;
  String? _selectedBand3;

  String _resistanceValue = '';
  String _tolerance = '';
  int _numberOfBands = 4;

  @override
  void initState() {
    super.initState();
    _calculateResistance();
  }

  void _calculateResistance() {
    if (_numberOfBands == 4) {
      if (_selectedBand1 != null &&
          _selectedBand2 != null &&
          _selectedMultiplier != null &&
          _selectedTolerance != null) {
        final int band1Val = _bandValue[_selectedBand1!]!;
        final int band2Val = _bandValue[_selectedBand2!]!;
        final double multiplierVal = _multiplierValue[_selectedMultiplier!]!;
        final String toleranceVal = _toleranceValue[_selectedTolerance!]!;

        double resistance = (band1Val * 10 + band2Val) * multiplierVal;

        setState(() {
          _resistanceValue = _formatResistance(resistance);
          _tolerance = toleranceVal;
        });
      } else {
        setState(() {
          _resistanceValue = 'Selecciona todos los colores';
          _tolerance = '';
        });
      }
    } else {
      if (_selectedBand1 != null &&
          _selectedBand2 != null &&
          _selectedBand3 != null &&
          _selectedMultiplier != null &&
          _selectedTolerance != null) {
        final int band1Val = _bandValue[_selectedBand1!]!;
        final int band2Val = _bandValue[_selectedBand2!]!;
        final int band3Val = _bandValue[_selectedBand3!]!;
        final double multiplierVal = _multiplierValue[_selectedMultiplier!]!;
        final String toleranceVal = _toleranceValue[_selectedTolerance!]!;

        double resistance =
            (band1Val * 100 + band2Val * 10 + band3Val) * multiplierVal;

        setState(() {
          _resistanceValue = _formatResistance(resistance);
          _tolerance = toleranceVal;
        });
      } else {
        setState(() {
          _resistanceValue = 'Selecciona todos los colores';
          _tolerance = '';
        });
      }
    }
  }

  String _formatResistance(double value) {
    if (value.abs() >= 1e9) {
      return '${(value / 1e9).toStringAsFixed(3)} GΩ';
    } else if (value.abs() >= 1e6) {
      return '${(value / 1e6).toStringAsFixed(3)} MΩ';
    } else if (value.abs() >= 1e3) {
      return '${(value / 1e3).toStringAsFixed(3)} kΩ';
    } else {
      return '${value.toStringAsFixed(3)} Ω';
    }
  }

  Color _getColor(String? colorName) {
    switch (colorName) {
      case 'Negro':
        return Colors.black;
      case 'Marrón':
        return const Color(0xFF795548);
      case 'Rojo':
        return Colors.red;
      case 'Naranja':
        return Colors.orange;
      case 'Amarillo':
        return Colors.yellow;
      case 'Verde':
        return Colors.green;
      case 'Azul':
        return Colors.blue;
      case 'Violeta':
        return Colors.purple;
      case 'Gris':
        return Colors.grey;
      case 'Blanco':
        return Colors.white;
      case 'Oro':
        return const Color(0xFFFFD700);
      case 'Plata':
        return const Color(0xFFC0C0C0);
      default:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de Resistencias'),
        centerTitle: true,
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Resistencia',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomPaint(
                      size: const Size(300, 120),
                      painter: ResistorPainter(
                        band1Color: _getColor(_selectedBand1),
                        band2Color: _getColor(_selectedBand2),
                        band3Color: _getColor(_selectedBand3),
                        multiplierColor: _getColor(_selectedMultiplier),
                        toleranceColor: _getColor(_selectedTolerance),
                        numberOfBands: _numberOfBands,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'Número de Bandas:',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _buildBandChoice(4),
                _buildBandChoice(5),
                _buildBandChoice(6),
              ],
            ),
            const SizedBox(height: 24),

            _buildColorDropdown(
              'Banda 1 (1er dígito)',
              _selectedBand1,
              _band1Colors,
            ),
            _buildColorDropdown(
              'Banda 2 (2do dígito)',
              _selectedBand2,
              _band2Colors,
            ),
            if (_numberOfBands >= 5)
              _buildColorDropdown(
                'Banda 3 (3er dígito)',
                _selectedBand3,
                _band3Colors,
              ),
            _buildColorDropdown(
              'Multiplicador',
              _selectedMultiplier,
              _multiplierColors,
            ),
            _buildColorDropdown(
              'Tolerancia',
              _selectedTolerance,
              _toleranceColors,
            ),
            const SizedBox(height: 24),

            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Resultado:', style: theme.textTheme.titleLarge),
                    const SizedBox(height: 8),
                    Text(
                      _resistanceValue,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text('Tolerancia:', style: theme.textTheme.titleMedium),
                    Text(
                      _tolerance,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBandChoice(int bands) {
    final isSelected = _numberOfBands == bands;
    return ChoiceChip(
      label: Text('$bands Bandas'),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _numberOfBands = bands;
          if (bands == 4) _selectedBand3 = null;
          _calculateResistance();
        });
      },
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
      labelStyle: TextStyle(
        color: isSelected
            ? Theme.of(context).colorScheme.onPrimaryContainer
            : Theme.of(context).colorScheme.onSurface,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  Widget _buildColorDropdown(
    String label,
    String? selectedValue,
    List<String> items,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        dropdownColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        value: selectedValue,
        hint: const Text('Selecciona color'),
        onChanged: (newValue) {
          setState(() {
            switch (label) {
              case 'Banda 1 (1er dígito)':
                _selectedBand1 = newValue;
                break;
              case 'Banda 2 (2do dígito)':
                _selectedBand2 = newValue;
                break;
              case 'Banda 3 (3er dígito)':
                _selectedBand3 = newValue;
                break;
              case 'Multiplicador':
                _selectedMultiplier = newValue;
                break;
              case 'Tolerancia':
                _selectedTolerance = newValue;
                break;
            }
            _calculateResistance();
          });
        },
        items: items.map((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  // --- MODIFICACIÓN AQUÍ ---
                  decoration: BoxDecoration(
                    color: _getColor(
                      value,
                    ), // El color se mueve AQUI, dentro de BoxDecoration
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  // ELIMINAR 'color: _getColor(value),' si estaba aquí fuera del decoration.
                  margin: const EdgeInsets.only(right: 12),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class ResistorPainter extends CustomPainter {
  final Color? band1Color;
  final Color? band2Color;
  final Color? band3Color;
  final Color? multiplierColor;
  final Color? toleranceColor;
  final int numberOfBands;

  ResistorPainter({
    required this.band1Color,
    required this.band2Color,
    this.band3Color,
    required this.multiplierColor,
    required this.toleranceColor,
    required this.numberOfBands,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double resistorWidth = size.width * 0.8;
    final double resistorHeight = size.height * 0.35;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    // Sombra
    final shadowPaint = Paint()
      ..color = const Color.fromRGBO(0, 0, 0, 40)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX, centerY + resistorHeight * 0.8),
        width: resistorWidth * 0.9,
        height: resistorHeight * 0.4,
      ),
      shadowPaint,
    );

    // Cuerpo de la resistencia
    final bodyPaint = Paint()
      ..shader =
          LinearGradient(
            colors: [
              Colors.grey.shade400,
              Colors.grey.shade200,
              Colors.grey.shade400,
            ],
            stops: const [0.0, 0.5, 1.0],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(
            Rect.fromCenter(
              center: Offset(centerX, centerY),
              width: resistorWidth,
              height: resistorHeight,
            ),
          )
      ..style = PaintingStyle.fill;

    final resistorBody = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(centerX, centerY),
        width: resistorWidth,
        height: resistorHeight,
      ),
      Radius.circular(resistorHeight / 2),
    );
    canvas.drawRRect(resistorBody, bodyPaint);

    // Efecto de luz
    final highlightPaint = Paint()
      ..shader =
          RadialGradient(
            center: const Alignment(-0.3, -0.3),
            radius: 0.7,
            colors: [
              const Color.fromRGBO(255, 255, 255, 30),
              Colors.transparent,
            ],
          ).createShader(
            Rect.fromCenter(
              center: Offset(centerX, centerY),
              width: resistorWidth,
              height: resistorHeight,
            ),
          )
      ..blendMode = BlendMode.overlay;
    canvas.drawRRect(resistorBody, highlightPaint);

    // Dibujar bandas de colores
    final double bandWidth = resistorHeight * 0.25;
    double currentBandX = centerX - resistorWidth / 2 + resistorHeight * 0.4;

    _drawBand(
      canvas,
      currentBandX,
      centerY,
      bandWidth,
      resistorHeight,
      band1Color,
    );
    currentBandX += bandWidth * 1.3;

    _drawBand(
      canvas,
      currentBandX,
      centerY,
      bandWidth,
      resistorHeight,
      band2Color,
    );
    currentBandX += bandWidth * 1.3;

    if (numberOfBands >= 5) {
      _drawBand(
        canvas,
        currentBandX,
        centerY,
        bandWidth,
        resistorHeight,
        band3Color,
      );
      currentBandX += bandWidth * 1.3;
    }

    // Bandas del lado derecho
    currentBandX =
        centerX +
        resistorWidth / 2 -
        resistorHeight * 0.4 -
        (numberOfBands == 4 ? bandWidth * 1.3 : bandWidth * 2.6);

    _drawBand(
      canvas,
      currentBandX,
      centerY,
      bandWidth,
      resistorHeight,
      multiplierColor,
    );
    currentBandX += bandWidth * 1.3;

    _drawBand(
      canvas,
      currentBandX,
      centerY,
      bandWidth,
      resistorHeight,
      toleranceColor,
    );

    // Terminales
    _drawTerminal(
      canvas,
      centerX - resistorWidth / 2,
      centerY,
      centerX - size.width / 2.5,
      centerY,
    );
    _drawTerminal(
      canvas,
      centerX + resistorWidth / 2,
      centerY,
      centerX + size.width / 2.5,
      centerY,
    );
  }

  void _drawTerminal(
    Canvas canvas,
    double x1,
    double y1,
    double x2,
    double y2,
  ) {
    final terminalPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFFD0D0D0),
          const Color(0xFFA0A0A0),
          const Color(0xFF808080),
        ],
        stops: const [0.0, 0.5, 1.0],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromPoints(Offset(x1, y1 - 3), Offset(x2, y2 + 3)))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(x1, y1), Offset(x2, y2), terminalPaint);
  }

  void _drawBand(
    Canvas canvas,
    double x,
    double y,
    double bandWidth,
    double resistorHeight,
    Color? color,
  ) {
    if (color == null || color == Colors.transparent) return;

    final bandHeight = resistorHeight * 0.85;
    final bandRect = Rect.fromCenter(
      center: Offset(x, y),
      width: bandWidth,
      height: bandHeight,
    );

    // Banda principal con color sólido
    final bandPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    canvas.drawRect(bandRect, bandPaint);

    // Efecto de borde - Usando Color.fromRGBO en lugar de withOpacity
    final borderPaint = Paint()
      ..color =
          const Color.fromRGBO(0, 0, 0, 0.2) // Equivalente a withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..isAntiAlias = true;

    // Dibujar bordes
    canvas.drawLine(
      Offset(bandRect.left, bandRect.top),
      Offset(bandRect.right, bandRect.top),
      borderPaint,
    );
    canvas.drawLine(
      Offset(bandRect.left, bandRect.bottom),
      Offset(bandRect.right, bandRect.bottom),
      borderPaint,
    );

    // Efecto de sombra - Usando Color.fromRGBO
    final shadowPaint = Paint()
      ..color =
          const Color.fromRGBO(0, 0, 0, 0.15) // Equivalente a withOpacity(0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    canvas.drawRect(bandRect.shift(const Offset(1, 1)), shadowPaint);
  }

  @override
  bool shouldRepaint(covariant ResistorPainter oldDelegate) {
    return oldDelegate.band1Color != band1Color ||
        oldDelegate.band2Color != band2Color ||
        oldDelegate.band3Color != band3Color ||
        oldDelegate.multiplierColor != multiplierColor ||
        oldDelegate.toleranceColor != toleranceColor ||
        oldDelegate.numberOfBands != numberOfBands;
  }
}
