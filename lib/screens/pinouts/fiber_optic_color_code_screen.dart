// lib/screens/pinouts/fiber_optic_color_code_screen.dart
import 'package:flutter/material.dart';
import 'package:calculadora_electronica/screens/image_viewer_screen.dart';

// --- TÍTULO Y DESCRIPCIONES ---
const String _fiberOpticTitle = 'Código de Colores de Fibra Óptica';
const String _fiberOpticImagePath =
    'assets/images/pinouts/fiber_optic_color_code.png';
const String _fiberOpticDescription =
    'El código de colores para cables de fibra óptica es un estándar crucial en telecomunicaciones. Se rige principalmente por el estándar de la industria **EIA/TIA-598** (comúnmente usado en Norteamérica) y el estándar internacional **IEC 60304**. Estos estándares definen una secuencia de 12 colores que se utiliza para identificar tanto los tubos o "binders" (cada uno conteniendo hasta 12 fibras) como las fibras individuales dentro de cada tubo. Para cables con más de 12 fibras, la secuencia de colores se repite en cada tubo, y los tubos se ordenan siguiendo la misma secuencia.\n\n'
    'Este método de codificación es esencial para la correcta instalación, mantenimiento y empalme de cables de fibra óptica, asegurando que cada fibra pueda ser rastreada desde su origen hasta su destino.';

// --- MODELOS DE DATOS ---
/// Clase para representar una fibra individual dentro de un grupo.
class FiberDetail {
  final int number;
  final String color;

  FiberDetail({required this.number, required this.color});
}

/// Clase para representar un grupo de fibras o "binder".
class FiberGroup {
  final String binderColor;
  final String description;
  final List<FiberDetail> fibers;

  FiberGroup({
    required this.binderColor,
    required this.description,
    required this.fibers,
  });
}

// --- DATOS CENTRALIZADOS ---
final Map<String, Color> _baseColors = {
  'Azul': Colors.blue.shade600,
  'Naranja': Colors.orange.shade600,
  'Verde': Colors.green.shade600,
  'Café': Colors.brown.shade600,
  'Gris': Colors.grey.shade600,
  'Blanco': Colors.white,
  'Rojo': Colors.red.shade600,
  'Negro': Colors.black,
  'Amarillo': Colors.yellow.shade700,
  'Violeta': Colors.purple.shade600,
  'Rosa': Colors.pink.shade300,
  'Aqua': Colors.cyan.shade400,
};

Color _getColorFromName(String colorName) {
  return _baseColors[colorName] ?? Colors.grey.shade400;
}

// Secuencia de colores estándar para fibras y tubos, hasta 12.
const List<String> _colorSequence = [
  'Azul',
  'Naranja',
  'Verde',
  'Café',
  'Gris',
  'Blanco',
  'Rojo',
  'Negro',
  'Amarillo',
  'Violeta',
  'Rosa',
  'Aqua',
];

// Generación de los datos para los grupos de fibras, hasta 144 fibras.
final List<FiberGroup> _fiberOpticDetails = List.generate(12, (binderIndex) {
  final binderColor = _colorSequence[binderIndex];
  final startFiberNumber = (binderIndex * 12) + 1;
  final fibers = List.generate(12, (fiberIndex) {
    final fiberNumber = startFiberNumber + fiberIndex;
    final fiberColor = _colorSequence[fiberIndex];
    return FiberDetail(number: fiberNumber, color: fiberColor);
  });

  return FiberGroup(
    binderColor: binderColor,
    description:
        'Grupo de fibras #$binderIndex + 1} ($startFiberNumber}-${startFiberNumber + 11}), con el tubo de color $binderColor.',
    fibers: fibers,
  );
});

class FiberOpticColorCodeScreen extends StatelessWidget {
  const FiberOpticColorCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(_fiberOpticTitle),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMainImage(context),
            const SizedBox(height: 24),
            _buildDescription(context),
            const SizedBox(height: 24),
            _buildTubeColorTable(context),
            const SizedBox(height: 24),
            Text(
              'Detalle del Código de Colores por Grupos (Tubos):',
              style: textTheme.headlineSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _fiberOpticDetails.length,
              itemBuilder: (context, index) {
                final fiberGroup = _fiberOpticDetails[index];
                return _buildFiberGroupExpansionTile(context, fiberGroup);
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- MÉTODOS PRIVADOS PARA CONSTRUIR WIDGETS ---

  Widget _buildMainImage(BuildContext context) {
    return Hero(
      tag: _fiberOpticImagePath,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageViewerScreen(
                imagePath: _fiberOpticImagePath,
                title: _fiberOpticTitle,
              ),
            ),
          );
        },
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(_fiberOpticImagePath, fit: BoxFit.contain),
        ),
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Descripción General:',
          style: textTheme.headlineSmall?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _fiberOpticDescription,
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface,
            height: 1.5,
          ),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  /// Construye la tabla para la secuencia de colores de los tubos (binders).
  Widget _buildTubeColorTable(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Secuencia de Colores de Tubos y Fibras:',
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          // Usamos Wrap para que los Cards se organicen mejor en diferentes tamaños de pantalla
          spacing: 8.0,
          runSpacing: 8.0,
          children: _colorSequence.asMap().entries.map((entry) {
            final int index = entry.key;
            final String colorName = entry.value;
            final Color color = _getColorFromName(colorName);
            final textColor = color.computeLuminance() > 0.5
                ? Colors.black
                : Colors.white;
            final int number = index + 1;

            return SizedBox(
              width: 160.0, // Ancho fijo para cada Card
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 24.0,
                        height: 24.0,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey.shade400,
                            width: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Color #$number',
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              colorName,
                              style: textTheme.bodySmall?.copyWith(
                                color: textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Construye un ExpansionTile para cada grupo de fibras.
  Widget _buildFiberGroupExpansionTile(
    BuildContext context,
    FiberGroup fiberGroup,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final fiberGroupColor = _getColorFromName(fiberGroup.binderColor);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        key: Key(fiberGroup.binderColor),
        title: Text(
          'Grupo: ${fiberGroup.binderColor}',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          fiberGroup.description,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: fiberGroupColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade400, width: 1.0),
          ),
        ),
        childrenPadding: const EdgeInsets.all(16.0),
        children: [_buildFibersTable(fiberGroup.fibers, context)],
      ),
    );
  }

  /// Construye la tabla para las fibras dentro de un grupo.
  Widget _buildFibersTable(List<FiberDetail> fibers, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final List<DataColumn> columns = [
      const DataColumn(
        label: Text('Número', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      const DataColumn(
        label: Text('Color', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    ];

    return Card(
      // ¡Nueva Card para la tabla interna!
      margin: EdgeInsets.zero,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 10,
          dataRowMinHeight: 30,
          dataRowMaxHeight: 50,
          headingRowColor: WidgetStateProperty.all(
            colorScheme.tertiaryContainer,
          ),
          border: TableBorder.all(
            color: colorScheme.outlineVariant,
            width: 0.5,
            borderRadius: BorderRadius.circular(8),
          ),
          columns: columns,
          rows: fibers
              .map(
                (fiber) => DataRow(
                  cells: [
                    DataCell(Text(fiber.number.toString())),
                    _buildColorCell(fiber.color, context),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  /// Construye una celda de tabla con el color del nombre.
  DataCell _buildColorCell(String colorName, BuildContext context) {
    final color = _getColorFromName(colorName);
    final textColor = color.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;

    return DataCell(
      Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade400, width: 0.5),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Text(
          colorName,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
