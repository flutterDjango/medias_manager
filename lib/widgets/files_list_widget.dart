import 'dart:io';

import 'package:flutter/material.dart';
import 'package:medias_manager/utils/utils.dart';
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
  var checkAllPermissions = CheckPermission();

  var getFilesPath = DirectoriesPath();
  directoriesPath() async {
    var filesJsonList = [];
    List<FileSystemEntity> files =
        await getFilesPath.localFiles(widget.mediaCategory);
    // https://flutterexperts.com/convert-object-to-json-in-dart-flutter/
    debugPrint('-- $files');
    debugPrint(filesList.toString());
    for (var file in files) {
      filesJsonList
          .add({"path": file.path, "fileName": file.path.split('/').last});
    }
    setState(() {
      filesList = filesJsonList;
    });
  }

  checkPermission() async {
    var permission = await checkAllPermissions.storagePermission();
    // var permission = await checkAllPermissions.isStoragePermission();
    debugPrint("------------- $permission $checkAllPermissions");
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

  // var filesList = [
  //   {
  //     "id": "1",
  //     "title": "file Video 1",
  //     "url": "https://download.samplelib.com/mp4/sample-20s.mp4"
  //   },
  //   {
  //     "id": "2",
  //     "title": "file Video 2",
  //     "url": "https://download.samplelib.com/mp4/sample-15s.mp4"
  //   },
  //   {
  //     "id": "3",
  //     "title": "file Video 3",
  //     "url": "https://download.samplelib.com/mp4/sample-10s.mp4"
  //   },
  // ];
  // var getPath = DirectoriesPath();
  // var filesList = getPath.audioFiles;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isPermission
          ? filesList.isNotEmpty
              ? ListView.builder(
                  itemCount: filesList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var file = filesList[index];
                    return TileList(
                        fileName: file['fileName'],
                        path: file['path'],
                        mediaCategory: widget.mediaCategory);
                  },
                )
              : Center(
                  child:
                      Text('Aucun fichier ${widget.mediaCategory} disponible.'),
                )
          : TextButton(
              onPressed: () {
                checkPermission();
              },
              child: const Text("Problème de permission"),
            ),
    );
  }
}

class TileList extends StatelessWidget {
  const TileList(
      {super.key,
      required this.fileName,
      required this.path,
      required this.mediaCategory});

  final String fileName;
  final String path;
  final String mediaCategory;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shadowColor: Colors.grey.shade100,
      child: ListTile(
          title: Text(fileName),
          subtitle: Text(mediaCategory),
          leading: getIconMedia(mediaCategory),
          trailing: TextButton(
            onPressed: () {debugPrint('edit');},
            child: const Icon(Icons.edit),
          ),
          onTap: () {
            debugPrint('coucou $path');
            OpenFile.open(path);
          }),
    );
  }

  getIconMedia(mediaCategory) {
    if (mediaCategory == "Audio") {
      return const Icon(Icons.music_note);
    } else if (mediaCategory == "Video") {
      return const Icon(Icons.local_movies);
    } else if (mediaCategory == "Image") {
      return const Icon(Icons.photo);
    }
  }
}
