import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:calculadora_electronica/main.dart';

/// Pantalla de símbolos electrónicos (sin ASCII).
/// - Icons profesionales por componente.
/// - Modo PRO visible (badge) y con detalles extra.
/// - Grid móvil-first sin overflow (altura fija por celda).
class ElectronicSymbolsScreen extends StatefulWidget {
  const ElectronicSymbolsScreen({super.key});

  @override
  State<ElectronicSymbolsScreen> createState() =>
      _ElectronicSymbolsScreenState();
}

class _ElectronicSymbolsScreenState extends State<ElectronicSymbolsScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';
  String _selectedCategory = 'Todos';
  bool _compactView = false; // false = lista, true = grid

  late final List<SymbolItem> _allItems = _buildCatalog();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPro = context.select<AppSettings, bool>((s) => s.professionalMode);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Símbolos Electrónicos'),
        actions: [
          if (isPro)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFD8F4).withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF9C27B0),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF9C27B0).withValues(alpha: 0.40),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.workspace_premium,
                      size: 16,
                      color: Color(0xFF9C27B0),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'PRO',
                      style: TextStyle(
                        color: Color(0xFF9C27B0),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Tooltip(
            message: _compactView ? 'Vista lista' : 'Vista cuadrícula',
            child: IconButton(
              onPressed: () => setState(() => _compactView = !_compactView),
              icon: Icon(_compactView ? Icons.view_agenda : Icons.grid_view),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _SearchBar(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v),
              onClear: () {
                _searchCtrl.clear();
                setState(() => _query = '');
              },
            ),
            const SizedBox(height: 4),
            _CategoryChips(
              categories: <String>{
                'Todos',
                ..._allItems.map((e) => e.category),
              }.toList()..sort(),
              selected: _selectedCategory,
              onSelected: (c) => setState(() => _selectedCategory = c),
              counts: isPro
                  ? {
                      for (final c in <String>{
                        'Todos',
                        ..._allItems.map((e) => e.category),
                      }.toList())
                        c: c == 'Todos'
                            ? _allItems.length
                            : _allItems.where((e) => e.category == c).length,
                    }
                  : null,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _SymbolsGrid(
                items: _allItems.where((e) {
                  final matchesCategory =
                      _selectedCategory == 'Todos' ||
                      e.category == _selectedCategory;
                  final q = _query.trim().toLowerCase();
                  final matchesQuery =
                      q.isEmpty ||
                      e.name.toLowerCase().contains(q) ||
                      e.alias.any((a) => a.toLowerCase().contains(q)) ||
                      e.description.toLowerCase().contains(q) ||
                      e.standardsRef.toLowerCase().contains(q) ||
                      e.typicalUse.toLowerCase().contains(q) ||
                      e.category.toLowerCase().contains(q);
                  return matchesCategory && matchesQuery;
                }).toList(),
                compact: _compactView,
                proMode: isPro,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<SymbolItem> _buildCatalog() {
    // Puedes ajustar/añadir componentes; intenta mantener nombres y categorías coherentes
    return const [
      // ACTIVOS
      SymbolItem(
        category: 'Activos',
        name: 'Diodo',
        icon: Icons.straight,
        alias: ['Rectificador'],
        description: 'Conduce en un solo sentido.',
        standardsRef: 'IEC 60617-11-02 / ANSI Y32.2',
        typicalUse: 'Rectificación, protección.',
      ),
      SymbolItem(
        category: 'Activos',
        name: 'LED',
        icon: Icons.light_mode,
        alias: ['Diodo emisor de luz'],
        description: 'Emite luz al conducir.',
        standardsRef: 'IEC 60617-11-16',
        typicalUse: 'Indicadores, iluminación.',
      ),
      SymbolItem(
        category: 'Activos',
        name: 'Amplificador Operacional',
        icon: Icons.graphic_eq,
        alias: ['OpAmp', 'A.O.'],
        description: 'Bloque analógico de alta ganancia.',
        standardsRef: 'IEC 60617-13-12',
        typicalUse: 'Filtros, comparadores.',
      ),

      // FUENTES
      SymbolItem(
        category: 'Fuentes',
        name: 'Fuente de DC',
        icon: Icons.battery_charging_full,
        alias: ['Batería'],
        description: 'Suministro de tensión continua.',
        standardsRef: 'IEC 60617-02-03',
        typicalUse: 'Alimentación electrónica.',
      ),
      SymbolItem(
        category: 'Fuentes',
        name: 'Convertidor Buck',
        icon: Icons.power,
        alias: ['Step-Down'],
        description: 'Reductor conmutado de tensión.',
        standardsRef: 'Símbolo funcional',
        typicalUse: 'Bajar 12→5 V.',
      ),

      // MEDICIÓN
      SymbolItem(
        category: 'Medición',
        name: 'Voltímetro',
        icon: Icons.flash_on,
        alias: ['V-meter'],
        description: 'Mide tensión eléctrica.',
        standardsRef: 'IEC 60417-5007',
        typicalUse: 'Pruebas y diagnóstico.',
      ),

      // SEMICONDUCTORES
      SymbolItem(
        category: 'Semiconductores',
        name: 'Diodo Zener',
        icon: Icons.timeline,
        alias: ['Zener'],
        description: 'Tensión de ruptura definida.',
        standardsRef: 'IEC 60617-11-07',
        typicalUse: 'Referencia/limitación de voltaje.',
      ),

      // LÓGICA
      SymbolItem(
        category: 'Lógica',
        name: 'Puerta NOT',
        icon: Icons.switch_left,
        alias: ['Inversor'],
        description: 'Invierte el nivel lógico.',
        standardsRef: 'IEC 60617-12-21',
        typicalUse: 'Buffers inversores.',
      ),

      // ELECTROMECÁNICOS
      SymbolItem(
        category: 'Electromecánicos',
        name: 'Interruptor SPST',
        icon: Icons.toggle_on,
        alias: ['Switch'],
        description: 'Un polo, una vía (ON/OFF).',
        standardsRef: 'IEC 60617-07-01',
        typicalUse: 'Conmutación básica.',
      ),

      // PASIVOS
      SymbolItem(
        category: 'Pasivos',
        name: 'Resistencia',
        icon: Icons.linear_scale,
        alias: ['Resistor', 'R'],
        description: 'Oposición al paso de corriente.',
        standardsRef: 'IEC 60617-02-04',
        typicalUse: 'Limitación y divisores.',
      ),
      SymbolItem(
        category: 'Pasivos',
        name: 'Capacitor',
        icon: Icons.view_week,
        alias: ['Condensador', 'C'],
        description: 'Almacena energía eléctrica.',
        standardsRef: 'IEC 60617-02-05',
        typicalUse: 'Filtrado, acoplo.',
      ),
      SymbolItem(
        category: 'Pasivos',
        name: 'Inductor',
        icon: Icons.waves,
        alias: ['Bobina', 'L'],
        description: 'Almacena energía en campo magnético.',
        standardsRef: 'IEC 60617-02-06',
        typicalUse: 'Filtros, convertidores.',
      ),
    ];
  }
}

/* ---------- UI Aux ---------- */

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Buscar símbolo, alias o uso…',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: controller.text.isEmpty
              ? null
              : IconButton(onPressed: onClear, icon: const Icon(Icons.clear)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          filled: true,
        ),
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({
    required this.categories,
    required this.selected,
    required this.onSelected,
    this.counts,
  });

  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelected;
  final Map<String, int>? counts;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 46,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final c = categories[i];
          final selectedNow = c == selected;
          return ChoiceChip(
            label: Text(counts == null ? c : '$c (${counts![c] ?? 0})'),
            selected: selectedNow,
            onSelected: (_) => onSelected(c),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            visualDensity: VisualDensity.compact,
            side: BorderSide(
              color: selectedNow ? scheme.primary : scheme.outlineVariant,
            ),
          );
        },
      ),
    );
  }
}

