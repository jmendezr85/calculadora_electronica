// lib/screens/pinouts/eide_ata_sata_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:calculadora_electronica/screens/image_viewer_screen.dart'; // ¡NUEVO! Importa la pantalla de visualización de imagen

const String _eideSataTitle = 'Conectores EIDE/ATA y SATA (Almacenamiento)';
const String _eideSataImagePath =
    'assets/images/pinouts/sata_connector.png'; // Asume una imagen de SATA, más común hoy
const String _eideSataDescription =
    'Los conectores EIDE/ATA (también conocidos como PATA o Parallel ATA) y SATA (Serial ATA) son interfaces estándar utilizadas para conectar dispositivos de almacenamiento como discos duros (HDD) y unidades de estado sólido (SSD), así como unidades ópticas, a la placa base de una computadora. Representan la evolución de la tecnología de almacenamiento, pasando de un enfoque paralelo a uno serial.';

// Función auxiliar para obtener el objeto Color a partir de un tipo de señal o función.
Color _getColorForSignalType(String type) {
  switch (type.toLowerCase()) {
    case 'ground':
      return Colors.black; // Negro
    case 'data (xx)': // Genérico para pines de datos ATA
      return Colors.grey.shade600;
    case 'data -':
      return Colors.blue.shade600; // Azul para Data - (SATA)
    case 'data +':
      return Colors.green.shade600; // Verde para Data + (SATA)
    case '+3.3v':
      return Colors.orange.shade600; // Naranja para 3.3V
    case '+5v':
      return Colors.red.shade600; // Rojo para 5V
    case '+12v':
      return Colors.yellow.shade600; // Amarillo para 12V
    case 'nc':
    case 'no conectado':
      return Colors.grey.shade300; // No conectado
    case 'reset':
      return Colors.cyan.shade600; // Cyan para Reset
    case 'activity':
      return Colors.pink.shade400; // Rosado para Actividad
    default:
      return Colors.grey.shade100; // Por defecto
  }
}

