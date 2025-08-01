// lib/screens/pinouts/scart_detail_screen.dart
import 'package:flutter/material.dart';

const String _scartTitle = 'Conector SCART (Euroconector)';
const String _scartImagePath =
    'assets/images/pinouts/scart_connector.png'; // Asume que tienes una imagen SCART
const String _scartDescription =
    'El conector SCART (Syndicat des Constructeurs d\'Appareils Radiorécepteurs et Téléviseurs), también conocido como Euroconector, es un estándar de conector y protocolo de señales analógicas de 21 pines que fue ampliamente utilizado en Europa para conectar equipos de audio y vídeo, como televisores, reproductores de VCR, reproductores de DVD y consolas de videojuegos. Aunque ha sido en gran medida reemplazado por estándares digitales como HDMI, SCART fue innovador al permitir múltiples tipos de señales (compuesto, S-Video, RGB e incluso audio estéreo) a través de un solo cable, eliminando la necesidad de múltiples cables de conexión.';

// Función auxiliar para obtener el objeto Color a partir de un tipo de señal o función.
Color _getColorForSignalType(String type) {
  switch (type.toLowerCase()) {
    case 'video in':
    case 'video out':
    case 'video rgb':
      return Colors.blue.shade200; // Señales de video
    case 'audio in':
    case 'audio out':
      return Colors.green.shade200; // Señales de audio
    case 'data/control':
      return Colors.orange.shade200; // Señales de control/datos
    case 'ground':
      return Colors.grey.shade600; // Tierra
    case 'power':
      return Colors.red.shade200; // Alimentación
    case 'switch':
      return Colors.purple.shade200; // Señales de conmutación
    case 'no conectado':
    case 'nc':
      return Colors.grey.shade300; // No conectado
    default:
      return Colors.grey.shade100; // Por defecto
  }
}

