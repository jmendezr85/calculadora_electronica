// lib/screens/pinouts/xlr_dmx_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

const String _xlrDmxTitle =
    'Conectores XLR y DMX (Audio Profesional e Iluminación)';
const String _xlrDmxImagePath = 'assets/images/pinouts/xlr_connector.png';
const String _xlrDmxDescription =
    'Los conectores XLR (originalmente llamados "Cannon XLR") son un tipo de conector eléctrico profesional utilizado principalmente para equipos de audio, video e iluminación escénica. Son conocidos por su robustez, su capacidad para transmisiones balanceadas y su mecanismo de bloqueo. En el ámbito de la iluminación, son el estándar para la comunicación digital DMX512.';

Color _getColorForSignalType(String type) {
  switch (type.toLowerCase()) {
    case 'ground':
      return Colors.grey.shade600;
    case 'audio hot (+ve)':
      return Colors.red.shade400;
    case 'audio cold (-ve)':
      return Colors.blue.shade400;
    case 'dmx data -':
      return Colors.orange.shade400;
    case 'dmx data +':
      return Colors.green.shade400;
    case 'secondary data -':
    case 'secondary data +':
      return Colors.purple.shade200;
    case 'power':
      return Colors.amber.shade200;
    case 'no conectado':
    case 'nc':
      return Colors.grey.shade300;
    default:
      return Colors.grey.shade100;
  }
}

