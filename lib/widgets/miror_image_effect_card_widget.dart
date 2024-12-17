import 'dart:io';

import 'package:flutter/material.dart';

import '../screens/screens.dart';
import '../utils/utils.dart';
import 'widgets.dart';

class MirorImageEffectCard extends StatefulWidget {
  const MirorImageEffectCard(
      {super.key, required this.file, required this.mediaCategory});

  final String mediaCategory;
  final FileSystemEntity file;
  @override
  State<MirorImageEffectCard> createState() => _MirorImageEffectCardState();
}

class _MirorImageEffectCardState extends State<MirorImageEffectCard> {
  final TextEditingController _mediaNameController = TextEditingController();
  String? imagePath;
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

  @override
  void dispose() {
    _mediaNameController.dispose();
    super.dispose();
  }

  var getFilesPath = DirectoriesPath();
  directoriesPath() async {
    var path = await getFilesPath.getPath(widget.mediaCategory);

    setState(() {
      imagePath = path;
    });
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
          child: Padding(
            padding: const EdgeInsets.only(
                top: 10.0, left: 15, right: 15, bottom: 20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    "Effet miroir",
                    style: TextStyle(fontSize: 20),
                  ),
                   const SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: _mediaNameController,
                    // keyboardType: TextInputType.text,
                    maxLength: nbMaxChar,
                    decoration: const InputDecoration(
                      label: Text("Nom du fichier (sans extension)", style: TextStyle(fontSize: 12),),
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
                              format = widget.file.path
                                  .split('/')
                                  .last
                                  .split('.')
                                  .last;
                              String outputFile =
                                  "$imagePath/$_fileName.$format";
                              final String inputFile = widget.file.path;
                              if (Helpers.fileAlreadyExist(outputFile)) {
                                final result = await showDialog(
                                  context: context,
                                  builder: (_) => AlertDialogYesNoWidget(
                                      title: "Attention!",
                                      message:
                                          "Le fichier '${outputFile.split('/').last}' existe déjà. Voulez-vous l'écraser ?"),
                                );
                                // const confirm =  AlertDialogYesNoWidget(title: "Effacer le fichier",message: "Voulez-vous effacer le fichier ?");
                                if (result) {
                                  File(outputFile).deleteSync();
                                } else {
                                  return;
                                }
                              }
                              setState(() {
                                _isNotDone = false;
                              });
                              await FfmpegCommands.imageMirorEffect(
                                  inputFile, outputFile);
                              // await FfmpegCommands.removeAudioFromVideo(
                              //     inputFile, outputFile);

                              if (context.mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ListMediaScreens(
                                      mediaCategory: widget.mediaCategory,
                                    ),
                                  ),
                                );
                              } else {
                                return;
                              }
                            }
                          },
                          child: const Text("Créer l'effet miroir"),
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
