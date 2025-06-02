import 'package:flutter/material.dart';
import 'home_page.dart';

/*
 * Schermata iniziale con animazione splash.
 * Mostra due pannelli che si aprono orizzontalmente rivelando la HomePage.
 */
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool _showContent = false;

  //Inizializza il controller dell’animazione e imposta il ritardo iniziale. Quando l’animazione termina, mostra la `HomePage`.
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _showContent = true;
        });
      }
    });

    // Avvia l’animazione dopo 800ms per un effetto di attesa iniziale
    Future.delayed(const Duration(milliseconds: 800), () {
      _controller.forward();
    });
  }

  // Libera le risorse usate dall’animazione.
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  //Costruisce lo splash screen con due pannelli animati e il logo. Alla fine dell’animazione, mostra la `HomePage`.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Mostra la HomePage solo quando l’animazione è completata
          if (_showContent) const HomePage(),

          // Mostra l’animazione finché _showContent è false
          if (!_showContent)
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Row(
                  children: [
                    // Pannello sinistro (colore chiaro)
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      color: Colors.brown[200],
                    ),

                    // Pannello destro (colore scuro) con animazione di rotazione
                    Transform(
                      alignment: Alignment.centerLeft,
                      transform:
                          Matrix4.identity()
                            ..setEntry(3, 2, 0.001) // profondità per effetto 3D
                            ..rotateY(_animation.value * 3.14),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        color: Colors.brown[800],
                        child: Center(
                          child: Image.asset(
                            'assets/icon/Logo_def.png',
                            width: 120,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}
