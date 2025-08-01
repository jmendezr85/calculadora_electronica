// lib/screens/pinouts/dvi_detail_screen.dart
import 'package:flutter/material.dart';

const String _dviTitle = 'Conector DVI (Digital Visual Interface)';
const String _dviImagePath =
    'assets/images/pinouts/dvi_connector.png'; // Asume que tienes una imagen DVI
const String _dviDescription =
    'El conector DVI (Digital Visual Interface) es un estándar de interfaz de video diseñado para transmitir video digital sin comprimir a un dispositivo de visualización, como un monitor de computadora. Fue desarrollado para reemplazar el estándar VGA analógico y proporcionar una conexión de mayor calidad para pantallas digitales. DVI es versátil, ya que puede transmitir solo señales digitales (DVI-D), solo señales analógicas (DVI-A) o una combinación de ambas (DVI-I), lo que permitió una transición más suave de las tecnologías analógicas a las digitales.';

// Función auxiliar para obtener el objeto Color a partir de un tipo de señal o función.
Color _getColorForSignalType(String type) {
  switch (type.toLowerCase()) {
    case 'digital rgb':
    case 'digital data':
      return Colors.blue.shade200; // Señales digitales de video
    case 'analog rgb':
      return Colors.green.shade200; // Señales analógicas de video
    case 'ground':
      return Colors.grey.shade600; // Tierra
    case 'power':
      return Colors.red.shade200; // Alimentación
    case 'hot plug detect':
      return Colors.orange.shade200; // Detección de conexión
    case 'clock':
      return Colors.purple.shade200; // Señal de reloj
    case 'no conectado':
    case 'nc':
      return Colors.grey.shade300; // No conectado
    default:
      return Colors.grey.shade100; // Por defecto
  }
}

