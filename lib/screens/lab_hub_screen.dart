import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LabHubScreen extends StatelessWidget {
  const LabHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Laboratorio')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _LabOptionCard(
            icon: Icons.settings_remote_outlined,
            title: 'Servos (BLE)',
            description:
                'Escanea módulos Bluetooth Low Energy compatibles y ajusta el ángulo de servomotores en tiempo real.',
            color: colorScheme.primary,
            onTap: () => Navigator.pushNamed(context, '/servos'),
          ),
          const SizedBox(height: 16),
          _LabOptionCard(
            icon: Icons.ssid_chart,
            title: 'Data Logger (BLE)',
            description:
                'Visualiza mediciones ambientales desde periféricos BLE con el servicio NUS y exporta los datos a CSV.',
            color: colorScheme.secondary,
            onTap: () => Navigator.pushNamed(context, '/logger'),
          ),
        ],
      ),
    );
  }
}

class _LabOptionCard extends StatelessWidget {
  const _LabOptionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<IconData>('icon', icon))
      ..add(StringProperty('title', title))
      ..add(StringProperty('description', description))
      ..add(ColorProperty('color', color))
      ..add(ObjectFlagProperty<VoidCallback>.has('onTap', onTap));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: color.withAlpha(
                    12,
                  ), // Corregido: cambiado withValues por withAlpha
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
