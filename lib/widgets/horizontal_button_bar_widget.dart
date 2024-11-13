import 'package:flutter/material.dart';
import 'package:medias_manager/screens/home_screen.dart';
import 'package:medias_manager/widgets/files_list_widget.dart';

class HorizontalButtonBarWidget extends StatelessWidget {
  const HorizontalButtonBarWidget({super.key, required this.homeScreen});

  final bool homeScreen;

  @override
  Widget build(BuildContext context) {
    final Color bgColor = Colors.grey.shade200;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        if (!homeScreen)
          FloatingActionButton(
            heroTag: 'Home',
            backgroundColor: bgColor,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
              // context.push(RouteLocation.createContact);
            },
            child: const Icon(Icons.home),
          ),
        FloatingActionButton(
          heroTag: 'Audio',
          backgroundColor: bgColor,
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
          backgroundColor: bgColor,
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
        FloatingActionButton(
          heroTag: 'Image',
          backgroundColor: bgColor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FilesListWidget(
                  mediaCategory: "Image",
                ),
              ),
            );
            // //  context.push(RouteLocation.category);
          },
          child: const Icon(Icons.image_outlined),
        ),
      ],),
    );
  }
}
