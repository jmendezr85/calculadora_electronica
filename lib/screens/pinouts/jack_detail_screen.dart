// lib/screens/pinouts/jack_detail_screen.dart
import 'package:flutter/material.dart';

const String _jackTitle = 'Conector Jack (Audio, TRRS, TRS, TS)';
const String _jackImagePath =
    'assets/images/pinouts/jack_connector.png'; // Asume que tienes una imagen genérica
const String _jackDescription =
    'El conector Jack (también conocido como conector telefónico, conector de audio, conector de auriculares o conector estéreo) es un conector eléctrico cilíndrico de uso común para señales de audio analógicas. Existen en varios tamaños, siendo los más comunes 2.5mm, 3.5mm (el más extendido) y 6.35mm (1/4 de pulgada). Su diseño permite múltiples contactos que corresponden a diferentes canales de audio o funciones, como estéreo, micrófono o control remoto.';

// Función auxiliar para obtener el objeto Color a partir de un tipo de señal o función.
Color _getColorForSignalType(String type) {
  switch (type.toLowerCase()) {
    case 'left audio':
      return Colors.blue.shade400; // Audio Izquierdo
    case 'right audio':
      return Colors.red.shade400; // Audio Derecho
    case 'microphone':
      return Colors.green.shade400; // Micrófono
    case 'video':
      return Colors.purple.shade200; // Video (obsoleto en jacks)
    case 'ground':
      return Colors.grey.shade600; // Tierra
    case 'signal (mono)':
      return Colors.orange.shade400; // Señal (Mono)
    case 'no conectado':
    case 'nc':
      return Colors.grey.shade300; // No conectado
    default:
      return Colors.grey.shade100; // Por defecto
  }
}

