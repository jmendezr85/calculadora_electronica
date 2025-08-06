// lib/screens/pinouts/ethernet_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:calculadora_electronica/screens/image_viewer_screen.dart'; // ¡NUEVO! Importa la pantalla de visualización de imagen

const String _ethernetTitle = 'Puerto y Estándares Ethernet (RJ45)';
const String _ethernetImagePath = 'assets/images/pinouts/ethernet_port.png';
const String _ethernetDescription =
    'El puerto Ethernet (RJ45) es el conector estándar para la interconexión de redes cableadas, especialmente en el ámbito de las Redes de Área Local (LAN). Utiliza el protocolo IEEE 802.3, que define las reglas para la comunicación de datos. Desde sus inicios con velocidades de 10 Mbps sobre cable coaxial, Ethernet ha evolucionado significativamente para soportar velocidades de hasta 100 Gbps o más sobre par trenzado y fibra óptica, convirtiéndose en la columna vertebral de la infraestructura de red moderna en hogares y empresas. Su fiabilidad, rendimiento y compatibilidad lo hacen indispensable para la transmisión de voz, video y datos.';

// Función auxiliar para obtener el objeto Color o lista de Colores a partir de un nombre de color.
// El primer color será el base, el segundo (si existe) será la franja.
List<Color> _getColorsForCable(String colorName) {
  switch (colorName.toLowerCase()) {
    case 'negro':
      return [Colors.black];
    case 'rojo':
      return [Colors.red];
    case 'verde':
      return [Colors.green];
    case 'amarillo':
      return [Colors.yellow];
    case 'blanco/naranja':
      return [Colors.white, Colors.orange]; // Base: Blanco, Franja: Naranja
    case 'naranja':
      return [Colors.orange];
    case 'blanco/verde':
      return [Colors.white, Colors.green]; // Base: Blanco, Franja: Verde
    case 'azul':
      return [Colors.blue];
    case 'blanco/azul':
      return [Colors.white, Colors.blue]; // Base: Blanco, Franja: Azul
    case 'blanco/marrón':
      return [Colors.white, Colors.brown]; // Base: Blanco, Franja: Marrón
    case 'marrón':
      return [Colors.brown];
    case 'no usado':
    case 'no conectado':
    case '--': // Para RJ11 NC
      return [
        Colors.grey.shade300,
      ]; // Color por defecto para "No usado" o desconocido
    default:
      return [
        Colors.grey.shade300,
      ]; // En caso de cualquier otro texto no reconocido
  }
}

