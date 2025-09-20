// lib/screens/pinouts/twenty_five_pair_color_code_screen.dart
import 'package:calculadora_electronica/screens/image_viewer_screen.dart';
import 'package:flutter/material.dart';

// --- TÍTULO Y DESCRIPCIONES ---
const String _twentyFivePairTitle = 'Código de Colores de Cables de 25 Pares';
const String _twentyFivePairImagePath =
    'assets/images/pinouts/25_pair_cable_color_code.png';
const String _twentyFivePairDescription =
    'Este es el estándar industrial para la codificación de colores de cables multipar de 25 pares, utilizado en telecomunicaciones y cableado estructurado. La codificación se basa en la combinación de dos series de 5 colores cada una:\n\n'
    '•  **Colores Tip (Puntas):** Blanco, Rojo, Negro, Amarillo, Violeta.\n'
    '•  **Colores Ring (Anillos):** Azul, Naranja, Verde, Café, Gris.\n\n'
    'La combinación de un color de la serie Tip con uno de la serie Ring crea un par único. Los pares se agrupan en "binders" de 5, donde el color del Tip se mantiene constante para cada grupo.';

// --- MODELOS DE DATOS PARA MEJOR ROBUSTEZ ---
class PairDetail {
  final int pair;
  final String tipColor;
  final String ringColor;
  final String combined;

  PairDetail({
    required this.pair,
    required this.tipColor,
    required this.ringColor,
    required this.combined,
  });
}

class BinderGroup {
  final String binderColor;
  final String description;
  final List<PairDetail> pairs;

  BinderGroup({
    required this.binderColor,
    required this.description,
    required this.pairs,
  });
}

// --- DATOS CENTRALIZADOS ---
final Map<String, Color> _baseColors = {
  'Blanco': Colors.white,
  'Rojo': Colors.red.shade600,
  'Negro': Colors.black,
  'Amarillo': Colors.yellow.shade700,
  'Violeta': Colors.purple.shade600,
  'Azul': Colors.blue.shade600,
  'Naranja': Colors.orange.shade600,
  'Verde': Colors.green.shade600,
  'Café': Colors.brown.shade600,
  'Gris': Colors.grey.shade600,
};

Color _getColorFromName(String colorName) {
  return _baseColors[colorName] ?? Colors.grey.shade400;
}

final List<BinderGroup> _twentyFivePairDetails = [
  BinderGroup(
    binderColor: 'Blanco',
    description: 'El primer grupo de 5 pares usa el color base Blanco.',
    pairs: [
      PairDetail(
        pair: 1,
        tipColor: 'Blanco',
        ringColor: 'Azul',
        combined: 'Blanco-Azul',
      ),
      PairDetail(
        pair: 2,
        tipColor: 'Blanco',
        ringColor: 'Naranja',
        combined: 'Blanco-Naranja',
      ),
      PairDetail(
        pair: 3,
        tipColor: 'Blanco',
        ringColor: 'Verde',
        combined: 'Blanco-Verde',
      ),
      PairDetail(
        pair: 4,
        tipColor: 'Blanco',
        ringColor: 'Café',
        combined: 'Blanco-Café',
      ),
      PairDetail(
        pair: 5,
        tipColor: 'Blanco',
        ringColor: 'Gris',
        combined: 'Blanco-Gris',
      ),
    ],
  ),
  BinderGroup(
    binderColor: 'Rojo',
    description: 'El segundo grupo de 5 pares usa el color base Rojo.',
    pairs: [
      PairDetail(
        pair: 6,
        tipColor: 'Rojo',
        ringColor: 'Azul',
        combined: 'Rojo-Azul',
      ),
      PairDetail(
        pair: 7,
        tipColor: 'Rojo',
        ringColor: 'Naranja',
        combined: 'Rojo-Naranja',
      ),
      PairDetail(
        pair: 8,
        tipColor: 'Rojo',
        ringColor: 'Verde',
        combined: 'Rojo-Verde',
      ),
      PairDetail(
        pair: 9,
        tipColor: 'Rojo',
        ringColor: 'Café',
        combined: 'Rojo-Café',
      ),
      PairDetail(
        pair: 10,
        tipColor: 'Rojo',
        ringColor: 'Gris',
        combined: 'Rojo-Gris',
      ),
    ],
  ),
  BinderGroup(
    binderColor: 'Negro',
    description: 'El tercer grupo de 5 pares usa el color base Negro.',
    pairs: [
      PairDetail(
        pair: 11,
        tipColor: 'Negro',
        ringColor: 'Azul',
        combined: 'Negro-Azul',
      ),
      PairDetail(
        pair: 12,
        tipColor: 'Negro',
        ringColor: 'Naranja',
        combined: 'Negro-Naranja',
      ),
      PairDetail(
        pair: 13,
        tipColor: 'Negro',
        ringColor: 'Verde',
        combined: 'Negro-Verde',
      ),
      PairDetail(
        pair: 14,
        tipColor: 'Negro',
        ringColor: 'Café',
        combined: 'Negro-Café',
      ),
      PairDetail(
        pair: 15,
        tipColor: 'Negro',
        ringColor: 'Gris',
        combined: 'Negro-Gris',
      ),
    ],
  ),
  BinderGroup(
    binderColor: 'Amarillo',
    description: 'El cuarto grupo de 5 pares usa el color base Amarillo.',
    pairs: [
      PairDetail(
        pair: 16,
        tipColor: 'Amarillo',
        ringColor: 'Azul',
        combined: 'Amarillo-Azul',
      ),
      PairDetail(
        pair: 17,
        tipColor: 'Amarillo',
        ringColor: 'Naranja',
        combined: 'Amarillo-Naranja',
      ),
      PairDetail(
        pair: 18,
        tipColor: 'Amarillo',
        ringColor: 'Verde',
        combined: 'Amarillo-Verde',
      ),
      PairDetail(
        pair: 19,
        tipColor: 'Amarillo',
        ringColor: 'Café',
        combined: 'Amarillo-Café',
      ),
      PairDetail(
        pair: 20,
        tipColor: 'Amarillo',
        ringColor: 'Gris',
        combined: 'Amarillo-Gris',
      ),
    ],
  ),
  BinderGroup(
    binderColor: 'Violeta',
    description: 'El quinto grupo de 5 pares usa el color base Violeta.',
    pairs: [
      PairDetail(
        pair: 21,
        tipColor: 'Violeta',
        ringColor: 'Azul',
        combined: 'Violeta-Azul',
      ),
      PairDetail(
        pair: 22,
        tipColor: 'Violeta',
        ringColor: 'Naranja',
        combined: 'Violeta-Naranja',
      ),
      PairDetail(
        pair: 23,
        tipColor: 'Violeta',
        ringColor: 'Verde',
        combined: 'Violeta-Verde',
      ),
      PairDetail(
        pair: 24,
        tipColor: 'Violeta',
        ringColor: 'Café',
        combined: 'Violeta-Café',
      ),
      PairDetail(
        pair: 25,
        tipColor: 'Violeta',
        ringColor: 'Gris',
        combined: 'Violeta-Gris',
      ),
    ],
  ),
];

