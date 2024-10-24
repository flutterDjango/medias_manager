import 'package:flutter/material.dart';
class CircularProgressWidget extends StatelessWidget {
  const CircularProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
            child: CircularProgressIndicator(
              color: Colors.orangeAccent,
              backgroundColor: Colors.blueGrey,)
    );
  }
}