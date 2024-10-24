import 'package:flutter/material.dart';
import 'package:medias_manager/screens/audio_screen.dart';
import 'package:medias_manager/screens/video_screen.dart';
import 'package:medias_manager/widgets/files_list_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Title(
          color: Colors.white,
          child: const Text("Médias manager"),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FilesListWidget(
                      mediaCategory: "Vidéo",
                    ),
                  ),
                );
                //  Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const VideoScreen()),
                // );
              },
              child: const Text("Vidéo"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FilesListWidget(
                      mediaCategory: "Audio",
                    ),
                  ),
                );
              },
              child: const Text("Audio"),
            ),
          ],
        ),
      ),
    );
  }
}
