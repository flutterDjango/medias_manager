import 'dart:io';

import 'package:flutter/material.dart';
import 'package:medias_manager/utils/utils.dart';
import 'package:medias_manager/widgets/widgets.dart';

class ListMediaScreens extends StatefulWidget {
  const ListMediaScreens({super.key, required this.mediaCategory});

  final String mediaCategory;
  @override
  State<ListMediaScreens> createState() => _ListMediaScreensState();
}

class _ListMediaScreensState extends State<ListMediaScreens> {
  bool isPermission = false;
  List<FileSystemEntity> filesList = [];


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
        title: Center(
          child: Text(widget.mediaCategory),
        ),
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(
                Icons.add,
                color: Colors.black,
              ),
              style: IconButton.styleFrom(
                  backgroundColor: Colors.grey.shade200, iconSize: 30),
              onPressed: () async {
                await AddMediaFiles().addFiles(widget.mediaCategory);
                setState(() {
                  directoriesPath();
                });
              },
            ),
          ),
          
        ],
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
                              child: FilesList(
                                file: file,
                                mediaCategory: widget.mediaCategory,
                                filesList: filesList,
                              ));
                          
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
    );
  }
}