class TwentyFivePairColorCodeScreen extends StatelessWidget {
  const TwentyFivePairColorCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(_twentyFivePairTitle),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Sección de imagen principal con Hero Animation para una transición atractiva
            _buildMainImage(context),
            const SizedBox(height: 24),

            // Sección de descripción general del código de colores
            _buildDescription(context),
            const SizedBox(height: 24),

            // Título de la sección de detalle
            Text(
              'Detalle del Código por Grupos (Binders):',
              style: textTheme.headlineSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Lista de ExpansionTiles para cada grupo de pares
            ListView.builder(
              shrinkWrap:
                  true, // Para que el ListView se adapte al tamaño del contenido
              physics:
                  const NeverScrollableScrollPhysics(), // Deshabilita el scroll interno
              itemCount: _twentyFivePairDetails.length,
              itemBuilder: (context, index) {
                final binder = _twentyFivePairDetails[index];
                return _buildBinderExpansionTile(context, binder);
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
      tag: _twentyFivePairImagePath,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => const ImageViewerScreen(
                imagePath: _twentyFivePairImagePath,
                title: _twentyFivePairTitle,
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
          child: Image.asset(_twentyFivePairImagePath, fit: BoxFit.contain),
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
          _twentyFivePairDescription,
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface,
            height: 1.5,
          ),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  Widget _buildBinderExpansionTile(BuildContext context, BinderGroup binder) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final binderColor = _getColorFromName(binder.binderColor);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        key: Key(binder.binderColor),
        title: Text(
          'Binder: ${binder.binderColor}',
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme
                .onSurface, // El color del texto del título siempre se adaptará al tema de la aplicación
          ),
        ),
        subtitle: Text(
          binder.description,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: binderColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade400),
          ),
        ),
        childrenPadding: const EdgeInsets.all(16.0),
        children: [_buildPairsTable(binder.pairs, context)],
      ),
    );
  }

  Widget _buildPairsTable(List<PairDetail> pairs, BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final List<DataColumn> columns = [
      const DataColumn(
        label: Text('Par', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      const DataColumn(
        label: Text('Tip', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      const DataColumn(
        label: Text('Ring', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      const DataColumn(
        label: Text('Código', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 10,
        dataRowMinHeight: 30,
        dataRowMaxHeight: 50,
        headingRowColor: WidgetStateProperty.all(colorScheme.tertiaryContainer),
        border: TableBorder.all(
          color: colorScheme.outlineVariant,
          width: 0.5,
          borderRadius: BorderRadius.circular(8),
        ),
        columns: columns,
        rows: pairs
            .map(
              (pairDetail) => DataRow(
                cells: [
                  DataCell(Text(pairDetail.pair.toString())),
                  _buildColorCell(pairDetail.tipColor, context),
                  _buildColorCell(pairDetail.ringColor, context),
                  DataCell(Text(pairDetail.combined)),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

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
