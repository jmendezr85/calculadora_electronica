// lib/screens/battery_life_calculator_screen.dart

import 'package:flutter/material.dart';

class BatteryLifeCalculatorScreen extends StatefulWidget {
  const BatteryLifeCalculatorScreen({super.key});

  @override
  State<BatteryLifeCalculatorScreen> createState() =>
      _BatteryLifeCalculatorScreenState();
}

class _BatteryLifeCalculatorScreenState
    extends State<BatteryLifeCalculatorScreen>
    with SingleTickerProviderStateMixin {
  // Para la capacidad de la batería
  final TextEditingController _capacityController = TextEditingController();
  String _capacityUnit = 'mAh';
  final List<String> _capacityUnits = ['mAh', 'Ah'];

  // Para el consumo de corriente (opción directa)
  final TextEditingController _currentController = TextEditingController();
  String _currentUnit = 'mA';
  final List<String> _currentUnits = ['µA', 'mA', 'A'];

  // Para el consumo de potencia y voltaje (opción indirecta para calcular corriente)
  final TextEditingController _powerController = TextEditingController();
  final TextEditingController _voltageController = TextEditingController();
  String _powerUnit = 'mW';
  String _voltageUnit = 'V';

  final List<String> _powerUnits = ['mW', 'W'];
  final List<String> _voltageUnits = ['mV', 'V'];

  String _batteryLifeResult = '';

  // Animación de la batería
  late AnimationController _animationController;
  late Animation<double> _batteryAnimation;
  double _currentBatteryLevel =
      0.0; // Usado para el valor final del CircularProgressIndicator

  // Selector del método de entrada de corriente
  bool _directCurrentInputMode = true;

  // Selector del formato de tiempo de salida
  String _selectedTimeFormatUnit = 'Horas';
  final List<String> _timeFormatUnits = [
    'Segundos',
    'Minutos',
    'Horas',
    'Días',
    'Semanas',
    'Meses',
    'Años',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 1,
      ), // Duración de la animación de llenado
    );
    _batteryAnimation =
        Tween<double>(
          begin: 0.0,
          end: 0.0,
        ).animate(_animationController)..addListener(() {
          setState(
            () {},
          ); // Reconstruye el widget cada vez que cambia el valor de la animación
        });
  }

  // Función para convertir valores de entrada a unidades base
  double _convertToBaseCapacity(double value, String unit) {
    switch (unit) {
      case 'mAh':
        return value / 1000; // Convertir mAh a Ah
      case 'Ah':
      default:
        return value; // Ya está en Ah
    }
  }

  double _convertToBaseCurrent(double value, String unit) {
    switch (unit) {
      case 'µA':
        return value / 1e6; // Convertir µA a A
      case 'mA':
        return value / 1000; // Convertir mA a A
      case 'A':
      default:
        return value; // Ya está en A
    }
  }

  double _convertToBasePower(double value, String unit) {
    switch (unit) {
      case 'mW':
        return value / 1000; // Convertir mW a W
      case 'W':
      default:
        return value; // Ya está en W
    }
  }

  double _convertToBaseVoltage(double value, String unit) {
    switch (unit) {
      case 'mV':
        return value / 1000; // Convertir mV a V
      case 'V':
      default:
        return value; // Ya está en V
    }
  }

  void _calculateBatteryLife() {
    setState(() {
      final double rawCapacity =
          double.tryParse(_capacityController.text) ?? 0.0;
      double currentA = 0.0;

      if (_directCurrentInputMode) {
        final double rawCurrent =
            double.tryParse(_currentController.text) ?? 0.0;
        currentA = _convertToBaseCurrent(rawCurrent, _currentUnit);
      } else {
        final double rawPower = double.tryParse(_powerController.text) ?? 0.0;
        final double rawVoltage =
            double.tryParse(_voltageController.text) ?? 0.0;

        final double powerW = _convertToBasePower(rawPower, _powerUnit);
        final double voltageV = _convertToBaseVoltage(rawVoltage, _voltageUnit);

        if (voltageV > 0) {
          currentA = powerW / voltageV; // I = P / V
        } else {
          _batteryLifeResult = 'El voltaje no puede ser cero.';
          _currentBatteryLevel = 0.0;
          _animationController.reset();
          return; // Salir si el voltaje es inválido
        }
      }

      if (rawCapacity > 0 && currentA > 0) {
        final double capacityAh = _convertToBaseCapacity(
          rawCapacity,
          _capacityUnit,
        );

        // Fórmula: Vida útil (horas) = Capacidad (Ah) / Corriente (A)
        final double batteryLifeHours = capacityAh / currentA;

        _batteryLifeResult = _formatBatteryLife(
          batteryLifeHours,
          _selectedTimeFormatUnit,
        );
        _currentBatteryLevel =
            1.0; // Representa que el cálculo se completó y la batería 'llena'

        // Iniciar la animación
        _animationController.reset();
        _batteryAnimation = Tween<double>(
          begin: 0.0,
          end: _currentBatteryLevel,
        ).animate(_animationController);
        _animationController.forward();
      } else {
        _batteryLifeResult = 'Ingrese valores válidos';
        _currentBatteryLevel = 0.0;
        _animationController.reset();
      }
    });
  }

  // Función para formatear la vida útil de la batería según la unidad seleccionada
  String _formatBatteryLife(double hours, String unit) {
    double value;
    String suffix;

    switch (unit) {
      case 'Segundos':
        value = hours * 3600;
        suffix = 'segundos';
        break;
      case 'Minutos':
        value = hours * 60;
        suffix = 'minutos';
        break;
      case 'Horas':
        value = hours;
        suffix = 'horas';
        break;
      case 'Días':
        value = hours / 24;
        suffix = 'días';
        break;
      case 'Semanas':
        value = hours / (24 * 7);
        suffix = 'semanas';
        break;
      case 'Meses':
        value = hours / (24 * 30.4375); // Promedio de días al mes
        suffix = 'meses';
        break;
      case 'Años':
        value = hours / (24 * 365.25);
        suffix = 'años';
        break;
      default:
        value = hours;
        suffix = 'horas'; // Por defecto
    }
    return '${value.toStringAsFixed(2)} $suffix';
  }

  void _clearCalculations() {
    setState(() {
      _capacityController.clear();
      _currentController.clear();
      _powerController.clear();
      _voltageController.clear();

      _capacityUnit = 'mAh';
      _currentUnit = 'mA';
      _powerUnit = 'mW';
      _voltageUnit = 'V';

      _batteryLifeResult = '';
      _currentBatteryLevel = 0.0; // Restablecer la visualización
      _animationController.reset(); // Reiniciar la animación
    });
  }

  @override
  void dispose() {
    _capacityController.dispose();
    _currentController.dispose();
    _powerController.dispose();
    _voltageController.dispose();
    _animationController
        .dispose(); // IMPORTANTE: Disponer del controlador de animación
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de Vida de Batería'),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calcule la vida útil de una batería basándose en su capacidad y el consumo de corriente/potencia del dispositivo.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            _buildInputField(
              controller: _capacityController,
              labelText: 'Capacidad de la Batería',
              hintText: 'Ej: 2000',
              unit: _capacityUnit,
              units: _capacityUnits,
              onUnitChanged: (newValue) {
                setState(() {
                  _capacityUnit = newValue!;
                });
              },
              icon: Icons.battery_charging_full,
            ),
            const SizedBox(height: 20),
            Text(
              'Cómo desea ingresar el consumo:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('Corriente Directa'),
                    value: true,
                    groupValue: _directCurrentInputMode,
                    onChanged: (bool? value) {
                      setState(() {
                        _directCurrentInputMode = value!;
                        _clearCalculations();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('Potencia y Voltaje'),
                    value: false,
                    groupValue: _directCurrentInputMode,
                    onChanged: (bool? value) {
                      setState(() {
                        _directCurrentInputMode = value!;
                        _clearCalculations();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            if (_directCurrentInputMode)
              _buildInputField(
                controller: _currentController,
                labelText: 'Corriente de Consumo',
                hintText: 'Ej: 50',
                unit: _currentUnit,
                units: _currentUnits,
                onUnitChanged: (newValue) {
                  setState(() {
                    _currentUnit = newValue!;
                  });
                },
                icon: Icons.electrical_services,
              )
            else
              Column(
                children: [
                  _buildInputField(
                    controller: _powerController,
                    labelText: 'Potencia del Dispositivo',
                    hintText: 'Ej: 0.5',
                    unit: _powerUnit,
                    units: _powerUnits,
                    onUnitChanged: (newValue) {
                      setState(() {
                        _powerUnit = newValue!;
                      });
                    },
                    icon: Icons.power,
                  ),
                  const SizedBox(height: 15),
                  _buildInputField(
                    controller: _voltageController,
                    labelText: 'Voltaje de la Batería (o del Dispositivo)',
                    hintText: 'Ej: 3.7',
                    unit: _voltageUnit,
                    units: _voltageUnits,
                    onUnitChanged: (newValue) {
                      setState(() {
                        _voltageUnit = newValue!;
                      });
                    },
                    icon: Icons.flash_on,
                  ),
                ],
              ),
            const SizedBox(height: 20),
            Text(
              'Formato de Tiempo de Salida:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            DropdownButton<String>(
              value: _selectedTimeFormatUnit,
              isExpanded: true,
              items: _timeFormatUnits.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedTimeFormatUnit = newValue!;
                  if (_batteryLifeResult.isNotEmpty &&
                      _batteryLifeResult != 'Ingrese valores válidos' &&
                      _batteryLifeResult != 'El voltaje no puede ser cero.') {
                    // Recalcular el formato si ya hay un resultado
                    final double rawCapacity =
                        double.tryParse(_capacityController.text) ?? 0.0;
                    double currentA = 0.0;

                    if (_directCurrentInputMode) {
                      final double rawCurrent =
                          double.tryParse(_currentController.text) ?? 0.0;
                      currentA = _convertToBaseCurrent(
                        rawCurrent,
                        _currentUnit,
                      );
                    } else {
                      final double rawPower =
                          double.tryParse(_powerController.text) ?? 0.0;
                      final double rawVoltage =
                          double.tryParse(_voltageController.text) ?? 0.0;
                      final double powerW = _convertToBasePower(
                        rawPower,
                        _powerUnit,
                      );
                      final double voltageV = _convertToBaseVoltage(
                        rawVoltage,
                        _voltageUnit,
                      );
                      currentA = (voltageV > 0) ? powerW / voltageV : 0.0;
                    }
                    if (rawCapacity > 0 && currentA > 0) {
                      final double capacityAh = _convertToBaseCapacity(
                        rawCapacity,
                        _capacityUnit,
                      );
                      final double batteryLifeHours = capacityAh / currentA;
                      _batteryLifeResult = _formatBatteryLife(
                        batteryLifeHours,
                        _selectedTimeFormatUnit,
                      );
                    }
                  }
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _calculateBatteryLife,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Calcular Vida Útil'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _clearCalculations,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Theme.of(context).colorScheme.errorContainer,
                foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
              ),
              child: const Text('Borrar Cálculos'),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resultado de la Vida Útil:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: AnimatedBuilder(
                        animation: _batteryAnimation,
                        builder: (context, child) {
                          // Define el color basado en el progreso de la animación
                          Color indicatorColor;
                          if (_batteryAnimation.value > 0.6) {
                            indicatorColor = Colors.green;
                          } else if (_batteryAnimation.value > 0.3) {
                            indicatorColor = Colors.orange;
                          } else {
                            indicatorColor = Colors.red;
                          }

                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: CircularProgressIndicator(
                                  value: _batteryAnimation
                                      .value, // Usa el valor de la animación
                                  strokeWidth: 10,
                                  backgroundColor: Colors.grey.shade300,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    indicatorColor,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.battery_full,
                                size: 60,
                                color: indicatorColor,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        _batteryLifeResult.isNotEmpty &&
                                _batteryLifeResult !=
                                    'Ingrese valores válidos' &&
                                _batteryLifeResult !=
                                    'El voltaje no puede ser cero.'
                            ? 'La batería durará aproximadamente:'
                            : 'Ingrese datos para calcular.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                    Center(
                      child: Text(
                        _batteryLifeResult,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium!
                            .copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget genérico para campos de entrada con selector de unidad e icono
  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    String? hintText,
    required String unit,
    required List<String> units,
    required ValueChanged<String?> onUnitChanged,
    IconData? icon,
  }) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: Theme.of(context).colorScheme.secondary),
          const SizedBox(width: 10),
        ],
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: labelText,
              hintText: hintText,
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 10),
        DropdownButton<String>(
          value: unit,
          items: units.map((String value) {
            return DropdownMenuItem<String>(
              // <--- CORRECCIÓN AQUÍ
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onUnitChanged,
        ),
      ],
    );
  }
}
