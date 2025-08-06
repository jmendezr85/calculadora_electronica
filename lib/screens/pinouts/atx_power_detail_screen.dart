// lib/screens/pinouts/atx_power_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:calculadora_electronica/screens/image_viewer_screen.dart'; // ¡NUEVO! Importa la pantalla de visualización de imagen

const String _atxPowerTitle = 'Conectores de Alimentación ATX';
const String _atxPowerImagePath =
    'assets/images/pinouts/atx_main_connector.png'; // Asume una imagen del conector ATX principal
const String _atxPowerDescription =
    'Las fuentes de alimentación ATX (Advanced Technology eXtended) son el estándar más común para PCs de escritorio. Proporcionan diferentes voltajes (como +3.3V, +5V, +12V, y -12V) a los componentes del sistema a través de varios conectores dedicados. Conocer el propósito y el pinout de cada conector es crucial para construir, reparar y diagnosticar problemas en un PC.'; //

// Función auxiliar para obtener el objeto Color a partir de un tipo de señal o función.
Color _getColorForVoltage(String voltage) {
  switch (voltage.toLowerCase()) {
    case '+12v':
      return Colors.yellow.shade600; // Amarillo
    case '+5v':
      return Colors.red.shade600; // Rojo
    case '+3.3v':
      return Colors.orange.shade600; // Naranja
    case '-12v':
      return Colors.blue.shade600; // Azul
    case '+5vsb (standby)':
      return Colors.purple.shade600; // Morado
    case 'ground':
      return Colors.black; // Negro
    case 'power good':
      return Colors.grey.shade400; // Gris
    case 'ps_on# (power on)':
      return Colors.green.shade600; // Verde
    case 'nc':
    case 'no conectado':
      return Colors.grey.shade300; // No conectado
    default:
      return Colors.grey.shade100; // Por defecto
  }
}

