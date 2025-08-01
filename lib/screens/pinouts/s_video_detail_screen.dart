// lib/screens/pinouts/s_video_detail_screen.dart
import 'package:flutter/material.dart';

const String _sVideoTitle = 'Conector S-Video (Separate Video)';
const String _sVideoImagePath = 'assets/images/pinouts/s_video_connector.png'; // Asume que tienes una imagen genérica
const String _sVideoDescription =
    'S-Video (Separate Video) es un estándar de señal de video analógica que transporta datos de video como dos señales separadas de brillo (luminancia o "Y") y color (crominancia o "C"). Al mantener estas dos señales separadas, S-Video reduce la interferencia en comparación con el video compuesto (que combina todo en una sola señal), ofreciendo una calidad de imagen superior para video de definición estándar. Se utiliza comúnmente en televisores, grabadoras de video, DVD/VCR combinados y algunos equipos informáticos antiguos.';

// Función auxiliar para obtener el objeto Color a partir de un tipo de señal o función.
Color _getColorForSignalType(String type) {
  switch (type.toLowerCase()) {
    case 'luminance (y)':
      return Colors.yellow.shade400; // Brillo (Y)
    case 'chrominance (c)':
      return Colors.red.shade400; // Color (C)
    case 'ground':
      return Colors.grey.shade600; // Tierra
    case 'data (7-pin only)':
      return Colors.purple.shade200; // Datos (solo 7 pines)
    case 'composite (7-pin only)':
      return Colors.blue.shade200; // Compuesto (solo 7 pines)
    case 'no conectado':
    case 'nc':
      return Colors.grey.shade300; // No conectado
    default:
      return Colors.grey.shade100; // Por defecto
  }
}

const List<Map<String, dynamic>> _sVideoDetails = [
  {
    'section_title': 'Conector S-Video (Mini-DIN) y sus Pines',
    'description':
        'Los conectores S-Video más comunes son el de 4 pines y el de 7 pines (Mini-DIN). El de 4 pines es el más extendido, mientras que el de 7 pines añade capacidad para video compuesto y datos.',
    'table_data': [
      {
        'tipo': 'S-Video de 4 Pines (Mini-DIN)',
        'pines': '4',
        'descripcion': 'El conector S-Video más común. Transmite Luminancia (Y) y Crominancia (C) por separado.',
        'imagen_pinout': 'assets/images/pinouts/s_video_4_pin_pinout.png', // Asume imagen específica
        'pin_details': [
          {'pin': '1', 'funcion': 'Ground (Y Return)', 'tipo_senal': 'Ground'},
          {'pin': '2', 'funcion': 'Ground (C Return)', 'tipo_senal': 'Ground'},
          {'pin': '3', 'funcion': 'Y (Luminance / Brightness)', 'tipo_senal': 'Luminance (Y)'},
          {'pin': '4', 'funcion': 'C (Chrominance / Color)', 'tipo_senal': 'Chrominance (C)'},
        ]
      },
      {
        'tipo': 'S-Video de 7 Pines (Mini-DIN)',
        'pines': '7',
        'descripcion': 'Menos común, añade pines para video compuesto, datos, o tierra adicional. No todos los 7 pines se usan siempre.',
        'imagen_pinout': 'assets/images/pinouts/s_video_7_pin_pinout.png', // Asume imagen específica
        'pin_details': [
          {'pin': '1', 'funcion': 'Ground (Y Return)', 'tipo_senal': 'Ground'},
          {'pin': '2', 'funcion': 'Ground (C Return)', 'tipo_senal': 'Ground'},
          {'pin': '3', 'funcion': 'Y (Luminance / Brightness)', 'tipo_senal': 'Luminance (Y)'},
          {'pin': '4', 'funcion': 'C (Chrominance / Color)', 'tipo_senal': 'Chrominance (C)'},
          {'pin': '5', 'funcion': 'Composite Video (Ground for C in 4-pin)', 'tipo_senal': 'Composite (7-pin only)'},
          {'pin': '6', 'funcion': 'Data / Aux Audio / NC', 'tipo_senal': 'Data (7-pin only)'},
          {'pin': '7', 'funcion': 'Composite Video Signal', 'tipo_senal': 'Composite (7-pin only)'},
        ]
      },
    ],
  },
  {
    'section_title': 'Calidad de Video y Limitaciones',
    'description':
        'S-Video fue una mejora sobre el video compuesto, pero aún tiene limitaciones importantes debido a su naturaleza analógica y de definición estándar.',
    'list_data': [
      {
        'title': 'Definición Estándar (SD)',
        'details': 'S-Video está limitado a resoluciones de definición estándar, como 480i (NTSC) o 576i (PAL). No es apto para video de alta definición (HD).'
      },
      {
        'title': 'Sin Audio',
        'details': 'S-Video transmite exclusivamente la señal de video. Para el audio, se requieren cables separados (como RCA estéreo o coaxial/óptico digital).'
      },
      {
        'title': 'Sin Protección de Copia (HDCP)',
        'details': 'Al ser una interfaz analógica antigua, S-Video no soporta HDCP, lo que significa que no puede transportar contenido de alta definición protegido contra copia (ej. Blu-ray).'
      },
      {
        'title': 'Susceptible a Degradación',
        'details': 'Aunque mejor que el video compuesto, la señal S-Video sigue siendo analógica y puede sufrir de ruido, degradación de la señal y "crosstalk" (interferencia entre Y y C) con cables largos o de mala calidad.'
      },
    ],
  },
  {
    'section_title': 'Comparación con Otras Interfaces Analógicas',
    'description':
        'S-Video ocupa un lugar intermedio en la calidad del video analógico, ofreciendo una mejora sobre el compuesto y siendo superado por el componente.',
    'list_data': [
      {
        'title': 'vs. Video Compuesto (RCA Amarillo)',
        'details':
            '**Video Compuesto:** Combina Luminancia (Y), Crominancia (C) y sincronización en una sola señal y un solo cable. Esto provoca que las señales se "mezclen" y se generen artefactos de color (color bleeding) y menos nitidez.\n**S-Video:** Separa Y y C en dos cables o dos pares de hilos. Esto reduce significativamente el "crosstalk" y la borrosidad, resultando en una imagen más nítida y con colores más puros, aunque ambos son SD.'
      },
      {
        'title': 'vs. Video por Componentes (YPbPr)',
        'details':
            '**Video por Componentes:** Separa la señal de video en tres componentes analógicas: Luminancia (Y) y dos señales de diferencia de color (Pb y Pr). Esta separación completa minimiza aún más la interferencia y permite la transmisión de video de alta definición (720p, 1080i) de forma analógica. Es superior a S-Video y Compuesto en calidad y capacidad de resolución.'
      },
    ],
  },
  {
    'section_title': 'Problemas Comunes y Solución de Problemas',
    'description':
        'Aquí algunas soluciones para problemas típicos con el conector S-Video:',
    'list_data': [
      {
        'title': 'Imagen en blanco y negro (sin color)',
        'details':
            '**Síntomas:** La imagen se ve, pero solo en escala de grises.\n**Solución:**\n1.  **Conexión defectuosa:** El cable o el puerto S-Video tienen una conexión floja o dañada en el canal de Crominancia (C). Asegúrate de que el cable esté bien insertado. Revisa si hay pines doblados o rotos.\n2.  **Cable incorrecto:** Asegúrate de que estás usando un cable S-Video real y no un cable compuesto conectado a un puerto S-Video o un adaptador defectuoso.\n3.  **Configuración del dispositivo:** Algunos dispositivos pueden tener una opción en el menú para seleccionar la salida de video (Composite vs. S-Video). Asegúrate de que S-Video esté seleccionado.'
      },
      {
        'title': 'No hay señal o imagen distorsionada',
        'details':
            '**Síntomas:** Pantalla negra, "No Input", o imagen con muchas interferencias.\n**Solución:**\n1.  **Conexión segura:** Asegurarse de que el cable esté firmemente conectado en ambos extremos. Los conectores mini-DIN pueden ser un poco difíciles de alinear.\n2.  **Entrada correcta:** Verificar que el televisor/monitor esté en la entrada S-Video correcta (a menudo etiquetada como "S-Video" o "Y/C").\n3.  **Cable dañado:** Probar con otro cable S-Video. La calidad del cable es importante para evitar el ruido.\n4.  **Adaptadores:** Si usas un adaptador (ej. S-Video a RCA Compuesto), asegúrate de que funcione correctamente. Los adaptadores pasivos pueden introducir pérdidas o problemas de calidad.'
      },
      {
        'title': 'Imagen borrosa o poco nítida',
        'details':
            '**Síntomas:** La imagen se ve suave, no tiene la nitidez esperada para S-Video.\n**Solución:**\n1.  **Calidad del cable:** Utiliza un cable S-Video de buena calidad y de la menor longitud posible.\n2.  **Fuente de video:** La calidad de la señal S-Video de la fuente (DVD, VCR, consola) también influye. Las grabaciones antiguas de VCR pueden tener una calidad inherente baja.\n3.  **Interferencia:** Aleja el cable S-Video de cables de alimentación u otras fuentes de interferencia electromagnética.'
      },
    ],
  },
];

