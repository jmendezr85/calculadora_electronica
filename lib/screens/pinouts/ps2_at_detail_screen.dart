// lib/screens/pinouts/ps2_at_detail_screen.dart
import 'package:calculadora_electronica/screens/image_viewer_screen.dart'; // ¡NUEVO! Importa la pantalla de visualización de imagen
import 'package:flutter/material.dart';

const String _ps2AtTitle = 'Conectores PS/2 y AT (Teclado/Ratón)';
const String _ps2AtImagePath =
    'assets/images/pinouts/ps2_connector.png'; // Asume una imagen del conector PS/2
const String _ps2AtDescription =
    'Los conectores PS/2 (Mini-DIN de 6 pines) y AT (DIN de 5 pines) son interfaces serie antiguas utilizadas para conectar teclados y ratones a la placa base de una computadora. Aunque han sido ampliamente reemplazados por el USB, muchos sistemas legacy y algunas placas base modernas aún los incluyen por compatibilidad y ventajas específicas.';

// Función auxiliar para obtener el objeto Color a partir de un tipo de señal o función.
Color _getColorForSignalType(String type) {
  switch (type.toLowerCase()) {
    case 'data':
      return Colors.blue.shade600; // Azul para Data
    case 'clock':
      return Colors.green.shade600; // Verde para Clock
    case 'vcc (+5v)':
      return Colors.red.shade600; // Rojo para VCC
    case 'ground':
      return Colors.black; // Negro para Ground
    case 'nc':
    case 'no conectado':
      return Colors.grey.shade300; // No conectado
    default:
      return Colors.grey.shade100; // Por defecto
  }
}