const List<Map<String, dynamic>> _atxPowerDetails = [
  {
    'section_title': 'Conector ATX Principal (20+4 Pines)',
    'description':
        'Este es el conector más grande y fundamental, suministra energía a la placa base y a muchos de sus componentes integrados. Las fuentes modernas suelen tener un conector de 20 pines más un módulo desmontable de 4 pines para compatibilidad con placas base antiguas (20 pines) y nuevas (24 pines).',
    'image_pinout':
        'assets/images/pinouts/atx_24_pin_pinout.png', // Asume imagen específica
    'table_data': [
      {
        'pin': '1',
        'color': 'Naranja',
        'voltage': '+3.3V',
        'funcion': 'Voltaje para CPU, RAM, chipsets',
      },
      {
        'pin': '2',
        'color': 'Naranja',
        'voltage': '+3.3V',
        'funcion': 'Voltaje para CPU, RAM, chipsets',
      },
      {'pin': '3', 'color': 'Negro', 'voltage': 'Ground', 'funcion': 'Tierra'},
      {
        'pin': '4',
        'color': 'Rojo',
        'voltage': '+5V',
        'funcion': 'Voltaje para chips, unidades, USB',
      },
      {'pin': '5', 'color': 'Negro', 'voltage': 'Ground', 'funcion': 'Tierra'},
      {
        'pin': '6',
        'color': 'Rojo',
        'voltage': '+5V',
        'funcion': 'Voltaje para chips, unidades, USB',
      },
      {'pin': '7', 'color': 'Negro', 'voltage': 'Ground', 'funcion': 'Tierra'},
      {
        'pin': '8',
        'color': 'Gris',
        'voltage': 'Power Good',
        'funcion':
            'Señal de la PSU a la placa base de que los voltajes son estables',
      },
      {
        'pin': '9',
        'color': 'Morado',
        'voltage': '+5VSB (Standby)',
        'funcion':
            'Voltaje constante para funciones de encendido/apagado, USB siempre encendido',
      },
      {
        'pin': '10',
        'color': 'Amarillo',
        'voltage': '+12V',
        'funcion': 'Voltaje para CPU, GPU, motores de unidades',
      },
      {
        'pin': '11',
        'color': 'Naranja',
        'voltage': '+3.3V',
        'funcion': 'Voltaje para CPU, RAM, chipsets',
      },
      {
        'pin': '12',
        'color': 'Azul',
        'voltage': '-12V',
        'funcion': 'Voltaje para puertos serie/paralelo (poco uso hoy)',
      },
      {
        'pin': '13',
        'color': 'Naranja',
        'voltage': '+3.3V',
        'funcion': 'Voltaje para CPU, RAM, chipsets',
      },
      {
        'pin': '14',
        'color': 'Azul claro (o Amarillo)',
        'voltage': '-12V',
        'funcion': 'Voltaje para puertos serie/paralelo (poco uso hoy)',
      }, // A veces es amarillo para +12V en configuraciones 20-pin
      {'pin': '15', 'color': 'Negro', 'voltage': 'Ground', 'funcion': 'Tierra'},
      {'pin': '16', 'color': 'Negro', 'voltage': 'Ground', 'funcion': 'Tierra'},
      {'pin': '17', 'color': 'Negro', 'voltage': 'Ground', 'funcion': 'Tierra'},
      {'pin': '18', 'color': 'Negro', 'voltage': 'Ground', 'funcion': 'Tierra'},
      {'pin': '19', 'color': 'Negro', 'voltage': 'Ground', 'funcion': 'Tierra'},
      {
        'pin': '20',
        'color': 'Naranja',
        'voltage': '+3.3V (o NC en 20-pin)',
        'funcion': 'Voltaje para CPU, RAM, chipsets',
      },
      {
        'pin': '21',
        'color': 'Rojo',
        'voltage': '+5V',
        'funcion': 'Voltaje para chips, unidades, USB',
      },
      {
        'pin': '22',
        'color': 'Rojo',
        'voltage': '+5V',
        'funcion': 'Voltaje para chips, unidades, USB',
      },
      {'pin': '23', 'color': 'Negro', 'voltage': 'Ground', 'funcion': 'Tierra'},
      {
        'pin': '24',
        'color': 'Verde',
        'voltage': 'PS_ON# (Power On)',
        'funcion':
            'Señal de encendido/apagado de la PSU, controlada por la placa base',
      },
    ],
  },
  {
    'section_title': 'Conector de Alimentación de CPU (EPS12V: 4+4 Pines)',
    'description':
        'Este conector proporciona energía exclusivamente al procesador (CPU). Las placas base modernas requieren un conector de 8 pines, mientras que las más antiguas o de menor potencia pueden usar uno de 4 pines. Las fuentes de alimentación a menudo lo ofrecen como un conector "4+4" divisible.',
    'image_pinout':
        'assets/images/pinouts/atx_cpu_8_pin_pinout.png', // Asume imagen específica
    'table_data': [
      {'pin': '1', 'color': 'Negro', 'voltage': 'Ground', 'funcion': 'Tierra'},
      {'pin': '2', 'color': 'Negro', 'voltage': 'Ground', 'funcion': 'Tierra'},
      {'pin': '3', 'color': 'Negro', 'voltage': 'Ground', 'funcion': 'Tierra'},
      {'pin': '4', 'color': 'Negro', 'voltage': 'Ground', 'funcion': 'Tierra'},
      {
        'pin': '5',
        'color': 'Amarillo',
        'voltage': '+12V',
        'funcion': 'Voltaje principal para CPU',
      },
      {
        'pin': '6',
        'color': 'Amarillo',
        'voltage': '+12V',
        'funcion': 'Voltaje principal para CPU',
      },
      {
        'pin': '7',
        'color': 'Amarillo',
        'voltage': '+12V',
        'funcion': 'Voltaje principal para CPU',
      },
      {
        'pin': '8',
        'color': 'Amarillo',
        'voltage': '+12V',
        'funcion': 'Voltaje principal para CPU',
      },
    ],
  },
  {
    'section_title': 'Conector de Alimentación PCIe (6+2 Pines)',
    'description':
        'Diseñado para suministrar energía adicional a tarjetas gráficas de alto rendimiento que requieren más potencia de la que puede proporcionar el slot PCIe de la placa base. También es a menudo divisible para compatibilidad con tarjetas que solo necesitan 6 pines.',
    'image_pinout':
        'assets/images/pinouts/atx_pcie_8_pin_pinout.png', // Asume imagen específica
    'table_data': [
      {'pin': '1', 'color': 'Negro', 'voltage': 'Ground', 'funcion': 'Tierra'},
      {'pin': '2', 'color': 'Negro', 'voltage': 'Ground', 'funcion': 'Tierra'},
      {'pin': '3', 'color': 'Negro', 'voltage': 'Ground', 'funcion': 'Tierra'},
      {
        'pin': '4',
        'color': 'Amarillo',
        'voltage': '+12V',
        'funcion': 'Voltaje principal para GPU',
      },
      {
        'pin': '5',
        'color': 'Amarillo',
        'voltage': '+12V',
        'funcion': 'Voltaje principal para GPU',
      },
      {
        'pin': '6',
        'color': 'Amarillo',
        'voltage': '+12V',
        'funcion': 'Voltaje principal para GPU',
      },
      {
        'pin': '7 (del +2)',
        'color': 'Negro',
        'voltage': 'Ground',
        'funcion': 'Tierra adicional para 8-pin',
      },
      {
        'pin': '8 (del +2)',
        'color': 'Amarillo',
        'voltage': '+12V',
        'funcion': 'Voltaje adicional para 8-pin',
      },
    ],
  },
  {
    'section_title': 'Conector de Alimentación SATA',
    'description':
        'Utilizado para suministrar energía a discos duros SATA, unidades de estado sólido (SSD) y unidades ópticas SATA. Proporciona +3.3V, +5V y +12V.',
    'image_pinout':
        'assets/images/pinouts/atx_sata_power_pinout.png', // Asume imagen específica
    'table_data': [
      {
        'pin': '1',
        'color': 'Naranja',
        'voltage': '+3.3V',
        'funcion':
            'Voltaje para la lógica de la unidad (opcional, no siempre usado)',
      },
      {'pin': '2', 'color': 'Negro', 'voltage': 'Ground', 'funcion': 'Tierra'},
      {
        'pin': '3',
        'color': 'Rojo',
        'voltage': '+5V',
        'funcion': 'Voltaje para la lógica de la unidad',
      },
      {'pin': '4', 'color': 'Negro', 'voltage': 'Ground', 'funcion': 'Tierra'},
      {
        'pin': '5',
        'color': 'Amarillo',
        'voltage': '+12V',
        'funcion': 'Voltaje para el motor de la unidad',
      },
    ],
  },
  {
    'section_title': 'Conector Molex (4 Pines Periféricos)',
    'description':
        'Un conector más antiguo pero aún común para ventiladores, bombas de agua, controladores de LED y algunos discos duros IDE heredados o unidades ópticas. Se le conoce también como "conectores LP4" (Large Peripheral 4-pin).',
    'image_pinout':
        'assets/images/pinouts/atx_molex_pinout.png', // Asume imagen específica
    'table_data': [
      {
        'pin': '1',
        'color': 'Amarillo',
        'voltage': '+12V',
        'funcion': 'Voltaje para motores, iluminación',
      },
      {'pin': '2', 'color': 'Negro', 'voltage': 'Ground', 'funcion': 'Tierra'},
      {'pin': '3', 'color': 'Negro', 'voltage': 'Ground', 'funcion': 'Tierra'},
      {
        'pin': '4',
        'color': 'Rojo',
        'voltage': '+5V',
        'funcion': 'Voltaje para lógica, accesorios',
      },
    ],
  },
  {
    'section_title': 'Compatibilidad y Modularidad de Conectores',
    'description':
        'Las fuentes de alimentación ATX modernas están diseñadas para ofrecer flexibilidad y compatibilidad con una amplia gama de componentes.',
    'list_data': [
      {
        'title': '20+4 Pin (Main ATX)',
        'details':
            'La mayoría de las PSUs ATX modernas tienen un conector principal de 24 pines que puede dividirse en 20+4 pines. Esto permite conectar la PSU a placas base antiguas que solo requieren 20 pines, o a placas base modernas que usan los 24 pines completos.',
      },
      {
        'title': '4+4 Pin (CPU/EPS12V)',
        'details':
            'Similarmente, el conector de la CPU a menudo se divide en dos secciones de 4 pines. Esto permite usar la PSU con CPUs que solo necesitan 4 pines de alimentación (ej. algunos Intel i3/i5 o AMD Ryzen 3/5 de gama baja/media) o los 8 pines completos para CPUs de alto rendimiento.',
      },
      {
        'title': '6+2 Pin (PCIe)',
        'details':
            'Las tarjetas gráficas pueden requerir 6 pines o 8 pines de alimentación PCIe. El diseño "6+2" de las fuentes de alimentación permite que un solo cable y conector se adapte a ambas necesidades, haciendo que la PSU sea compatible con una mayor variedad de GPUs.',
      },
      {
        'title': 'Fuentes Modulares y Semi-Modulares',
        'details':
            'Las PSUs modulares y semi-modulares permiten al usuario conectar solo los cables que necesita, reduciendo el desorden dentro del gabinete y mejorando el flujo de aire. Esto no afecta el pinout en sí, sino la gestión de cables.',
      },
    ],
  },
  {
    'section_title': 'Señales Clave de la Fuente de Alimentación',
    'description':
        'Además de suministrar voltajes, las fuentes de alimentación ATX utilizan señales específicas para comunicarse con la placa base.',
    'list_data': [
      {
        'title': 'PS_ON# (Power On)',
        'details':
            '**Color:** Verde (Pin 24 en conector principal)\nEs la señal que la placa base envía a la fuente de alimentación para encenderla o apagarla. Cuando este pin se pone a tierra (conectado al Negro/Ground), la PSU se enciende. Es el principio detrás de la "prueba del clip" de papel para las PSUs.',
      },
      {
        'title': 'Power Good (PWR_OK)',
        'details':
            '**Color:** Gris (Pin 8 en conector principal)\nUna vez que la fuente de alimentación ha verificado que todos los voltajes de salida están estables y dentro de las tolerancias, envía esta señal a la placa base. La placa base no intentará iniciar el sistema hasta que reciba esta señal. Esto previene arranques inestables o daños a los componentes por voltajes incorrectos.',
      },
      {
        'title': '+5VSB (Standby Voltage)',
        'details':
            '**Color:** Morado (Pin 9 en conector principal)\nEste voltaje está siempre presente cuando la fuente de alimentación está conectada a la corriente, incluso si el PC está "apagado" (en modo de espera). Permite funciones como "Wake-on-LAN", cargar dispositivos USB con el PC apagado y mantener la alimentación del botón de encendido.',
      },
    ],
  },
  {
    'section_title': 'Problemas Comunes y Solución de Problemas',
    'description':
        'Aquí algunas soluciones para problemas típicos relacionados con la fuente de alimentación ATX:',
    'list_data': [
      {
        'title': 'El PC no enciende (sin señal de vida)',
        'details':
            '**Síntomas:** No hay luces, no hay ventiladores, el PC está completamente muerto.\n**Solución:**\n1.  **Interruptor de la PSU:** Asegúrate de que el interruptor físico de la fuente de alimentación esté en la posición "ON" (generalmente "I").\n2.  **Cable de alimentación:** Verifica que el cable de alimentación esté firmemente conectado a la PSU y a una toma de corriente que funcione.\n3.  **Conectores internos:** Revisa que el conector principal de 20/24 pines y el conector de la CPU de 4/8 pines estén bien conectados a la placa base.\n4.  **Botón de encendido:** Asegúrate de que los cables del panel frontal estén correctamente conectados a los pines de la placa base.\n5.  **Prueba del clip (Paperclip Test):** Puedes probar si la PSU enciende fuera del sistema conectando el pin verde (PS_ON#) al pin negro (Ground) con un clip de papel doblado. Si el ventilador de la PSU gira, la PSU al menos tiene energía y el ventilador funciona. Si no, la PSU está probablemente muerta.',
      },
      {
        'title': 'Reinicios aleatorios o cuelgues del sistema',
        'details':
            '**Síntomas:** El PC se reinicia o se apaga inesperadamente, especialmente bajo carga.\n**Solución:**\n1.  **PSU insuficiente/defectuosa:** La fuente de alimentación podría no estar proporcionando suficiente potencia o sus voltajes son inestables bajo carga. Considera una PSU de mayor potencia o probar con otra.\n2.  **Conexiones flojas:** Vuelve a verificar todos los conectores de alimentación a la placa base, CPU, GPU y unidades.\n3.  **Sobrecalentamiento:** Aunque no es directamente un problema de PSU, el sobrecalentamiento de la CPU o GPU puede hacer que el sistema se apague. Verifica las temperaturas. Un ventilador de PSU defectuoso puede contribuir a esto.\n4.  **Cables de extensión/adaptadores:** Evita el uso excesivo de cables de extensión o adaptadores de alimentación PCIe que no estén diseñados para altas cargas.',
      },
      {
        'title': 'Componente específico no funciona (Ej. GPU, HDD)',
        'details':
            '**Síntomas:** El PC enciende, pero una tarjeta gráfica, un disco duro o un ventilador específico no recibe energía o no es detectado.\n**Solución:**\n1.  **Conector específico:** Asegúrate de que el conector de alimentación apropiado (PCIe para GPU, SATA para unidades, Molex para ventiladores/accesorios) esté correctamente conectado.\n2.  **Cableado modular:** Si la PSU es modular, verifica que el cable esté conectado firmemente tanto en el extremo del componente como en el de la fuente de alimentación.\n3.  **Puerto/cable dañado:** Prueba con otro cable de la PSU (si es modular) o con otro puerto de la PSU si está disponible. Inspecciona el puerto del componente en busca de daños.',
      },
    ],
  },
];

