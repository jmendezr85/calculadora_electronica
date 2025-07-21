import 'package:flutter/material.dart';
import 'package:calculadora_electronica/screens/ohm_law_screen.dart';
import 'package:calculadora_electronica/screens/resistor_color_code_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora Electrónica'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Opción para la Ley de Ohm
              Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const OhmLawScreen(),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.flash_on,
                          size: 40,
                          color: Colors.deepPurple,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Ley de Ohm',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Calcula voltaje, corriente y resistencia.',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Espacio entre tarjetas
              const SizedBox(height: 20),
              // Opción para el Código de Colores de Resistencias
              Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ResistorColorCodeScreen(),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Icon(Icons.colorize, size: 40, color: Colors.teal),
                        SizedBox(height: 10),
                        Text(
                          'Código de Colores de Resistencias',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Determina el valor de una resistencia por sus bandas de color.',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Puedes añadir más opciones aquí en el futuro
            ],
          ),
        ),
      ),
    );
  }
}
