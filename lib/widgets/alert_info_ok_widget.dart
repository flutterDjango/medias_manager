import 'package:flutter/material.dart';

class AlertInfoOkWidget extends StatelessWidget {
  const AlertInfoOkWidget(
      {super.key, required this.title, required this.message});
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(child: Text(title)),
      content: Row(
        // mainAxisAlignment: MainAxisAlignment.,
        children: [
          const Icon(Icons.warning_amber, color: Colors.red,),
          const SizedBox(width: 10,),
          Text(message),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Ok'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
      elevation: 24.0,
    );
  }
}