const List<Map<String, dynamic>> _scartDetails = [
  {
    'section_title': 'Pinout del Conector SCART (21 pines)',
    'description':
        'El conector SCART de 21 pines permite la transmisión de audio (estéreo), vídeo compuesto, S-Video y RGB, además de señales de control. A continuación, se detalla la función de cada pin:',
    'table_data': [
      {'pin': '1', 'funcion': 'Audio OUT (Right)', 'tipo_senal': 'Audio Out'},
      {'pin': '2', 'funcion': 'Audio IN (Right)', 'tipo_senal': 'Audio In'},
      {
        'pin': '3',
        'funcion': 'Audio OUT (Left/Mono)',
        'tipo_senal': 'Audio Out',
      },
      {'pin': '4', 'funcion': 'Audio GND', 'tipo_senal': 'Ground'},
      {'pin': '5', 'funcion': 'RGB Blue GND', 'tipo_senal': 'Ground'},
      {'pin': '6', 'funcion': 'Audio IN (Left/Mono)', 'tipo_senal': 'Audio In'},
      {'pin': '7', 'funcion': 'RGB Blue IN/OUT', 'tipo_senal': 'Video RGB'},
      {
        'pin': '8',
        'funcion': 'Conmutación Rango de Entrada/Salida (Auto Switch)',
        'tipo_senal': 'Switch',
      },
      {'pin': '9', 'funcion': 'RGB Green GND', 'tipo_senal': 'Ground'},
      {
        'pin': '10',
        'funcion': 'Datos D2B (Clock)',
        'tipo_senal': 'Data/Control',
      },
      {'pin': '11', 'funcion': 'RGB Green IN/OUT', 'tipo_senal': 'Video RGB'},
      {
        'pin': '12',
        'funcion': 'Datos D2B (Data)',
        'tipo_senal': 'Data/Control',
      },
      {'pin': '13', 'funcion': 'RGB Red GND', 'tipo_senal': 'Ground'},
      {'pin': '14', 'funcion': 'Datos D2B (GND)', 'tipo_senal': 'Ground'},
      {
        'pin': '15',
        'funcion': 'RGB Red IN/OUT / Chrominance (S-Video)',
        'tipo_senal': 'Video RGB',
      },
      {
        'pin': '16',
        'funcion': 'Conmutación Rápida (RGB/Video Compuesto)',
        'tipo_senal': 'Switch',
      },
      {
        'pin': '17',
        'funcion': 'Video Compuesto/Luminance (S-Video) GND',
        'tipo_senal': 'Ground',
      },
      {
        'pin': '18',
        'funcion': 'Conmutación Rápida GND',
        'tipo_senal': 'Ground',
      },
      {
        'pin': '19',
        'funcion': 'Video Compuesto OUT / Luminance (S-Video) OUT',
        'tipo_senal': 'Video Out',
      },
      {
        'pin': '20',
        'funcion': 'Video Compuesto IN / Luminance (S-Video) IN',
        'tipo_senal': 'Video In',
      },
      {
        'pin': '21',
        'funcion': 'Chasis GND / Apantallamiento',
        'tipo_senal': 'Ground',
      },
    ],
  },
  {
    'section_title': 'Modos de Señal y Capacidad',
    'description':
        'SCART puede transmitir diferentes tipos de señales de vídeo, lo que lo hizo muy versátil en su momento:',
    'list_data': [
      {
        'title': 'Vídeo Compuesto (CVBS)',
        'details':
            'El modo más básico, donde la luminancia (brillo) y la crominancia (color) se combinan en una sola señal. Es el modo por defecto si no se activan otras señales de control. Ofrece la menor calidad de imagen.',
      },
      {
        'title': 'S-Video (Y/C)',
        'details':
            'Separa la luminancia (Y) de la crominancia (C), resultando en una mejor calidad de imagen que el vídeo compuesto, con menos artefactos de color. Requiere que el dispositivo fuente y el receptor soporten S-Video a través de SCART.',
      },
      {
        'title': 'RGB (Red, Green, Blue)',
        'details':
            'Transmite las señales de color primarias (R, G, B) de forma separada, además de una señal de sincronización. Este modo ofrece la mejor calidad de imagen que SCART puede proporcionar, superior a compuesto y S-Video, ideal para consolas de videojuegos y DVD de alta calidad.',
      },
      {
        'title': 'Audio Estéreo',
        'details':
            'Capaz de transmitir audio estéreo de alta fidelidad, con canales izquierdo y derecho separados.',
      },
      {
        'title': 'Señales de Control',
        'details':
            'SCART incluye pines para control automático, como la conmutación automática a la entrada SCART cuando un dispositivo se enciende, o la selección automática del modo de vídeo (compuesto/RGB).',
      },
    ],
  },
  {
    'section_title': 'Usos Comunes y Legado',
    'description':
        'Aunque el uso de SCART ha disminuido, fue un estándar fundamental durante décadas:',
    'list_data': [
      {
        'title': 'Televisores Antiguos',
        'details':
            'Prácticamente todos los televisores CRT (de tubo) y muchos de los primeros televisores de pantalla plana en Europa tenían al menos una entrada SCART.',
      },
      {
        'title': 'Reproductores de Video (VCR, DVD)',
        'details':
            'El principal método de conexión para videocasetes y reproductores de DVD antes de la popularización del HDMI.',
      },
      {
        'title': 'Consolas de Videojuegos',
        'details':
            'Muchas consolas de las generaciones de los 90 y principios de los 2000 (ej. Super Nintendo, PlayStation, Sega Saturn, Dreamcast, PlayStation 2, GameCube, Xbox) utilizaban SCART para la salida de vídeo, a menudo con cables RGB SCART para la mejor calidad posible.',
      },
      {
        'title': 'Decodificadores de TV y Receptores Satelitales',
        'details':
            'Comúnmente usados para conectar estos dispositivos a los televisores.',
      },
      {
        'title': 'Adaptadores (SCART a HDMI/RCA)',
        'details':
            'Todavía se usan adaptadores para conectar dispositivos SCART antiguos a televisores modernos con HDMI, o viceversa, aunque con la inevitable pérdida de calidad de analógico a digital.',
      },
    ],
  },
  {
    'section_title': 'Problemas Comunes y Solución de Problemas',
    'description':
        'Aunque simple en su concepto, SCART podía presentar algunos problemas. Aquí algunas soluciones:',
    'list_data': [
      {
        'title': 'Sin Imagen o Imagen Distorsionada',
        'details':
            '**Síntomas:** Pantalla negra, imagen con ruido, colores incorrectos o parpadeos.\n**Solución:**\n1.  **Conexión floja:** Asegurarse de que el conector SCART esté firmemente insertado en ambos extremos. El conector es conocido por aflojarse fácilmente.\n2.  **Cable defectuoso:** Probar con otro cable SCART si es posible. Los cables SCART de baja calidad o dañados son una causa común de problemas.\n3.  **Configuración de entrada:** Asegurarse de que el televisor esté en la entrada AV/SCART correcta (a menudo etiquetada como AV1, AV2, Euro AV, etc.).\n4.  **Modo de vídeo incorrecto:** Algunos dispositivos pueden tener configuraciones de salida de vídeo (compuesto, S-Video, RGB) que deben coincidir con la entrada del televisor. Intentar cambiar la configuración en el dispositivo fuente.',
      },
      {
        'title': 'Sin Sonido o Sonido Distorsionado',
        'details':
            '**Síntomas:** Silencio, zumbido, crujido o sonido intermitente.\n**Solución:**\n1.  **Conexión de audio:** Verificar que los pines de audio no estén dañados o que el cable no esté doblado cerca del conector.\n2.  **Volumen/Mute:** Asegurarse de que el volumen del televisor o dispositivo fuente no esté en silencio o muy bajo.\n3.  **Conflicto de señal:** A veces, las señales de vídeo pueden interferir con el audio si el cable es de mala calidad o está mal apantallado.',
      },
      {
        'title': 'Conexión Inestable (imagen va y viene)',
        'details':
            '**Síntomas:** La imagen o el sonido se cortan intermitentemente.\n**Solución:**\n1.  **Conector sucio/oxidado:** Limpiar suavemente los pines del conector SCART con alcohol isopropílico y un hisopo de algodón. La oxidación es común en conectores antiguos.\n2.  **Cable de mala calidad:** Un cable con un apantallamiento deficiente o soldaduras internas deficientes puede ser la causa. Reemplazar por un cable de mejor calidad.\n3.  **Interferencia:** Mantener el cable SCART alejado de cables de alimentación o dispositivos que emitan mucha interferencia electromagnética.',
      },
    ],
  },
];