const List<Map<String, dynamic>> _eideSataDetails = [
  {
    'section_title': 'Conectores EIDE/ATA (Parallel ATA - PATA)',
    'description':
        'El estándar EIDE/ATA fue la interfaz dominante para el almacenamiento interno de PC antes de la llegada de SATA. Se caracteriza por sus anchos cables ribbon y sus 40 pines (a veces 44 pines para portátiles). Requiere configuración de jumpers (Master/Slave/Cable Select).',
    'image_pinout':
        'assets/images/pinouts/ata_40_pin_pinout.png', // Asume imagen específica
    'table_data': [
      {'pin': '1', 'funcion': 'Reset (IDE Reset)', 'tipo_senal': 'Reset'},
      {'pin': '2', 'funcion': 'Ground', 'tipo_senal': 'Ground'},
      {'pin': '3', 'funcion': 'Data 7', 'tipo_senal': 'Data (xx)'},
      {'pin': '4', 'funcion': 'Data 8', 'tipo_senal': 'Data (xx)'},
      {'pin': '5', 'funcion': 'Data 6', 'tipo_senal': 'Data (xx)'},
      {'pin': '6', 'funcion': 'Data 9', 'tipo_senal': 'Data (xx)'},
      {'pin': '7', 'funcion': 'Data 5', 'tipo_senal': 'Data (xx)'},
      {'pin': '8', 'funcion': 'Data 10', 'tipo_senal': 'Data (xx)'},
      {'pin': '9', 'funcion': 'Data 4', 'tipo_senal': 'Data (xx)'},
      {'pin': '10', 'funcion': 'Data 11', 'tipo_senal': 'Data (xx)'},
      {'pin': '11', 'funcion': 'Data 3', 'tipo_senal': 'Data (xx)'},
      {'pin': '12', 'funcion': 'Data 12', 'tipo_senal': 'Data (xx)'},
      {'pin': '13', 'funcion': 'Data 2', 'tipo_senal': 'Data (xx)'},
      {'pin': '14', 'funcion': 'Data 13', 'tipo_senal': 'Data (xx)'},
      {'pin': '15', 'funcion': 'Data 1', 'tipo_senal': 'Data (xx)'},
      {'pin': '16', 'funcion': 'Data 14', 'tipo_senal': 'Data (xx)'},
      {'pin': '17', 'funcion': 'Data 0', 'tipo_senal': 'Data (xx)'},
      {'pin': '18', 'funcion': 'Data 15', 'tipo_senal': 'Data (xx)'},
      {'pin': '19', 'funcion': 'Ground', 'tipo_senal': 'Ground'},
      {
        'pin': '20',
        'funcion': 'Key (No Pin)',
        'tipo_senal': 'NC',
      }, // Pin faltante para orientación
      {'pin': '21', 'funcion': 'DMACK#', 'tipo_senal': 'Control'},
      {'pin': '22', 'funcion': 'Ground', 'tipo_senal': 'Ground'},
      {'pin': '23', 'funcion': 'IOW#', 'tipo_senal': 'Control'},
      {'pin': '24', 'funcion': 'Ground', 'tipo_senal': 'Ground'},
      {'pin': '25', 'funcion': 'IOR#', 'tipo_senal': 'Control'},
      {'pin': '26', 'funcion': 'Ground', 'tipo_senal': 'Ground'},
      {'pin': '27', 'funcion': 'IOCRDY', 'tipo_senal': 'Control'},
      {'pin': '28', 'funcion': 'CSEL (Cable Select)', 'tipo_senal': 'Control'},
      {'pin': '29', 'funcion': 'DASPO#', 'tipo_senal': 'Control'},
      {'pin': '30', 'funcion': 'Ground', 'tipo_senal': 'Ground'},
      {'pin': '31', 'funcion': 'IRQ14', 'tipo_senal': 'Control'},
      {
        'pin': '32',
        'funcion': 'NC (IDE Activity in 80-wire)',
        'tipo_senal': 'Activity',
      }, // Puede ser actividad en 80 hilos
      {'pin': '33', 'funcion': 'ADDR1', 'tipo_senal': 'Control'},
      {'pin': '34', 'funcion': 'PDIAG#', 'tipo_senal': 'Control'},
      {'pin': '35', 'funcion': 'ADDR0', 'tipo_senal': 'Control'},
      {'pin': '36', 'funcion': 'ADDR2', 'tipo_senal': 'Control'},
      {'pin': '37', 'funcion': 'CS1FX#', 'tipo_senal': 'Control'},
      {'pin': '38', 'funcion': 'CS3FX#', 'tipo_senal': 'Control'},
      {
        'pin': '39',
        'funcion': 'Active (IDE Active/Slave Present)',
        'tipo_senal': 'Activity',
      }, // Cable Activity LED
      {'pin': '40', 'funcion': 'Ground', 'tipo_senal': 'Ground'},
    ],
  },
  {
    'section_title': 'Conectores SATA (Serial ATA)',
    'description':
        'SATA reemplazó a ATA como la interfaz estándar para almacenamiento debido a su mayor velocidad, cables más delgados y capacidades como el hot-swapping. Consta de dos conectores: uno para datos y otro para alimentación.',
    'list_data': [
      {
        'title': 'Conector de Datos SATA (7 Pines)',
        'details':
            'Este conector transfiere la información entre el dispositivo de almacenamiento y la placa base. Es pequeño y plano, y permite velocidades de hasta 6 Gbps (SATA III).\n\n**Pinout (Datos):**\n* **Pin 1:** Ground\n* **Pin 2:** TX Data+ (Transmisión de datos)\n* **Pin 3:** TX Data- (Transmisión de datos)\n* **Pin 4:** Ground\n* **Pin 5:** RX Data- (Recepción de datos)\n* **Pin 6:** RX Data+ (Recepción de datos)\n* **Pin 7:** Ground',
        'image_pinout':
            'assets/images/pinouts/sata_data_pinout.png', // Asume imagen específica
      },
      {
        'title': 'Conector de Alimentación SATA (15 Pines)',
        'details':
            'Este conector suministra energía al dispositivo SATA desde la fuente de alimentación. Proporciona +3.3V, +5V y +12V.\n\n**Pinout (Alimentación):**\n* **Pin 1-3:** +3.3V (generalmente N/C en PSUs antiguas)\n* **Pin 4-6:** Ground\n* **Pin 7-9:** +5V\n* **Pin 10-12:** Ground\n* **Pin 13-15:** +12V',
        'image_pinout':
            'assets/images/pinouts/sata_power_pinout.png', // Reutiliza la de ATX si es la misma
      },
    ],
  },
  {
    'section_title': 'Evolución y Ventajas de SATA sobre EIDE/ATA',
    'description':
        'La transición de ATA a SATA marcó una mejora significativa en el rendimiento, la gestión de cables y la flexibilidad del sistema.',
    'list_data': [
      {
        'title': 'Velocidad',
        'details':
            '**ATA:** Las versiones más rápidas (ATA/133) alcanzaban 133 MB/s.\n**SATA:** Las versiones iniciales (SATA 1.0) empezaron en 150 MB/s, y SATA III (6.0 Gbps) alcanza 600 MB/s, un salto masivo que es crucial para los SSD.',
      },
      {
        'title': 'Cableado',
        'details':
            '**ATA:** Utiliza cables ribbon anchos de 40 u 80 hilos, que son voluminosos, obstruyen el flujo de aire y dificultan la gestión de cables.\n**SATA:** Utiliza cables delgados de 7 hilos para datos, mucho más fáciles de manejar y que mejoran significativamente el flujo de aire dentro del gabinete.',
      },
      {
        'title': 'Conectividad',
        'details':
            '**ATA:** Un solo cable ATA puede conectar dos dispositivos (maestro/esclavo) a un puerto de la placa base.\n**SATA:** Cada dispositivo SATA se conecta directamente a un puerto dedicado en la placa base, lo que simplifica la configuración (sin jumpers) y mejora el rendimiento al no compartir el ancho de banda.',
      },
      {
        'title': 'Hot-Swapping (Conexión en caliente)',
        'details':
            '**ATA:** No soporta hot-swapping; los dispositivos deben conectarse o desconectarse con el PC apagado.\n**SATA:** Permite conectar y desconectar dispositivos mientras el sistema está encendido, lo que es útil para unidades externas o bahías de intercambio rápido.',
      },
      {
        'title': 'Eficiencia de Energía',
        'details':
            'SATA generalmente consume menos energía que su predecesor ATA, especialmente en los dispositivos modernos.',
      },
    ],
  },
  {
    'section_title': 'Problemas Comunes y Solución de Problemas',
    'description':
        'Aquí algunas soluciones para problemas típicos con los conectores EIDE/ATA y SATA:',
    'list_data': [
      {
        'title': 'Dispositivo no detectado (EIDE/ATA)',
        'details':
            '**Síntomas:** El disco duro o la unidad óptica no aparece en el BIOS/UEFI o en el sistema operativo.\n**Solución:**\n1.  **Jumpers:** Verifica los jumpers de Master/Slave/Cable Select en el dispositivo. Si solo hay un dispositivo en el cable, debe ser "Master" o "Cable Select". Si hay dos, uno debe ser "Master" y el otro "Slave". "Cable Select" es lo más sencillo si ambos dispositivos y la placa base lo soportan.\n2.  **Cable ribbon:** Asegúrate de que el cable esté conectado correctamente, el "Pin 1" (el borde rojo/azul del cable) debe coincidir con el "Pin 1" del conector tanto en el dispositivo como en la placa base.\n3.  **Cable dañado:** Los cables ATA son propensos a daños. Prueba con un cable diferente.',
      },
      {
        'title': 'Dispositivo no detectado (SATA)',
        'details':
            '**Síntomas:** El disco duro o SSD no aparece en el BIOS/UEFI o en el sistema operativo.\n**Solución:**\n1.  **Cables firmes:** Asegúrate de que tanto el cable de datos SATA como el de alimentación SATA estén firmemente conectados a la unidad y a la placa base/fuente de alimentación.\n2.  **Puerto SATA:** Prueba con otro puerto SATA en la placa base.\n3.  **Configuración del BIOS/UEFI:** Asegúrate de que el puerto SATA esté habilitado en el BIOS/UEFI y que el modo SATA (AHCI, IDE) sea el correcto (AHCI es recomendado para SSDs).\n4.  **Cable dañado:** Los cables SATA son más robustos pero pueden fallar. Prueba con un cable de datos SATA diferente.',
      },
      {
        'title': 'Rendimiento lento o errores de transferencia (Ambos)',
        'details':
            '**Síntomas:** El sistema operativo o los programas se cargan lentamente, o las transferencias de archivos son muy lentas.\n**Solución:**\n1.  **Cable de calidad:** Para SATA, un cable de datos de baja calidad puede causar errores. Prueba con uno de buena calidad. Para ATA, asegúrate de usar un cable de 80 hilos para Ultra ATA.\n2.  **Drivers:** Asegúrate de que los controladores del chipset de la placa base estén actualizados.\n3.  **Modo de operación:** Para SATA, verifica que el dispositivo esté operando en el modo de velocidad más alta posible (ej. SATA III 6Gbps si el dispositivo y la placa base lo soportan).\n4.  **Salud del disco:** Usa herramientas de diagnóstico (como CrystalDiskInfo para Windows) para verificar el estado de salud del HDD/SSD. Un disco defectuoso puede ser la causa.',
      },
    ],
  },
];