const List<Map<String, dynamic>> _ethernetDetails = [
  {
    'section_title': 'Cableado Estándar (T568A vs. T568B)',
    'description':
        'Existen dos estándares principales para el cableado de pares trenzados UTP (Unshielded Twisted Pair) con conectores RJ45: T568A y T568B. Ambos definen el orden de los colores de los cables dentro del conector. Aunque difieren en el orden de los pares naranja y verde, funcionalmente son idénticos si se usan de forma consistente en ambos extremos. El estándar T568B es el más común en Estados Unidos y a nivel mundial para nuevas instalaciones.',
    'table_data': [
      {
        'pin': '1',
        't568a': 'Blanco/Verde',
        't568b': 'Blanco/Naranja',
        'funcion': 'TX+ (Transmisión +)',
      },
      {
        'pin': '2',
        't568a': 'Verde',
        't568b': 'Naranja',
        'funcion': 'TX- (Transmisión -)',
      },
      {
        'pin': '3',
        't568a': 'Blanco/Naranja',
        't568b': 'Blanco/Verde',
        'funcion': 'RX+ (Recepción +)',
      },
      {
        'pin': '4',
        't568a': 'Azul',
        't568b': 'Azul',
        'funcion': 'No usado (BI_D+ para Gigabit)',
      },
      {
        'pin': '5',
        't568a': 'Blanco/Azul',
        't568b': 'Blanco/Azul',
        'funcion': 'No usado (BI_D- para Gigabit)',
      },
      {
        'pin': '6',
        't568a': 'Naranja',
        't568b': 'Verde',
        'funcion': 'RX- (Recepción -)',
      },
      {
        'pin': '7',
        't568a': 'Blanco/Marrón',
        't568b': 'Blanco/Marrón',
        'funcion': 'No usado (BI_C+ para Gigabit)',
      },
      {
        'pin': '8',
        't568a': 'Marrón',
        't568b': 'Marrón',
        'funcion': 'No usado (BI_C- para Gigabit)',
      },
    ],
  },
  {
    'section_title': 'Tipos de Cables Ethernet (Categorías y Rendimiento)',
    'description':
        'Los cables Ethernet se clasifican en categorías (Cat) según su rendimiento, velocidad de datos, ancho de banda y capacidad para reducir la diafonía y el ruido. Las categorías más comunes son:',
    'table_data': [
      {
        'tipo': 'Cat5e',
        'velocidad': '1 Gbps',
        'ancho_banda': '100 MHz',
        'distancia_max': '100m',
        'uso': 'Redes domésticas y pequeñas oficinas. Estándar común.',
      },
      {
        'tipo': 'Cat6',
        'velocidad': '1 Gbps (hasta 10 Gbps en 55m)',
        'ancho_banda': '250 MHz',
        'distancia_max': '100m',
        'uso':
            'Mejora la Cat5e, ideal para juegos y streaming. Reduce interferencias.',
      },
      {
        'tipo': 'Cat6a',
        'velocidad': '10 Gbps',
        'ancho_banda': '500 MHz',
        'distancia_max': '100m',
        'uso': 'Entornos empresariales, centros de datos. Mejor blindaje.',
      },
      {
        'tipo': 'Cat7',
        'velocidad': '10 Gbps',
        'ancho_banda': '600 MHz',
        'distancia_max': '100m',
        'uso':
            'Alto rendimiento, blindaje individual por par. Para entornos de alta interferencia.',
      },
      {
        'tipo': 'Cat7a',
        'velocidad': '10 Gbps (soporte futuro 40/100 Gbps)',
        'ancho_banda': '1000 MHz',
        'distancia_max': '100m',
        'uso':
            'Versión mejorada de Cat7 con mayor frecuencia. Uso especializado.',
      },
      {
        'tipo': 'Cat8',
        'velocidad': '25/40 Gbps',
        'ancho_banda': '2000 MHz',
        'distancia_max': '30m',
        'uso':
            'Centros de datos y aplicaciones de alta velocidad en distancias cortas.',
      },
    ],
  },
  {
    'section_title': 'Power over Ethernet (PoE) y sus Estándares',
    'description':
        'PoE permite transmitir datos y energía eléctrica a través de un único cable Ethernet, simplificando la instalación de dispositivos como cámaras IP, teléfonos VoIP y puntos de acceso inalámbricos al eliminar la necesidad de tomas de corriente cercanas. Los estándares principales son:',
    'list_data': [
      {
        'title': 'IEEE 802.3af (PoE)',
        'details':
            'Potencia máxima: 15.4W en el puerto de origen (PSE), 12.95W en el dispositivo (PD). Suficiente para teléfonos IP básicos y puntos de acceso ligeros. Utiliza solo 2 de los 4 pares trenzados para la energía.',
      },
      {
        'title': 'IEEE 802.3at (PoE+)',
        'details':
            'Potencia máxima: 30W en el PSE, 25.5W en el PD. Permite alimentar dispositivos de mayor consumo como cámaras PTZ, puntos de acceso avanzados y terminales de punto de venta. También utiliza 2 pares.',
      },
      {
        'title': 'IEEE 802.3bt (PoE++ / 4PPoE)',
        'details':
            'Define dos tipos: Tipo 3 (60W en PSE, 51W en PD) y Tipo 4 (100W en PSE, 71W en PD). Utiliza los 4 pares trenzados para la transmisión de energía, lo que permite un suministro significativamente mayor. Ideal para iluminación LED, monitores y sistemas de videovigilancia avanzados.',
      },
    ],
  },
  {
    'section_title': 'Problemas Comunes y Solución de Problemas',
    'description':
        'Los problemas con las conexiones Ethernet pueden ser frustrantes, pero muchos tienen soluciones sencillas. Aquí se describen algunos síntomas y pasos básicos para la resolución:',
    'list_data': [
      {
        'title': 'No hay conexión a Internet / Red no identificada',
        'details':
            '**Síntomas:** Icono de Ethernet con una X roja, mensaje "Sin Internet" o "Red no identificada".\n**Solución:**\n1. Verificar el cable: Asegurarse de que el cable RJ45 esté firmemente conectado en ambos extremos (computadora/dispositivo y router/switch). Inspeccionar el cable en busca de daños visibles (cortes, dobleces). Probar con otro cable si es posible.\n2. Reiniciar equipos: Apagar y encender el router, el módem y el dispositivo. Esperar unos minutos para que se inicien completamente.\n3. Verificar luces del puerto: Las luces LED en el puerto Ethernet del dispositivo y del router/switch deben estar encendidas o parpadeando (indicando actividad).\n4. Configuración de red (SO): En Windows/macOS/Linux, verificar que el adaptador Ethernet esté habilitado y configurado para obtener IP automáticamente (DHCP).',
      },
      {
        'title': 'Desconexiones frecuentes / Velocidad lenta',
        'details':
            '**Síntomas:** La conexión se cae aleatoriamente, velocidad de descarga/subida por debajo de lo esperado.\n**Solución:**\n1. Interferencias: Alejar el cable Ethernet de fuentes de interferencia electromagnética (cables eléctricos de alta tensión, microondas, motores).\n2. Cable dañado o de baja categoría: Un cable antiguo o dañado, o uno de categoría inferior a la necesaria (ej. Cat5 en red Gigabit), puede causar problemas de rendimiento. Reemplazar si es necesario.\n3. Controladores de red: Actualizar los controladores del adaptador de red en el dispositivo.\n4. Congestión de red: Demasiados dispositivos usando la red simultáneamente o un switch/router antiguo pueden causar cuellos de botella.',
      },
      {
        'title': 'No hay luces intermitentes en el puerto Ethernet',
        'details':
            '**Síntomas:** Los LEDs del puerto Ethernet están completamente apagados.\n**Solución:**\n1. Cable desconectado o defectuoso: Revisar conexión y probar con otro cable.\n2. Adaptador de red deshabilitado: Verificar en la configuración del sistema operativo (Administrador de Dispositivos en Windows) que el adaptador Ethernet esté habilitado.\n3. Problema de hardware: Si los pasos anteriores no funcionan, podría ser un fallo del puerto Ethernet en el dispositivo o en el router/switch.',
      },
    ],
  },
  {
    'section_title': 'Mejores Prácticas de Cableado Ethernet',
    'description':
        'Un cableado bien planificado y ejecutado es crucial para el rendimiento y la fiabilidad de la red. Considere estas mejores prácticas:',
    'list_data': [
      {
        'title': 'Planificación',
        'details':
            'Diseñar la red considerando la ubicación de dispositivos, la longitud de los cables y futuras expansiones. Usar cables de la categoría adecuada para la velocidad y distancia requeridas.',
      },
      {
        'title': 'Calidad del Cable y Conectores',
        'details':
            'Invertir en cables de cobre puro y conectores certificados. Evitar cables CCA (Copper Clad Aluminum) ya que tienen peor rendimiento y son menos duraderos.',
      },
      {
        'title': 'Manejo Correcto del Cable',
        'details':
            '**Evitar dobleces agudos:** No doblar los cables en ángulos menores a su radio de curvatura mínimo (generalmente 4-8 veces el diámetro del cable).\n**Evitar tensión excesiva:** No tirar de los cables con demasiada fuerza durante la instalación para no dañar los pares trenzados internos.\n**Organización:** Utilizar bridas, canaletas y paneles de parcheo para organizar y proteger los cables, evitando enredos y facilitando el mantenimiento.',
      },
      {
        'title': 'Evitar Interferencias',
        'details':
            'Mantener los cables Ethernet alejados de fuentes de interferencia electromagnética (EMI) como cables de alimentación eléctrica, transformadores, luces fluorescentes y motores. Idealmente, mantener una distancia mínima de 30 cm (12 pulgadas).',
      },
      {
        'title': 'Etiquetado',
        'details':
            'Etiquetar claramente ambos extremos de cada cable. Esto es fundamental para la solución de problemas, el mantenimiento y futuras modificaciones de la red.',
      },
      {
        'title': 'Pruebas y Certificación',
        'details':
            'Después de la instalación, realizar pruebas de continuidad, longitud, diafonía (crosstalk) y pérdida de inserción para asegurar que el cableado cumple con los estándares y el rendimiento esperado.',
      },
    ],
  },
];

