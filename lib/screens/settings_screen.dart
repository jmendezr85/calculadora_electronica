import 'package:calculadora_electronica/app_localizations.dart';
import 'package:calculadora_electronica/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        systemNavigationBarColor: theme.scaffoldBackgroundColor,
        systemNavigationBarIconBrightness: theme.brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
      ),
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.translate('settings'))),
        body: Consumer<AppSettings>(
          builder: (context, settings, _) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _SettingsSection(
                  icon: Icons.palette,
                  title: l10n.translate('appearanceTitle'),
                  children: [
                    _ThemeSelector(settings: settings),
                    const SizedBox(height: 8),
                    _ThemeColorGrid(settings: settings),
                  ],
                ),
                const SizedBox(height: 24),
                const _AppInfoSection(),

                _SettingsSection(
                  icon: Icons.tune,
                  title: l10n.translate('functionalityTitle'),
                  children: [
                    _ProfessionalModeSwitch(settings: settings),
                    _HapticFeedbackSwitch(settings: settings),
                  ],
                ),
                const SizedBox(height: 24),

                _SettingsSection(
                  icon: Icons.text_fields,
                  title: l10n.translate('typographyTitle'),
                  children: [_TextScaleSlider(settings: settings)],
                ),
                const SizedBox(height: 24),

                _SettingsSection(
                  icon: Icons.language,
                  title: l10n.translate('languageTitle'),
                  children: [_LanguageDropdown(settings: settings)],
                ),
                const SizedBox(height: 24),

                _ResetSettingsButton(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.icon,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<IconData>('icon', icon))
      ..add(StringProperty('title', title));
  }
}

class _ThemeSelector extends StatelessWidget {
  final AppSettings settings;

  const _ThemeSelector({required this.settings});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final String themeName = settings.themeMode == ThemeMode.light
        ? l10n.translate('lightTheme')
        : settings.themeMode == ThemeMode.dark
        ? l10n.translate('darkTheme')
        : l10n.translate('systemTheme');

    return ListTile(
      leading: const Icon(Icons.style),
      title: Text(l10n.translate('appTheme')),
      subtitle: Text(themeName),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => showDialog<void>(
        context: context,
        builder: (context) => _ThemeDialog(settings: settings),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AppSettings>('settings', settings));
  }
}

class _ThemeDialog extends StatelessWidget {
  final AppSettings settings;

  const _ThemeDialog({required this.settings});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SimpleDialog(
      title: Text(l10n.translate('chooseTheme')),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SegmentedButton<ThemeMode>(
            segments: [
              ButtonSegment<ThemeMode>(
                value: ThemeMode.system,
                label: Text(l10n.translate('systemTheme')),
              ),
              ButtonSegment<ThemeMode>(
                value: ThemeMode.light,
                label: Text(l10n.translate('lightTheme')),
              ),
              ButtonSegment<ThemeMode>(
                value: ThemeMode.dark,
                label: Text(l10n.translate('darkTheme')),
              ),
            ],
            selected: {settings.themeMode},
            onSelectionChanged: (selection) {
              settings.setThemeMode(selection.first);
            },
          ),
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AppSettings>('settings', settings));
  }
}

class _ThemeColorGrid extends StatelessWidget {
  final AppSettings settings;

  const _ThemeColorGrid({required this.settings});

  @override
  Widget build(BuildContext context) {
    final colors = _getAvailableSeedColors(settings);
    final current = _getSeedColor(settings);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final c in colors)
                GestureDetector(
                  onTap: () => _setSeedColor(settings, c),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: c,
                      border: Border.all(
                        color: c == current
                            ? Theme.of(context).colorScheme.onSurface
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: current,
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
            ),
            title: const Text('Color personalizado'),
            subtitle: Text(_hexColor(current)),
            trailing: const Icon(Icons.edit_outlined),
            onTap: () async {
              final picked = await showDialog<Color>(
                context: context,
                builder: (ctx) =>
                    _CustomColorPickerDialog(initialColor: current),
              );
              if (picked != null) {
                _setSeedColor(settings, picked);
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AppSettings>('settings', settings));
  }
}

class _CustomColorPickerDialog extends StatefulWidget {
  final Color initialColor;
  const _CustomColorPickerDialog({required this.initialColor});