class ScartDetailScreen extends StatelessWidget {
  const ScartDetailScreen({super.key});

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
        title: const Text(_scartTitle),
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
              child: Image.asset(_scartImagePath, fit: BoxFit.contain),
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
              _scartDescription,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),
            ..._scartDetails.map((section) {
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

    return DataTable(
      columnSpacing: 16,
      dataRowMinHeight: 40,
      dataRowMaxHeight: 60,
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      headingRowColor: WidgetStateProperty.all(colorScheme.primaryContainer),
      border: TableBorder.all(
        color: colorScheme.outlineVariant,
        width: 1,
        borderRadius: BorderRadius.circular(8),
      ),
      columns: _buildColumns(sectionTitle),
      rows: data
          .map(
            (item) => DataRow(
              color: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) =>
                    states.contains(WidgetState.hovered) ? hoverColor : null,
              ),
              cells: _buildCells(item, sectionTitle, context),
            ),
          )
          .toList(),
    );
  }

  List<DataColumn> _buildColumns(String sectionTitle) {
    if (sectionTitle.contains('Pinout')) {
      return const [
        DataColumn(
          label: Expanded(
            child: Text('Pin', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Función',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Tipo de Señal',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ];
    }
    return [];
  }

  List<DataCell> _buildCells(
    dynamic item,
    String sectionTitle,
    BuildContext context,
  ) {
    if (sectionTitle.contains('Pinout')) {
      return [
        DataCell(Text(item['pin']!)),
        DataCell(
          Text(item['funcion']!, maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
        _buildSignalTypeCell(item['tipo_senal']!, context),
      ];
    }
    return [];
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

    // Usar las propiedades 'a', 'r', 'g', 'b' (normalizadas de 0.0 a 1.0) y convertirlas a int (0-255)
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
