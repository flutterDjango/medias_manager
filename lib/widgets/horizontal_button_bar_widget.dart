import 'package:flutter/material.dart';
import 'package:medias_manager/screens/home_screen.dart';
import 'package:medias_manager/widgets/files_list_widget.dart';


class HorizontalButtonBarWidget extends StatelessWidget {
  const HorizontalButtonBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        FloatingActionButton(
          heroTag: 'Home',
          onPressed: () {
            Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen()
                  ),
                );
            // context.push(RouteLocation.createContact);
          },
          child: const Icon(Icons.home),
        ),
        FloatingActionButton(
          heroTag: 'Audio',
          onPressed: () {
            Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FilesListWidget(
                      mediaCategory: "Audio",
                    ),
                  ),
                );
            // context.push(RouteLocation.createContact);
          },
          child: const Icon(Icons.music_note),
        ),
        FloatingActionButton(
            heroTag: 'Video',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FilesListWidget(
                      mediaCategory: "Vidéo",
                    ),
                  ),
                );
              // //  context.push(RouteLocation.category);
            },
            child: const Icon(Icons.play_circle_outline),
          ),
          
      ]),
    );
  }
}
