//widget per gestire il fatto che quando premo un icona dell'AppBar cambia colore (sempre rispettando il tema)
import 'package:flutter/material.dart';

class AppBarIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const AppBarIconButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(100), 
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Icon(
          icon,
          size: 28,
          color: Theme.of(context).appBarTheme.iconTheme?.color, // usa colore da tema
        ),
      ),
    );
  }
}
