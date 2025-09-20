import 'package:calculadora_electronica/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProModeBadge extends StatelessWidget {
  const ProModeBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final isPro = context.select<AppSettings, bool>((s) => s.professionalMode);

    return isPro
        ? Chip(
            label: const Text('PRO'),
            backgroundColor: Colors.deepPurple.withAlpha(51),
            labelStyle: const TextStyle(
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          )
        : const SizedBox.shrink();
  }
}
