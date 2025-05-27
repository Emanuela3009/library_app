
import 'package:flutter/material.dart';
import 'home_page.dart';

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

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _showContent = true;
          });
        }
      });

    Future.delayed(const Duration(milliseconds: 800), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_showContent)
          const HomePage(), // oppure HomePage() se preferisci
          if (!_showContent)
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Row(
                  children: [
                    // Sinistra: retro copertina (fermo)
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      color: Colors.brown[200],
                    ),
                    // Destra: copertina animata che si apre
                    Transform(
                      alignment: Alignment.centerLeft,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
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