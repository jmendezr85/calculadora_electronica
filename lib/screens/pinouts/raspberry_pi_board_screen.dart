// lib/screens/pinouts/raspberry_pi_board_screen.dart
import 'package:calculadora_electronica/screens/image_viewer_screen.dart';
import 'package:flutter/material.dart';

const String _raspberryPiTitle = 'Pinout de la placa Raspberry Pi';
const String _raspberryPiImagePath =
    'assets/images/pinouts/raspberry_pi_board.png';
const String _raspberryPiDescription =
    'La Raspberry Pi es una serie de computadoras de placa única (SBC) del tamaño de una tarjeta de crédito, creada en el Reino Unido por la Raspberry Pi Foundation. A diferencia de un microcontrolador como Arduino, la Pi es una computadora completa que puede ejecutar un sistema operativo (como Raspberry Pi OS) y realizar tareas complejas. Su principal característica para la electrónica es el cabezal de 40 pines GPIO (General-Purpose Input/Output) que permite la conexión y control de componentes electrónicos, sensores y otros dispositivos.';

// --- MODELOS DE DATOS ---
/// Clase para representar un pin de la placa Raspberry Pi.
class RaspberryPiPin {
  final int pin;
  final String gpio;
  final String function;
  final String description;

  RaspberryPiPin({
    required this.pin,
    required this.gpio,
    required this.function,
    required this.description,
  });
}

