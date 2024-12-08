import 'dart:io';

import 'package:flutter/material.dart';
import '../utils/utils.dart';
import 'widgets.dart';

class JuxtaposeImagesCardWidget extends StatefulWidget {
  const JuxtaposeImagesCardWidget(
      {super.key, required this.imagesFilesList, required this.imagesSize});

  final List<FileSystemEntity> imagesFilesList;
  final Map<String, Map<String, dynamic>> imagesSize;
  @override
  State<JuxtaposeImagesCardWidget> createState() =>
      _JuxtaposeImagesCardWidgetState();
}

class _JuxtaposeImagesCardWidgetState extends State<JuxtaposeImagesCardWidget> {
  final TextEditingController _juxtaposedImageNameController =
      TextEditingController();
  String? _firstImage;
  String? _secondImage;
  FileSystemEntity? _fileImage1;
  FileSystemEntity? _fileImage2;
  final _formGlobalKey = GlobalKey<FormState>();

  @override
  void initState() {
    _firstImage = getFirstImage();
    _secondImage = getSecondImage();
    super.initState();
  }

  @override
  void dispose() {
    _juxtaposedImageNameController.dispose();
    super.dispose();
  }

  String getFirstImage() {
    FileSystemEntity fileImage1 = widget.imagesFilesList[0];
    String fileName1 = fileImage1.path.split("/").last;
    debugPrint("das le init $fileName1");
    setState(
      () {
        _fileImage1 = fileImage1;
        // _firstImage = fileName1;
      },
    );
    return fileName1;
  }

  String getSecondImage() {
    FileSystemEntity fileImage2 = widget.imagesFilesList[1];
    String fileName2 = fileImage2.path.split("/").last;
    setState(
      () {
        _fileImage2 = fileImage2;
      },
    );
    return fileName2;
  }

  @override
  Widget build(BuildContext context) {
    // int image1Width = widget.imagesSize[_fileImage1!.path]!['width'];
    int image1Height = widget.imagesSize[_fileImage1!.path]!['height'];
    // int image2Width = widget.imagesSize[_fileImage2!.path]!['width'];
    int image2Height = widget.imagesSize[_fileImage2!.path]!['height'];
    int imageHeight = 0;
    String fileExtension = _fileImage1!.path.split('.').last;
    String outputFilePath = _fileImage1!.parent.path;
    String outputImage = "";
    const int nbMaxChar = 15;
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Juxtaposer deux images")),
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
      body: Form(
        key: _formGlobalKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const HorizontalButtonBarWidget(
                homeScreen: false,
              ),
              const SizedBox(
                height: 15,
              ),
              Card(
                elevation: 10,
                shadowColor: Colors.grey.shade100,
                color: Colors.grey.shade200,
                child: Column(
                  children: [
                    Text(
                      "Photo de gauche: $_firstImage",
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Photo de droite: $_secondImage",
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        FileSystemEntity? bufferFileImage = _fileImage1;
                        setState(
                          () {
                            _fileImage1 = _fileImage2;
                            _fileImage2 = bufferFileImage;
                            _firstImage = _fileImage1!.path.split("/").last;
                            _secondImage = _fileImage2!.path.split("/").last;
                          },
                        );
                      },
                      child: const Text("Permuter les images"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 15, right: 15, bottom: 20.0),
                      child: TextFormField(
                        controller: _juxtaposedImageNameController,
                        // keyboardType: TextInputType.text,
                        maxLength: nbMaxChar,
                        decoration: const InputDecoration(
                          label: Text("Nom du fichier de sortie"),
                        ),
                        validator: (value) {
                          return Helpers.validStringField(value, nbMaxChar);
                        },
                        onSaved: (value) {
                          outputImage =
                              "$outputFilePath/${value!}.$fileExtension";
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formGlobalKey.currentState!.validate()) {
                          _formGlobalKey.currentState!.save();
                          (image1Height >= image2Height)
                              ? imageHeight = image2Height
                              : imageHeight = image2Height;
                          // debugPrint(
                          //     "${_fileImage1!.path}, ${_fileImage2!.path}, $image1Height, $image2Height, $imageHeight");
                          await FfmpegCommands.juxtaposeTwoImageH(
                              _fileImage1!.path,
                              _fileImage2!.path,
                              imageHeight,
                              outputImage);
                          if (context.mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FilesListWidget(
                                  mediaCategory: "Image",
                                ),
                              ),
                            );
                          } else {
                            return;
                          }
                        }
                      },
                      child: const Text("Valider"),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Text("$outputFilePath/toto.$fileExtension"),

          // FfmpegCommands.juxtaposeTwoImageH(fileImage1.path, fileImage2.path, image1Height, outputImage);
          // for (FileSystemEntity imageFile in widget.imagesFilesList)
          //   Card(
          //     child: Column(
          //       children: [
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //           children: [
          //             Text(imageFile.path.split('/').last),
          //             Text(
          //                 "Largeur: ${widget.imagesSize[imageFile.path]!['width']}"),
          //             Text(
          //                 "Hauteur: ${widget.imagesSize[imageFile.path]!['height']}"),
          //           ],
          //         ),

          //       ],
          //     ),
          //   ),

          // Card(
          //   child: ,
          // ),
        ),
      ),
    );
  }
}