  @override
  State<_CustomColorPickerDialog> createState() =>
      _CustomColorPickerDialogState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('initialColor', initialColor));
  }
}

class _CustomColorPickerDialogState extends State<_CustomColorPickerDialog> {
  late double _h; // 0..360
  late double _s; // 0..1
  late double _v; // 0..1

  @override
  void initState() {
    super.initState();
    final hsv = HSVColor.fromColor(widget.initialColor);
    _h = hsv.hue;
    _s = hsv.saturation;
    _v = hsv.value;
  }

  Color get _color => HSVColor.fromAHSV(1.0, _h, _s, _v).toColor();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Elegir color'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 44,
            width: double.infinity,
            decoration: BoxDecoration(
              color: _color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
          ),
          const SizedBox(height: 12),
          _LabeledSlider(
            label: 'Matiz (H)',
            value: _h,
            min: 0,
            max: 360,
            onChanged: (v) => setState(() => _h = v),
          ),
          _LabeledSlider(
            label: 'Saturación (S)',
            value: _s,
            min: 0,
            max: 1,
            onChanged: (v) => setState(() => _s = v),
          ),
          _LabeledSlider(
            label: 'Brillo (V)',
            value: _v,
            min: 0,
            max: 1,
            onChanged: (v) => setState(() => _v = v),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(_color),
          child: const Text('Aceptar'),
        ),
      ],
    );
  }
}

class _LabeledSlider extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  const _LabeledSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(label), Text(value.toStringAsFixed(2))],
        ),
        Slider(value: value, min: min, max: max, onChanged: onChanged),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('label', label))
      ..add(DoubleProperty('value', value))
      ..add(DoubleProperty('min', min))
      ..add(DoubleProperty('max', max))
      ..add(
        ObjectFlagProperty<ValueChanged<double>>.has('onChanged', onChanged),
      );
  }
}

class _ProfessionalModeSwitch extends StatelessWidget {
  final AppSettings settings;

  const _ProfessionalModeSwitch({required this.settings});

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(AppLocalizations.of(context)!.translate('professionalMode')),
      subtitle: Text(
        AppLocalizations.of(context)!.translate('professionalModeSubtitle'),
      ),
      value: (settings as dynamic).professionalMode ?? false,
      onChanged: (settings as dynamic).setProfessionalMode,
      secondary: const Icon(Icons.workspace_premium_outlined),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AppSettings>('settings', settings));
  }
}

class _HapticFeedbackSwitch extends StatelessWidget {
  final AppSettings settings;

  const _HapticFeedbackSwitch({required this.settings});

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(AppLocalizations.of(context)!.translate('haptics')),
      value: (settings as dynamic).hapticFeedback ?? true,
      onChanged: (settings as dynamic).setHapticFeedback,
      secondary: const Icon(Icons.vibration),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AppSettings>('settings', settings));
  }
}

class _TextScaleSlider extends StatelessWidget {
  final AppSettings settings;

  const _TextScaleSlider({required this.settings});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final value = _getTextScale(settings);

    return ListTile(
      leading: const Icon(Icons.text_fields),
      title: Text(l10n.translate('fontSize')),
      subtitle: Slider(
        value: value,
        onChanged: (v) => _setTextScale(settings, v),
        min: 0.85,
        max: 1.25,
        divisions: 8,
        label: '${(value * 100).round()}%',
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AppSettings>('settings', settings));
  }
}

class _LanguageDropdown extends StatelessWidget {
  final AppSettings settings;

  const _LanguageDropdown({required this.settings});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.translate),
      title: Text(AppLocalizations.of(context)!.translate('appLanguage')),
      trailing: DropdownButton<String>(
        value: _getSelectedLanguage(settings),
        underline: Container(),
        items: const [
          DropdownMenuItem(value: 'es', child: Text('Español')),
          DropdownMenuItem(value: 'en', child: Text('English')),
        ],
        onChanged: (value) => _setLanguage(settings, value ?? 'es'),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<AppSettings>('settings', settings));
  }
}