// --- DATOS CENTRALIZADOS ---
final List<RaspberryPiPin> _raspberryPiPins = [
  RaspberryPiPin(
    pin: 1,
    gpio: '3.3V',
    function: 'Alimentación',
    description: 'Suministra 3.3V a los componentes.',
  ),
  RaspberryPiPin(
    pin: 2,
    gpio: '5V',
    function: 'Alimentación',
    description: 'Suministra 5V a los componentes.',
  ),
  RaspberryPiPin(
    pin: 3,
    gpio: 'GPIO2',
    function: 'GPIO / I2C',
    description: 'Pin GPIO 2 (SDA), para comunicación I²C.',
  ),
  RaspberryPiPin(
    pin: 4,
    gpio: '5V',
    function: 'Alimentación',
    description: 'Suministra 5V a los componentes.',
  ),
  RaspberryPiPin(
    pin: 5,
    gpio: 'GPIO3',
    function: 'GPIO / I2C',
    description: 'Pin GPIO 3 (SCL), para comunicación I²C.',
  ),
  RaspberryPiPin(
    pin: 6,
    gpio: 'GND',
    function: 'Tierra',
    description: 'Pin de tierra.',
  ),
  RaspberryPiPin(
    pin: 7,
    gpio: 'GPIO4',
    function: 'GPIO',
    description: 'Pin GPIO 4.',
  ),
  RaspberryPiPin(
    pin: 8,
    gpio: 'GPIO14',
    function: 'GPIO / UART',
    description: 'Pin GPIO 14 (TXD), para comunicación serial.',
  ),
  RaspberryPiPin(
    pin: 9,
    gpio: 'GND',
    function: 'Tierra',
    description: 'Pin de tierra.',
  ),
  RaspberryPiPin(
    pin: 10,
    gpio: 'GPIO15',
    function: 'GPIO / UART',
    description: 'Pin GPIO 15 (RXD), para comunicación serial.',
  ),
  RaspberryPiPin(
    pin: 11,
    gpio: 'GPIO17',
    function: 'GPIO',
    description: 'Pin GPIO 17.',
  ),
  RaspberryPiPin(
    pin: 12,
    gpio: 'GPIO18',
    function: 'GPIO / PWM',
    description: 'Pin GPIO 18, compatible con PWM.',
  ),
  RaspberryPiPin(
    pin: 13,
    gpio: 'GPIO27',
    function: 'GPIO',
    description: 'Pin GPIO 27.',
  ),
  RaspberryPiPin(
    pin: 14,
    gpio: 'GND',
    function: 'Tierra',
    description: 'Pin de tierra.',
  ),
  RaspberryPiPin(
    pin: 15,
    gpio: 'GPIO22',
    function: 'GPIO',
    description: 'Pin GPIO 22.',
  ),
  RaspberryPiPin(
    pin: 16,
    gpio: 'GPIO23',
    function: 'GPIO',
    description: 'Pin GPIO 23.',
  ),
  RaspberryPiPin(
    pin: 17,
    gpio: '3.3V',
    function: 'Alimentación',
    description: 'Suministra 3.3V a los componentes.',
  ),
  RaspberryPiPin(
    pin: 18,
    gpio: 'GPIO24',
    function: 'GPIO',
    description: 'Pin GPIO 24.',
  ),
  RaspberryPiPin(
    pin: 19,
    gpio: 'GPIO10',
    function: 'GPIO / SPI',
    description: 'Pin GPIO 10 (MOSI), para comunicación SPI.',
  ),
  RaspberryPiPin(
    pin: 20,
    gpio: 'GND',
    function: 'Tierra',
    description: 'Pin de tierra.',
  ),
  RaspberryPiPin(
    pin: 21,
    gpio: 'GPIO9',
    function: 'GPIO / SPI',
    description: 'Pin GPIO 9 (MISO), para comunicación SPI.',
  ),
  RaspberryPiPin(
    pin: 22,
    gpio: 'GPIO25',
    function: 'GPIO',
    description: 'Pin GPIO 25.',
  ),
  RaspberryPiPin(
    pin: 23,
    gpio: 'GPIO11',
    function: 'GPIO / SPI',
    description: 'Pin GPIO 11 (SCLK), para comunicación SPI.',
  ),
  RaspberryPiPin(
    pin: 24,
    gpio: 'GPIO8',
    function: 'GPIO / SPI',
    description: 'Pin GPIO 8 (CE0), para comunicación SPI.',
  ),
  RaspberryPiPin(
    pin: 25,
    gpio: 'GND',
    function: 'Tierra',
    description: 'Pin de tierra.',
  ),
  RaspberryPiPin(
    pin: 26,
    gpio: 'GPIO7',
    function: 'GPIO / SPI',
    description: 'Pin GPIO 7 (CE1), para comunicación SPI.',
  ),
  RaspberryPiPin(
    pin: 27,
    gpio: 'ID_SD',
    function: 'EEPROM ID',
    description: 'ID EEPROM para detección de HATs.',
  ),
  RaspberryPiPin(
    pin: 28,
    gpio: 'ID_SC',
    function: 'EEPROM ID',
    description: 'ID EEPROM para detección de HATs.',
  ),
  RaspberryPiPin(
    pin: 29,
    gpio: 'GPIO5',
    function: 'GPIO',
    description: 'Pin GPIO 5.',
  ),
  RaspberryPiPin(
    pin: 30,
    gpio: 'GND',
    function: 'Tierra',
    description: 'Pin de tierra.',
  ),
  RaspberryPiPin(
    pin: 31,
    gpio: 'GPIO6',
    function: 'GPIO',
    description: 'Pin GPIO 6.',
  ),
  RaspberryPiPin(
    pin: 32,
    gpio: 'GPIO12',
    function: 'GPIO / PWM',
    description: 'Pin GPIO 12, compatible con PWM.',
  ),
  RaspberryPiPin(
    pin: 33,
    gpio: 'GPIO13',
    function: 'GPIO / PWM',
    description: 'Pin GPIO 13, compatible con PWM.',
  ),
  RaspberryPiPin(
    pin: 34,
    gpio: 'GND',
    function: 'Tierra',
    description: 'Pin de tierra.',
  ),
  RaspberryPiPin(
    pin: 35,
    gpio: 'GPIO19',
    function: 'GPIO / PWM / SPI',
    description: 'Pin GPIO 19, compatible con PWM y SPI.',
  ),
  RaspberryPiPin(
    pin: 36,
    gpio: 'GPIO16',
    function: 'GPIO',
    description: 'Pin GPIO 16.',
  ),
  RaspberryPiPin(
    pin: 37,
    gpio: 'GPIO26',
    function: 'GPIO',
    description: 'Pin GPIO 26.',
  ),
  RaspberryPiPin(
    pin: 38,
    gpio: 'GPIO20',
    function: 'GPIO / SPI',
    description: 'Pin GPIO 20 (MOSI) para SPI2.',
  ),
  RaspberryPiPin(
    pin: 39,
    gpio: 'GND',
    function: 'Tierra',
    description: 'Pin de tierra.',
  ),
  RaspberryPiPin(
    pin: 40,
    gpio: 'GPIO21',
    function: 'GPIO / SPI',
    description: 'Pin GPIO 21 (SCLK) para SPI2.',
  ),
];

