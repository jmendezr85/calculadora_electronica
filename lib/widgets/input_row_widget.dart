import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class InputRowWidget extends StatelessWidget {
  final IconData icon;
  final String labelText;
  final TextEditingController controller;
  final String selectedUnit;
  final List<String> units;
  final ValueChanged<String?> onUnitChanged;

  const InputRowWidget({
    super.key,
    required this.icon,
    required this.labelText,
    required this.controller,
    required this.selectedUnit,
    required this.units,
    required this.onUnitChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: labelText,
                  border: InputBorder.none, // Remove default border
                  isDense: true,
                ),
                // Ya no hay onChanged aquí, ya que el cálculo se hace al pulsar el botón
              ),
            ),
            SizedBox(
              width: 80, // Fixed width for dropdown
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedUnit,
                  onChanged:
                      onUnitChanged, // Pasa el nuevo valor a la pantalla padre
                  items: units.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  isExpanded: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<IconData>('icon', icon))
      ..add(StringProperty('labelText', labelText))
      ..add(
        DiagnosticsProperty<TextEditingController>('controller', controller),
      )
      ..add(StringProperty('selectedUnit', selectedUnit))
      ..add(IterableProperty<String>('units', units))
      ..add(
        ObjectFlagProperty<ValueChanged<String?>>.has(
          'onUnitChanged',
          onUnitChanged,
        ),
      );
  }
}
