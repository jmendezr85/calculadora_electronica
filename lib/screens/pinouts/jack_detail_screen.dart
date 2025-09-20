// lib/screens/pinouts/jack_detail_screen.dart
import 'package:calculadora_electronica/screens/image_viewer_screen.dart'; // ¡NUEVO! Importa la pantalla de visualización de imagen
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
    case 'control / gnd':
      return Colors.brown.shade400; // Control o Tierra
    default:
      return Colors.grey.shade100; // Por defecto
  }
}

const List<Map<String, dynamic>> _jackDetails = [
  {
    'section_title': 'Tipos de Conectores Jack (TS, TRS, TRRS)',
    'description':
        'Los conectores Jack se distinguen por el número de "segmentos" o contactos, que determinan el tipo y número de señales que pueden transmitir. Los más comunes son TS, TRS y TRRS:',
    'table_data': [
      {
        'tipo': 'TS (Tip-Sleeve)',
        'contactos': '2',
        'funcion': 'Audio mono no balanceado, señal de instrumento.',
        'imagen_pinout': 'assets/images/pinouts/jack_ts_pinout.png',
        'pin_details': [
          {
            'parte': 'Tip',
            'funcion': 'Señal (Caliente / +)',
            'tipo_senal': 'Left Audio',
          },
          {
            'parte': 'Sleeve',
            'funcion': 'Tierra / Masa',
            'tipo_senal': 'Ground',
          },
        ],
      },
      {
        'tipo': 'TRS (Tip-Ring-Sleeve)',
        'contactos': '3',
        'funcion':
            'Audio estéreo (izquierda/derecha y tierra), audio mono balanceado.',
        'imagen_pinout': 'assets/images/pinouts/jack_trs_pinout.png',
        'pin_details': [
          {
            'parte': 'Tip',
            'funcion': 'Audio Izquierdo',
            'tipo_senal': 'Left Audio',
          },
          {
            'parte': 'Ring',
            'funcion': 'Audio Derecho',
            'tipo_senal': 'Right Audio',
          },
          {
            'parte': 'Sleeve',
            'funcion': 'Tierra / Masa',
            'tipo_senal': 'Ground',
          },
        ],
      },
      {
        'tipo': 'TRRS (Tip-Ring-Ring-Sleeve)',
        'contactos': '4',
        'funcion':
            'Audio estéreo + micrófono, o audio estéreo + video (obsoleto). Utilizado comúnmente en smartphones.',
        'imagen_pinout': 'assets/images/pinouts/jack_trrs_pinout_generic.png',
        'pin_details': [
          // Se explica la diferencia en la sección de estándares
          {
            'parte': 'Tip',
            'funcion': 'Audio Izquierdo',
            'tipo_senal': 'Left Audio',
          },
          {
            'parte': 'Ring1',
            'funcion': 'Audio Derecho',
            'tipo_senal': 'Right Audio',
          },
          {
            'parte': 'Ring2',
            'funcion': 'Micrófono / Tierra (Varía)',
            'tipo_senal': 'Microphone',
          },
          {
            'parte': 'Sleeve',
            'funcion': 'Tierra / Micrófono (Varía)',
            'tipo_senal': 'Ground',
          },
        ],
      },
    ],
  },
  {
    'section_title': 'Estándares TRRS (CTIA vs. OMTP)',
    'description':
        'Para los conectores TRRS, existen dos estándares de pinout principales, lo que puede causar incompatibilidades entre auriculares con micrófono y dispositivos. La diferencia radica en la posición del micrófono y la tierra (Ground):',
    'list_data': [
      {
        'title': 'CTIA (Cellular Telecommunications Industry Association)',
        'details':
            '**El estándar más común y moderno, usado por Apple, Samsung (la mayoría), Google, Xbox, y la mayoría de PCs y laptops recientes.**\n* **Tip:** Audio Izquierdo\n* **Ring1:** Audio Derecho\n* **Ring2:** Tierra (Ground)\n* **Sleeve:** Micrófono\nSi tus auriculares son CTIA y tu dispositivo es OMTP, el micrófono no funcionará o el sonido será intermitente. Necesitarías un adaptador.',
        'image_pinout': 'assets/images/pinouts/trrs_ctia.png',
      },
      {
        'title': 'OMTP (Open Mobile Terminal Platform)',
        'details':
            '**Un estándar más antiguo, usado por algunos dispositivos Android más viejos, Nokia (antes de Microsoft), y algunos dispositivos de origen chino.**\n* **Tip:** Audio Izquierdo\n* **Ring1:** Audio Derecho\n* **Ring2:** Micrófono\n* **Sleeve:** Tierra (Ground)\nSi tus auriculares son OMTP y tu dispositivo es CTIA, el micrófono no funcionará. Necesitarías un adaptador.',
        'image_pinout': 'assets/images/pinouts/trrs_omtp.png',
      },
    ],
  },
  {
    'section_title': 'Tamaños Comunes de Jack',
    'description':
        'Aunque el pinout es el mismo para un tipo dado, los conectores Jack vienen en varios tamaños físicos:',
    'list_data': [
      {
        'title': '3.5mm (1/8 de pulgada o Mini-Jack)',
        'details':
            'El tamaño más extendido. Utilizado en la mayoría de smartphones, tablets, ordenadores portátiles, auriculares, reproductores de MP3 y sistemas de audio de consumo.',
      },
      {
        'title': '6.35mm (1/4 de pulgada o Jack Estándar)',
        'details':
            'Comúnmente usado en equipos de audio profesional y semiprofesional como guitarras eléctricas, amplificadores, mezcladores, interfaces de audio y auriculares de estudio.',
      },
      {
        'title': '2.5mm (3/32 de pulgada o Micro-Jack)',
        'details':
            'Un tamaño más pequeño, menos común hoy en día. Se encontraba en algunos teléfonos móviles antiguos, radios bidireccionales y dispositivos pequeños.',
      },
    ],
  },
  {
    'section_title': 'Problemas Comunes y Solución de Problemas',
    'description':
        'Los problemas con los conectores Jack suelen estar relacionados con la conexión física o la compatibilidad de estándares. Aquí hay algunas soluciones:',
    'list_data': [
      {
        'title': 'Sonido solo en un canal (un auricular)',
        'details':
            '**Síntomas:** Audio solo sale por el auricular izquierdo o derecho.\n**Solución:**\n1.  **Inserción completa:** Asegurarse de que el conector Jack esté completamente insertado en el puerto del dispositivo. A veces, un empuje adicional lo soluciona.\n2.  **Cable dañado:** El cable de los auriculares podría estar dañado internamente (un cable de audio roto). Probar con otros auriculares o un cable diferente.\n3.  **Puerto sucio/dañado:** Inspeccionar el puerto de audio del dispositivo en busca de suciedad, pelusa o daños. Un palillo de dientes o aire comprimido pueden ayudar a limpiarlo.',
      },
      {
        'title': 'Micrófono no funciona (auriculares TRRS)',
        'details':
            '**Síntomas:** El audio de los auriculares funciona, pero el micrófono no detecta voz.\n**Solución:**\n1.  **Incompatibilidad TRRS:** La razón más común es la incompatibilidad entre los estándares CTIA y OMTP. Si el dispositivo y los auriculares usan estándares diferentes, el micrófono no funcionará. Un adaptador TRRS inversor (CTIA a OMTP o viceversa) es la solución.\n2.  **Configuración de entrada:** En la configuración de sonido de tu PC o smartphone, asegúrate de que el micrófono de los auriculares esté seleccionado como dispositivo de entrada predeterminado.\n3.  **Micrófono silenciado/dañado:** Asegúrate de que el micrófono no esté silenciado y que no esté físicamente dañado.',
      },
      {
        'title': 'Sonido distorsionado o con ruido',
        'details':
            '**Síntomas:** El audio suena entrecortado, con estática o zumbido.\n**Solución:**\n1.  **Conexión suelta:** Volver a conectar el Jack firmemente.\n2.  **Interferencia:** Alejar el dispositivo o los cables de fuentes de interferencia electromagnética (altavoces sin blindaje, cables de alimentación).\n3.  **Calidad del cable:** Un cable de baja calidad o muy largo puede introducir ruido. Probar con un cable más corto o de mejor blindaje.\n4.  **Configuración de volumen:** Asegurarse de que el volumen no esté demasiado alto, causando distorsión.',
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
            // MODIFICACIÓN: Imagen principal con GestureDetector y Hero
            Hero(
              tag: _jackImagePath, // El tag debe ser único
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const ImageViewerScreen(
                        imagePath: _jackImagePath,
                        title:
                            _jackTitle, // Pasa el título para la pantalla de zoom
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
                  child: Image.asset(_jackImagePath, fit: BoxFit.contain),
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
                  'Contactos: ${item['contactos']}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
                ),
                Text(
                  'Función: ${item['funcion']}',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
                ),
                if (item.containsKey('imagen_pinout'))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      // MODIFICACIÓN: Imagen de pinout dentro de la tabla con GestureDetector y Hero
                      child: Hero(
                        tag: item['imagen_pinout']!, // El tag debe ser único
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (context) => ImageViewerScreen(
                                  imagePath: item['imagen_pinout']!,
                                  title:
                                      item['tipo']!, // Usa el tipo como título
                                ),
                              ),
                            );
                          },
                          child: Image.asset(
                            item['imagen_pinout']!,
                            fit: BoxFit.contain,
                            height:
                                150, // Altura fija para las imágenes de pinout
                          ),
                        ),
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
                              'Parte',
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
                              'Tipo Señal',
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
                                  DataCell(Text(pinDetail['parte']!)),
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
              // MODIFICACIÓN: Imagen de pinout dentro de la lista con GestureDetector y Hero
              if (item.containsKey('image_pinout') &&
                  item['image_pinout'] != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Center(
                    child: Hero(
                      tag: item['image_pinout']!, // El tag debe ser único
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (context) => ImageViewerScreen(
                                imagePath: item['image_pinout']!,
                                title:
                                    item['title']!, // Usa el título del elemento de la lista
                              ),
                            ),
                          );
                        },
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
