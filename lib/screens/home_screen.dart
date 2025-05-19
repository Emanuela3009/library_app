import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(     //allina verticalmente 
        crossAxisAlignment: CrossAxisAlignment.start,  //allinea a sinistra 
        children: [

          //sezione 1
          Padding(
            padding: const EdgeInsets.all(16),   //inserisce padding all interno del widget 
            child: Text("Currently reading", style: Theme.of(context).textTheme.titleLarge),
          ),
          
          
           // magari un ListView orizzontalev

          //sezione 2
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text("Popular now", style: Theme.of(context).textTheme.titleLarge),
          ),
          // ... contenuto ...


          //sezione 3
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text("Your books", style: Theme.of(context).textTheme.titleLarge),
          ),

        ],
      ),
    );
  }
}