import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

import '../utils/utils.dart';
import 'widgets.dart';

class SelectImagesCardWidget extends StatefulWidget {
  const SelectImagesCardWidget(
      {super.key,
      required this.file,
      required this.mediaCategory,
      required this.filesList});

  final FileSystemEntity file;
  final String mediaCategory;
  final List<dynamic> filesList;

  @override
  State<SelectImagesCardWidget> createState() => _SelectImagesCardWidgetState();
}

class _SelectImagesCardWidgetState extends State<SelectImagesCardWidget> {
  @override
  Widget build(BuildContext context) {
    widget.filesList.remove(widget.file);
    FileSystemEntity fileImage1 = widget.file;
    // debugPrint('file list ${widget.filesList.toString()}');
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
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Première image: ",
                style: TextStyle(fontSize: 18.0),
              ),
              Text(
                widget.file.path.split('/').last,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              )
            ],
          ),
          const Divider(
            thickness: 1.5,
            color: Colors.grey,
            indent: 20,
            endIndent: 20,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sélectionner la deuxième image.",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              Icon(Icons.pan_tool_alt_rounded)
            ],
          ),
          // Text(widget.filesList.toString()),
          // Text(widget.filesList.length.toString()),
          Expanded(
            child: ListView.builder(
              // shrinkWrap: true,
              itemCount: widget.filesList.length,
              itemBuilder: (BuildContext context, int index) {
                var file = widget.filesList[index];
                String fileName = file.path.split('/').last;
                // String fileExtension = file.path.split('.').last;
                Map<String, Map<String, dynamic>> imageSize = {};
                return Padding(
                  padding: const EdgeInsets.only(
                      top: 8.0, bottom: 0.4, left: 1.0, right: 1.0),
                  child: Card(
                    elevation: 10,
                    shadowColor: Colors.grey.shade100,
                    color: Colors.grey.shade200,
                    child: ListTile(
                      title: Text(fileName),
                      subtitle: Text(widget.mediaCategory),
                      leading: IconButton(
                        iconSize: 25,
                        onPressed: () {
                          OpenFile.open(file.path);
                        },
                        icon: MediasFormat.getIconMedia(widget.mediaCategory),
                      ),
                      trailing: IconButton(
                        iconSize: 25,
                        onPressed: () async {
                          FileSystemEntity fileImage2 = file;
                          List<FileSystemEntity> imagesFilesList = [
                            fileImage1,
                            fileImage2
                          ];
                          for (FileSystemEntity imageFile in imagesFilesList) {
                            await Helpers.getImageSize(imageFile, imageSize);
                          }
                          
                          if (context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => JuxtaposeImagesCardWidget(
                                  imagesFilesList: imagesFilesList,
                                  imagesSize: imageSize,
                                ),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.pan_tool_alt_rounded),
                      ),
                      onTap: () async {
                        await showModalBottomSheet(
                          context: context,
                          builder: (ctx) {
                            return DetailMediaWidget(
                                file: file,
                                mediaCategory: widget.mediaCategory);
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// const AlertInfoOkWidget(
//         title: "Attention !",
//         message: "Horaires de début et fin incohérents !",
//       );
//   }




// def rezise(photo, output, width):
//     subprocess.run(["ffmpeg", "-i", photo, "-vf", f"scale={width}:-1", output])


// if __name__ == "__main__":
//     photo = "../photos/exo2.jpg"
//     width = 2480
//     output_photo = f"../photos/exo2_{width}.jpg"
//     rezise(photo, output_photo, width)




// def join_two_images_horizontally(photo_1, photo_2, output_photo):
//     subprocess.run(
//         [
//             "ffmpeg",
//             "-i",
//             photo_1,
//             "-i",
//             photo_2,
//             "-filter_complex",
//             "hstack",
//             output_photo,
//         ]
//     )
