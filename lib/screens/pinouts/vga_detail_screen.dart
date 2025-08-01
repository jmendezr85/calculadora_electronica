// lib/screens/pinouts/vga_detail_screen.dart
import 'package:flutter/material.dart';

const String _vgaTitle = 'Conector VGA (Video Graphics Array)';
const String _vgaImagePath =
    'assets/images/pinouts/vga_connector.png'; // Asume que tienes una imagen genérica
const String _vgaDescription =
    'El conector VGA (Video Graphics Array), también conocido como conector DE-15 o HD-15, es una interfaz de pantalla analógica que se utiliza para conectar ordenadores con monitores, proyectores y televisores de alta definición. Fue introducido por IBM en 1987 y, a pesar de la aparición de interfaces digitales como DVI, HDMI y DisplayPort, sigue siendo común en equipos y proyectores antiguos o de propósito especial.';

// Función auxiliar para obtener el objeto Color a partir de un tipo de señal o función.
Color _getColorForSignalType(String type) {
  switch (type.toLowerCase()) {
    case 'red video':
      return Colors.red.shade400; // Video Rojo
    case 'green video':
      return Colors.green.shade400; // Video Verde
    case 'blue video':
      return Colors.blue.shade400; // Video Azul
    case 'hsync':
      return Colors.orange.shade200; // Sincronización Horizontal
    case 'vsync':
      return Colors.purple.shade200; // Sincronización Vertical
    case 'ground':
      return Colors.grey.shade600; // Tierra
    case 'id bit':
      return Colors.amber.shade200; // Bits de ID (EDID)
    case 'power':
      return Colors.red.shade200; // Alimentación (raramente usada)
    case 'nc':
    case 'no conectado':
      return Colors.grey.shade300; // No conectado
    default:
      return Colors.grey.shade100; // Por defecto
  }
}