const List<Map<String, dynamic>> _xlrDmxDetails = [
  {
    'section_title': 'Conectores XLR para Audio Profesional',
    'description':
        'Los conectores XLR de 3 pines son el estándar de la industria para audio balanceado, lo que ayuda a rechazar el ruido en cables largos.',
    'table_data': [
      {
        'tipo': 'XLR de 3 Pines (Audio) - Macho y Hembra',
        'pines': '3',
        'descripcion':
            'El conector más común para micrófonos, mezcladores y equipos de audio profesional. Ofrece transmisión de audio balanceada.',
        'imagen_pinout': 'assets/images/pinouts/xlr_3_pin_audio_pinout.png',
        'pin_details': [
          {
            'pin': '1',
            'funcion': 'Ground / Cable Shield',
            'tipo_senal': 'Ground',
          },
          {
            'pin': '2',
            'funcion': 'Hot (+) / Positive Polarity',
            'tipo_senal': 'Audio Hot (+ve)',
          },
          {
            'pin': '3',
            'funcion': 'Cold (-) / Negative Polarity',
            'tipo_senal': 'Audio Cold (-ve)',
          },
        ],
      },
      {
        'tipo': 'XLR de 4 Pines (Audio) - Usos Menos Comunes',
        'pines': '4',
        'descripcion':
            'Puede usarse para alimentación phantom, auriculares de intercomunicación, o audio estéreo balanceado (Raramente).',
        'imagen_pinout': 'assets/images/pinouts/xlr_4_pin_audio_pinout.png',
        'pin_details': [
          {'pin': '1', 'funcion': 'Ground', 'tipo_senal': 'Ground'},
          {
            'pin': '2',
            'funcion': 'Audio Hot (+ve)',
            'tipo_senal': 'Audio Hot (+ve)',
          },
          {
            'pin': '3',
            'funcion': 'Audio Cold (-ve)',
            'tipo_senal': 'Audio Cold (-ve)',
          },
          {'pin': '4', 'funcion': 'Power / Control', 'tipo_senal': 'Power'},
        ],
      },
    ],
  },
  {
    'section_title': 'Conectores XLR para Iluminación DMX512',
    'description':
        'DMX512 es un protocolo de control digital unidireccional para luces, máquinas de humo, etc. Utiliza cables y conectores XLR, típicamente de 3 o 5 pines.',
    'table_data': [
      {
        'tipo': 'XLR de 3 Pines (DMX512)',
        'pines': '3',
        'descripcion':
            'Aunque común en equipos económicos, el estándar DMX preferido es el de 5 pines. Su uso puede causar problemas de interferencia si se confunde con audio.',
        'imagen_pinout': 'assets/images/pinouts/xlr_3_pin_dmx_pinout.png',
        'pin_details': [
          {'pin': '1', 'funcion': 'Ground / Shield', 'tipo_senal': 'Ground'},
          {
            'pin': '2',
            'funcion': 'Data Complementary (Data -)',
            'tipo_senal': 'DMX Data -',
          },
          {
            'pin': '3',
            'funcion': 'Data Primary (Data +)',
            'tipo_senal': 'DMX Data +',
          },
        ],
      },
      {
        'tipo': 'XLR de 5 Pines (DMX512) - Estándar',
        'pines': '5',
        'descripcion':
            'El conector estándar y recomendado para DMX512. Ofrece un par de datos secundario para futuras expansiones o control bidireccional (RDM).',
        'imagen_pinout': 'assets/images/pinouts/xlr_5_pin_dmx_pinout.png',
        'pin_details': [
          {'pin': '1', 'funcion': 'Ground / Shield', 'tipo_senal': 'Ground'},
          {
            'pin': '2',
            'funcion': 'Data Complementary (Data -)',
            'tipo_senal': 'DMX Data -',
          },
          {
            'pin': '3',
            'funcion': 'Data Primary (Data +)',
            'tipo_senal': 'DMX Data +',
          },
          {
            'pin': '4',
            'funcion': 'Optional Secondary Data Complementary (Data 2 -)',
            'tipo_senal': 'Secondary Data -',
          },
          {
            'pin': '5',
            'funcion': 'Optional Secondary Data Primary (Data 2 +)',
            'tipo_senal': 'Secondary Data +',
          },
        ],
      },
    ],
  },
  {
    'section_title': 'Compatibilidad de Cables XLR: ¿Audio o DMX?',
    'description':
        'Aunque los conectores XLR para audio y DMX se parecen mucho, especialmente los de 3 pines, es **CRÍTICO** no intercambiar los cables entre estas aplicaciones.',
    'list_data': [
      {
        'title': 'Diferencias Eléctricas y de Impedancia',
        'details':
            '**Cables de Audio (XLR):** Diseñados para baja impedancia (generalmente < 100 ohmios) y transporte de señales analógicas.\n**Cables DMX (XLR):** Diseñados para una impedancia específica de 110 ohmios y transporte de señales digitales de alta velocidad. Los cables de audio no tienen la impedancia correcta ni el blindaje adecuado para DMX.\n\n**¡Advertencia!** Usar un cable de audio para DMX puede causar:\n* Comportamiento errático de las luces (parpadeo, retrasos).\n* Pérdida de datos en cadenas largas.\n* Daño potencial al equipo DMX debido a una incorrecta terminación de señal.',
      },
      {
        'title': 'Conectores de 3 Pines: Un Riesgo Común',
        'details':
            'La confusión es mayor con los conectores XLR de 3 pines. Un cable de audio XLR de 3 pines *físicamente encaja* en un puerto DMX de 3 pines, pero sus propiedades eléctricas no son las correctas para DMX. Siempre se debe usar un cable DMX con la impedancia de 110 ohmios para iluminación, idealmente con conectores de 5 pines para evitar confusiones.',
      },
      {
        'title': 'Conectores de 5 Pines: Prevención de Errores',
        'details':
            'El uso de XLR de 5 pines para DMX es el estándar preferido no solo por la opción del segundo par de datos, sino también porque ayuda a evitar la conexión accidental de cables de audio (de 3 pines) a una cadena DMX.',
      },
    ],
  },
  {
    'section_title': 'Problemas Comunes y Solución de Problemas',
    'description':
        'Aquí algunas soluciones para problemas típicos con los conectores XLR (audio) y DMX (iluminación):',
    'list_data': [
      {
        'title': 'Problemas de Audio (XLR): Zumbidos o Ruido',
        'details':
            '**Síntomas:** Un zumbido constante (hum) o ruido de fondo.\n**Solución:**\n1.  **Conexión a tierra:** Asegúrate de que todos los equipos estén conectados a una toma de tierra adecuada y común (no uses tomas de corriente no polarizadas).\n2.  **Bucle de tierra:** Si hay un "bucle de tierra" (múltiples caminos a tierra), usa un aislador de bucle de tierra o una caja DI (Direct Injection) con aislamiento de tierra.\n3.  **Cable dañado:** Un blindaje defectuoso en el cable XLR puede permitir la entrada de ruido. Prueba con otro cable de buena calidad.\n4.  **Fuentes de interferencia:** Aleja los cables de audio de cables de alimentación, transformadores y equipos que generen EMI.',
      },
      {
        'title': 'Problemas de Audio (XLR): Falta de Sonido o Sonido Débil',
        'details':
            '**Síntomas:** No hay señal de audio o la señal es muy baja.\n**Solución:**\n1.  **Cable correcto:** Asegúrate de que el cable XLR es para audio (balanceado). Aunque es raro, un cable DMX podría pasar algo de audio, pero no está optimizado.\n2.  **Conexión segura:** Asegúrate de que el conector esté completamente insertado y bloqueado en el puerto.\n3.  **Alimentación Phantom:** Si es un micrófono de condensador, verifica que la alimentación phantom (+48V) esté activada en la mezcladora o interfaz.\n4.  **Atenuación (PAD):** Algunos micrófonos o preamplificadores tienen un switch PAD para reducir la señal, asegúrate de que no esté activado inadvertidamente.',
      },
      {
        'title': 'Problemas de DMX: Luces Parpadeantes o Erráticas',
        'details':
            '**Síntomas:** Las luces DMX parpadean, reaccionan de forma intermitente o no responden correctamente.\n**Solución:**\n1.  **Cable DMX, no de audio:** **¡Es el problema más común!** Asegúrate de que estás usando cables DMX de 110 ohmios. ¡No uses cables de micrófono!\n2.  **Terminador DMX:** El último aparato en la cadena DMX debe tener un terminador de 120 ohmios enchufado en su puerto DMX OUT. Esto evita que la señal "reverberé" y cause errores.\n3.  **Número de aparatos:** No excedas el límite de 32 aparatos por universo DMX (sin un splitter/repetidor).\n4.  **Direccionamiento DMX:** Verifica que cada luz tenga una dirección DMX única y correcta.\n5.  **Longitud del cable:** En cadenas muy largas, la señal puede degradarse. Un repetidor/splitter DMX puede ser necesario.',
      },
      {
        'title': 'Problemas de DMX: No hay Control',
        'details':
            '**Síntomas:** Las luces no responden en absoluto.\n**Solución:**\n1.  **Conexión correcta:** Asegúrate de que el cable DMX esté conectado del DMX OUT de la controladora al DMX IN del primer aparato, y luego del DMX OUT de ese aparato al DMX IN del siguiente, y así sucesivamente.\n2.  **Controladora DMX:** Asegúrate de que la controladora esté encendida y enviando señal.\n3.  **Modo DMX:** Verifica que cada aparato de iluminación esté configurado en el modo DMX correcto (no en modo autónomo, maestro/esclavo, etc.).',
      },
    ],
  },
];

