import 'dart:io';

import 'package:flutter/material.dart';
import 'package:medias_manager/widgets/widgets.dart';
import 'package:open_file_plus/open_file_plus.dart';

import '../screens/screens.dart';
import 'utils.dart';

class FilesList extends StatelessWidget {
  const FilesList(
      {super.key,
      required this.file,
      required this.mediaCategory,
      required this.filesList});

  final FileSystemEntity file;
  final List<dynamic> filesList;
  final String mediaCategory;

  @override
  Widget build(BuildContext context) {
    final String fileName = file.path.split('/').last;
    return Padding(
      padding:
          const EdgeInsets.only(top: 8.0, bottom: 0.2, left: 1.0, right: 1),
      child: Card(
        elevation: 10,
        shadowColor: Colors.grey.shade100,
        color: Colors.grey.shade200,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          dense: true,
          visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
          title: Text(
            fileName,
            style: const TextStyle(fontSize: 15.0),
          ),
          subtitle: Text(mediaCategory),
          leading: IconButton(
              iconSize: 25,
              onPressed: () {
                OpenFile.open(file.path);
              },
              icon: MediasFormat.getIconMedia(mediaCategory)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (mediaCategory == "Image")
                IconButton(
                    iconSize: 25,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectImagesCardWidget(
                            file: file,
                            // fileName: fileName,
                            filesList: filesList,
                            mediaCategory: mediaCategory,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.pan_tool_alt_rounded)),
              IconButton(
                iconSize: 25,
                onPressed: () async {
                  final result = await showDialog(
                    context: context,
                    builder: (_) => AlertDialogYesNoWidget(
                        title: "Attention!",
                        message:
                            "Voulez-vous effacer le fichier '$fileName' ?"),
                  );
                  // const confirm =  AlertDialogYesNoWidget(title: "Effacer le fichier",message: "Voulez-vous effacer le fichier ?");

                  if (!result) {
                    return;
                  }
                  if (file.existsSync()) {
                    file.deleteSync();
                  }
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FilesListWidget(
                          mediaCategory: mediaCategory,
                        ),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.delete),
              ),
              IconButton(
                iconSize: 25,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditMediaScreen(
                          mediaCategory: mediaCategory,
                          fileName: fileName,
                          file: file),
                    ),
                  );
                },
                icon: const Icon(Icons.navigate_next),
              ),
            ],
          ),
          onTap: () async {
            await showModalBottomSheet(
              context: context,
              builder: (ctx) {
                return DetailMediaWidget(
                    file: file, mediaCategory: mediaCategory);
              },
            );
          },
        ),
      ),
    );
  }
}
