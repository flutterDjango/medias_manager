import 'package:flutter/material.dart';

import 'package:medias_manager/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Title(
            color: Colors.white,
            child: const Text("Médias manager"),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: HorizontalButtonBarWidget(homeScreen: true,),
      ),
    );
  }
}