class EideAtaSataDetailScreen extends StatelessWidget {
  const EideAtaSataDetailScreen({super.key});

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
        title: const Text(_eideSataTitle),
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
              tag: _eideSataImagePath, // El tag debe ser único
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageViewerScreen(
                        imagePath: _eideSataImagePath,
                        title:
                            _eideSataTitle, // Pasa el título para la pantalla de zoom
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
                  child: Image.asset(_eideSataImagePath, fit: BoxFit.contain),
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
              _eideSataDescription,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),
            ..._eideSataDetails.map((section) {
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
                  if (section.containsKey('image_pinout') &&
                      section['table_data'] !=
                          null) // Solo si hay tabla, muestra imagen específica
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        // MODIFICACIÓN: Imagen de pinout dentro de la tabla con GestureDetector y Hero
                        child: Hero(
                          tag:
                              section['image_pinout']!, // El tag debe ser único
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageViewerScreen(
                                    imagePath: section['image_pinout']!,
                                    title:
                                        section['section_title']!, // Usa el título de la sección
                                  ),
                                ),
                              );
                            },
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
              if (item.containsKey('image_pinout') &&
                  item['image_pinout'] != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Center(
                    // MODIFICACIÓN: Imagen de pinout dentro de la lista con GestureDetector y Hero
                    child: Hero(
                      tag: item['image_pinout']!, // El tag debe ser único
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImageViewerScreen(
                                imagePath: item['image_pinout']!,
                                title:
                                    item['title']!, // Usa el título del elemento
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
