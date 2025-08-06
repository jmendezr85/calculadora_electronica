// lib/screens/pinouts/hdmi_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:calculadora_electronica/screens/image_viewer_screen.dart'; // ¡NUEVO! Importa la pantalla de visualización de imagen

const String _hdmiTitle =
    'Conector HDMI (High-Definition Multimedia Interface)';
const String _hdmiImagePath =
    'assets/images/pinouts/hdmi_connector.png'; // Asume que tienes una imagen HDMI genérica
const String _hdmiDescription =
    'HDMI (High-Definition Multimedia Interface) es una interfaz de audio/video digital propietaria que transmite datos de video sin comprimir y datos de audio digital comprimidos o sin comprimir desde un dispositivo fuente compatible con HDMI a un monitor de computadora, proyector de video, televisión digital o dispositivo de audio digital compatible. HDMI es un estándar global para la conexión de alta definición, habiendo reemplazado en gran medida a interfaces analógicas como VGA y SCART, y ofreciendo una solución de un solo cable para audio y video de alta calidad.';

// Función auxiliar para obtener el objeto Color a partir de un tipo de señal o función.
Color _getColorForSignalType(String type) {
  switch (type.toLowerCase()) {
    case 'tmds data':
    case 'tmds clock':
      return Colors.blue.shade200; // Señales de datos y reloj TMDS
    case 'utility':
      return Colors.green.shade200; // Señales de utilidad (DDC, CEC, HPD)
    case 'power':
      return Colors.red.shade200; // Alimentación
    case 'ground':
      return Colors.grey.shade600; // Tierra
    case 'hec':
      return Colors.orange.shade200; // Canal Ethernet HDMI
    case 'arc/earc':
      return Colors.purple.shade200; // Canal de Retorno de Audio
    case 'nc':
    case 'no conectado':
      return Colors.grey.shade300; // No conectado
    default:
      return Colors.grey.shade100; // Por defecto
  }
}