class _SymbolsGrid extends StatelessWidget {
  const _SymbolsGrid({
    required this.items,
    required this.compact,
    required this.proMode,
  });

  final List<SymbolItem> items;
  final bool compact; // true => grid
  final bool proMode;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const _EmptyState();

    if (!compact) {
      // LISTA
      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        itemCount: items.length,
        itemBuilder: (context, i) =>
            _SymbolCard(item: items[i], dense: false, proMode: proMode),
      );
    }

    // GRID
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final cols = proMode
            ? (w >= 1200
                  ? 4
                  : w >= 900
                  ? 3
                  : 2)
            : 2;

        // alturas móviles-first para asegurar que no haya overflow
        final double cellHeight = w <= 380
            ? (proMode ? 190 : 180)
            : w <= 440
            ? (proMode ? 200 : 190)
            : (proMode ? 210 : 200);

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: cellHeight, // altura fija
          ),
          itemCount: items.length,
          itemBuilder: (context, i) =>
              _SymbolCard(item: items[i], dense: true, proMode: proMode),
        );
      },
    );
  }
}

class _SymbolCard extends StatelessWidget {
  const _SymbolCard({
    required this.item,
    required this.dense,
    required this.proMode,
  });

  final SymbolItem item;
  final bool dense; // grid=true
  final bool proMode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final border = proMode
        ? Border.all(color: scheme.primary, width: 1.25)
        : Border.all(color: scheme.outlineVariant);

