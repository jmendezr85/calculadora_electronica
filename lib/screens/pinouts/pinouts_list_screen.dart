// lib/screens/pinouts/pinouts_list_screen.dart
import 'package:flutter/material.dart';
import 'package:calculadora_electronica/screens/pinouts/pinout_detail_screen.dart';
import 'package:calculadora_electronica/screens/pinouts/serial_detail_screen.dart';
import 'package:calculadora_electronica/screens/pinouts/parallel_detail_screen.dart';
import 'package:calculadora_electronica/screens/pinouts/ethernet_detail_screen.dart';
import 'package:calculadora_electronica/screens/pinouts/registered_jack_detail_screen.dart';
import 'package:calculadora_electronica/screens/pinouts/scart_detail_screen.dart';
import 'package:calculadora_electronica/screens/pinouts/dvi_detail_screen.dart';
import 'package:calculadora_electronica/screens/pinouts/hdmi_detail_screen.dart';
import 'package:calculadora_electronica/screens/pinouts/displayport_detail_screen.dart';
import 'package:calculadora_electronica/screens/pinouts/vga_detail_screen.dart';
import 'package:calculadora_electronica/screens/pinouts/s_video_detail_screen.dart';
import 'package:calculadora_electronica/screens/pinouts/jack_detail_screen.dart';
import 'package:calculadora_electronica/screens/pinouts/xlr_dmx_detail_screen.dart';
import 'package:calculadora_electronica/screens/pinouts/atx_power_detail_screen.dart';
import 'package:calculadora_electronica/screens/pinouts/eide_ata_sata_detail_screen.dart';
import 'package:calculadora_electronica/screens/pinouts/ps2_at_detail_screen.dart';
import 'package:calculadora_electronica/screens/pinouts/twenty_five_pair_color_code_screen.dart';
import 'package:calculadora_electronica/screens/pinouts/fiber_optic_color_code_screen.dart';
import 'package:calculadora_electronica/screens/pinouts/midi_connector_screen.dart';
import 'package:calculadora_electronica/screens/pinouts/apple_lightning_connector_screen.dart';
import 'package:calculadora_electronica/screens/pinouts/obd_ii_connector_screen.dart';
import 'package:calculadora_electronica/screens/pinouts/iso_connector_screen.dart';
import 'package:calculadora_electronica/screens/pinouts/arduino_uno_board_screen.dart';
import 'package:calculadora_electronica/screens/pinouts/raspberry_pi_board_screen.dart';