const List<Map<String, dynamic>> _ps2AtDetails = [
  {
    'section_title': 'Conector PS/2 (Mini-DIN de 6 Pines)',
    'description':
        'El conector PS/2 es un puerto estándar de IBM introducido con su línea de computadoras Personal System/2 en 1987. Es un conector Mini-DIN de 6 pines. Se utiliza comúnmente para teclados (verde) y ratones (morado), aunque el color no es un estándar rígido, sí es la convención más extendida.',
    'image_pinout':
        'assets/images/pinouts/ps2_pinout.png', // Asume imagen específica
    'table_data': [
      {'pin': '1', 'funcion': 'Data', 'tipo_senal': 'Data'},
      {'pin': '2', 'funcion': 'NC (No Conectado)', 'tipo_senal': 'NC'},
      {'pin': '3', 'funcion': 'Ground', 'tipo_senal': 'Ground'},
      {'pin': '4', 'funcion': 'VCC (+5V)', 'tipo_senal': 'VCC (+5V)'},
      {'pin': '5', 'funcion': 'Clock', 'tipo_senal': 'Clock'},
      {'pin': '6', 'funcion': 'NC (No Conectado)', 'tipo_senal': 'NC'},
    ],
  },
  {
    'section_title': 'Conector AT de Teclado (DIN de 5 Pines)',
    'description':
        'El conector AT es un conector DIN de 5 pines utilizado para teclados en sistemas IBM PC/AT y compatibles anteriores a la era PS/2. Aunque obsoleto para sistemas modernos, es importante para la restauración de equipos vintage y el conocimiento histórico.',
    'image_pinout':
        'assets/images/pinouts/at_keyboard_pinout.png', // Asume imagen específica
    'table_data': [
      {'pin': '1', 'funcion': 'Clock', 'tipo_senal': 'Clock'},
      {'pin': '2', 'funcion': 'Data', 'tipo_senal': 'Data'},
      {'pin': '3', 'funcion': 'NC (No Conectado)', 'tipo_senal': 'NC'},
      {'pin': '4', 'funcion': 'Ground', 'tipo_senal': 'Ground'},
      {'pin': '5', 'funcion': 'VCC (+5V)', 'tipo_senal': 'VCC (+5V)'},
    ],
  },
  {
    'section_title': 'Evolución: De AT a PS/2 y USB',
    'description':
        'La historia de los conectores de teclado y ratón refleja la búsqueda de mayor eficiencia, velocidad y simplicidad.',
    'list_data': [
      {
        'title': 'Conector AT (DIN de 5 pines)',
        'details':
            'Fue el estándar original para teclados de PC, caracterizado por su robustez. Su principal limitación era que no era "hot-pluggable" (no se podía conectar/desconectar con el equipo encendido sin riesgo de daños).',
      },
      {
        'title': 'Conector PS/2 (Mini-DIN de 6 pines)',
        'details':
            'Introducido por IBM, el PS/2 era más compacto que el AT. Permitió la conexión tanto de teclado como de ratón con conectores separados pero idénticos. Aunque tampoco es oficialmente "hot-pluggable" para evitar riesgos, en la práctica es más tolerante que el AT. Una ventaja de PS/2 es que permite que el teclado y el ratón interactúen directamente con la CPU a nivel de interrupción, lo que puede ser beneficioso en escenarios de baja latencia o cuando el USB está sobrecargado.',
      },
      {
        'title': 'Conectores USB (Universal Serial Bus)',
        'details':
            'El USB se convirtió en el estándar dominante debido a su versatilidad, alta velocidad, capacidad "hot-pluggable", y la habilidad de conectar múltiples tipos de dispositivos (no solo teclados/ratones) a un solo puerto o hub. Ha simplificado enormemente el cableado y la conectividad en las PCs modernas, relegando a PS/2 y AT a nichos o sistemas legacy.',
      },
    ],
  },
  {
    'section_title': 'Problemas Comunes y Solución de Problemas',
    'description':
        'Aquí algunas soluciones para problemas típicos con los conectores PS/2 y AT:',
    'list_data': [
      {
        'title': 'Teclado/Ratón PS/2 no funciona',
        'details':
            '**Síntomas:** El dispositivo no responde, no hay luces (si las tiene).\n**Solución:**\n1.  **Reinicio:** A menudo, un dispositivo PS/2 debe conectarse antes de encender el PC. Reinicia la computadora.\n2.  **Puerto incorrecto:** Asegúrate de que el teclado (generalmente verde) esté en el puerto PS/2 verde y el ratón (generalmente morado) en el puerto PS/2 morado. Son idénticos físicamente pero internamente están cableados para dispositivos específicos.\n3.  **Conexión floja:** Asegúrate de que el conector esté firmemente insertado.\n4.  **Adaptador USB:** Si tienes un adaptador PS/2 a USB, prueba a conectar el dispositivo a un puerto USB para ver si el problema es del conector PS/2 de la placa base o del propio dispositivo.',
      },
      {
        'title': 'Problemas con adaptadores PS/2 a USB o viceversa',
        'details':
            '**Síntomas:** El dispositivo funciona directamente pero no con el adaptador, o se comporta erráticamente.\n**Solución:**\n1.  **Tipo de adaptador:** Algunos adaptadores PS/2 a USB solo funcionan con teclados o ratones específicos "dual-protocol" que pueden auto-detectar si están conectados a USB o PS/2. Los adaptadores pasivos (sin electrónica) solo funcionarán con estos dispositivos.\n2.  **Adaptador activo:** Para teclados/ratones PS/2 antiguos que no son "dual-protocol", necesitarás un adaptador activo (con un chip conversor) de PS/2 a USB.\n3.  **Conectividad:** Asegúrate de que el adaptador esté bien conectado en ambos extremos.',
      },
      {
        'title': 'Teclado AT no responde (Sistemas antiguos)',
        'details':
            '**Síntomas:** El teclado no funciona en un sistema AT.\n**Solución:**\n1.  **Conexión firme:** Asegúrate de que el conector DIN de 5 pines esté firmemente insertado en el puerto de teclado de la placa base.\n2.  **Reiniciar:** Apaga y vuelve a encender el equipo. Los teclados AT no son hot-pluggable.\n3.  **Probar otro teclado:** Si es posible, prueba con otro teclado AT para descartar que el problema sea del teclado mismo.',
      },
    ],
  },
];