const List<Map<String, dynamic>> _jackDetails = [
  {
    'section_title': 'Tipos de Conectores Jack y sus Pines',
    'description':
        'Los conectores Jack se diferencian por su diámetro y por el número de "contactos" o "segmentos" que poseen: Tip (Punta), Ring (Anillo/s) y Sleeve (Manga).',
    'table_data': [
      {
        'tipo': 'TS (Tip-Sleeve) - Mono',
        'pines': '2',
        'descripcion':
            'Para audio mono no balanceado, o señales de control/instrumento (ej. guitarras).',
        'imagen_pinout':
            'assets/images/pinouts/jack_ts_pinout.png', // Asume imagen específica
        'pin_details': [
          {
            'pin': 'Tip',
            'funcion': 'Signal (Mono Audio / Positive)',
            'tipo_senal': 'Signal (Mono)',
          },
          {
            'pin': 'Sleeve',
            'funcion': 'Ground (Tierra)',
            'tipo_senal': 'Ground',
          },
        ],
      },
      {
        'tipo': 'TRS (Tip-Ring-Sleeve) - Estéreo o Balanceado',
        'pines': '3',
        'descripcion':
            'Para audio estéreo (izquierda, derecha, tierra) o audio mono balanceado.',
        'imagen_pinout':
            'assets/images/pinouts/jack_trs_pinout.png', // Asume imagen específica
        'pin_details': [
          {
            'pin': 'Tip',
            'funcion': 'Left Audio / Positive',
            'tipo_senal': 'Left Audio',
          },
          {
            'pin': 'Ring',
            'funcion': 'Right Audio / Negative',
            'tipo_senal': 'Right Audio',
          },
          {
            'pin': 'Sleeve',
            'funcion': 'Ground (Tierra)',
            'tipo_senal': 'Ground',
          },
        ],
      },
      {
        'tipo': 'TRRS (Tip-Ring-Ring-Sleeve) - Estéreo + Mic / Video',
        'pines': '4',
        'descripcion':
            'Para audio estéreo y micrófono, o audio estéreo y video (en dispositivos más antiguos). Existen dos estándares principales.',
        'imagen_pinout':
            'assets/images/pinouts/jack_trrs_pinout_generic.png', // Asume imagen genérica para TRRS
        'pin_details': [
          {'pin': 'Tip', 'funcion': 'Left Audio', 'tipo_senal': 'Left Audio'},
          {
            'pin': 'Ring1',
            'funcion': 'Right Audio',
            'tipo_senal': 'Right Audio',
          },
          {
            'pin': 'Ring2',
            'funcion': 'Microphone o Video',
            'tipo_senal': 'Microphone',
          }, // Se detalla más adelante
          {
            'pin': 'Sleeve',
            'funcion': 'Ground (Tierra)',
            'tipo_senal': 'Ground',
          },
        ],
      },
    ],
  },
  {
    'section_title': 'Estándares TRRS (CTIA vs. OMTP) y Compatibilidad',
    'description':
        'Para los conectores TRRS (4-contactos), la ubicación de los pines del micrófono y la tierra varía entre dos estándares principales, lo que puede causar problemas de compatibilidad.',
    'list_data': [
      {
        'title':
            'Estándar CTIA / AHJ (Apple, Samsung, la mayoría de Android modernos)',
        'details':
            '**Pinout:**\n* **Tip:** Audio Izquierdo\n* **Ring1:** Audio Derecho\n* **Ring2:** Tierra (Ground)\n* **Sleeve:** Micrófono / Control\n\nEste es el estándar más extendido en auriculares con micrófono para smartphones y tabletas modernas.',
      },
      {
        'title': 'Estándar OMTP (Nokia, Sony Ericsson, LG antiguos)',
        'details':
            '**Pinout:**\n* **Tip:** Audio Izquierdo\n* **Ring1:** Audio Derecho\n* **Ring2:** Micrófono / Control\n* **Sleeve:** Tierra (Ground)\n\nEste estándar es menos común hoy en día, pero aún se encuentra en algunos dispositivos antiguos. Un auricular OMTP en un dispositivo CTIA (o viceversa) resultará en audio, pero el micrófono y los controles pueden no funcionar.',
      },
      {
        'title': 'Problemas de Compatibilidad Comunes',
        'details':
            'Si un micrófono no funciona o se escucha un zumbido al conectar unos auriculares con micrófono, es probable que se deba a una incompatibilidad entre el estándar CTIA y OMTP. Algunos adaptadores (TRRS a TRRS) están disponibles para solucionar este problema invirtiendo los pines de tierra y micrófono.',
      },
    ],
  },
  {
    'section_title': 'Usos Comunes y Aplicaciones',
    'description':
        'Los conectores Jack son increíblemente versátiles y se encuentran en una vasta gama de dispositivos de audio.',
    'list_data': [
      {
        'title': 'Auriculares y Cascos',
        'details':
            'La aplicación más común, desde audífonos simples (TRS) hasta auriculares con micrófono y controles para smartphones (TRRS).',
      },
      {
        'title': 'Entrada/Salida de Audio (Auxiliar)',
        'details':
            'Para conectar reproductores de música, teléfonos o tablets a sistemas de sonido, radios de coche, etc.',
      },
      {
        'title': 'Micrófonos',
        'details':
            'Muchos micrófonos utilizan conectores Jack (generalmente TS o TRS para micrófonos balanceados/estéreo).',
      },
      {
        'title': 'Instrumentos Musicales',
        'details':
            'Las guitarras eléctricas y otros instrumentos usan conectores TS de 6.35mm (1/4 pulgada). También se usan para equipos de sonido profesional.',
      },
      {
        'title': 'Control Remoto / Datos',
        'details':
            'En algunos equipos (ej. cámaras, proyectores), los jacks pueden llevar señales de control o datos bidireccionales.',
      },
    ],
  },
  {
    'section_title': 'Problemas Comunes y Solución de Problemas',
    'description':
        'Aquí algunas soluciones para problemas típicos con los conectores Jack:',
    'list_data': [
      {
        'title': 'Sonido solo en un lado (mono o canal izquierdo/derecho)',
        'details':
            '**Síntomas:** Audio solo por un auricular o canal.\n**Solución:**\n1.  **Enchufe flojo:** Asegúrate de que el conector Jack esté completamente insertado en el puerto. A veces, unos milímetros pueden hacer la diferencia.\n2.  **Cable dañado:** El cable interno puede estar roto en uno de los canales. Prueba con otro cable/auricular.\n3.  **Configuración de audio:** Verifica la configuración de audio en el dispositivo (balance de canales).\n4.  **Suciedad/Obstrucción:** Limpia el puerto Jack del dispositivo con aire comprimido o un hisopo de algodón seco (con cuidado).',
      },
      {
        'title': 'Sonido distorsionado o con ruido',
        'details':
            '**Síntomas:** Zumbidos, estática, audio "metálico" o intermitente.\n**Solución:**\n1.  **Conexión floja:** Vuelve a insertar el Jack.\n2.  **Cable/Conector sucio:** La suciedad en los contactos puede causar mala conexión. Limpia el conector del cable y el puerto.\n3.  **Cable dañado:** Especialmente si el cable se ha doblado o pisado con frecuencia.\n4.  **Interferencia:** Aleja el cable de fuentes de interferencia electromagnética (cables de alimentación, routers).',
      },
      {
        'title': 'Micrófono no funciona (en TRRS)',
        'details':
            '**Síntomas:** El audio funciona, pero el micrófono no detecta sonido.\n**Solución:**\n1.  **Compatibilidad CTIA/OMTP:** Este es el problema más común. Si tu dispositivo y tus auriculares usan estándares diferentes, el micrófono no funcionará. Busca un adaptador TRRS a TRRS que invierta los pines de tierra y micrófono.\n2.  **Configuración del sistema:** Verifica que el micrófono correcto esté seleccionado como dispositivo de entrada en la configuración de sonido de tu PC/smartphone.\n3.  **Botón de mute:** Algunos auriculares tienen un botón de silencio para el micrófono. Asegúrate de que no esté activado.\n4.  **Micrófono dañado:** Prueba los auriculares con otro dispositivo para descartar un fallo del micrófono.',
      },
    ],
  },
];

class JackDetailScreen extends StatelessWidget {
  const JackDetailScreen({super.key});

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
        title: const Text(_jackTitle),
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
              child: Image.asset(_jackImagePath, fit: BoxFit.contain),
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
              _jackDescription,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),
            ..._jackDetails.map((section) {
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
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
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
                ),
                Text(
                  'Descripción: ${item['descripcion']}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
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
                        headingRowColor: WidgetStateProperty.all(
                          colorScheme.tertiaryContainer,
                        ),
                        border: TableBorder.all(
                          color: colorScheme.outlineVariant,
                          width: 0.5,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        columns: const [
                          DataColumn(
                            label: Text(
                              'Contacto',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Función',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Tipo',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                        rows: (item['pin_details'] as List<dynamic>)
                            .map(
                              (pinDetail) => DataRow(
                                color: WidgetStateProperty.resolveWith<Color?>(
                                  (Set<WidgetState> states) =>
                                      states.contains(WidgetState.hovered)
                                      ? hoverColor
                                      : null,
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
                                  _buildSignalTypeCell(
                                    pinDetail['tipo_senal']!,
                                    context,
                                  ),
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