    final bg = proMode ? scheme.surfaceContainerHigh : scheme.surface;

    final titleStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: 0.2,
    );

    final subtitleMax = dense ? 1 : (proMode ? 2 : 3);

    final Widget footer = dense
        ? SizedBox(
            height: 26,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: proMode
                    ? [
                        _ProPill(
                          icon: Icons.rule_folder_outlined,
                          label: 'Norma',
                          value: item.standardsRef,
                        ),
                        const SizedBox(width: 6),
                        _ProPill(
                          icon: Icons.handyman_outlined,
                          label: 'Uso',
                          value: item.typicalUse,
                        ),
                      ]
                    : [
                        _Tag(item.category),
                        const SizedBox(width: 6),
                        ...item.alias
                            .take(1)
                            .map(
                              (a) => Padding(
                                padding: const EdgeInsets.only(right: 6),
                                child: _Tag(a),
                              ),
                            ),
                      ],
              ),
            ),
          )
        : Wrap(
            spacing: 6,
            runSpacing: dense ? -6 : 6,
            children: proMode
                ? [
                    _ProPill(
                      icon: Icons.rule_folder_outlined,
                      label: 'Norma',
                      value: item.standardsRef,
                    ),
                    _ProPill(
                      icon: Icons.handyman_outlined,
                      label: 'Uso',
                      value: item.typicalUse,
                    ),
                    _ProPill(
                      icon: Icons.category_outlined,
                      label: 'Cat',
                      value: item.category,
                    ),
                  ]
                : [_Tag(item.category), ...item.alias.take(2).map(_Tag.new)],
          );

    return Material(
      color: bg,
      elevation: proMode ? 1.2 : 0,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showDetails(context),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: border,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(item.icon, size: dense ? 26 : 30, color: scheme.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: titleStyle,
                    ),
                  ),
                ],
              ),
              SizedBox(height: dense ? 6 : 8),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(
                    item.icon,
                    size: dense ? 44 : 56,
                    color: scheme.primary.withValues(alpha: 0.35),
                  ),
                ),
              ),
              SizedBox(height: dense ? 6 : 8),
              Text(
                item.description,
                maxLines: subtitleMax,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              footer,
            ],
          ),
        ),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(item.icon, size: 28, color: scheme.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: Icon(
                  item.icon,
                  size: 72,
                  color: scheme.primary.withValues(alpha: 0.75),
                ),
              ),
              const SizedBox(height: 16),
              _DetailRow(label: 'Categoría', value: item.category),
              _DetailRow(label: 'Alias', value: item.alias.join(', ')),
              _DetailRow(label: 'Uso típico', value: item.typicalUse),
              _DetailRow(label: 'Norma/Referencia', value: item.standardsRef),
              const SizedBox(height: 12),
              Text(item.description, style: theme.textTheme.bodyLarge),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}

/* ---------- Chips / Pills ---------- */

class _ProPill extends StatelessWidget {
  const _ProPill({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: scheme.primary),
          const SizedBox(width: 6),
          Text(
            '$label: ',
            style: TextStyle(
              color: scheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 180),
            child: Text(value, overflow: TextOverflow.ellipsis, maxLines: 1),
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        border: Border.all(color: scheme.outlineVariant),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, overflow: TextOverflow.ellipsis),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(value, overflow: TextOverflow.ellipsis, maxLines: 2),
          ),
        ],
      ),
    );
  }
}

/* ---------- Modelo ---------- */

class SymbolItem {
  final String category;
  final String name;
  final IconData icon;
  final List<String> alias;
  final String description;
  final String standardsRef;
  final String typicalUse;

  const SymbolItem({
    required this.category,
    required this.name,
    required this.icon,
    required this.alias,
    required this.description,
    required this.standardsRef,
    required this.typicalUse,
  });
}

/* ---------- Estados vacíos ---------- */

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 42, color: theme.colorScheme.outline),
          const SizedBox(height: 8),
          Text('Sin resultados', style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            'Prueba con otra palabra clave o cambia de categoría.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