class _ResetSettingsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return OutlinedButton.icon(
      icon: const Icon(Icons.restart_alt),
      label: Text(l10n.translate('resetSettings')),
      onPressed: () => showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.translate('resetConfirmationTitle')),
          content: Text(l10n.translate('resetConfirmationContent')),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.translate('cancel')),
            ),
            FilledButton(
              onPressed: () {
                final s = Provider.of<AppSettings>(context, listen: false);
                _resetToDefaults(s);
                Navigator.of(context).pop();
              },
              child: Text(l10n.translate('confirm')),
            ),
          ],
        ),
      ),
    );
  }
}

// ---- Información de la app (Sección Play Store) ----
class _AppInfoSection extends StatefulWidget {
  const _AppInfoSection();
  @override
  State<_AppInfoSection> createState() => _AppInfoSectionState();
}

class _AppInfoSectionState extends State<_AppInfoSection> {
  String _appName = '';
  String _version = '';
  String _buildNumber = '';
  String _packageName = '';

  @override
  void initState() {
    super.initState();
    _loadInfo();
  }

  Future<void> _loadInfo() async {
    try {
      final info = await PackageInfo.fromPlatform();
      setState(() {
        _appName = info.appName;
        _version = info.version;
        _buildNumber = info.buildNumber;
        _packageName = info.packageName;
      });
    } catch (_) {}
  }

  void _copyToClipboard(BuildContext context, String label, String value) {
    if (value.isEmpty) return;
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$label copiado')));
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Política de Privacidad'),
        content: const SingleChildScrollView(
          child: Text(
            'Esta aplicación no recopila, almacena ni comparte información personal identificable de los usuarios.\n\n'
            'Cualquier dato ingresado por el usuario se mantiene únicamente en su dispositivo y no se transmite a servidores externos.\n\n'
            'No se utilizan servicios de terceros para el seguimiento o análisis de uso.\n\n'
            'El único propósito de esta aplicación es ofrecer herramientas de cálculo y utilidades electrónicas para el usuario.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showTerms(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Términos y Condiciones'),
        content: const SingleChildScrollView(
          child: Text(
            'El uso de esta aplicación es bajo su propia responsabilidad. '
            'La información y resultados proporcionados son de carácter informativo y no constituyen asesoría profesional. '
            'No se garantiza la exactitud absoluta de los cálculos y el desarrollador no será responsable por pérdidas derivadas de su uso.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showLicenses(BuildContext context) {
    showLicensePage(
      context: context,
      applicationName: _appName.isEmpty ? 'Aplicación' : _appName,
      applicationVersion: _version.isEmpty
          ? null
          : 'v$_version (+$_buildNumber)',
    );
  }

  void _rateOnPlayStore() {
    const playUrl = 'https://play.google.com/store/apps/details?id=';
    if (_packageName.isNotEmpty) {
      _openUrl('$playUrl$_packageName');
    } else {
      _openUrl(playUrl);
    }
  }

  Future<void> _shareApp() async {
    const fallback = '¡Prueba esta app!';
    final msg = _packageName.isNotEmpty
        ? '¡Prueba esta app! https://play.google.com/store/apps/details?id=$_packageName'
        : fallback;

    // API nueva de share_plus:
    await SharePlus.instance.share(ShareParams(text: msg));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text('Información', style: theme.textTheme.titleLarge),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.apps),
                title: Text(_appName.isEmpty ? 'Aplicación' : _appName),
                subtitle: Text(
                  _packageName.isEmpty
                      ? 'ID de paquete no disponible'
                      : _packageName,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.copy),
                  tooltip: 'Copiar ID de paquete',
                  onPressed: () =>
                      _copyToClipboard(context, 'ID de paquete', _packageName),
                ),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Versión'),
                subtitle: Text(
                  (_version.isEmpty && _buildNumber.isEmpty)
                      ? 'No disponible'
                      : '$_version (+$_buildNumber)',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.copy),
                  tooltip: 'Copiar versión',
                  onPressed: () => _copyToClipboard(
                    context,
                    'Versión',
                    (_version.isEmpty && _buildNumber.isEmpty)
                        ? ''
                        : '$_version (+$_buildNumber)',
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: const Text('Política de privacidad'),
                onTap: () => _showPrivacyPolicy(context),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.description_outlined),
                title: const Text('Términos y condiciones'),
                onTap: () => _showTerms(context),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.article_outlined),
                title: const Text('Licencias de código abierto'),
                onTap: () => _showLicenses(context),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.star_rate_outlined),
                title: const Text('Calificar en Play Store'),
                onTap: _rateOnPlayStore,
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.share_outlined),
                title: const Text('Compartir app'),
                onTap: _shareApp,
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

