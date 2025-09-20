// lib/screens/pinouts/apple_lightning_connector_screen.dart
import 'package:calculadora_electronica/screens/image_viewer_screen.dart';
import 'package:flutter/material.dart';

const String _appleLightningTitle = 'Conector Apple Lightning';
const String _appleLightningImagePath =
    'assets/images/pinouts/apple_lightning_connector.png';
const String _appleLightningDescription =
    'El conector Apple Lightning es un bus de computadora y un conector de alimentación desarrollado por Apple Inc. para conectar dispositivos móviles como iPhones, iPads y iPods a computadoras, monitores externos, cargadores, cámaras y otros periféricos. Se introdujo en 2012 para reemplazar el anterior conector de 30 pines y se caracteriza por ser reversible y mucho más compacto. Aunque la interfaz física es de 8 pines, la tecnología de chip interno en el cable y el dispositivo gestiona dinámicamente la función de cada pin para la transmisión de datos y energía.';

// --- MODELOS DE DATOS ---
/// Clase para representar un pin del conector Lightning.
class LightningPin {
  final String pin;
  final String function;
  final String description;

  LightningPin({
    required this.pin,
    required this.function,
    required this.description,
  });
}

// --- DATOS CENTRALIZADOS ---
final List<LightningPin> _lightningPins = [
  LightningPin(pin: 'A1 / B8', function: 'GND', description: 'Tierra.'),
  LightningPin(
    pin: 'A2 / B7',
    function: 'ID0',
    description: 'Línea de identificación/control (datos de baja velocidad).',
  ),
  LightningPin(
    pin: 'A3 / B6',
    function: 'L+ / D+',
    description: 'Línea positiva para datos USB (D+).',
  ),
  LightningPin(
    pin: 'A4 / B5',
    function: 'VBUS',
    description: 'Voltaje de bus (Alimentación).',
  ),
  LightningPin(
    pin: 'A5 / B4',
    function: 'L- / D-',
    description: 'Línea negativa para datos USB (D-).',
  ),
  LightningPin(
    pin: 'A6 / B3',
    function: 'ID1',
    description: 'Línea de identificación/control (datos de baja velocidad).',
  ),
  LightningPin(
    pin: 'A7 / B2',
    function: 'PP',
    description: 'Fuente de alimentación del accesorio (3.3V).',
  ),
  LightningPin(
    pin: 'A8 / B1',
    function: 'ID2',
    description: 'Línea de identificación/control (datos de baja velocidad).',
  ),
];