class Ps2AtDetailScreen extends StatelessWidget {
  const Ps2AtDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final hoverColor = Color.lerp(
      colorScheme.primary,
      colorScheme.surface,
      0.9,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(_ps2AtTitle),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.antiAlias,
              // MODIFICACIÓN: Imagen principal con GestureDetector y Hero
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const ImageViewerScreen(
                        imagePath: _ps2AtImagePath,
                        title: _ps2AtTitle,
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: _ps2AtImagePath, // El tag debe ser único
                  child: Image.asset(_ps2AtImagePath, fit: BoxFit.contain),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Descripción General:',
              style: textTheme.headlineSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _ps2AtDescription,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),
            ..._ps2AtDetails.map((section) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section['section_title']!,
                    style: textTheme.titleLarge?.copyWith(
                      color: colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (section.containsKey('description'))
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Text(
                        section['description']!,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  const SizedBox(height: 12),
                  // MODIFICACIÓN: Imagenes de pinout en tablas con GestureDetector y Hero
                  if (section.containsKey('image_pinout') &&
                      section['table_data'] != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (context) => ImageViewerScreen(
                                  imagePath: section['image_pinout']!,
                                  title:
                                      section['section_title']!, // Usa el título de la sección
                                ),
                              ),
                            );
                          },
                          child: Hero(
                            tag:
                                section['image_pinout']!, // Debe ser único por imagen
                            child: Image.asset(
                              section['image_pinout']!,
                              fit: BoxFit.contain,
                              height: 180, // Ajusta la altura
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (section.containsKey('table_data'))
                    _buildTable(
                      section['table_data'] as List<dynamic>,
                      context,
                      hoverColor: hoverColor!,
                    ),
                  if (section.containsKey('list_data'))
                    _buildExpandableList(
                      section['list_data'] as List<Map<String, String>>,
                      context,
                    ),
                  const SizedBox(height: 24),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTable(
    List<dynamic> data,
    BuildContext context, {
    required Color hoverColor,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    final List<DataColumn> columns = [
      const DataColumn(
        label: Text('Pin', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      const DataColumn(
        label: Text('Función', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      const DataColumn(
        label: Text('Tipo', style: TextStyle(fontWeight: FontWeight.bold)),
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
        rows: data
            .map(
              (pinDetail) => DataRow(
                color: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) =>
                      states.contains(WidgetState.hovered) ? hoverColor : null,
                ),
                cells: [
                  DataCell(Text(pinDetail['pin']!)),
                  DataCell(
                    Text(
                      pinDetail['funcion']!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildSignalTypeCell(pinDetail['tipo_senal']!, context),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  DataCell _buildSignalTypeCell(String signalType, BuildContext context) {
    final color = _getColorForSignalType(signalType);
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
          signalType,
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

  Widget _buildExpandableList(
    List<Map<String, String>> data,
    BuildContext context,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final baseColor = colorScheme.surfaceContainerHighest;

    final int convertedAlpha = (baseColor.a * 255.0).round().clamp(0, 255);
    final int convertedRed = (baseColor.r * 255.0).round().clamp(0, 255);
    final int convertedGreen = (baseColor.g * 255.0).round().clamp(0, 255);
    final int convertedBlue = (baseColor.b * 255.0).round().clamp(0, 255);

    return Column(
      children: data.map((item) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6.0),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ExpansionTile(
            title: Text(
              item['title']!,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            childrenPadding: const EdgeInsets.all(16.0),
            collapsedBackgroundColor: Color.fromARGB(
              (convertedAlpha * 0.3).round(),
              convertedRed,
              convertedGreen,
              convertedBlue,
            ),
            backgroundColor: Color.fromARGB(
              (convertedAlpha * 0.5).round(),
              convertedRed,
              convertedGreen,
              convertedBlue,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            children: <Widget>[
              // MODIFICACIÓN: Imágenes dentro de listas expandibles con GestureDetector y Hero
              if (item.containsKey('image_pinout') &&
                  item['image_pinout'] != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) => ImageViewerScreen(
                              imagePath: item['image_pinout']!,
                              title: item['title']!, // Usa el título del ítem
                            ),
                          ),
                        );
                      },
                      child: Hero(
                        tag: item['image_pinout']!, // Debe ser único por imagen
                        child: Image.asset(
                          item['image_pinout']!,
                          fit: BoxFit.contain,
                          height:
                              120, // Altura más pequeña para pinouts dentro de la lista
                        ),
                      ),
                    ),
                  ),
                ),
              Text(
                item['details']!,
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurface,
                  height: 1.5,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