class PinoutsListScreen extends StatelessWidget {
  const PinoutsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Lista de pin-outs con su nombre, la ruta de la imagen, descripción y el icono específico
    // NOTA: Para el 'Puerto USB', los detalles ya no se necesitan aquí, se manejan en PinoutDetailScreen.
    final List<Map<String, dynamic>> pinouts = [
      {
        'name': 'Puerto USB',
        'imagePath':
            'assets/images/pinouts/usb_port.png', // Asegúrate de tener esta imagen
        'description':
            'El Universal Serial Bus (USB) es un estándar de la industria que establece especificaciones para la conectividad y las interfaces de alimentación entre los ordenadores y los dispositivos periféricos.', // Descripción general
        'icon': Icons.usb, // Icono de USB
      },
      {
        'name': 'Puerto Serie',
        'imagePath': 'assets/images/pinouts/serial_port.png',
        'description':
            'El puerto serie es una interfaz de comunicación que transmite datos un bit a la vez, secuencialmente. Se utiliza comúnmente para conectar periféricos como módems o ratones antiguos.',
        'icon': Icons.settings_ethernet,
      },
      {
        'name': 'Puerto Paralelo',
        'imagePath': 'assets/images/pinouts/parallel_port.png',
        'description':
            'El puerto paralelo es una interfaz que permite la transmisión de datos de forma simultánea, a diferencia del puerto serie. Se utilizaba principalmente para conectar impresoras, escáneres y otros periféricos que requerían una alta velocidad de transferencia de datos en su momento.',
        'icon': Icons.print,
      },
      {
        'name': 'Puerto Ethernet',
        'imagePath': 'assets/images/pinouts/ethernet_port.png',
        'description':
            'El puerto Ethernet es una interfaz de red que permite a los dispositivos conectarse a una red de área local (LAN) o a Internet mediante un cable Ethernet. Es el estándar más común para conexiones de red por cable.',
        'icon': Icons.router,
      },
      {
        'name': 'Jack Registrado',
        'imagePath': 'assets/images/pinouts/registered_jack.png',
        'description':
            'Los jacks registrados (RJ) son un tipo de conector estandarizado utilizado para la interconexión de equipos de telecomunicaciones. Los más comunes son RJ-11 para teléfonos y RJ-45 para redes Ethernet.',
        'icon': Icons.phone,
      },
      {
        'name': 'Conector SCART',
        'imagePath': 'assets/images/pinouts/scart_connector.png',
        'description':
            'SCART (Syndicat des Constructeurs d\'Appareils Radiorécepteurs et Téléviseurs) es un estándar de conexión de audio y video analógico popular en Europa, utilizado principalmente para conectar equipos como reproductores de DVD, decodificadores y videoconsolas a televisores.',
        'icon': Icons.tv,
      },
      {
        'name': 'Conector DVI',
        'imagePath': 'assets/images/pinouts/dvi_connector.png',
        'description':
            'DVI (Digital Visual Interface) es una interfaz de video diseñada para maximizar la calidad visual de las pantallas digitales, como los monitores LCD y los proyectores de video. Permite la transmisión de video digital (y en algunas versiones, analógico) sin pérdidas.',
        'icon': Icons.monitor,
      },
      {
        'name': 'Conector HDMI',
        'imagePath': 'assets/images/pinouts/hdmi_connector.png',
        'description':
            'HDMI (High-Definition Multimedia Interface) es una interfaz digital que combina video de alta definición y audio multicanal en un solo cable. Es el estándar actual para conectar televisores, reproductores Blu-ray, consolas de videojuegos y otros dispositivos multimedia.',
        'icon': Icons.hd,
      },
      {
        'name': 'Pinout Display Port',
        'imagePath': 'assets/images/pinouts/display_port_pinout.png',
        'description':
            'DisplayPort es una interfaz de pantalla digital desarrollada por la Video Electronics Standards Association (VESA). Se utiliza para transmitir video y audio digital, y a menudo se encuentra en computadoras, monitores y tarjetas gráficas, ofreciendo un alto ancho de banda.',
        'icon': Icons.desktop_windows,
      },
      {
        'name': 'Conector VGA',
        'imagePath': 'assets/images/pinouts/vga_connector.png',
        'description':
            'VGA (Video Graphics Array) es un estándar de pantalla analógico muy popular que se utilizó ampliamente en ordenadores personales. Transmite señales de video analógicas y aún se encuentra en muchos monitores y proyectores antiguos.',
        'icon': Icons.videocam,
      },
      {
        'name': 'Conector S-Video',
        'imagePath': 'assets/images/pinouts/s_video_connector.png',
        'description':
            'S-Video (Separate Video) es un estándar de video analógico que transmite la señal de luminancia (brillo) y crominancia (color) por separado, lo que ofrece una mejor calidad de imagen que el video compuesto tradicional.',
        'icon': Icons.videogame_asset,
      },
      {
        'name': 'Conector Jack',
        'imagePath': 'assets/images/pinouts/jack_connector.png',
        'description':
            'Los conectores jack (también conocidos como TS o TRS) son ampliamente utilizados para la transmisión de señales de audio. Los tamaños más comunes son 3.5mm (auriculares) y 6.35mm (instrumentos musicales).',
        'icon': Icons.headphones,
      },
      {
        'name': 'Conector XLR y DMX',
        'imagePath': 'assets/images/pinouts/xlr_dmx_connectors.png',
        'description':
            'Los conectores XLR se utilizan principalmente en equipos de audio profesional para señales de micrófono balanceadas, mientras que los conectores DMX (usan la misma forma física XLR) se emplean para el control de iluminación de escenarios y efectos.',
        'icon': Icons.mic,
      },
      {
        'name': 'Conectores de alimentación ATX',
        'imagePath': 'assets/images/pinouts/atx_power_connectors.png',
        'description':
            'Los conectores de alimentación ATX son los principales conectores de la fuente de poder de una computadora, suministrando energía a la placa base, CPU, tarjetas gráficas y otros componentes.',
        'icon': Icons.power,
      },
      {
        'name': 'EIDE / ATA - SATA',
        'imagePath': 'assets/images/pinouts/eide_ata_sata.png',
        'description':
            'EIDE/ATA (Enhanced Integrated Drive Electronics / Advanced Technology Attachment) y SATA (Serial ATA) son estándares de interfaz para conectar dispositivos de almacenamiento como discos duros y unidades ópticas a la placa base de una computadora. SATA es el estándar más moderno y rápido.',
        'icon': Icons.storage,
      },
      {
        'name': 'Conectores PS/2-AT',
        'imagePath': 'assets/images/pinouts/ps2_at_connectors.png',
        'description':
            'Los conectores PS/2 y AT se usaban en computadoras para teclados y ratones. PS/2 es un estándar más reciente que AT, aunque ambos han sido ampliamente reemplazados por USB.',
        'icon': Icons.keyboard,
      },
      {
        'name': 'Código de colores de cables de 25 pares',
        'imagePath': 'assets/images/pinouts/25_pair_cable_color_code.png',
        'description':
            'Este código de colores se utiliza para identificar pares de cables individuales dentro de un cable multipar de 25 pares, comúnmente empleado en telecomunicaciones y cableado estructurado.',
        'icon': Icons.cable,
      },
      {
        'name': 'Código de colores para cables de fibra óptica',
        'imagePath': 'assets/images/pinouts/fiber_optic_cable_color_code.png',
        'description':
            'El código de colores para cables de fibra óptica se utiliza para identificar fibras individuales y grupos de fibras dentro de un cable de fibra óptica, facilitando la instalación y el mantenimiento.',
        'icon': Icons.lightbulb,
      },
      {
        'name': 'Conector MIDI',
        'imagePath': 'assets/images/pinouts/midi_connector.png',
        'description':
            'MIDI (Musical Instrument Digital Interface) es un protocolo estándar que permite a los instrumentos musicales electrónicos, ordenadores y otros dispositivos comunicarse y sincronizarse. El conector MIDI es un conector DIN de 5 pines.',
        'icon': Icons.music_note,
      },
      {
        'name': 'Conector Apple Lightning',
        'imagePath': 'assets/images/pinouts/apple_lightning_connector.png',
        'description':
            'El conector Lightning es una interfaz de bus de ordenador y alimentación patentada por Apple, utilizada para conectar dispositivos móviles como iPhones y iPads. Es un conector más compacto y reversible que su predecesor de 30 pines.',
        'icon': Icons.phone_iphone,
      },
      {
        'name': 'Pinout Conector de auto OBD-II',
        'imagePath': 'assets/images/pinouts/obd2_auto_connector_pinout.png',
        'description':
            'El conector OBD-II (On-Board Diagnostics II) es un puerto estandarizado que se encuentra en la mayoría de los vehículos modernos. Permite a los técnicos y dispositivos externos acceder a la información de diagnóstico del vehículo, como códigos de error del motor.',
        'icon': Icons.directions_car,
      },
      {
        'name': 'Conector ISO para estereos de automovil.',
        'imagePath': 'assets/images/pinouts/iso_car_stereo_connector.png',
        'description':
            'El conector ISO para estéreos de automóvil es un estándar internacional que facilita la instalación de radios de coche. Consta de varios conectores que suministran alimentación, tierra, y señales de audio a los altavoces.',
        'icon': Icons.radio,
      },
      {
        'name': 'Arduino Uno board',
        'imagePath': 'assets/images/pinouts/arduino_uno_board.png',
        'description':
            'El Arduino Uno es una popular placa de desarrollo de microcontroladores de código abierto. Este pinout muestra la disposición de sus pines digitales, analógicos, de alimentación y de comunicación, esenciales para el diseño y conexión de proyectos electrónicos.',
        'icon': Icons.developer_board,
      },
      {'name': 'Pinout de la placa Raspberry Pi', 'icon': Icons.computer},
    ];