// Corregido: Se cambió a `final` porque contiene referencias a `_lightningPins`, que no es `const`.
final List<Map<String, dynamic>> _lightningSections = [
  {
    'section_title': 'Pinout del Conector',
    'description':
        'El conector Lightning tiene 8 pines digitales que pueden ser utilizados dinámicamente para diferentes funciones. Su diseño reversible significa que el mismo pinout se utiliza en ambas orientaciones (A y B).',
    'pin_details': _lightningPins,
  },
  {
    'section_title': 'Tecnología y Chips Internos',
    'description':
        'El conector Lightning no es solo una simple conexión de pines. Contiene un chip de autenticación que garantiza que solo los accesorios certificados (MFi - Made For iPhone/iPad) funcionen correctamente. Este chip es crucial para la gestión de energía y la reasignación de pines. Los pines ID0, ID1 e ID2 actúan como una "mano" digital para configurar la interfaz de acuerdo con el periférico conectado, lo que permite la transmisión de datos, audio, video y energía a través de una conexión de 8 pines que de otro modo sería limitada.',
    'list_data': const [
      {
        'title': 'Chip de Autenticación',
        'details':
            'Un chip interno en el cable verifica si el accesorio es genuino y certificado por Apple. Sin este chip, muchas funciones del cable no estarán disponibles o el dispositivo mostrará un mensaje de error.',
      },
      {
        'title': 'Pines Dinámicos',
        'details':
            'A diferencia de USB, los pines de Lightning no tienen una función fija. El chip del cable y el dispositivo negocian y reconfiguran dinámicamente los pines para diferentes usos. Esto permite que el conector sea reversible y que una misma conexión soporte tanto la carga como la transferencia de datos y audio.',
      },
    ],
  },
  {
    'section_title': 'Lightning vs. USB-C',
    'description':
        'Aunque el conector USB-C ha ganado popularidad como un estándar universal, Lightning ha mantenido su presencia en el ecosistema de Apple. Aquí una comparación de sus principales diferencias:',
    'list_data': const [
      {
        'title': 'Pines y Funcionalidad',
        'details':
            '**Lightning:** 8 pines, con funcionalidad dinámica. Más compacto.\n**USB-C:** 24 pines (12 por lado), con funciones fijas para la mayoría de los pines. Más versátil para protocolos como Thunderbolt, DisplayPort, etc.',
      },
      {
        'title': 'Velocidad de Transferencia',
        'details':
            '**Lightning:** Originalmente comparable a USB 2.0 (480 Mbps). Modelos más recientes de iPad Pro con Lightning han mejorado esta velocidad, pero sigue siendo un cuello de botella en comparación con las velocidades de USB-C.\n**USB-C:** Ofrece velocidades significativamente más altas, hasta 40 Gbps con el protocolo Thunderbolt 4/USB4, y soporte para USB 3.1 Gen 2 (10 Gbps) como estándar.',
      },
      {
        'title': 'Ecosistema',
        'details':
            '**Lightning:** Exclusivo de Apple, lo que permite un control estricto sobre la calidad y el ecosistema de accesorios (MFi). Requiere cables y adaptadores específicos.\n**USB-C:** Un estándar de la industria, universalmente adoptado por casi todos los fabricantes, lo que promueve la interoperabilidad entre dispositivos de diferentes marcas.',
      },
    ],
  },
];

class AppleLightningConnectorScreen extends StatelessWidget {
  const AppleLightningConnectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(_appleLightningTitle),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMainImage(context),
            const SizedBox(height: 24),
            _buildDescription(context),
            const SizedBox(height: 24),

            ..._lightningSections.map((section) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section['section_title']!,
                    style: textTheme.headlineSmall?.copyWith(
                      color: colorScheme.primary,
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
                  if (section.containsKey('pin_details'))
                    _buildPinoutTable(
                      context,
                      section['pin_details'] as List<LightningPin>,
                    ),
                  if (section.containsKey('list_data'))
                    _buildExpandableList(
                      context,
                      section['list_data'] as List<Map<String, String>>,
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

  // --- MÉTODOS PRIVADOS PARA CONSTRUIR WIDGETS ---

  Widget _buildMainImage(BuildContext context) {
    return Hero(
      tag: _appleLightningImagePath,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => const ImageViewerScreen(
                imagePath: _appleLightningImagePath,
                title: _appleLightningTitle,
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
          child: Image.asset(_appleLightningImagePath, fit: BoxFit.contain),
        ),
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Descripción General:',
          style: textTheme.headlineSmall?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _appleLightningDescription,
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface,
            height: 1.5,
          ),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  Widget _buildPinoutTable(BuildContext context, List<LightningPin> pins) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DataTable(
          columnSpacing: 10,
          dataRowMinHeight: 40,
          dataRowMaxHeight: 60,
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
              label: Text('Pin', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            DataColumn(
              label: Text(
                'Función',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Descripción',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
          rows: pins
              .map(
                (pin) => DataRow(
                  cells: [
                    DataCell(Text(pin.pin)),
                    DataCell(Text(pin.function)),
                    DataCell(Text(pin.description)),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildExpandableList(
    BuildContext context,
    List<Map<String, String>> data,
  ) {
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
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            childrenPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            children: [
              Text(
                item['details']!,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
