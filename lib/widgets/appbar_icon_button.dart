import 'package:flutter/material.dart';

//Widget riutilizzabile per creare un'icona tappabile in una AppBar.
class AppBarIconButton extends StatelessWidget {
  final IconData icon; // Icona da mostrare
  final VoidCallback onTap; // Azione da eseguire al tocco

  const AppBarIconButton({super.key, required this.icon, required this.onTap});

  /// Costruisce l’icona tappabile con stile coerente al tema dell’AppBar.
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(
        100,
      ), // bordo rotondo per effetto splash
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Icon(
          icon,
          size: 28,
          color:
              Theme.of(
                context,
              ).appBarTheme.iconTheme?.color, // usa il colore dell’AppBar
        ),
      ),
    );
  }
}