const List<Map<String, dynamic>> _hdmiDetails = [
  {
    'section_title': 'Tipos de Conectores HDMI',
    'description':
        'HDMI utiliza varios tipos de conectores, siendo los más comunes el Tipo A (estándar), Tipo C (Mini) y Tipo D (Micro). Todos ellos tienen 19 pines, pero con diferentes factores de forma:',
    'table_data': [
      {
        'tipo': 'HDMI Tipo A (Estándar)',
        'pines': '19',
        'descripcion':
            'El conector HDMI más común, utilizado en la mayoría de televisores, reproductores de Blu-ray, consolas, etc. Es el conector de tamaño completo.',
        'imagen_pinout':
            'assets/images/pinouts/hdmi_type_a.png', // Asume imagen específica
        'pin_details': [
          {'pin': '1', 'funcion': 'TMDS Data2+', 'tipo_senal': 'TMDS Data'},
          {'pin': '2', 'funcion': 'TMDS Data2 Shield', 'tipo_senal': 'Ground'},
          {'pin': '3', 'funcion': 'TMDS Data2-', 'tipo_senal': 'TMDS Data'},
          {'pin': '4', 'funcion': 'TMDS Data1+', 'tipo_senal': 'TMDS Data'},
          {'pin': '5', 'funcion': 'TMDS Data1 Shield', 'tipo_senal': 'Ground'},
          {'pin': '6', 'funcion': 'TMDS Data1-', 'tipo_senal': 'TMDS Data'},
          {'pin': '7', 'funcion': 'TMDS Data0+', 'tipo_senal': 'TMDS Data'},
          {'pin': '8', 'funcion': 'TMDS Data0 Shield', 'tipo_senal': 'Ground'},
          {'pin': '9', 'funcion': 'TMDS Data0-', 'tipo_senal': 'TMDS Data'},
          {'pin': '10', 'funcion': 'TMDS Clock+', 'tipo_senal': 'TMDS Clock'},
          {'pin': '11', 'funcion': 'TMDS Clock Shield', 'tipo_senal': 'Ground'},
          {'pin': '12', 'funcion': 'TMDS Clock-', 'tipo_senal': 'TMDS Clock'},
          {
            'pin': '13',
            'funcion': 'CEC (Consumer Electronics Control)',
            'tipo_senal': 'Utility',
          },
          {
            'pin': '14',
            'funcion': 'HEC (HDMI Ethernet Channel) / Reserved',
            'tipo_senal': 'HEC',
          },
          {
            'pin': '15',
            'funcion': 'SCL (Serial Clock for DDC)',
            'tipo_senal': 'Utility',
          },
          {
            'pin': '16',
            'funcion': 'SDA (Serial Data for DDC)',
            'tipo_senal': 'Utility',
          },
          {
            'pin': '17',
            'funcion': 'DDC/CEC/HEC Ground',
            'tipo_senal': 'Ground',
          },
          {'pin': '18', 'funcion': '+5V Power', 'tipo_senal': 'Power'},
          {
            'pin': '19',
            'funcion': 'Hot Plug Detect / ARC / eARC',
            'tipo_senal': 'ARC/eARC',
          },
        ],
      },
      {
        'tipo': 'HDMI Tipo C (Mini HDMI)',
        'pines': '19',
        'descripcion':
            'Una versión más pequeña del Tipo A, utilizada en cámaras DSLR, videocámaras portátiles y algunas tabletas.',
        'imagen_pinout':
            'assets/images/pinouts/hdmi_type_c.png', // Asume imagen específica
        'pin_details': [
          // Los pines son funcionalmente los mismos que el Tipo A, pero el diseño físico es diferente.
          // Para simplificar, aquí se puede referenciar al Tipo A o duplicar la lista si hay diferencias sutiles.
          // Por ahora, se asume que son los mismos en función.
          {'pin': '1', 'funcion': 'TMDS Data2+', 'tipo_senal': 'TMDS Data'},
          {'pin': '2', 'funcion': 'TMDS Data2 Shield', 'tipo_senal': 'Ground'},
          {'pin': '3', 'funcion': 'TMDS Data2-', 'tipo_senal': 'TMDS Data'},
          {'pin': '4', 'funcion': 'TMDS Data1+', 'tipo_senal': 'TMDS Data'},
          {'pin': '5', 'funcion': 'TMDS Data1 Shield', 'tipo_senal': 'Ground'},
          {'pin': '6', 'funcion': 'TMDS Data1-', 'tipo_senal': 'TMDS Data'},
          {'pin': '7', 'funcion': 'TMDS Data0+', 'tipo_senal': 'TMDS Data'},
          {'pin': '8', 'funcion': 'TMDS Data0 Shield', 'tipo_senal': 'Ground'},
          {'pin': '9', 'funcion': 'TMDS Data0-', 'tipo_senal': 'TMDS Data'},
          {'pin': '10', 'funcion': 'TMDS Clock+', 'tipo_senal': 'TMDS Clock'},
          {'pin': '11', 'funcion': 'TMDS Clock Shield', 'tipo_senal': 'Ground'},
          {'pin': '12', 'funcion': 'TMDS Clock-', 'tipo_senal': 'TMDS Clock'},
          {'pin': '13', 'funcion': 'CEC', 'tipo_senal': 'Utility'},
          {'pin': '14', 'funcion': 'HEC / Reserved', 'tipo_senal': 'HEC'},
          {'pin': '15', 'funcion': 'SCL', 'tipo_senal': 'Utility'},
          {'pin': '16', 'funcion': 'SDA', 'tipo_senal': 'Utility'},
          {
            'pin': '17',
            'funcion': 'DDC/CEC/HEC Ground',
            'tipo_senal': 'Ground',
          },
          {'pin': '18', 'funcion': '+5V Power', 'tipo_senal': 'Power'},
          {
            'pin': '19',
            'funcion': 'Hot Plug Detect / ARC / eARC',
            'tipo_senal': 'ARC/eARC',
          },
        ],
      },
      {
        'tipo': 'HDMI Tipo D (Micro HDMI)',
        'pines': '19',
        'descripcion':
            'La versión más pequeña de HDMI, encontrada en smartphones, tabletas y algunos dispositivos muy compactos.',
        'imagen_pinout':
            'assets/images/pinouts/hdmi_type_d.png', // Asume imagen específica
        'pin_details': [
          // Los pines son funcionalmente los mismos que el Tipo A, pero el diseño físico es diferente.
          {'pin': '1', 'funcion': 'TMDS Data2+', 'tipo_senal': 'TMDS Data'},
          {'pin': '2', 'funcion': 'TMDS Data2 Shield', 'tipo_senal': 'Ground'},
          {'pin': '3', 'funcion': 'TMDS Data2-', 'tipo_senal': 'TMDS Data'},
          {'pin': '4', 'funcion': 'TMDS Data1+', 'tipo_senal': 'TMDS Data'},
          {'pin': '5', 'funcion': 'TMDS Data1 Shield', 'tipo_senal': 'Ground'},
          {'pin': '6', 'funcion': 'TMDS Data1-', 'tipo_senal': 'TMDS Data'},
          {'pin': '7', 'funcion': 'TMDS Data0+', 'tipo_senal': 'TMDS Data'},
          {'pin': '8', 'funcion': 'TMDS Data0 Shield', 'tipo_senal': 'Ground'},
          {'pin': '9', 'funcion': 'TMDS Data0-', 'tipo_senal': 'TMDS Data'},
          {'pin': '10', 'funcion': 'TMDS Clock+', 'tipo_senal': 'TMDS Clock'},
          {'pin': '11', 'funcion': 'TMDS Clock Shield', 'tipo_senal': 'Ground'},
          {'pin': '12', 'funcion': 'TMDS Clock-', 'tipo_senal': 'TMDS Clock'},
          {'pin': '13', 'funcion': 'CEC', 'tipo_senal': 'Utility'},
          {'pin': '14', 'funcion': 'HEC / Reserved', 'tipo_senal': 'HEC'},
          {'pin': '15', 'funcion': 'SCL', 'tipo_senal': 'Utility'},
          {'pin': '16', 'funcion': 'SDA', 'tipo_senal': 'Utility'},
          {
            'pin': '17',
            'funcion': 'DDC/CEC/HEC Ground',
            'tipo_senal': 'Ground',
          },
          {'pin': '18', 'funcion': '+5V Power', 'tipo_senal': 'Power'},
          {
            'pin': '19',
            'funcion': 'Hot Plug Detect / ARC / eARC',
            'tipo_senal': 'ARC/eARC',
          },
        ],
      },
    ],
  },
  {
    'section_title': 'Versiones de HDMI y sus Capacidades',
    'description':
        'HDMI ha evolucionado a lo largo de los años para soportar mayores resoluciones, frecuencias de actualización y nuevas características:',
    'list_data': [
      {
        'title': 'HDMI 1.0 - 1.2a',
        'details':
            'Soporte para 1080p a 60Hz. Audio de 8 canales. Primeras versiones con soporte para DVD-Audio, SACD y CEC.',
      },
      {
        'title': 'HDMI 1.3 - 1.4b',
        'details':
            '**HDMI 1.3:** Mayor ancho de banda (hasta 10.2 Gbps), soporte para Deep Color, xvYCC, DTS-HD Master Audio y Dolby TrueHD.\n**HDMI 1.4:** Introdujo HDMI Ethernet Channel (HEC), Audio Return Channel (ARC), soporte para 4K a 30Hz y 3D.',
      },
      {
        'title': 'HDMI 2.0 - 2.0b',
        'details':
            'Mayor ancho de banda (hasta 18 Gbps), soporte para 4K a 60Hz, 21:9 aspect ratio, HDR estático (HDR10), y hasta 32 canales de audio.',
      },
      {
        'title': 'HDMI 2.1',
        'details':
            'La versión más reciente y avanzada. Ancho de banda de hasta 48 Gbps (FRL), soporte para 4K a 120Hz, 8K a 60Hz, y hasta 10K. Introduce Dynamic HDR (HDR10+, Dolby Vision), eARC (Enhanced Audio Return Channel), VRR (Variable Refresh Rate), QMS (Quick Media Switching) y QFT (Quick Frame Transport).',
      },
    ],
  },
  {
    'section_title': 'Características Clave de HDMI',
    'description':
        'HDMI no solo transmite video y audio, sino que también incluye varias características avanzadas:',
    'list_data': [
      {
        'title': 'HDCP (High-bandwidth Digital Content Protection)',
        'details':
            'Un sistema de protección de copia digital para evitar la piratería de contenido de alta definición. Tanto el dispositivo fuente como el receptor deben ser compatibles con HDCP.',
      },
      {
        'title': 'CEC (Consumer Electronics Control)',
        'details':
            'Permite que los dispositivos conectados a través de HDMI se controlen entre sí. Por ejemplo, encender el televisor puede encender automáticamente el reproductor de Blu-ray.',
      },
      {
        'title': 'ARC (Audio Return Channel)',
        'details':
            'Permite que el audio de un televisor se envíe a un receptor de audio/barra de sonido a través del mismo cable HDMI que envía el video al televisor, simplificando el cableado.',
      },
      {
        'title': 'eARC (Enhanced Audio Return Channel)',
        'details':
            'Una mejora de ARC en HDMI 2.1 que soporta formatos de audio de mayor ancho de banda como Dolby Atmos y DTS:X sin comprimir.',
      },
      {
        'title': 'HEC (HDMI Ethernet Channel)',
        'details':
            'Permite que los dispositivos conectados compartan una conexión a Internet a través del cable HDMI, eliminando la necesidad de un cable Ethernet separado.',
      },
      {
        'title': 'HDR (High Dynamic Range)',
        'details':
            'Mejora el contraste y la gama de colores, ofreciendo imágenes más realistas y vibrantes. HDMI 2.0 soporta HDR estático (HDR10), mientras que HDMI 2.1 introduce HDR dinámico (HDR10+, Dolby Vision).',
      },
      {
        'title': 'VRR (Variable Refresh Rate)',
        'details':
            'Una característica de HDMI 2.1 que permite que la pantalla ajuste dinámicamente su frecuencia de actualización para que coincida con la salida de la tarjeta gráfica, reduciendo el "screen tearing" y el "stuttering" en juegos.',
      },
    ],
  },
  {
    'section_title': 'Problemas Comunes y Solución de Problemas',
    'description':
        'Aunque HDMI es muy fiable, pueden surgir problemas. Aquí algunas soluciones:',
    'list_data': [
      {
        'title': 'Sin imagen o imagen intermitente',
        'details':
            '**Síntomas:** Pantalla negra, "No Signal", o imagen que aparece y desaparece.\n**Solución:**\n1.  **Conexión segura:** Asegurarse de que el cable HDMI esté firmemente conectado en ambos extremos. Los cables HDMI pueden aflojarse fácilmente.\n2.  **Entrada correcta:** Verificar que el televisor/monitor esté configurado en la entrada HDMI correcta.\n3.  **Cable defectuoso:** Probar con otro cable HDMI, preferiblemente uno de buena calidad y de longitud adecuada. Los cables muy largos o de baja calidad pueden causar problemas con altas resoluciones.\n4.  **Reiniciar dispositivos:** Apagar y encender tanto el dispositivo fuente como el de visualización. A veces un "handshake" HDMI fallido se resuelve con un reinicio.\n5.  **Compatibilidad de versión:** Asegurarse de que los dispositivos y el cable sean compatibles con la versión de HDMI necesaria para la resolución y frecuencia deseadas (ej. para 4K@60Hz necesitas HDMI 2.0 o superior).',
      },
      {
        'title': 'Problemas de audio (sin sonido o distorsionado)',
        'details':
            '**Síntomas:** No hay sonido, sonido entrecortado o distorsionado.\n**Solución:**\n1.  **Configuración de audio:** Verificar la configuración de salida de audio en el dispositivo fuente (PC, consola, reproductor) y la configuración de entrada de audio en el televisor/receptor.\n2.  **Cable HDMI:** Aunque HDMI transmite audio, un cable dañado puede afectar la señal de audio.\n3.  **ARC/eARC:** Si usas ARC/eARC, asegúrate de que esté habilitado en el televisor y en el dispositivo de audio, y que estés usando el puerto HDMI ARC/eARC correcto en el televisor.',
      },
      {
        'title': 'Problemas con HDCP',
        'details':
            '**Síntomas:** Pantalla negra o mensaje de error de HDCP al intentar reproducir contenido protegido (Blu-ray, streaming 4K).\n**Solución:**\n1.  **Compatibilidad HDCP:** Asegurarse de que todos los dispositivos en la cadena (fuente, receptor A/V, televisor) soporten la misma versión de HDCP (o una compatible).\n2.  **Reiniciar:** A veces, un reinicio completo de todos los dispositivos conectados resuelve problemas temporales de HDCP.\n3.  **Actualizar firmware:** Verificar si hay actualizaciones de firmware para el televisor, receptor o reproductor.',
      },
      {
        'title': 'Problemas con CEC (Consumer Electronics Control)',
        'details':
            '**Síntomas:** Los dispositivos no se controlan entre sí automáticamente.\n**Solución:**\n1.  **Habilitar CEC:** Asegurarse de que CEC esté habilitado en la configuración de todos los dispositivos (cada fabricante tiene su propio nombre para CEC: Anynet+, Bravia Sync, Simplink, Viera Link, etc.).\n2.  **Compatibilidad:** Aunque es un estándar, la implementación de CEC puede variar entre fabricantes, lo que a veces causa problemas de compatibilidad.',
      },
    ],
  },
];

class HDMIDetailScreen extends StatelessWidget {
  const HDMIDetailScreen({super.key});

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
        title: const Text(_hdmiTitle),
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
              tag: _hdmiImagePath, // El tag debe ser único
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageViewerScreen(
                        imagePath: _hdmiImagePath,
                        title:
                            _hdmiTitle, // Pasa el título para la pantalla de zoom
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
                  child: Image.asset(_hdmiImagePath, fit: BoxFit.contain),
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
              _hdmiDescription,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),
            ..._hdmiDetails.map((section) {
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
                      // MODIFICACIÓN: Imagen de pinout dentro de la tabla con GestureDetector y Hero
                      child: Hero(
                        tag: item['imagen_pinout']!, // El tag debe ser único
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
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
