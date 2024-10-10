import 'package:flutter/material.dart';
import 'package:medias_manager/widgets/files_list_widget.dart';

class AudioScreen extends StatelessWidget {
  const AudioScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Title(
          color: Colors.cyan,
          child: const Text("Audio"),
        ),
      ),
      body: const FilesListWidget(mediaCategory: "Audio",),
      // body: Center(
      //   child: ElevatedButton(
      //     onPressed: () {
      //        Navigator.pop(context);
      //     },
      //     child: const Text("Retour"),
      //   ),
      // ),
    );
  }
}