class EthernetDetailScreen extends StatelessWidget {
  const EthernetDetailScreen({super.key});

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
        title: const Text(_ethernetTitle),
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
              tag: _ethernetImagePath, // El tag debe ser único
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ImageViewerScreen(
                        imagePath: _ethernetImagePath,
                        title:
                            _ethernetTitle, // Pasa el título para la pantalla de zoom
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
                  child: Image.asset(_ethernetImagePath, fit: BoxFit.contain),
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
              _ethernetDescription,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),
            ..._ethernetDetails.map((section) {
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

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 16, // Espaciado entre columnas
        dataRowMinHeight: 40, // Altura mínima de fila de datos
        dataRowMaxHeight: 60, // Altura máxima de fila de datos
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(
            8,
          ), // Bordes redondeados para toda la tabla
        ),
        headingRowColor: WidgetStateProperty.all(colorScheme.primaryContainer),
        border: TableBorder.all(
          color: colorScheme.outlineVariant,
          width: 1,
          borderRadius: BorderRadius.circular(8),
        ),
        columns: _buildColumns(sectionTitle),
        rows: data
            .map(
              (item) => DataRow(
                color: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) =>
                      states.contains(WidgetState.hovered) ? hoverColor : null,
                ),
                cells: _buildCells(item, sectionTitle, context),
              ),
            )
            .toList(),
      ),
    );
  }

  List<DataColumn> _buildColumns(String sectionTitle) {
    if (sectionTitle.contains('T568')) {
      return const [
        DataColumn(
          label: Expanded(
            child: Text('Pin', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text('T568A', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text('T568B', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Función',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ];
    } else if (sectionTitle.contains('Categorías')) {
      return const [
        DataColumn(
          label: Expanded(
            child: Text('Tipo', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Velocidad',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Ancho Banda',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Dist. Max',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Uso Típico',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ];
    }
    return []; // Devolver una lista vacía por defecto
  }

  List<DataCell> _buildCells(
    dynamic item,
    String sectionTitle,
    BuildContext context,
  ) {
    if (sectionTitle.contains('T568')) {
      return [
        DataCell(Text(item['pin']!)),
        _buildColorCell(item['t568a']!, context),
        _buildColorCell(item['t568b']!, context),
        DataCell(
          Text(item['funcion']!, maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
      ];
    } else if (sectionTitle.contains('Categorías')) {
      return [
        DataCell(Text(item['tipo']!)),
        DataCell(Text(item['velocidad']!)),
        DataCell(Text(item['ancho_banda']!)),
        DataCell(Text(item['distancia_max']!)),
        DataCell(
          Text(item['uso']!, maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
      ];
    }
    return []; // Devolver una lista vacía por defecto
  }

  // Método para construir la celda de color con aspecto de cable
  DataCell _buildColorCell(String colorName, BuildContext context) {
    final pinColors = _getColorsForCable(colorName);
    final baseColor = pinColors[0];
    final stripeColor = pinColors.length > 1 ? pinColors[1] : null;

    final textColor = baseColor.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;

    return DataCell(
      Container(
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade400, width: 0.5),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (stripeColor != null)
              Container(
                width: 8,
                decoration: BoxDecoration(
                  color: stripeColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            Text(
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
          ],
        ),
      ),
    );
  }

  // Nuevo método para construir listas expandibles para información detallada
  Widget _buildExpandableList(
    List<Map<String, String>> data,
    BuildContext context,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final baseColor = colorScheme.surfaceContainerHighest;

    // Usar las propiedades 'a', 'r', 'g', 'b' (normalizadas de 0.0 a 1.0) y convertirlas a int (0-255)
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
              (convertedAlpha * 0.3)
                  .round(), // Multiplicamos por 0.3 para reducir la opacidad
              convertedRed,
              convertedGreen,
              convertedBlue,
            ),
            backgroundColor: Color.fromARGB(
              (convertedAlpha * 0.5)
                  .round(), // Multiplicamos por 0.5 para una opacidad ligeramente mayor
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