class AtxPowerDetailScreen extends StatelessWidget {
  const AtxPowerDetailScreen({super.key});

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
        title: const Text(_atxPowerTitle),
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
              // MODIFICACIÓN: Imagen principal con GestureDetector y Hero
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageViewerScreen(
                        imagePath: _atxPowerImagePath,
                        title: _atxPowerTitle,
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: _atxPowerImagePath, // El tag debe ser único
                  child: Image.asset(_atxPowerImagePath, fit: BoxFit.contain),
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
              _atxPowerDescription,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),
            ..._atxPowerDetails.map((section) {
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
                  // MODIFICACIÓN: Imagenes de pinout en tablas con GestureDetector y Hero
                  if (section.containsKey('image_pinout'))
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
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
                          child: Hero(
                            tag:
                                section['image_pinout']!, // Debe ser único por imagen
                            child: Image.asset(
                              section['image_pinout']!,
                              fit: BoxFit.contain,
                              height: 200, // Ajusta la altura según necesites
                            ),
                          ),
                        ),
                      ),
                    ),
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

    // Ajustamos las columnas para los datos de la fuente ATX
    final List<DataColumn> columns = [
      const DataColumn(
        label: Text('Pin', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      const DataColumn(
        label: Text('Color', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      const DataColumn(
        label: Text('Voltaje', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      const DataColumn(
        label: Text('Función', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    ];

    return SingleChildScrollView(
      // Permite scroll horizontal si la tabla es muy ancha
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
                  _buildColorCell(
                    pinDetail['color']!,
                    context,
                  ), // Utiliza la función para el color
                  _buildSignalTypeCell(
                    pinDetail['voltage']!,
                    context,
                  ), // Reutiliza para el voltaje
                  DataCell(
                    Text(
                      pinDetail['funcion']!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  // Método para construir la celda de tipo de señal con color de fondo (reutilizado para voltaje)
  DataCell _buildSignalTypeCell(String signalType, BuildContext context) {
    final color = _getColorForVoltage(
      signalType,
    ); // Usa la función de color para voltaje
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

  // Nuevo método para construir la celda de color del cable
  DataCell _buildColorCell(String colorName, BuildContext context) {
    final Map<String, Color> cableColors = {
      'Negro': Colors.black,
      'Naranja': Colors.orange.shade600,
      'Rojo': Colors.red.shade600,
      'Amarillo': Colors.yellow.shade600,
      'Azul': Colors.blue.shade600,
      'Morado': Colors.purple.shade600,
      'Gris': Colors.grey.shade600,
      'Verde': Colors.green.shade600,
      'Azul claro': Colors.lightBlue.shade300,
      '--': Colors.grey.shade200, // Para colores no especificados
    };

    final color = cableColors[colorName] ?? Colors.grey.shade200;
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
          colorName,
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
              // MODIFICACIÓN: Imágenes dentro de listas expandibles con GestureDetector y Hero
              if (item.containsKey('image_pinout') &&
                  item['image_pinout'] != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImageViewerScreen(
                              imagePath: item['image_pinout']!,
                              title: item['title']!, // Usa el título del ítem
                            ),
                          ),
                        );
                      },
                      child: Hero(
                        tag: item['image_pinout']!, // Debe ser único por imagen
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
