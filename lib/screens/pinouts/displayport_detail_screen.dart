// lib/screens/pinouts/displayport_detail_screen.dart
import 'package:flutter/material.dart';

const String _displayPortTitle = 'Conector DisplayPort';
const String _displayPortImagePath =
    'assets/images/pinouts/displayport_connector.png'; // Asume que tienes una imagen genérica
const String _displayPortDescription =
    'DisplayPort es una interfaz de pantalla digital desarrollada por un consorcio de fabricantes de PC y chips y estandarizada por la Video Electronics Standards Association (VESA). Se utiliza principalmente para conectar una fuente de video a un dispositivo de visualización, como un monitor de computadora. Es una alternativa a HDMI, ofreciendo características como tasas de refresco adaptativas (VRR), mayores anchos de banda y soporte para múltiples pantallas a través de una sola conexión (Multi-Stream Transport - MST).';

// Función auxiliar para obtener el objeto Color a partir de un tipo de señal o función.
Color _getColorForSignalType(String type) {
  switch (type.toLowerCase()) {
    case 'main link data':
      return Colors.blue.shade200; // Datos del enlace principal
    case 'aux channel':
      return Colors.green.shade200; // Canal auxiliar (control, DDC)
    case 'hot plug detect':
      return Colors.orange.shade200; // Detección de conexión
    case 'power':
      return Colors.red.shade200; // Alimentación
    case 'ground':
      return Colors.grey.shade600; // Tierra
    case 'config pin':
      return Colors.purple.shade200; // Pin de configuración (para adaptadores)
    case 'no conectado':
    case 'nc':
      return Colors.grey.shade300; // No conectado
    default:
      return Colors.grey.shade100; // Por defecto
  }
}

