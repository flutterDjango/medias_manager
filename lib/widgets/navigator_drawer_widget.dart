import 'package:flutter/material.dart';
import 'package:medias_manager/screens/screens.dart';

import 'widgets.dart';

class NavigatorDrawerWidget extends StatelessWidget {
  const NavigatorDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width*0.4,
      backgroundColor: Colors.grey.shade200,
      child: ListView(
        padding: const EdgeInsets.only(top: 40),
        children: [
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Accueil"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.music_note),
            title: const Text("Audio"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FilesListWidget(
                    mediaCategory: "Audio",
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.play_circle_outline),
            title: const Text("Vidéo"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FilesListWidget(
                    mediaCategory: "Vidéo",
                  ),
                ),
              );
            },
          ),
           ListTile(
            leading: const Icon(Icons.image_outlined),
            title: const Text("Image"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FilesListWidget(
                    mediaCategory: "Image",
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
