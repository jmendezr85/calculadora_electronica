import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Para abrir enlaces externos

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de la App'),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Logo o icono de la app (puedes reemplazarlo con una imagen real)
            Icon(Icons.calculate, size: 80, color: colorScheme.primary),
            const SizedBox(height: 20),
            Text(
              'Calculadora Electrónica',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Versión 1.0.0', // Puedes actualizar la versión aquí
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Esta aplicación está diseñada para ser una herramienta útil para estudiantes, entusiastas y profesionales de la electrónica. Proporciona una variedad de calculadoras y referencias para facilitar el trabajo con componentes y circuitos.',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 30),
            Text(
              'Desarrollado por:',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            Text(
              'Jorge', // Reemplaza con tu nombre si lo deseas
              style: textTheme.bodyLarge?.copyWith(color: colorScheme.primary),
            ),
            const SizedBox(height: 30),
            // Enlaces útiles
            Text(
              'Contacto y Recursos:',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            _buildLinkTile(
              context,
              icon: Icons.email,
              title: 'Enviar un correo',
              url:
                  'mailto:tucorreo@ejemplo.com?subject=Consulta%20sobre%20Calculadora%20Electronica', // Cambia a tu correo
            ),
            _buildLinkTile(
              context,
              icon: Icons.code,
              title: 'Repositorio de GitHub',
              url:
                  'https://github.com/tu-usuario/tu-repositorio', // Cambia a tu repositorio si tienes uno público
            ),
            _buildLinkTile(
              context,
              icon: Icons.web,
              title: 'Visitar mi sitio web',
              url:
                  'https://www.tudominio.com', // Cambia a tu sitio web o deja en blanco si no tienes
            ),
            const SizedBox(height: 40),
            Text(
              '© 2024 Calculadora Electrónica. Todos los derechos reservados.',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para crear tiles de enlaces
  Widget _buildLinkTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String url,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () async {
          if (url.isNotEmpty && await canLaunchUrl(Uri.parse(url))) {
            await launchUrl(
              Uri.parse(url),
              mode: LaunchMode.externalApplication,
            );
          } else {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No se pudo abrir el enlace.')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.secondary),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
