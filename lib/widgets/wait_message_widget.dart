import 'package:flutter/material.dart';

import 'widgets.dart';

class WaitMessageWidget extends StatelessWidget {
  const WaitMessageWidget(
      {super.key, required this.title, required this.message});
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title),
        const SizedBox(
          height: 15,
        ),
        const CircularProgressWidget(),
        const SizedBox(
          height: 15,
        ),
        Text(message),
      ],
    );
  }
}