const List<Map<String, dynamic>> _vgaDetails = [
  {
    'section_title': 'Conector VGA DB-15 (HD-15) Macho y sus Pines',
    'description':
        'El conector VGA es un conector de 15 pines con tres filas, diseñado para señales de video analógicas RGBHV (Rojo, Verde, Azul, Sincronización Horizontal, Sincronización Vertical). Es típicamente de color azul.',
    'table_data': [
      {
        'tipo': 'VGA DB-15 Macho (Vista Frontal)',
        'pines': '15',
        'descripcion': 'El conector estándar de 15 pines para video analógico.',
        'imagen_pinout':
            'assets/images/pinouts/vga_standard_pinout.png', // Asume imagen específica
        'pin_details': [
          {
            'pin': '1',
            'funcion': 'RED (Video Rojo)',
            'tipo_senal': 'Red Video',
          },
          {
            'pin': '2',
            'funcion': 'GREEN (Video Verde)',
            'tipo_senal': 'Green Video',
          },
          {
            'pin': '3',
            'funcion': 'BLUE (Video Azul)',
            'tipo_senal': 'Blue Video',
          },
          {
            'pin': '4',
            'funcion': 'ID2 / RES (Monitor ID Bit 2)',
            'tipo_senal': 'ID Bit',
          },
          {'pin': '5', 'funcion': 'GND (Ground)', 'tipo_senal': 'Ground'},
          {
            'pin': '6',
            'funcion': 'RED_RTN (Red Return / Ground)',
            'tipo_senal': 'Ground',
          },
          {
            'pin': '7',
            'funcion': 'GREEN_RTN (Green Return / Ground)',
            'tipo_senal': 'Ground',
          },
          {
            'pin': '8',
            'funcion': 'BLUE_RTN (Blue Return / Ground)',
            'tipo_senal': 'Ground',
          },
          {
            'pin': '9',
            'funcion': 'KEY / PWR (+5V Power - Raramente usado)',
            'tipo_senal': 'Power',
          },
          {'pin': '10', 'funcion': 'GND (Ground)', 'tipo_senal': 'Ground'},
          {
            'pin': '11',
            'funcion': 'ID0 / RES (Monitor ID Bit 0)',
            'tipo_senal': 'ID Bit',
          },
          {
            'pin': '12',
            'funcion': 'ID1 / SDA (Monitor ID Bit 1 / Serial Data Line - DDC)',
            'tipo_senal': 'ID Bit',
          },
          {
            'pin': '13',
            'funcion': 'HSYNC (Horizontal Sync)',
            'tipo_senal': 'HSYNC',
          },
          {
            'pin': '14',
            'funcion': 'VSYNC (Vertical Sync)',
            'tipo_senal': 'VSYNC',
          },
          {
            'pin': '15',
            'funcion': 'ID3 / SCL (Monitor ID Bit 3 / Serial Clock Line - DDC)',
            'tipo_senal': 'ID Bit',
          },
        ],
      },
    ],
  },
  {
    'section_title': 'Resoluciones y Capacidades Típicas',
    'description':
        'Aunque VGA es analógico, puede soportar una amplia gama de resoluciones, aunque la calidad disminuye a medida que aumenta la resolución y la longitud del cable.',
    'list_data': [
      {
        'title': '640x480 (VGA)',
        'details':
            'La resolución original para la que fue diseñado VGA. Muy común en monitores antiguos.',
      },
      {
        'title': '800x600 (SVGA)',
        'details':
            'Super VGA. Una mejora popular sobre la resolución original de VGA.',
      },
      {
        'title': '1024x768 (XGA)',
        'details':
            'Extended Graphics Array. Una resolución estándar para monitores de PC durante muchos años.',
      },
      {
        'title': '1280x1024 (SXGA)',
        'details': 'Super XGA. Común en monitores de relación de aspecto 5:4.',
      },
      {
        'title': '1920x1080 (Full HD)',
        'details':
            'Algunos cables y tarjetas VGA de alta calidad pueden soportar Full HD, pero la calidad de imagen puede degradarse notablemente debido a la conversión digital-analógica.',
      },
      {
        'title': 'Limitaciones Clave',
        'details':
            'VGA no transmite audio. La señal es puramente de video. No soporta HDCP (protección de copia digital), lo que limita su uso con contenido moderno protegido. Es sensible al ruido eléctrico y la interferencia.',
      },
    ],
  },
  {
    'section_title': 'Factores que Afectan la Calidad de la Señal VGA',
    'description':
        'Debido a su naturaleza analógica, la calidad de la señal VGA es susceptible a varios factores:',
    'list_data': [
      {
        'title': 'Longitud y Calidad del Cable',
        'details':
            '**Longitud:** Cuanto más largo sea el cable VGA, mayor será la degradación de la señal, resultando en imágenes borrosas o "fantasma". Se recomienda usar cables cortos (menos de 5 metros) para la mejor calidad.\n**Calidad:** Los cables VGA de baja calidad o sin buen blindaje (apantallamiento) son muy propensos a la interferencia electromagnética (EMI), que se manifiesta como ruido en la imagen, líneas o colores distorsionados. Los cables de buena calidad utilizan blindaje individual para cada línea de señal (RGB, HSync, VSync).',
      },
      {
        'title': 'Interferencia y Ruido',
        'details':
            'Las señales VGA pueden ser afectadas por dispositivos eléctricos cercanos, cables de alimentación o incluso otros cables de datos que no estén bien blindados. Esto puede causar "ondas" o "nieve" en la imagen. Mantener los cables alejados de fuentes de interferencia ayuda a mitigar esto.',
      },
      {
        'title': 'Resolución y Frecuencia de Refresco',
        'details':
            'A mayores resoluciones y frecuencias de refresco, la señal analógica necesita ser más robusta. Un cable que funciona bien a 800x600 podría mostrar problemas a 1920x1080.',
      },
      {
        'title': 'Impedancia del Cable',
        'details':
            'Los cables VGA deben tener una impedancia específica (generalmente 75 ohmios para las líneas de video) para evitar reflexiones de señal, que causan imágenes fantasma o duplicadas.',
      },
    ],
  },
  {
    'section_title': 'Problemas Comunes y Solución de Problemas',
    'description':
        'Aunque VGA es simple, puede presentar algunos problemas. Aquí algunas soluciones:',
    'list_data': [
      {
        'title': 'Sin imagen o "No Signal"',
        'details':
            '**Síntomas:** Pantalla en blanco o mensaje de "No Signal".\n**Solución:**\n1.  **Conexión segura:** Asegurarse de que el cable VGA esté firmemente atornillado en ambos extremos (PC y monitor).\n2.  **Entrada correcta:** Verificar que el monitor esté configurado en la entrada VGA/PC correcta.\n3.  **Cable defectuoso:** Probar con otro cable VGA. Son propensos a daños internos, especialmente si son antiguos o se manipulan mucho.\n4.  **Resolución no soportada:** El monitor podría no soportar la resolución o frecuencia de refresco que la tarjeta gráfica está enviando. Iniciar en Modo Seguro si es posible para cambiar la resolución.',
      },
      {
        'title': 'Imagen borrosa, fantasma o ruidosa',
        'details':
            '**Síntomas:** La imagen se ve difusa, se ven duplicados de los objetos o líneas/patrones extraños.\n**Solución:**\n1.  **Calidad del cable:** Reemplazar el cable VGA por uno de mayor calidad, más corto y bien blindado.\n2.  **Interferencia:** Alejar el cable VGA de cables de alimentación, transformadores o dispositivos electrónicos que puedan generar ruido.\n3.  **Resolución/Frecuencia:** Bajar la resolución o la frecuencia de refresco en la configuración de pantalla del PC. Esto reduce la exigencia sobre la calidad del cable.',
      },
      {
        'title': 'Colores incorrectos o falta de color',
        'details':
            '**Síntomas:** La imagen tiene un tinte de color (ej. muy rojiza) o falta un color primario.\n**Solución:**\n1.  **Pines doblados/rotos:** Desconectar el cable VGA y revisar cuidadosamente los pines en ambos extremos. Un pin doblado o roto (especialmente los de RGB) puede causar este problema. Enderezar con cuidado o reemplazar el cable/conector.\n2.  **Conexión floja:** Asegurarse de que el cable esté completamente conectado y atornillado.',
      },
    ],
  },
];

class VGADetailScreen extends StatelessWidget {
  const VGADetailScreen({super.key});

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
        title: const Text(_vgaTitle),
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
              child: Image.asset(_vgaImagePath, fit: BoxFit.contain),
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
              _vgaDescription,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),
            ..._vgaDetails.map((section) {
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
