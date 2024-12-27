import 'package:flutter/material.dart';

class AlertInfoOkWidget extends StatelessWidget {
  const AlertInfoOkWidget(
      {super.key, required this.title, required this.message, required this.icon});
  final String title;
  final String message;
  final bool icon;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text(title)),
      content: Row(
        children: [
          if (icon)
            const Icon(Icons.warning_amber, color: Colors.red,),
          const SizedBox(width: 10,),
          Expanded(child: Text(message)),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
      elevation: 24.0,
    );
  }
}
