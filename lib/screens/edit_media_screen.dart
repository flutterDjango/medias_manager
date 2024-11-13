import 'dart:io';

import 'package:flutter/material.dart';
import 'package:medias_manager/widgets/widgets.dart';

class EditMediaScreen extends StatefulWidget {
  const EditMediaScreen(
      {super.key,
      required this.mediaCategory,
      required this.fileName,
      required this.file});

  final String mediaCategory;
  final String fileName;
  final FileSystemEntity file;

  @override
  State<EditMediaScreen> createState() => _EditMediaScreenState();
}

class _EditMediaScreenState extends State<EditMediaScreen> {
  // final TextEditingController _mediaFileTitleController =
  //     TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(widget.fileName),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const HorizontalButtonBarWidget(
                homeScreen: false,
              ),
              if (widget.mediaCategory == "Vidéo")
                Column(
                  children: [
                    Center(
                      child: ExtractAudioCardWidget(
                        mediaCategory: widget.mediaCategory,
                        // audioFormat: audioFormat,
                        file: widget.file,
                      ),
                    ),
                    Center(
                      child: RemoveAudioCardWidget(
                        mediaCategory: widget.mediaCategory,
                        // audioFormat: audioFormat,
                        file: widget.file,
                      ),
                    ),
                    Center(
                      child: CutUpMediaCardWidget(
                        mediaCategory: widget.mediaCategory,
                        // audioFormat: audioFormat,
                        file: widget.file,
                      ),
                    ),
                  ],
                )
              else
                (widget.mediaCategory == "Audio")
                    ? Column(
                        children: [
                          Center(
                            child: CutUpMediaCardWidget(
                              mediaCategory: widget.mediaCategory,
                              // audioFormat: audioFormat,
                              file: widget.file,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Center(
                            child: JuxtaposeImagesCardWidget(
                                file: widget.file,),
                          ),
                        ],
                      ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // audioFormat(selected) {
  //   debugPrint("audio: $selected");
  // }
  // callback(selectedItem) {
  //   debugPrint('ici selectedIem $selectedItem');
  // }

  // List<String> getFormatList(mediaCategory, extract) {
  //   final String media = removeDiacritics(mediaCategory);

  //   if ((media == "Audio") | (extract)) {
  //     return ['mp3', "wav", "wma", "au", "m4a", "aac"];
  //   }
  //   if (media == "Video") {
  //     return ['mp4', "mov"];
  //   }
  //   return [];
  // }

  // Widget _extractCardWidget() {
  //   return Card(
  //     elevation: 10,
  //     shadowColor: Colors.grey.shade100,
  //     child: Padding(
  //       padding: const EdgeInsets.all(20.0),
  //       child: Column(
  //         children: [
  //           const Text(
  //             "Extraire l'audio de la vidéo.",
  //             style: TextStyle(fontSize: 20),
  //           ),
  //           const SizedBox(
  //             height: 20,
  //           ),
  //           DropdownItems(
  //             itemsList: getFormatList(widget.mediaCategory, true),
  //             initialItem: null,
  //             callback: callback,
  //           ),
  //           const SizedBox(
  //             height: 20,
  //           ),
  //           ElevatedButton(
  //             onPressed: () {},
  //             child: const Text("Extraire"),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