const List<Map<String, dynamic>> _displayPortDetails = [
  {
    'section_title': 'Conector DisplayPort Estándar y sus Pines',
    'description':
        'El conector DisplayPort estándar (o completo) tiene 20 pines. A diferencia de HDMI, DisplayPort utiliza micro-paquetes de datos que permiten una comunicación más flexible.',
    'table_data': [
      {
        'tipo': 'DisplayPort Estándar (20 pines)',
        'pines': '20',
        'descripcion':
            'El conector de tamaño completo más común para DisplayPort.',
        'imagen_pinout':
            'assets/images/pinouts/displayport_standard.png', // Asume imagen específica
        'pin_details': [
          {
            'pin': '1',
            'funcion': 'ML_Lane0_P (Main Link Lane 0 Plus)',
            'tipo_senal': 'Main Link Data',
          },
          {
            'pin': '2',
            'funcion': 'GND (Main Link Lane 0 Ground)',
            'tipo_senal': 'Ground',
          },
          {
            'pin': '3',
            'funcion': 'ML_Lane0_N (Main Link Lane 0 Minus)',
            'tipo_senal': 'Main Link Data',
          },
          {
            'pin': '4',
            'funcion': 'ML_Lane1_P (Main Link Lane 1 Plus)',
            'tipo_senal': 'Main Link Data',
          },
          {
            'pin': '5',
            'funcion': 'GND (Main Link Lane 1 Ground)',
            'tipo_senal': 'Ground',
          },
          {
            'pin': '6',
            'funcion': 'ML_Lane1_N (Main Link Lane 1 Minus)',
            'tipo_senal': 'Main Link Data',
          },
          {
            'pin': '7',
            'funcion': 'ML_Lane2_P (Main Link Lane 2 Plus)',
            'tipo_senal': 'Main Link Data',
          },
          {
            'pin': '8',
            'funcion': 'GND (Main Link Lane 2 Ground)',
            'tipo_senal': 'Ground',
          },
          {
            'pin': '9',
            'funcion': 'ML_Lane2_N (Main Link Lane 2 Minus)',
            'tipo_senal': 'Main Link Data',
          },
          {
            'pin': '10',
            'funcion': 'ML_Lane3_P (Main Link Lane 3 Plus)',
            'tipo_senal': 'Main Link Data',
          },
          {
            'pin': '11',
            'funcion': 'GND (Main Link Lane 3 Ground)',
            'tipo_senal': 'Ground',
          },
          {
            'pin': '12',
            'funcion': 'ML_Lane3_N (Main Link Lane 3 Minus)',
            'tipo_senal': 'Main Link Data',
          },
          {
            'pin': '13',
            'funcion': 'GND (AUX Channel / HPD Ground)',
            'tipo_senal': 'Ground',
          },
          {
            'pin': '14',
            'funcion': 'AUX_CH_P (Auxiliary Channel Plus)',
            'tipo_senal': 'Aux Channel',
          },
          {
            'pin': '15',
            'funcion': 'AUX_CH_N (Auxiliary Channel Minus)',
            'tipo_senal': 'Aux Channel',
          },
          {
            'pin': '16',
            'funcion': 'Hot Plug Detect',
            'tipo_senal': 'Hot Plug Detect',
          },
          {
            'pin': '17',
            'funcion': 'DP_PWR (DisplayPort Power)',
            'tipo_senal': 'Power',
          },
          {
            'pin': '18',
            'funcion': 'Config Pin 1',
            'tipo_senal': 'Config Pin',
          }, // Para adaptadores
          {
            'pin': '19',
            'funcion': 'Config Pin 2',
            'tipo_senal': 'Config Pin',
          }, // Para adaptadores
          {
            'pin': '20',
            'funcion': 'DP_PWR (DisplayPort Power)',
            'tipo_senal': 'Power',
          }, // También se usa para DP_PWR
        ],
      },
      {
        'tipo': 'Mini DisplayPort (20 pines)',
        'pines': '20',
        'descripcion':
            'Una versión más compacta del conector, popular en laptops de Apple (antes de USB-C) y algunos Ultrabooks.',
        'imagen_pinout':
            'assets/images/pinouts/displayport_mini.png', // Asume imagen específica
        'pin_details': [
          // Los pines son funcionalmente los mismos que el estándar, solo el factor de forma cambia.
          // Para simplificar, se duplica la lista si no hay diferencias eléctricas significativas.
          {'pin': '1', 'funcion': 'ML_Lane0_P', 'tipo_senal': 'Main Link Data'},
          {'pin': '2', 'funcion': 'GND', 'tipo_senal': 'Ground'},
          {'pin': '3', 'funcion': 'ML_Lane0_N', 'tipo_senal': 'Main Link Data'},
          {'pin': '4', 'funcion': 'ML_Lane1_P', 'tipo_senal': 'Main Link Data'},
          {'pin': '5', 'funcion': 'GND', 'tipo_senal': 'Ground'},
          {'pin': '6', 'funcion': 'ML_Lane1_N', 'tipo_senal': 'Main Link Data'},
          {'pin': '7', 'funcion': 'ML_Lane2_P', 'tipo_senal': 'Main Link Data'},
          {'pin': '8', 'funcion': 'GND', 'tipo_senal': 'Ground'},
          {'pin': '9', 'funcion': 'ML_Lane2_N', 'tipo_senal': 'Main Link Data'},
          {
            'pin': '10',
            'funcion': 'ML_Lane3_P',
            'tipo_senal': 'Main Link Data',
          },
          {'pin': '11', 'funcion': 'GND', 'tipo_senal': 'Ground'},
          {
            'pin': '12',
            'funcion': 'ML_Lane3_N',
            'tipo_senal': 'Main Link Data',
          },
          {'pin': '13', 'funcion': 'GND (AUX / HPD)', 'tipo_senal': 'Ground'},
          {'pin': '14', 'funcion': 'AUX_CH_P', 'tipo_senal': 'Aux Channel'},
          {'pin': '15', 'funcion': 'AUX_CH_N', 'tipo_senal': 'Aux Channel'},
          {
            'pin': '16',
            'funcion': 'Hot Plug Detect',
            'tipo_senal': 'Hot Plug Detect',
          },
          {'pin': '17', 'funcion': 'DP_PWR', 'tipo_senal': 'Power'},
          {'pin': '18', 'funcion': 'Config Pin 1', 'tipo_senal': 'Config Pin'},
          {'pin': '19', 'funcion': 'Config Pin 2', 'tipo_senal': 'Config Pin'},
          {'pin': '20', 'funcion': 'DP_PWR', 'tipo_senal': 'Power'},
        ],
      },
    ],
  },
  {
    'section_title': 'Versiones de DisplayPort y sus Capacidades',
    'description':
        'DisplayPort ha sido actualizado constantemente para soportar las últimas tecnologías de visualización:',
    'list_data': [
      {
        'title': 'DisplayPort 1.0 - 1.1a',
        'details':
            'Soporte para 1080p y 2560x1600. Ancho de banda de 10.8 Gbps (High Bit Rate - HBR). Primeras versiones, sin audio ni protección de copia.',
      },
      {
        'title': 'DisplayPort 1.2 - 1.2a',
        'details':
            'Mayor ancho de banda (21.6 Gbps - HBR2). Soporte para 4K a 60Hz. Introducción de Multi-Stream Transport (MST) para múltiples monitores encadenados y DisplayID. Soporte para G-Sync y FreeSync.',
      },
      {
        'title': 'DisplayPort 1.3',
        'details':
            'Ancho de banda de 32.4 Gbps (HBR3). Soporte para 4K a 120Hz, 5K a 60Hz y 8K a 30Hz. Compatibilidad con Dual-Mode DisplayPort (DP++).',
      },
      {
        'title': 'DisplayPort 1.4',
        'details':
            'Mismo ancho de banda de 32.4 Gbps (HBR3). Introduce Display Stream Compression (DSC) 1.2, que permite resoluciones aún más altas (8K a 60Hz con HDR) y HDR con metadatos estáticos o dinámicos. También soporta Forward Error Correction (FEC) y un canal de audio mejorado.',
      },
      {
        'title': 'DisplayPort 2.0 - 2.1 (UHBR)',
        'details':
            'Un salto significativo en ancho de banda. DisplayPort 2.0 (80 Gbps - UHBR 10, 13.5, 20) y 2.1 (mismo ancho de banda, mejoras en la conectividad). Soporte para 4K a 240Hz, 8K a 85Hz, o incluso 16K a 60Hz (con DSC). Diseñado para Realidad Virtual, monitores de alta gama y múltiples pantallas de alta resolución. Admite Display Stream Compression (DSC) 1.2a.',
      },
    ],
  },
  {
    'section_title': 'Características Clave de DisplayPort',
    'description':
        'DisplayPort ofrece una serie de características avanzadas que lo distinguen:',
    'list_data': [
      {
        'title': 'MST (Multi-Stream Transport)',
        'details':
            'Permite conectar múltiples monitores en cadena (daisy-chaining) a un solo puerto DisplayPort en la tarjeta gráfica. Cada monitor actúa como un hub para el siguiente.',
      },
      {
        'title': 'Adaptive Sync (FreeSync/G-Sync Compatible)',
        'details':
            'Tecnología que sincroniza la frecuencia de actualización del monitor con la tasa de fotogramas de la tarjeta gráfica, eliminando el tearing y el stuttering en juegos y video. Estandarizado por VESA como Adaptive Sync.',
      },
      {
        'title': 'DSC (Display Stream Compression)',
        'details':
            'Un algoritmo de compresión visual sin pérdidas (o visualmente sin pérdidas) que permite transmitir resoluciones y frecuencias de actualización muy altas a través del ancho de banda existente, especialmente relevante en DisplayPort 1.4 y 2.x.',
      },
      {
        'title': 'Dual-Mode DisplayPort (DP++)',
        'details':
            'Indica que el puerto DisplayPort puede emitir una señal HDMI o DVI directamente a través de un adaptador pasivo. Esto permite la compatibilidad con monitores HDMI/DVI sin necesidad de un conversor activo, usando los pines 18 y 20.',
      },
      {
        'title': 'HDR (High Dynamic Range)',
        'details':
            'Soporte para imágenes con mayor contraste y una gama de colores más amplia, mejorando la calidad visual. DisplayPort 1.4 y posteriores son fundamentales para el HDR en monitores de PC.',
      },
    ],
  },
  {
    'section_title': 'Ventajas y Desventajas de DisplayPort',
    'description':
        'DisplayPort tiene sus propios puntos fuertes y débiles en comparación con otras interfaces:',
    'list_data': [
      {
        'title': 'Ventajas',
        'details':
            '**Alto ancho de banda:** Especialmente con DP 2.x, soporta las resoluciones y frecuencias más altas.\n**MST (Multi-Stream Transport):** Permite encadenar varios monitores, ideal para configuraciones de múltiples pantallas.\n**Adaptive Sync:** Soporte nativo para tecnologías de refresco adaptativo como FreeSync y G-Sync Compatible, crucial para gamers.\n**Tecnología de paquetes:** Más flexible y extensible para futuras mejoras.\n**Royalty-free:** A diferencia de HDMI (que requiere pagos de licencias), DisplayPort es libre de regalías.',
      },
      {
        'title': 'Desventajas',
        'details':
            '**Menos común en TVs:** Aunque está ganando terreno, HDMI sigue siendo la interfaz dominante en televisores de consumo.\n**Cableado delicado:** Los cables DisplayPort pueden ser más sensibles a la calidad y la longitud para mantener la integridad de la señal en altas resoluciones.\n**Conector con pestillo:** Aunque útil para asegurar la conexión, el pestillo puede romperse si se fuerza la desconexión sin pulsarlo.',
      },
    ],
  },
  {
    'section_title': 'Problemas Comunes y Solución de Problemas',
    'description':
        'Aquí algunas soluciones para problemas comunes con DisplayPort:',
    'list_data': [
      {
        'title': 'No hay señal o pantalla negra',
        'details':
            '**Síntomas:** "No Signal", pantalla completamente negra.\n**Solución:**\n1.  **Conexión segura:** Asegurarse de que el cable DisplayPort esté firmemente insertado en ambos extremos. El pestillo debe encajar.\n2.  **Entrada correcta:** Verificar que el monitor esté configurado en la entrada DisplayPort correcta.\n3.  **Cable de calidad:** Probar con un cable DisplayPort certificado y de longitud adecuada. Los cables DisplayPort pueden ser muy sensibles a la calidad, especialmente para altas resoluciones/frecuencias.\n4.  **Reiniciar dispositivos:** Apagar y encender completamente el PC y el monitor (desconectar la alimentación por un minuto si es posible).\n5.  **Controladores:** Actualizar los controladores de la tarjeta gráfica a la última versión.',
      },
      {
        'title': 'Parpadeo o artefactos de imagen',
        'details':
            '**Síntomas:** La pantalla parpadea, aparecen artefactos visuales o líneas.\n**Solución:**\n1.  **Reducir resolución/frecuencia:** Intentar bajar la resolución o la frecuencia de actualización del monitor. Si esto soluciona el problema, puede ser un cable o tarjeta gráfica incapaz de soportar el ancho de banda requerido.\n2.  **Desactivar G-Sync/FreeSync:** Probar a desactivar Adaptive Sync temporalmente para ver si el problema persiste.\n3.  **Cable dañado:** Inspeccionar el cable en busca de daños físicos. Un cable defectuoso es una causa común.',
      },
      {
        'title': 'Problemas con múltiples monitores (MST)',
        'details':
            '**Síntomas:** Solo un monitor funciona, o la cadena se rompe.\n**Solución:**\n1.  **Habilitar MST:** Asegurarse de que MST esté habilitado en la configuración de tu monitor (a menudo llamado "DisplayPort 1.2 Mode" o "Daisy Chain Mode").\n2.  **Orden de conexión:** Intentar conectar los monitores en un orden diferente en la cadena.\n3.  **Límite de ancho de banda:** Verificar que el ancho de banda del puerto DisplayPort en tu tarjeta gráfica sea suficiente para todos los monitores en la cadena a sus respectivas resoluciones y frecuencias.',
      },
      {
        'title': 'Problemas con adaptadores (DP a HDMI/DVI)',
        'details':
            '**Síntomas:** No hay señal al usar un adaptador.\n**Solución:**\n1.  **Adaptador activo vs. pasivo:** Para conversiones a HDMI/DVI Dual Link o para altas resoluciones, a menudo se necesita un adaptador *activo* con alimentación externa, ya que los adaptadores pasivos solo funcionan con puertos "DP++" y tienen limitaciones de ancho de banda y resolución.\n2.  **Compatibilidad:** Asegurarse de que el adaptador sea compatible con la versión de DisplayPort de tu tarjeta gráfica y con la resolución/frecuencia de tu monitor.',
      },
    ],
  },
];

class DisplayPortDetailScreen extends StatelessWidget {
  const DisplayPortDetailScreen({super.key});

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
        title: const Text(_displayPortTitle),
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
              child: Image.asset(_displayPortImagePath, fit: BoxFit.contain),
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
              _displayPortDescription,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),
            ..._displayPortDetails.map((section) {
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
