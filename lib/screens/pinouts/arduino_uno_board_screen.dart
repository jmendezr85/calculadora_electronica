// lib/screens/pinouts/arduino_uno_board_screen.dart
import 'package:flutter/material.dart';
import 'package:calculadora_electronica/screens/image_viewer_screen.dart';

const String _arduinoUnoTitle = 'Pinout de la placa Arduino Uno';
const String _arduinoUnoImagePath =
    'assets/images/pinouts/arduino_uno_board.png';
const String _arduinoUnoDescription =
    'La placa Arduino Uno es la base del ecosistema Arduino, una plataforma de hardware de código abierto diseñada para facilitar la creación de prototipos electrónicos. Equipada con el microcontrolador ATmega328P, la Uno es una herramienta popular para aficionados, estudiantes y profesionales que buscan interactuar con el mundo físico a través de sensores y actuadores. Su pinout estandarizado y su entorno de desarrollo simple la convierten en un punto de partida ideal para la electrónica y la programación.';

// --- MODELOS DE DATOS ---
/// Clase para representar un pin de la placa Arduino Uno.
class ArduinoPin {
  final String pin;
  final String function;
  final String description;

  ArduinoPin({
    required this.pin,
    required this.function,
    required this.description,
  });
}

// --- DATOS CENTRALIZADOS ---
final List<ArduinoPin> _arduinoPins = [
  ArduinoPin(
    pin: '5V',
    function: 'Alimentación',
    description: 'Pin regulado de 5V para alimentar componentes externos.',
  ),
  ArduinoPin(
    pin: '3.3V',
    function: 'Alimentación',
    description: 'Pin regulado de 3.3V para componentes de bajo voltaje.',
  ),
  ArduinoPin(
    pin: 'GND',
    function: 'Tierra',
    description: 'Pines de tierra (GND).',
  ),
  ArduinoPin(
    pin: 'VIN',
    function: 'Entrada de Voltaje',
    description:
        'Pin para alimentar la placa con una fuente de poder externa (7-12V).',
  ),
  ArduinoPin(
    pin: 'IOREF',
    function: 'Referencia de E/S',
    description:
        'Este pin proporciona la referencia de voltaje del microcontrolador (5V).',
  ),
  ArduinoPin(
    pin: 'RESET',
    function: 'Reset',
    description: 'Pin para reiniciar el microcontrolador.',
  ),
  ArduinoPin(
    pin: 'AREF',
    function: 'Referencia Analógica',
    description:
        'Pin opcional para voltaje de referencia en lecturas analógicas.',
  ),
  ArduinoPin(
    pin: 'D0 (RX)',
    function: 'Digital / UART',
    description:
        'Pin digital 0, también pin de recepción (RX) para comunicación serial.',
  ),
  ArduinoPin(
    pin: 'D1 (TX)',
    function: 'Digital / UART',
    description:
        'Pin digital 1, también pin de transmisión (TX) para comunicación serial.',
  ),
  ArduinoPin(
    pin: 'D2 - D13',
    function: 'Digital',
    description: 'Pines digitales de entrada/salida (I/O).',
  ),
  ArduinoPin(
    pin: 'A0 - A5',
    function: 'Analógico',
    description: 'Pines de entrada analógica.',
  ),
  ArduinoPin(
    pin: 'D3, D5, D6, D9, D10, D11',
    function: 'PWM',
    description: 'Pines con capacidad de modulación por ancho de pulsos.',
  ),
  ArduinoPin(
    pin: 'A4 (SDA), A5 (SCL)',
    function: 'I²C',
    description: 'Pines para comunicación I²C (SDA y SCL).',
  ),
  ArduinoPin(
    pin: 'D10 (SS), D11 (MOSI), D12 (MISO), D13 (SCK)',
    function: 'SPI',
    description: 'Pines para comunicación SPI.',
  ),
];

final List<Map<String, dynamic>> _arduinoUnoSections = [
  {
    'section_title': 'Pinout y Funciones de los Pines',
    'description':
        'La placa Arduino Uno tiene varios grupos de pines que cumplen diferentes funciones. Es crucial entender cada uno para conectar componentes correctamente y evitar daños en la placa o en los componentes.',
    'pin_details': _arduinoPins,
  },
  {
    'section_title': 'Tipos de Pines',
    'description':
        'Los pines de la Arduino Uno se clasifican en varias categorías, cada una con un propósito específico en el desarrollo de proyectos:',
    'list_data': const [
      {
        'title': 'Pines de Alimentación',
        'details':
            'Estos pines se utilizan para suministrar energía a la placa y a los componentes externos. Incluyen pines de 5V, 3.3V, GND (tierra) y VIN (entrada de voltaje para la placa).',
      },
      {
        'title': 'Pines Digitales (I/O)',
        'details':
            'Los pines del D0 al D13 pueden configurarse como entradas o salidas. Se utilizan para leer señales digitales (como un interruptor) o para controlar componentes digitales (como un LED).',
      },
      {
        'title': 'Pines Analógicos',
        'details':
            'Los pines del A0 al A5 se utilizan para leer señales analógicas, como el voltaje variable de un sensor de luz o de temperatura. Las lecturas se convierten en valores digitales de 0 a 1023.',
      },
      {
        'title': 'Pines PWM (Modulación por Ancho de Pulso)',
        'details':
            'Pines digitales específicos que pueden simular una salida analógica variando el ancho de un pulso de voltaje. Se identifican con un símbolo de tilde (~). Se usan para controlar la intensidad de un LED o la velocidad de un motor.',
      },
    ],
  },
  {
    'section_title': 'Recomendaciones de Uso',
    'description':
        'Para garantizar la longevidad y el correcto funcionamiento de tu placa Arduino Uno y tus proyectos, sigue estas recomendaciones:',
    'list_data': const [
      {
        'title': 'No exceder los límites de voltaje y corriente',
        'details':
            'Evita conectar voltajes superiores a 5V en los pines digitales o analógicos. La placa puede suministrar hasta 40 mA por pin digital y un total de 200 mA. Exceder estos límites puede dañar el microcontrolador.',
      },
      {
        'title': 'Usar la resistencia adecuada',
        'details':
            'Siempre usa una resistencia en serie cuando conectes un LED a un pin digital de salida. Esto limita la corriente y evita que el LED (o el pin) se queme.',
      },
      {
        'title': 'Cuidado con la alimentación',
        'details':
            'No conectes el pin VIN a una fuente de poder superior a 12V. La placa tiene un regulador de voltaje, pero un voltaje excesivo puede causar que se sobrecaliente. Para alimentar componentes externos de alta potencia, usa una fuente de poder externa y conecta solo la tierra (GND) a la Arduino.',
      },
    ],
  },
];

class ArduinoUnoBoardScreen extends StatelessWidget {
  const ArduinoUnoBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(_arduinoUnoTitle),
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

            ..._arduinoUnoSections.map((section) {
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
                      section['pin_details'] as List<ArduinoPin>,
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
      tag: _arduinoUnoImagePath,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageViewerScreen(
                imagePath: _arduinoUnoImagePath,
                title: _arduinoUnoTitle,
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
          child: Image.asset(_arduinoUnoImagePath, fit: BoxFit.contain),
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
          _arduinoUnoDescription,
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface,
            height: 1.5,
          ),
          textAlign: TextAlign.justify,
        ),
      ],
    );
  }

  Widget _buildPinoutTable(BuildContext context, List<ArduinoPin> pins) {
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
