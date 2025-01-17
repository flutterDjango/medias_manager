import 'dart:io';

import 'package:flutter/material.dart';
import 'package:medias_manager/screens/screens.dart';
import 'package:medias_manager/utils/utils.dart';
import 'package:medias_manager/widgets/widgets.dart';
import 'package:open_file_plus/open_file_plus.dart';

class FilesListWidget extends StatefulWidget {
  const FilesListWidget({super.key, required this.mediaCategory});

  final String mediaCategory;
  @override
  State<FilesListWidget> createState() => _FilesListWidgetState();
}

class _FilesListWidgetState extends State<FilesListWidget> {
  bool isPermission = false;
  var filesList = [];

  var getFilesPath = DirectoriesPath();
  directoriesPath() async {
    List<FileSystemEntity> files =
        await getFilesPath.localFiles(widget.mediaCategory);

    setState(() {
      filesList = files;
    });
  }

  checkPermission() async {
    var permission = await CheckPermission.storagePermission();
    if (permission) {
      setState(() {
        isPermission = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    directoriesPath();
    checkPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.mediaCategory)),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: const NavigatorDrawerWidget(),
      body: Column(
        children: [
          const HorizontalButtonBarWidget(
            homeScreen: false,
          ),
          if (widget.mediaCategory == 'Image')
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.pan_tool_alt_rounded),
                SizedBox(
                  width: 5,
                ),
                Text("Juxtaposer deux images"),
              ],
            ),
          isPermission
              ? filesList.isNotEmpty
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: filesList.length,
                        itemBuilder: (BuildContext context, int index) {
                          var file = filesList[index];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: TileList(
                              file: file,
                              mediaCategory: widget.mediaCategory,
                              fileList: filesList,
                            ),
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Text(
                          'Aucun fichier ${widget.mediaCategory} disponible.'),
                    )
              : TextButton(
                  onPressed: () {
                    checkPermission();
                  },
                  child: const Text("Problème de permission"),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await AddMediaFiles().addFiles(widget.mediaCategory);
          setState(() {
            directoriesPath();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TileList extends StatelessWidget {
  const TileList(
      {super.key,
      required this.file,
      required this.mediaCategory,
      required this.fileList});

  final FileSystemEntity file;
  final List<dynamic> fileList;
  final String mediaCategory;

  @override
  Widget build(BuildContext context) {
    final String fileName = file.path.split('/').last;
    return Padding(
      padding:
          const EdgeInsets.only(top: 8.0, bottom: 0.4, left: 1.0, right: 1.0),
      child: Card(
        elevation: 10,
        shadowColor: Colors.grey.shade100,
        color: Colors.grey.shade200,
        child: ListTile(
          title: Text(fileName),
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
                            filesList: fileList,
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
                      message: "Voulez-vous effacer le fichier '$fileName' ?",
                    ),
                  );

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