final List<Map<String, dynamic>> _raspberryPiSections = [
  {
    'section_title': 'Pinout y Funciones de los Pines GPIO',
    'description':
        'El cabezal de 40 pines de la Raspberry Pi es el corazón de la interacción con el hardware. Es importante identificar cada pin por su número y su función GPIO (ej: GPIO2, GPIO3, etc.), ya que los programas se referencian a ellos por el número GPIO, no por el número de pin físico.',
    'pin_details': _raspberryPiPins,
  },
  {
    'section_title': 'Tipos de Pines',
    'description':
        'Los pines de la Raspberry Pi se dividen en varias categorías, cada una con un uso específico:',
    'list_data': const [
      {
        'title': 'Pines de Alimentación',
        'details':
            'La Raspberry Pi tiene pines dedicados para 3.3V y 5V, además de varios pines de Tierra (GND). Esos pines son para alimentar componentes externos y deben usarse con precaución para no sobrecargar la placa.',
      },
      {
        'title': 'Pines GPIO (Entrada/Salida de Propósito General)',
        'details':
            'Estos son los pines más versátiles. Se pueden programar como entradas para leer señales (como un botón) o como salidas para controlar dispositivos (como un LED o un relé).',
      },
      {
        'title': 'Pines de Comunicación',
        'details':
            'La Raspberry Pi soporta varios protocolos de comunicación serial: **I²C** (pines GPIO2 y GPIO3), **SPI** (pines GPIO10, 9, 11, etc.) y **UART** (pines GPIO14 y GPIO15). Estos protocolos son esenciales para comunicarse con sensores y otros microcontroladores.',
      },
      {
        'title': 'Pines PWM',
        'details':
            'Algunos pines, como el GPIO12 y GPIO13, pueden generar señales de modulación por ancho de pulso (PWM) por hardware, lo que permite controlar la velocidad de los motores o la intensidad de la luz.',
      },
    ],
  },
  {
    'section_title': 'Recomendaciones de Uso',
    'description':
        'Para evitar daños y asegurar la estabilidad de tu Raspberry Pi, ten en cuenta lo siguiente:',
    'list_data': const [
      {
        'title': 'No exceder los 3.3V en las entradas',
        'details':
            'Los pines GPIO de la Raspberry Pi funcionan a 3.3V. Conectar un voltaje de 5V o superior directamente a un pin GPIO puede dañar permanentemente el microcontrolador de la placa.',
      },
      {
        'title': 'Considerar la fuente de alimentación',
        'details':
            'El cabezal de 5V tiene un límite de corriente total. Si vas a alimentar muchos componentes de 5V (como motores o tiras de LED), es mejor usar una fuente de poder externa dedicada para esos componentes y solo compartir la tierra con la Raspberry Pi.',
      },
      {
        'title': 'Usar bibliotecas de software',
        'details':
            'Para interactuar con los pines GPIO, es recomendable usar bibliotecas de software en Python como `RPi.GPIO` o `gpiozero`, que simplifican el proceso de lectura y escritura de pines.',
      },
    ],
  },
];

class RaspberryPiBoardScreen extends StatelessWidget {
  const RaspberryPiBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(_raspberryPiTitle),
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

            ..._raspberryPiSections.map((section) {
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
                      section['pin_details'] as List<RaspberryPiPin>,
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
      tag: _raspberryPiImagePath,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (context) => const ImageViewerScreen(
                imagePath: _raspberryPiImagePath,
                title: _raspberryPiTitle,
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
          child: Image.asset(_raspberryPiImagePath, fit: BoxFit.contain),
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
          _raspberryPiDescription,
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface,
            height: 1.5,
          ),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  Widget _buildPinoutTable(BuildContext context, List<RaspberryPiPin> pins) {
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
                'GPIO',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            DataColumn(
              label: Text(
                'Función',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
          rows: pins
              .map(
                (pin) => DataRow(
                  cells: [
                    DataCell(Text(pin.pin.toString())),
                    DataCell(Text(pin.gpio)),
                    DataCell(Text(pin.function)),
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