class XlrDmxDetailScreen extends StatelessWidget {
  const XlrDmxDetailScreen({super.key});

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
        title: const Text(_xlrDmxTitle),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Imagen principal con zoom
            GestureDetector(
              onTap: () => _showFullScreenImage(context, _xlrDmxImagePath),
              child: Hero(
                tag: _xlrDmxImagePath,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(_xlrDmxImagePath, fit: BoxFit.contain),
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
              _xlrDmxDescription,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),
            ..._xlrDmxDetails.map((section) {
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

  void _showFullScreenImage(BuildContext context, String imagePath) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
            elevation: 0,
          ),
          body: Center(
            child: PhotoView(
              imageProvider: AssetImage(imagePath),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 3,
              heroAttributes: PhotoViewHeroAttributes(tag: imagePath),
              backgroundDecoration: const BoxDecoration(color: Colors.black),
              loadingBuilder: (context, event) => Center(
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    value: event == null
                        ? 0
                        : event.cumulativeBytesLoaded /
                              event.expectedTotalBytes!,
                  ),
                ),
              ),
            ),
          ),
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
                    child: GestureDetector(
                      onTap: () =>
                          _showFullScreenImage(context, item['imagen_pinout']!),
                      child: Hero(
                        tag: item['imagen_pinout']!,
                        child: Center(
                          child: Image.asset(
                            item['imagen_pinout']!,
                            fit: BoxFit.contain,
                            height: 150,
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
                              'Pin',
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
