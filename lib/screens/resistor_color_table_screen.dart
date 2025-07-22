import 'package:flutter/material.dart';

class ResistorColorTableScreen extends StatelessWidget {
  const ResistorColorTableScreen({super.key});

  // Helper para obtener el objeto Color de Flutter dado un nombre de color
  Color _getColor(String colorName) {
    switch (colorName) {
      case 'Negro':
        return Colors.black;
      case 'Marrón':
        return Colors.brown;
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
        return const Color(0xFFFFD700); // Color oro
      case 'Plata':
        return const Color(0xFFC0C0C0); // Color plata
      default:
        return Colors.transparent;
    }
  }

  // Lista de datos para la tabla de dígitos
  final List<Map<String, String>> _digitData = const [
    {'Color': 'Negro', 'Valor': '0'},
    {'Color': 'Marrón', 'Valor': '1'},
    {'Color': 'Rojo', 'Valor': '2'},
    {'Color': 'Naranja', 'Valor': '3'},
    {'Color': 'Amarillo', 'Valor': '4'},
    {'Color': 'Verde', 'Valor': '5'},
    {'Color': 'Azul', 'Valor': '6'},
    {'Color': 'Violeta', 'Valor': '7'},
    {'Color': 'Gris', 'Valor': '8'},
    {'Color': 'Blanco', 'Valor': '9'},
  ];

  // Lista de datos para la tabla de multiplicadores
  final List<Map<String, String>> _multiplierData = const [
    {'Color': 'Negro', 'Valor': 'x1'},
    {'Color': 'Marrón', 'Valor': 'x10'},
    {'Color': 'Rojo', 'Valor': 'x100'},
    {'Color': 'Naranja', 'Valor': 'x1k'},
    {'Color': 'Amarillo', 'Valor': 'x10k'},
    {'Color': 'Verde', 'Valor': 'x100k'},
    {'Color': 'Azul', 'Valor': 'x1M'},
    {'Color': 'Violeta', 'Valor': 'x10M'},
    {'Color': 'Gris', 'Valor': 'x100M'},
    {'Color': 'Blanco', 'Valor': 'x1G'},
    {'Color': 'Oro', 'Valor': 'x0.1'},
    {'Color': 'Plata', 'Valor': 'x0.01'},
  ];

  // Lista de datos para la tabla de tolerancias
  final List<Map<String, String>> _toleranceData = const [
    {'Color': 'Marrón', 'Valor': '±1%'},
    {'Color': 'Rojo', 'Valor': '±2%'},
    {'Color': 'Verde', 'Valor': '±0.5%'},
    {'Color': 'Azul', 'Valor': '±0.25%'},
    {'Color': 'Violeta', 'Valor': '±0.1%'},
    {'Color': 'Gris', 'Valor': '±0.05%'},
    {'Color': 'Oro', 'Valor': '±5%'},
    {'Color': 'Plata', 'Valor': '±10%'},
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 3, // Dígitos, Multiplicador, Tolerancia
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tabla de Código de Colores'),
          centerTitle: true,
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
          bottom: TabBar(
            indicatorColor: colorScheme.primary,
            labelColor: colorScheme.primary,
            unselectedLabelColor: colorScheme.onSurfaceVariant,
            tabs: const [
              Tab(text: 'Dígitos'),
              Tab(text: 'Multiplicador'),
              Tab(text: 'Tolerancia'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildDataTable(_digitData, colorScheme, isDigitTable: true),
            _buildDataTable(_multiplierData, colorScheme),
            _buildDataTable(_toleranceData, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildDataTable(
    List<Map<String, String>> data,
    ColorScheme colorScheme, {
    bool isDigitTable = false,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: DataTable(
            columnSpacing: 20,
            dataRowMinHeight: 48,
            dataRowMaxHeight: 56,
            headingRowColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) => colorScheme.surfaceContainerHighest,
            ),
            columns: [
              DataColumn(
                label: Text(
                  'Color',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  isDigitTable ? 'Valor' : 'Multiplicador/Tolerancia',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
            rows: data.map((item) {
              return DataRow(
                cells: [
                  DataCell(
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          margin: const EdgeInsets.only(right: 10),
                          // --- MODIFICACIÓN AQUÍ ---
                          decoration: BoxDecoration(
                            color: _getColor(
                              item['Color']!,
                            ), // <--- EL COLOR SE MUEVE AQUÍ DENTRO
                            borderRadius: BorderRadius.circular(4),
                            // Borde para colores claros como blanco/amarillo
                            border:
                                item['Color'] == 'Blanco' ||
                                    item['Color'] == 'Amarillo'
                                ? Border.all(
                                    color: Colors.grey.shade400,
                                    width: 1,
                                  )
                                : null,
                          ),
                          // ELIMINA la línea 'color: _getColor(item['Color']!),' si estaba aquí fuera del decoration.
                        ),
                        Text(
                          item['Color']!,
                          style: TextStyle(color: colorScheme.onSurface),
                        ),
                      ],
                    ),
                  ),
                  DataCell(
                    Text(
                      item['Valor']!,
                      style: TextStyle(color: colorScheme.onSurface),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