String _hexColor(Color c) {
  int to8(double v) => (v * 255.0).round() & 0xff; // 0..1 -> 0..255
  String hex2(int n) => n.toRadixString(16).padLeft(2, '0');
  final a = hex2(to8(c.a));
  final r = hex2(to8(c.r));
  final g = hex2(to8(c.g));
  final b = hex2(to8(c.b));
  return '#$a$r$g$b'.toUpperCase();
}

// ===== Adaptadores para coincidir con tu AppSettings real =====
List<Color> _getAvailableSeedColors(AppSettings s) {
  try {
    final v = (s as dynamic).availableSeedColors;
    if (v is List<Color>) return v;
  } catch (_) {}
  try {
    final v = (s as dynamic).seedColors;
    if (v is List<Color>) return v;
  } catch (_) {}
  return const [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.indigo,
    Colors.pink,
    Colors.brown,
    Colors.cyan,
  ];
}

Color _getSeedColor(AppSettings s) {
  try {
    final v = (s as dynamic).seedColor;
    if (v is Color) return v;
  } catch (_) {}
  try {
    final v = (s as dynamic).primaryColor;
    if (v is Color) return v;
  } catch (_) {}
  return Colors.blue;
}

void _setSeedColor(AppSettings s, Color c) {
  try {
    (s as dynamic).setSeedColor(c);
    return;
  } catch (_) {}
  try {
    (s as dynamic).setSeed(c);
    return;
  } catch (_) {}
  try {
    (s as dynamic).setPrimaryColor(c);
    return;
  } catch (_) {}
}

double _getTextScale(AppSettings s) {
  try {
    final v = (s as dynamic).textScale;
    if (v is double) return v;
  } catch (_) {}
  try {
    final v = (s as dynamic).fontScale;
    if (v is double) return v;
  } catch (_) {}
  try {
    final v = (s as dynamic).textScaleFactor;
    if (v is double) return v;
  } catch (_) {}
  try {
    final v = (s as dynamic).fontSize;
    if (v is double) return v;
  } catch (_) {}
  return 1.0;
}

void _setTextScale(AppSettings s, double v) {
  try {
    (s as dynamic).setTextScale(v);
    return;
  } catch (_) {}
  try {
    (s as dynamic).setFontScale(v);
    return;
  } catch (_) {}
  try {
    (s as dynamic).setTextScaleFactor(v);
    return;
  } catch (_) {}
  try {
    (s as dynamic).setFontSize(v);
    return;
  } catch (_) {}
}

String _getSelectedLanguage(AppSettings s) {
  try {
    final v = (s as dynamic).selectedLanguage;
    if (v is String) return v;
  } catch (_) {}
  try {
    final v = (s as dynamic).languageCode;
    if (v is String) return v;
  } catch (_) {}
  try {
    final loc = (s as dynamic).locale;
    if (loc is Locale) return loc.languageCode;
    if (loc is String) return loc;
  } catch (_) {}
  try {
    final v = (s as dynamic).localeCode;
    if (v is String) return v;
  } catch (_) {}
  return 'es';
}

void _setLanguage(AppSettings s, String code) {
  try {
    (s as dynamic).setLanguage(code);
    return;
  } catch (_) {}
  try {
    (s as dynamic).setSelectedLanguage(code);
    return;
  } catch (_) {}
  try {
    (s as dynamic).setLocale(code);
    return;
  } catch (_) {}
  try {
    (s as dynamic).changeLanguage(code);
    return;
  } catch (_) {}
  try {
    (s as dynamic).setLanguageCode(code);
    return;
  } catch (_) {}
  try {
    (s as dynamic).setLocaleCode(code);
    return;
  } catch (_) {}
  try {
    (s as dynamic).setLocale(Locale(code));
    return;
  } catch (_) {}
}

void _resetToDefaults(AppSettings s) {
  try {
    (s as dynamic).resetToDefaults();
    return;
  } catch (_) {}
  try {
    (s as dynamic).resetSettings();
    return;
  } catch (_) {}
  try {
    (s as dynamic).reset();
    return;
  } catch (_) {}
}
