import 'package:flutter/material.dart';

class FadePageRoute extends PageRouteBuilder<void> {
  final Widget child;

  FadePageRoute({required this.child})
    : super(
        pageBuilder: (context, animation, secondaryAnimation) => child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(
          milliseconds: 300,
        ), // Duración de la animación
      );
}