const List<Map<String, dynamic>> _dviDetails = [
  {
    'section_title': 'Tipos de Conectores DVI y sus Pines',
    'description':
        'Existen varios tipos de conectores DVI, cada uno con una configuración de pines ligeramente diferente para soportar distintas combinaciones de señales digitales y analógicas:',
    'table_data': [
      {
        'tipo': 'DVI-D Single Link',
        'pines': '18+1',
        'descripcion':
            'Solo digital. Soporta resoluciones hasta 1920x1200 @ 60Hz.',
        'imagen_pinout':
            'assets/images/pinouts/dvi_d_single_link.png', // Asume imágenes específicas
        'pin_details': [
          {'pin': '1', 'funcion': 'TMDS Data2-', 'tipo_senal': 'Digital Data'},
          {'pin': '2', 'funcion': 'TMDS Data2+', 'tipo_senal': 'Digital Data'},
          {
            'pin': '3',
            'funcion': 'TMDS Data2/4 Shield',
            'tipo_senal': 'Ground',
          },
          {
            'pin': '4',
            'funcion': 'NC (Digital Data4-)',
            'tipo_senal': 'No Conectado',
          },
          {
            'pin': '5',
            'funcion': 'NC (Digital Data4+)',
            'tipo_senal': 'No Conectado',
          },
          {'pin': '6', 'funcion': 'DDC Clock', 'tipo_senal': 'Data/Control'},
          {'pin': '7', 'funcion': 'DDC Data', 'tipo_senal': 'Data/Control'},
          {'pin': '8', 'funcion': 'Analog VSYNC', 'tipo_senal': 'No Conectado'},
          {'pin': '9', 'funcion': 'TMDS Data1-', 'tipo_senal': 'Digital Data'},
          {'pin': '10', 'funcion': 'TMDS Data1+', 'tipo_senal': 'Digital Data'},
          {
            'pin': '11',
            'funcion': 'TMDS Data1/3 Shield',
            'tipo_senal': 'Ground',
          },
          {
            'pin': '12',
            'funcion': 'NC (Digital Data3-)',
            'tipo_senal': 'No Conectado',
          },
          {
            'pin': '13',
            'funcion': 'NC (Digital Data3+)',
            'tipo_senal': 'No Conectado',
          },
          {'pin': '14', 'funcion': '+5V Power', 'tipo_senal': 'Power'},
          {'pin': '15', 'funcion': 'Ground (for +5V)', 'tipo_senal': 'Ground'},
          {
            'pin': '16',
            'funcion': 'Hot Plug Detect',
            'tipo_senal': 'Hot Plug Detect',
          },
          {'pin': '17', 'funcion': 'TMDS Data0-', 'tipo_senal': 'Digital Data'},
          {'pin': '18', 'funcion': 'TMDS Data0+', 'tipo_senal': 'Digital Data'},
          {
            'pin': '19',
            'funcion': 'TMDS Data0/5 Shield',
            'tipo_senal': 'Ground',
          },
          {
            'pin': '20',
            'funcion': 'NC (Digital Data5-)',
            'tipo_senal': 'No Conectado',
          },
          {
            'pin': '21',
            'funcion': 'NC (Digital Data5+)',
            'tipo_senal': 'No Conectado',
          },
          {
            'pin': 'C1',
            'funcion': 'NC (Analog Red)',
            'tipo_senal': 'No Conectado',
          },
          {
            'pin': 'C2',
            'funcion': 'NC (Analog Green)',
            'tipo_senal': 'No Conectado',
          },
          {
            'pin': 'C3',
            'funcion': 'NC (Analog Blue)',
            'tipo_senal': 'No Conectado',
          },
          {
            'pin': 'C4',
            'funcion': 'NC (Analog HSYNC)',
            'tipo_senal': 'No Conectado',
          },
          {
            'pin': 'C5',
            'funcion': 'Analog Ground',
            'tipo_senal': 'No Conectado',
          },
        ],
      },
      {
        'tipo': 'DVI-D Dual Link',
        'pines': '24+1',
        'descripcion':
            'Solo digital. Soporta resoluciones muy altas, hasta 2560x1600 @ 60Hz o 1920x1080 @ 120Hz.',
        'imagen_pinout': 'assets/images/pinouts/dvi_d_dual_link.png',
        'pin_details': [
          {'pin': '1', 'funcion': 'TMDS Data2-', 'tipo_senal': 'Digital Data'},
          {'pin': '2', 'funcion': 'TMDS Data2+', 'tipo_senal': 'Digital Data'},
          {
            'pin': '3',
            'funcion': 'TMDS Data2/4 Shield',
            'tipo_senal': 'Ground',
          },
          {'pin': '4', 'funcion': 'TMDS Data4-', 'tipo_senal': 'Digital Data'},
          {'pin': '5', 'funcion': 'TMDS Data4+', 'tipo_senal': 'Digital Data'},
          {'pin': '6', 'funcion': 'DDC Clock', 'tipo_senal': 'Data/Control'},
          {'pin': '7', 'funcion': 'DDC Data', 'tipo_senal': 'Data/Control'},
          {'pin': '8', 'funcion': 'Analog VSYNC', 'tipo_senal': 'No Conectado'},
          {'pin': '9', 'funcion': 'TMDS Data1-', 'tipo_senal': 'Digital Data'},
          {'pin': '10', 'funcion': 'TMDS Data1+', 'tipo_senal': 'Digital Data'},
          {
            'pin': '11',
            'funcion': 'TMDS Data1/3 Shield',
            'tipo_senal': 'Ground',
          },
          {'pin': '12', 'funcion': 'TMDS Data3-', 'tipo_senal': 'Digital Data'},
          {'pin': '13', 'funcion': 'TMDS Data3+', 'tipo_senal': 'Digital Data'},
          {'pin': '14', 'funcion': '+5V Power', 'tipo_senal': 'Power'},
          {'pin': '15', 'funcion': 'Ground (for +5V)', 'tipo_senal': 'Ground'},
          {
            'pin': '16',
            'funcion': 'Hot Plug Detect',
            'tipo_senal': 'Hot Plug Detect',
          },
          {'pin': '17', 'funcion': 'TMDS Data0-', 'tipo_senal': 'Digital Data'},
          {'pin': '18', 'funcion': 'TMDS Data0+', 'tipo_senal': 'Digital Data'},
          {
            'pin': '19',
            'funcion': 'TMDS Data0/5 Shield',
            'tipo_senal': 'Ground',
          },
          {'pin': '20', 'funcion': 'TMDS Data5-', 'tipo_senal': 'Digital Data'},
          {'pin': '21', 'funcion': 'TMDS Data5+', 'tipo_senal': 'Digital Data'},
          {'pin': '22', 'funcion': 'TMDS Clock-', 'tipo_senal': 'Clock'},
          {'pin': '23', 'funcion': 'TMDS Clock+', 'tipo_senal': 'Clock'},
          {'pin': '24', 'funcion': 'TMDS Clock Shield', 'tipo_senal': 'Ground'},
          {
            'pin': 'C1',
            'funcion': 'NC (Analog Red)',
            'tipo_senal': 'No Conectado',
          },
          {
            'pin': 'C2',
            'funcion': 'NC (Analog Green)',
            'tipo_senal': 'No Conectado',
          },
          {
            'pin': 'C3',
            'funcion': 'NC (Analog Blue)',
            'tipo_senal': 'No Conectado',
          },
          {
            'pin': 'C4',
            'funcion': 'NC (Analog HSYNC)',
            'tipo_senal': 'No Conectado',
          },
          {
            'pin': 'C5',
            'funcion': 'Analog Ground',
            'tipo_senal': 'No Conectado',
          },
        ],
      },
      {
        'tipo': 'DVI-I Single Link',
        'pines': '18+5',
        'descripcion':
            'Digital y analógico. Soporta resoluciones de Single Link digital y VGA analógico.',
        'imagen_pinout': 'assets/images/pinouts/dvi_i_single_link.png',
        'pin_details': [
          {'pin': '1', 'funcion': 'TMDS Data2-', 'tipo_senal': 'Digital Data'},
          {'pin': '2', 'funcion': 'TMDS Data2+', 'tipo_senal': 'Digital Data'},
          {
            'pin': '3',
            'funcion': 'TMDS Data2/4 Shield',
            'tipo_senal': 'Ground',
          },
          {
            'pin': '4',
            'funcion': 'NC (Digital Data4-)',
            'tipo_senal': 'No Conectado',
          },
          {
            'pin': '5',
            'funcion': 'NC (Digital Data4+)',
            'tipo_senal': 'No Conectado',
          },
          {'pin': '6', 'funcion': 'DDC Clock', 'tipo_senal': 'Data/Control'},
          {'pin': '7', 'funcion': 'DDC Data', 'tipo_senal': 'Data/Control'},
          {'pin': '8', 'funcion': 'Analog VSYNC', 'tipo_senal': 'Analog RGB'},
          {'pin': '9', 'funcion': 'TMDS Data1-', 'tipo_senal': 'Digital Data'},
          {'pin': '10', 'funcion': 'TMDS Data1+', 'tipo_senal': 'Digital Data'},
          {
            'pin': '11',
            'funcion': 'TMDS Data1/3 Shield',
            'tipo_senal': 'Ground',
          },
          {
            'pin': '12',
            'funcion': 'NC (Digital Data3-)',
            'tipo_senal': 'No Conectado',
          },
          {
            'pin': '13',
            'funcion': 'NC (Digital Data3+)',
            'tipo_senal': 'No Conectado',
          },
          {'pin': '14', 'funcion': '+5V Power', 'tipo_senal': 'Power'},
          {'pin': '15', 'funcion': 'Ground (for +5V)', 'tipo_senal': 'Ground'},
          {
            'pin': '16',
            'funcion': 'Hot Plug Detect',
            'tipo_senal': 'Hot Plug Detect',
          },
          {'pin': '17', 'funcion': 'TMDS Data0-', 'tipo_senal': 'Digital Data'},
          {'pin': '18', 'funcion': 'TMDS Data0+', 'tipo_senal': 'Digital Data'},
          {
            'pin': '19',
            'funcion': 'TMDS Data0/5 Shield',
            'tipo_senal': 'Ground',
          },
          {
            'pin': '20',
            'funcion': 'NC (Digital Data5-)',
            'tipo_senal': 'No Conectado',
          },
          {
            'pin': '21',
            'funcion': 'NC (Digital Data5+)',
            'tipo_senal': 'No Conectado',
          },
          {'pin': 'C1', 'funcion': 'Analog Red', 'tipo_senal': 'Analog RGB'},
          {'pin': 'C2', 'funcion': 'Analog Green', 'tipo_senal': 'Analog RGB'},
          {'pin': 'C3', 'funcion': 'Analog Blue', 'tipo_senal': 'Analog RGB'},
          {'pin': 'C4', 'funcion': 'Analog HSYNC', 'tipo_senal': 'Analog RGB'},
          {'pin': 'C5', 'funcion': 'Analog Ground', 'tipo_senal': 'Ground'},
        ],
      },
      {
        'tipo': 'DVI-I Dual Link',
        'pines': '24+5',
        'descripcion':
            'Digital y analógico. Soporta resoluciones de Dual Link digital y VGA analógico.',
        'imagen_pinout': 'assets/images/pinouts/dvi_i_dual_link.png',
        'pin_details': [
          {'pin': '1', 'funcion': 'TMDS Data2-', 'tipo_senal': 'Digital Data'},
          {'pin': '2', 'funcion': 'TMDS Data2+', 'tipo_senal': 'Digital Data'},
          {
            'pin': '3',
            'funcion': 'TMDS Data2/4 Shield',
            'tipo_senal': 'Ground',
          },
          {'pin': '4', 'funcion': 'TMDS Data4-', 'tipo_senal': 'Digital Data'},
          {'pin': '5', 'funcion': 'TMDS Data4+', 'tipo_senal': 'Digital Data'},
          {'pin': '6', 'funcion': 'DDC Clock', 'tipo_senal': 'Data/Control'},
          {'pin': '7', 'funcion': 'DDC Data', 'tipo_senal': 'Data/Control'},
          {'pin': '8', 'funcion': 'Analog VSYNC', 'tipo_senal': 'Analog RGB'},
          {'pin': '9', 'funcion': 'TMDS Data1-', 'tipo_senal': 'Digital Data'},
          {'pin': '10', 'funcion': 'TMDS Data1+', 'tipo_senal': 'Digital Data'},
          {
            'pin': '11',
            'funcion': 'TMDS Data1/3 Shield',
            'tipo_senal': 'Ground',
          },
          {'pin': '12', 'funcion': 'TMDS Data3-', 'tipo_senal': 'Digital Data'},
          {'pin': '13', 'funcion': 'TMDS Data3+', 'tipo_senal': 'Digital Data'},
          {'pin': '14', 'funcion': '+5V Power', 'tipo_senal': 'Power'},
          {'pin': '15', 'funcion': 'Ground (for +5V)', 'tipo_senal': 'Ground'},
          {
            'pin': '16',
            'funcion': 'Hot Plug Detect',
            'tipo_senal': 'Hot Plug Detect',
          },
          {'pin': '17', 'funcion': 'TMDS Data0-', 'tipo_senal': 'Digital Data'},
          {'pin': '18', 'funcion': 'TMDS Data0+', 'tipo_senal': 'Digital Data'},
          {
            'pin': '19',
            'funcion': 'TMDS Data0/5 Shield',
            'tipo_senal': 'Ground',
          },
          {'pin': '20', 'funcion': 'TMDS Data5-', 'tipo_senal': 'Digital Data'},
          {'pin': '21', 'funcion': 'TMDS Data5+', 'tipo_senal': 'Digital Data'},
          {'pin': '22', 'funcion': 'TMDS Clock-', 'tipo_senal': 'Clock'},
          {'pin': '23', 'funcion': 'TMDS Clock+', 'tipo_senal': 'Clock'},
          {'pin': '24', 'funcion': 'TMDS Clock Shield', 'tipo_senal': 'Ground'},
          {'pin': 'C1', 'funcion': 'Analog Red', 'tipo_senal': 'Analog RGB'},
          {'pin': 'C2', 'funcion': 'Analog Green', 'tipo_senal': 'Analog RGB'},
          {'pin': 'C3', 'funcion': 'Analog Blue', 'tipo_senal': 'Analog RGB'},
          {'pin': 'C4', 'funcion': 'Analog HSYNC', 'tipo_senal': 'Analog RGB'},
          {'pin': 'C5', 'funcion': 'Analog Ground', 'tipo_senal': 'Ground'},
        ],
      },
      {
        'tipo': 'DVI-A',
        'pines': '12+5',
        'descripcion':
            'Solo analógico. Diseñado para conectar dispositivos DVI a monitores VGA.',
        'imagen_pinout': 'assets/images/pinouts/dvi_a.png',
        'pin_details': [
          {'pin': '1', 'funcion': 'NC', 'tipo_senal': 'No Conectado'},
          {'pin': '2', 'funcion': 'NC', 'tipo_senal': 'No Conectado'},
          {'pin': '3', 'funcion': 'NC', 'tipo_senal': 'No Conectado'},
          {'pin': '4', 'funcion': 'NC', 'tipo_senal': 'No Conectado'},
          {'pin': '5', 'funcion': 'NC', 'tipo_senal': 'No Conectado'},
          {'pin': '6', 'funcion': 'DDC Clock', 'tipo_senal': 'Data/Control'},
          {'pin': '7', 'funcion': 'DDC Data', 'tipo_senal': 'Data/Control'},
          {'pin': '8', 'funcion': 'Analog VSYNC', 'tipo_senal': 'Analog RGB'},
          {'pin': '9', 'funcion': 'NC', 'tipo_senal': 'No Conectado'},
          {'pin': '10', 'funcion': 'NC', 'tipo_senal': 'No Conectado'},
          {'pin': '11', 'funcion': 'NC', 'tipo_senal': 'No Conectado'},
          {'pin': '12', 'funcion': 'NC', 'tipo_senal': 'No Conectado'},
          {'pin': '13', 'funcion': 'NC', 'tipo_senal': 'No Conectado'},
          {'pin': '14', 'funcion': '+5V Power', 'tipo_senal': 'Power'},
          {'pin': '15', 'funcion': 'Ground (for +5V)', 'tipo_senal': 'Ground'},
          {
            'pin': '16',
            'funcion': 'Hot Plug Detect',
            'tipo_senal': 'Hot Plug Detect',
          },
          {'pin': '17', 'funcion': 'NC', 'tipo_senal': 'No Conectado'},
          {'pin': '18', 'funcion': 'NC', 'tipo_senal': 'No Conectado'},
          {'pin': '19', 'funcion': 'NC', 'tipo_senal': 'No Conectado'},
          {'pin': '20', 'funcion': 'NC', 'tipo_senal': 'No Conectado'},
          {'pin': '21', 'funcion': 'NC', 'tipo_senal': 'No Conectado'},
          {'pin': 'C1', 'funcion': 'Analog Red', 'tipo_senal': 'Analog RGB'},
          {'pin': 'C2', 'funcion': 'Analog Green', 'tipo_senal': 'Analog RGB'},
          {'pin': 'C3', 'funcion': 'Analog Blue', 'tipo_senal': 'Analog RGB'},
          {'pin': 'C4', 'funcion': 'Analog HSYNC', 'tipo_senal': 'Analog RGB'},
          {'pin': 'C5', 'funcion': 'Analog Ground', 'tipo_senal': 'Ground'},
        ],
      },
    ],
  },
  {
    'section_title': 'Resoluciones y Frecuencias Soportadas',
    'description':
        'La capacidad de resolución y frecuencia de actualización de DVI varía según el tipo de conector (Single Link o Dual Link):',
    'list_data': [
      {
        'title': 'Single Link (DVI-D SL, DVI-I SL)',
        'details':
            'Soporta un solo enlace TMDS. Resoluciones comunes incluyen 1920x1200 a 60Hz. Es suficiente para la mayoría de monitores Full HD.',
      },
      {
        'title': 'Dual Link (DVI-D DL, DVI-I DL)',
        'details':
            'Utiliza dos enlaces TMDS, duplicando el ancho de banda. Esto permite resoluciones mucho más altas, como 2560x1600 a 60Hz, o 1920x1080 a 120Hz para monitores de alta frecuencia de actualización.',
      },
    ],
  },
  {
    'section_title': 'Ventajas y Desventajas de DVI',
    'description':
        'DVI fue un paso importante en la evolución de las interfaces de video, pero también tiene sus limitaciones:',
    'list_data': [
      {
        'title': 'Ventajas',
        'details':
            '**Calidad de imagen:** Transmisión digital pura que evita la conversión analógica-digital, resultando en una imagen más nítida y sin ruido.\n**Versatilidad (DVI-I):** Capacidad de transmitir señales digitales y analógicas en un solo conector, facilitando la compatibilidad con equipos antiguos VGA.\n**Alta resolución:** Las versiones Dual Link soportan resoluciones muy altas, adecuadas para monitores profesionales y de gran tamaño.',
      },
      {
        'title': 'Desventajas',
        'details':
            '**No transporta audio:** A diferencia de HDMI o DisplayPort, DVI no transmite señales de audio, lo que requiere un cable de audio separado.\n**Tamaño del conector:** El conector es voluminoso en comparación con interfaces más modernas.\n**Sin Ethernet/USB:** Carece de funciones adicionales como Ethernet o USB que sí ofrecen interfaces más recientes.\n**Reemplazo por HDMI/DisplayPort:** Ha sido ampliamente superado por HDMI y DisplayPort, que ofrecen mayor ancho de banda, audio integrado y un factor de forma más pequeño.',
      },
    ],
  },
  {
    'section_title': 'Problemas Comunes y Solución de Problemas',
    'description':
        'Aunque DVI es generalmente fiable, pueden surgir problemas. Aquí algunas soluciones:',
    'list_data': [
      {
        'title': 'No hay señal o imagen en blanco/negro',
        'details':
            '**Síntomas:** "No Signal", pantalla negra o imagen solo en escala de grises.\n**Solución:**\n1.  **Conexión segura:** Asegurarse de que el cable DVI esté firmemente conectado en ambos extremos (tarjeta gráfica y monitor). Los tornillos de sujeción deben estar apretados.\n2.  **Entrada correcta:** Verificar que el monitor esté configurado en la entrada DVI correcta (si tiene varias entradas).\n3.  **Cable DVI:** Probar con otro cable DVI. Los cables defectuosos son una causa común.\n4.  **Tipo de DVI:** Asegurarse de que el tipo de cable DVI sea compatible con los puertos. Un cable DVI-D no funcionará en un puerto DVI-A, y un DVI-I puede no encajar en un DVI-D si el monitor no tiene los pines analógicos pasantes.',
      },
      {
        'title': 'Imagen con artefactos o parpadeos',
        'details':
            '**Síntomas:** Píxeles muertos aleatorios, líneas horizontales/verticales, parpadeo de imagen.\n**Solución:**\n1.  **Cable dañado:** Inspeccionar el cable DVI en busca de daños físicos. Un cable de mala calidad o demasiado largo puede causar problemas.\n2.  **Interferencia:** Alejar el cable de fuentes de interferencia electromagnética.\n3.  **Controladores de gráficos:** Actualizar los controladores de la tarjeta gráfica.\n4.  **Frecuencia de actualización:** Asegurarse de que la frecuencia de actualización configurada en el sistema operativo no exceda la capacidad del monitor o del cable.',
      },
      {
        'title': 'Problemas con adaptadores DVI',
        'details':
            '**Síntomas:** Problemas al usar adaptadores DVI a HDMI o DVI a VGA.\n**Solución:**\n1.  **Compatibilidad:** Asegurarse de que el adaptador sea el correcto para el tipo de señal. Un adaptador DVI-D a VGA no funcionará ya que DVI-D no tiene señal analógica.\n2.  **Calidad del adaptador:** Usar adaptadores de buena calidad. Los adaptadores baratos pueden introducir ruido o fallos.\n3.  **Adaptadores activos/pasivos:** Para conversiones de señal más complejas (ej. de DisplayPort a DVI Dual Link), puede ser necesario un adaptador activo con alimentación externa.',
      },
    ],
  },
];

class DVIDetailScreen extends StatelessWidget {
  const DVIDetailScreen({super.key});

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
        title: const Text(_dviTitle),
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
              child: Image.asset(_dviImagePath, fit: BoxFit.contain),
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
              _dviDescription,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),
            ..._dviDetails.map((section) {
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