class SVideoDetailScreen extends StatelessWidget {
  const SVideoDetailScreen({super.key});

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
        title: const Text(_sVideoTitle),
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
              child: Image.asset(_sVideoImagePath, fit: BoxFit.contain),
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
              _sVideoDescription,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),
            ..._sVideoDetails.map((section) {
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
                  if (section.containsKey('table_data'))
                    _buildTable(
                      section['table_data'] as List<dynamic>,
                      section['section_title']!,
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
    String sectionTitle,
    BuildContext context, {
    required Color hoverColor,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: data.map((item) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tipo: ${item['tipo']}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                ),
                Text(
                  'Pines: ${item['pines']}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                ),
                Text(
                  'Descripción: ${item['descripcion']}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                ),
                if (item.containsKey('imagen_pinout'))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: Image.asset(
                        item['imagen_pinout']!,
                        fit: BoxFit.contain,
                        height: 150, // Altura fija para las imágenes de pinout
                      ),
                    ),
                  ),
                if (item.containsKey('pin_details'))
                  ExpansionTile(
                    title: Text(
                      'Detalles de Pines (${item['tipo']})',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.secondary,
                          ),
                    ),
                    children: [
                      DataTable(
                        columnSpacing: 10,
                        dataRowMinHeight: 30,
                        dataRowMaxHeight: 50,
                        headingRowColor: WidgetStateProperty.all(colorScheme.tertiaryContainer),
                        border: TableBorder.all(
                          color: colorScheme.outlineVariant,
                          width: 0.5,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        columns: const [
                          DataColumn(label: Text('Pin', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Función', style: TextStyle(fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Tipo', style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                        rows: (item['pin_details'] as List<dynamic>)
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
                    ],
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // Método para construir la celda de tipo de señal con color de fondo
  DataCell _buildSignalTypeCell(String signalType, BuildContext context) {
    final color = _getColorForSignalType(signalType);
    final textColor = color.computeLuminance() > 0.5 ? Colors.black : Colors.white;

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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            children: <Widget>[
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