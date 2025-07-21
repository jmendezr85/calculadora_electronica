import 'package:flutter/material.dart';
import 'package:calculadora_electronica/screens/home_screen.dart'; // Importa la nueva pantalla de inicio

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora Electrónica',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(), // Establece HomeScreen como la pantalla inicial
      debugShowCheckedModeBanner:
          false, // Opcional: para quitar el banner de "DEBUG"
    );
  }
}
