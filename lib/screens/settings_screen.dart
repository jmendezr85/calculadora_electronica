import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:calculadora_electronica/main.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: colorScheme.surface,
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Configuración'),
          centerTitle: true,
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.onSurface,
          elevation: 0,
          scrolledUnderElevation: 4,
        ),
        body: Consumer<AppSettings>(
          builder: (context, settings, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sección de Apariencia
                  _buildSectionHeader(
                    context,
                    icon: Icons.palette,
                    title: 'Apariencia',
                  ),
                  _buildThemeSelector(context, settings),
                  _buildSettingSlider(
                    context,
                    title: 'Tamaño de texto',
                    value: settings.fontSize,
                    min: 0.8,
                    max: 1.5,
                    divisions: 7,
                    label: '${(settings.fontSize * 100).round()}%',
                    onChanged: (value) => settings.setFontSize(value),
                    icon: Icons.text_fields,
                  ),
                  const SizedBox(height: 24),

                  // Sección de Funcionalidad
                  _buildSectionHeader(
                    context,
                    icon: Icons.tune,
                    title: 'Funcionalidad',
                  ),
                  _buildSettingSwitch(
                    context,
                    title: 'Modo Profesional',
                    subtitle:
                        'Muestra opciones avanzadas y parámetros técnicos',
                    value: settings.professionalMode,
                    onChanged: (value) => settings.setProfessionalMode(value),
                    icon: Icons.engineering,
                  ),
                  _buildSettingSwitch(
                    context,
                    title: 'Retroalimentación háptica',
                    value: settings.hapticFeedback,
                    onChanged: (value) => settings.setHapticFeedback(value),
                    icon: Icons.vibration,
                  ),
                  const SizedBox(height: 24),

                  // Sección de Notificaciones
                  _buildSectionHeader(
                    context,
                    icon: Icons.notifications,
                    title: 'Notificaciones',
                  ),
                  _buildSettingSwitch(
                    context,
                    title: 'Notificaciones',
                    value: settings.notificationsEnabled,
                    onChanged: (value) =>
                        settings.setNotificationsEnabled(value),
                    icon: Icons.notifications_active,
                  ),
                  const SizedBox(height: 24),

                  // Sección de Idioma
                  _buildSectionHeader(
                    context,
                    icon: Icons.language,
                    title: 'Idioma',
                  ),
                  _buildSettingDropdown(
                    context,
                    title: 'Idioma de la aplicación',
                    value: settings.selectedLanguage,
                    items: const [
                      'Español',
                      'English',
                      'Português',
                      'Français',
                    ],
                    onChanged: (value) => settings.setSelectedLanguage(value!),
                    icon: Icons.translate,
                  ),
                  const SizedBox(height: 24),

                  // Sección de Información
                  _buildSectionHeader(
                    context,
                    icon: Icons.info,
                    title: 'Información',
                  ),
                  _buildInfoItem(
                    context,
                    title: 'Versión',
                    value: '1.2.0',
                    icon: Icons.apps,
                  ),
                  _buildInfoItem(
                    context,
                    title: 'Licencia',
                    value: 'GPL v3.0',
                    icon: Icons.description,
                    onTap: () => _showLicenseDialog(context),
                  ),
                  _buildInfoItem(
                    context,
                    title: 'Política de Privacidad',
                    value: 'Ver detalles',
                    icon: Icons.privacy_tip,
                    onTap: () => _showPrivacyPolicy(context),
                  ),
                  const SizedBox(height: 32),

                  // Botón de Restablecer
                  Center(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.restart_alt),
                      label: const Text('Restablecer configuración'),
                      onPressed: () => _resetSettings(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colorScheme.error,
                        side: BorderSide(color: colorScheme.error),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required IconData icon,
    required String title,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: colorScheme.primary),
          const SizedBox(width: 12),
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSelector(BuildContext context, AppSettings settings) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    String themeName = 'Sistema';
    if (settings.themeMode == ThemeMode.light) {
      themeName = 'Claro';
    } else if (settings.themeMode == ThemeMode.dark) {
      themeName = 'Oscuro';
    }

    return ListTile(
      leading: Icon(Icons.style, color: colorScheme.primary),
      title: Text('Tema de la aplicación', style: textTheme.bodyLarge),
      subtitle: Text(themeName, style: textTheme.bodySmall),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: colorScheme.onSurface,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      onTap: () => _showThemeSelectorDialog(context, settings),
    );
  }

  void _showThemeSelectorDialog(BuildContext context, AppSettings settings) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Seleccionar tema'),
        children: [
          RadioListTile<ThemeMode>(
            title: const Text('Sistema'),
            value: ThemeMode.system,
            groupValue: settings.themeMode,
            onChanged: (value) {
              if (value != null) {
                settings.setThemeMode(value);
                Navigator.pop(context);
              }
            },
            activeColor: colorScheme.primary,
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Claro'),
            value: ThemeMode.light,
            groupValue: settings.themeMode,
            onChanged: (value) {
              if (value != null) {
                settings.setThemeMode(value);
                Navigator.pop(context);
              }
            },
            activeColor: colorScheme.primary,
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Oscuro'),
            value: ThemeMode.dark,
            groupValue: settings.themeMode,
            onChanged: (value) {
              if (value != null) {
                settings.setThemeMode(value);
                Navigator.pop(context);
              }
            },
            activeColor: colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingSwitch(
    BuildContext context, {
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    String? subtitle,
    required IconData icon,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      leading: Icon(icon, color: colorScheme.primary),
      title: Text(title, style: textTheme.bodyLarge),
      subtitle: subtitle != null
          ? Text(subtitle, style: textTheme.bodySmall)
          : null,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: colorScheme.primary,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      onTap: () => onChanged(!value),
    );
  }

  Widget _buildSettingDropdown(
    BuildContext context, {
    required String title,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required IconData icon,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      leading: Icon(icon, color: colorScheme.primary),
      title: Text(title, style: textTheme.bodyLarge),
      trailing: DropdownButton<String>(
        value: value,
        underline: Container(),
        icon: Icon(Icons.arrow_drop_down, color: colorScheme.onSurface),
        items: items.map((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
        onChanged: onChanged,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
    );
  }

  Widget _buildSettingSlider(
    BuildContext context, {
    required String title,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String label,
    required ValueChanged<double> onChanged,
    required IconData icon,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      leading: Icon(icon, color: colorScheme.primary),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: textTheme.bodyLarge),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            label: label,
            onChanged: onChanged,
            activeColor: colorScheme.primary,
            inactiveColor: colorScheme.primary.withAlpha(77),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      leading: Icon(icon, color: colorScheme.primary),
      title: Text(title, style: textTheme.bodyLarge),
      trailing: Text(value, style: textTheme.bodyMedium),
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      onTap: onTap,
    );
  }

  void _resetSettings(BuildContext context) {
    final appSettings = Provider.of<AppSettings>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restablecer configuración'),
        content: const Text(
          '¿Estás seguro de que deseas restablecer todas las configuraciones a sus valores predeterminados?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              appSettings.resetSettings();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Configuración restablecida')),
              );
            },
            child: const Text('Restablecer'),
          ),
        ],
      ),
    );
  }

  void _showLicenseDialog(BuildContext context) {
    showLicensePage(
      context: context,
      applicationName: 'Electrónicos App',
      applicationVersion: 'Versión 1.2.0',
      applicationLegalese:
          '© ${DateTime.now().year} Electrónicos App. Todos los derechos reservados.',
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Política de Privacidad'),
        content: SingleChildScrollView(
          child: Text(
            'Política de Privacidad de Electrónicos App\n\n'
            '1. Recopilación de Información\n'
            'No recopilamos información personal identificable. La aplicación funciona completamente offline.\n\n'
            '2. Datos de Uso\n'
            'Para mejorar la experiencia del usuario, podemos recopilar datos anónimos de uso que no identifican personalmente al usuario.\n\n'
            '3. Seguridad\n'
            'Todos los cálculos se realizan localmente en tu dispositivo. No almacenamos ni transmitimos tus datos.\n\n'
            '4. Cambios en esta Política\n'
            'Nos reservamos el derecho de actualizar esta política ocasionalmente. Te notificaremos sobre cambios significativos.',
            style: textTheme.bodyMedium,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}