    final List<Color> iconPalette = [
      Colors.blueAccent,
      Colors.green,
      Colors.orange,
      Colors.pink,
      Colors.teal,
      Colors.redAccent,
      Colors.amber,
      Colors.cyan,
      Colors.lightGreen,
      Colors.deepOrangeAccent,
      Colors.indigoAccent,
      Colors.lime,
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('PIN-OUTS'),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: pinouts.length,
        itemBuilder: (context, index) {
          final pinout = pinouts[index];
          final iconColor = iconPalette[index % iconPalette.length];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () {
                // Si la tarjeta es el 'Puerto USB', navega a PinoutDetailScreen
                // sin pasar parámetros, ya que ahora PinoutDetailScreen contiene sus propios datos.
                if (pinout['name'] == 'Puerto USB') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const PinoutDetailScreen(), // No se pasan parámetros
                    ),
                  );
                } else if (pinout['name'] == 'Puerto Serie') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SerialDetailScreen(),
                    ),
                  );
                } else if (pinout['name'] == 'Puerto Paralelo') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ParallelDetailScreen(),
                    ),
                  );
                } else if (pinout['name'] == 'Puerto Ethernet') {
                  // <- Nueva condición
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EthernetDetailScreen(),
                    ),
                  );
                } else if (pinout['name'] == 'Jack Registrado') {
                  // <- Nueva condición para Jack Registrado
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisteredJackDetailScreen(),
                    ),
                  );
                } else if (pinout['name'] == 'Conector SCART') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ScartDetailScreen(),
                    ),
                  );
                } else if (pinout['name'] == 'Conector DVI') {
                  // ¡NUEVO! Lógica para DVI
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DVIDetailScreen(),
                    ),
                  );
                } else if (pinout['name'] == 'Conector HDMI') {
                  // ¡NUEVO! Lógica para HDMI
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HDMIDetailScreen(),
                    ),
                  );
                } else if (pinout['name'] == 'Pinout Display Port') {
                  // ¡NUEVO! Lógica para DisplayPort
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DisplayPortDetailScreen(),
                    ),
                  );
                } else if (pinout['name'] == 'Conector VGA') {
                  // ¡NUEVO! Lógica para VGA
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VGADetailScreen(),
                    ),
                  );
                } else if (pinout['name'] == 'Conector S-Video') {
                  // ¡NUEVO! Lógica para S-Video
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SVideoDetailScreen(),
                    ),
                  );
                } else if (pinout['name'] == 'Conector Jack') {
                  // ¡NUEVO! Lógica para Conector Jack
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const JackDetailScreen(),
                    ),
                  );
                } else if (pinout['name'] == 'Conector XLR y DMX') {
                  // ¡NUEVO! Lógica para Conector XLR y DMX
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const XlrDmxDetailScreen(),
                    ),
                  );
                } else if (pinout['name'] == 'Conectores de alimentación ATX') {
                  // ¡NUEVO! Lógica para Conectores de Alimentación ATX
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AtxPowerDetailScreen(),
                    ),
                  );
                } else if (pinout['name'] == 'EIDE / ATA - SATA') {
                  // ¡NUEVO! Lógica para Conectores EIDE/ATA y SATA
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EideAtaSataDetailScreen(),
                    ),
                  );
                } else if (pinout['name'] == 'Conectores PS/2-AT') {
                  // ¡NUEVO! Lógica para Conectores PS/2 y AT
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Ps2AtDetailScreen(),
                    ),
                  );
                } else if (pinout['name'] ==
                    'Código de colores de cables de 25 pares') {
                  // ¡NUEVO! Lógica para el código de colores de 25 pares
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const TwentyFivePairColorCodeScreen(),
                    ),
                  );
                } else if (pinout['name'] ==
                    'Código de colores para cables de fibra óptica') {
                  // ¡NUEVO! Lógica para el código de colores de fibra óptica
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FiberOpticColorCodeScreen(),
                    ),
                  );
                } else if (pinout['name'] == 'Conector MIDI') {
                  // ¡NUEVO! Lógica para el conector MIDI
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MidiConnectorScreen(),
                    ),
                  );
                } else if (pinout['name'] == 'Conector Apple Lightning') {
                  // ¡NUEVO! Lógica para el conector Lightning
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const AppleLightningConnectorScreen(),
                    ),
                  );
                } else if (pinout['name'] == 'Pinout Conector de auto OBD-II') {
                  // ¡NUEVO! Lógica para el conector OBD-II
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ObdIiConnectorScreen(),
                    ),
                  );
                } else if (pinout['name'] ==
                    'Conector ISO para estereos de automovil.') {
                  // ¡NUEVO! Lógica para el conector ISO
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const IsoConnectorScreen(),
                    ),
                  );
                } else if (pinout['name'] == 'Arduino Uno board') {
                  // ¡NUEVO! Lógica para la placa Arduino Uno
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ArduinoUnoBoardScreen(),
                    ),
                  );
                } else if (pinout['name'] ==
                    'Pinout de la placa Raspberry Pi') {
                  // ¡NUEVO! Lógica para la placa Raspberry Pi
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RaspberryPiBoardScreen(),
                    ),
                  );
                } else {
                  // Para otras tarjetas, como PinoutDetailScreen ahora es específico para USB,
                  // se muestra un mensaje. Si quisieras pantallas de detalle para cada puerto,
                  // necesitarías crear un archivo de detalle por cada uno, o volver a un enfoque genérico.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Detalles para ${pinout['name']} no disponibles aún en una pantalla dedicada.',
                      ),
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      pinout['icon'] as IconData,
                      color: iconColor,
                      size: 28,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        pinout['name']!,
                        style: Theme.of(context).textTheme.titleMedium,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.chevron_right,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
