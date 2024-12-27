import 'dart:io';

import 'package:flutter/material.dart';
import 'package:medias_manager/screens/list_media_screen.dart';
import 'package:medias_manager/utils/utils.dart';

import 'widgets.dart';

class RemoveAudioCardWidget extends StatefulWidget {
  const RemoveAudioCardWidget(
      {super.key,
      required this.mediaCategory,
      // required this.audioFormat,
      required this.file});

  final String mediaCategory;
  // final Function(String) audioFormat;
  final FileSystemEntity file;

  @override
  State<RemoveAudioCardWidget> createState() => _RemoveAudioCardWidgetState();
}

class _RemoveAudioCardWidgetState extends State<RemoveAudioCardWidget> {
  final TextEditingController _videoNameController = TextEditingController();
  String? videoPath;
  String format = "";
  String _fileName = "";
  bool _isNotDone = true;
  final _formGlobalKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    directoriesPath();
    _isNotDone = true;
  }

  var getFilesPath = DirectoriesPath();
  directoriesPath() async {
    var path = await getFilesPath.getPath("Vidéo");

    setState(() {
      videoPath = path;
      // filesList = filesJsonList;
    });
  }

  @override
  void dispose() {
    _videoNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const int nbMaxChar = 15;
    return Form(
      key: _formGlobalKey,
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10),
        child: Card(
          elevation: 10,
          shadowColor: Colors.grey.shade100,
          color: Colors.grey.shade200,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 10.0, left: 15, right: 15, bottom: 20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    "Supprimer l'audio de la vidéo.",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: _videoNameController,
                    maxLength: nbMaxChar,
                    decoration: const InputDecoration(
                      label: Text("Nom du fichier video"),
                    ),
                    validator: (value) {
                      return Helpers.validStringField(value, nbMaxChar);
                    },
                    onSaved: (value) {
                      _fileName = value!;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                 
                  _isNotDone
                      ? ElevatedButton(
                          onPressed: () async {
                            if (_formGlobalKey.currentState!.validate()) {
                              _formGlobalKey.currentState!.save();
                              format = widget.file.path.split('/').last.split('.').last;
                              String outputVideo = "$videoPath/$_fileName.$format";
                              final String inputVideo = widget.file.path;
                              setState(() {
                                _isNotDone = false;
                              });
                              await FfmpegCommands.removeAudioFromVideo(
                                  inputVideo, outputVideo);

                              if (context.mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ListMediaScreens(
                                      mediaCategory: "Vidéo",
                                    ),
                                  ),
                                );
                              } else {
                                return;
                              }
                            }
                          },
                          child: const Text("Supprimer"),
                        )
                      : const CircularProgressWidget()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
