import 'dart:io';

import 'package:flutter/material.dart';
import 'package:medias_manager/screens/list_media_screen.dart';
import 'package:medias_manager/utils/utils.dart';

import 'widgets.dart';

class ExtractAudioCardWidget extends StatefulWidget {
  const ExtractAudioCardWidget(
      {super.key,
      required this.mediaCategory,
      // required this.audioFormat,
      required this.file});

  final String mediaCategory;
  // final Function(String) audioFormat;
  final FileSystemEntity file;

  @override
  State<ExtractAudioCardWidget> createState() => _ExtractAudioCardWidgetState();
}

class _ExtractAudioCardWidgetState extends State<ExtractAudioCardWidget> {
  final TextEditingController _audioNameController = TextEditingController();
  String? audioPath;
  String format = "";
  String _fileName = "";
  bool _isNotDone = true;
  final _formGlobalKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    directoriesPath();
    format = 'mp3';
    _isNotDone = true;
  }

  var getFilesPath = DirectoriesPath();
  directoriesPath() async {
    var path = await getFilesPath.getPath("Audio");

    setState(() {
      audioPath = path;
    });
  }

  @override
  void dispose() {
    _audioNameController.dispose();
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
                    "Extraire l'audio de la vidéo.",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: _audioNameController,
                    maxLength: nbMaxChar,
                    decoration: const InputDecoration(
                      label: Text("Nom du fichier audio"),
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
                  DropdownItems(
                    itemsList:
                        MediasFormat.getFormatList("Audio", widget.file.path),
                    initialItem: format,
                    label: 'Format du fichier de sortie',
                    callback: callback,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formGlobalKey.currentState!.validate()) {
                        _formGlobalKey.currentState!.save();
                        String audio = "$audioPath/$_fileName.$format";
                        final String video = widget.file.path;
                        if (_isNotDone) {
                          showModalBottomSheet(
                            context: context,
                            builder: (ctx) {
                              return const WaitMessageWidget(
                                title: "Veuillez patienter !",
                                message: "Extraction en cours ...",
                              );
                            },
                          );
                        }
                        await FfmpegCommands.extractAudioFromVideo(
                            video, audio);
                        setState(
                          () {
                            _isNotDone = false;
                          },
                        );
                        if (context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ListMediaScreens(
                                mediaCategory: "Audio",
                              ),
                            ),
                          );
                        } else {
                          return;
                        }
                      }
                    },
                    child: const Text("Extraire"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  callback(selectedItem) {
    setState(
      () {
        format = selectedItem;
      },
    );
  }
}
