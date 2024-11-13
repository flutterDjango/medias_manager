import 'dart:io';

import 'package:flutter/material.dart';
import 'package:medias_manager/utils/utils.dart';
import 'widgets.dart';

class CutUpMediaCardWidget extends StatefulWidget {
  const CutUpMediaCardWidget(
      {super.key,
      required this.mediaCategory,
      // required this.audioFormat,
      required this.file});

  final String mediaCategory;
  // final Function(String) audioFormat;
  final FileSystemEntity file;

  @override
  State<CutUpMediaCardWidget> createState() => _CutUpMediaCardWidgetState();
}

class _CutUpMediaCardWidgetState extends State<CutUpMediaCardWidget> {
  final TextEditingController _mediaNameController = TextEditingController();
  // final TextEditingController _startTimeController = TextEditingController();
  String? videoPath;
  String format = "";
  String _fileName = "";
  bool _isNotDone = true;
  String startTime = '00:00:00';
  String endTime = '00:00:00';
  final _formGlobalKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    directoriesPath();
    _isNotDone = true;
  }

  var getFilesPath = DirectoriesPath();
  directoriesPath() async {
    var path = await getFilesPath.getPath(widget.mediaCategory);

    setState(() {
      videoPath = path;
      // filesList = filesJsonList;
    });
  }

  @override
  void dispose() {
    _mediaNameController.dispose();
    // _startTimeController.dispose();
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
          child: Padding(
            padding: const EdgeInsets.only(
                top: 10.0, left: 15, right: 15, bottom: 20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  (widget.mediaCategory == "Audio")
                      ? const Text(
                          "Extraire une partie de l'audio.",
                          style: TextStyle(fontSize: 20),
                        )
                      : const Text(
                          "Extraire une partie de la vidéo.",
                          style: TextStyle(fontSize: 20),
                        ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      // Expanded(child: Text('Début')),
                      ElevatedButton(
                        onPressed: () async {
                          const String title = "Début de l'extrait";

                          final String start = await showDialog(
                              context: context,
                              builder: (_) => const DialogTimeFormWidget(
                                    title: title,
                                  ));

                          setState(
                            () {
                              startTime = start;
                            },
                          );
                        },
                        child: const Text('Début'),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(startTime),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          const String title = "Fin de l'extrait";

                          final String end = await showDialog(
                              context: context,
                              builder: (_) => const DialogTimeFormWidget(
                                    title: title,
                                  ));

                          setState(
                            () {
                              endTime = end;
                            },
                          );
                        },
                        child: const Text('Fin'),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(endTime),
                    ],
                  ),
                  TextFormField(
                    controller: _mediaNameController,
                    // keyboardType: TextInputType.text,
                    maxLength: nbMaxChar,
                    decoration: const InputDecoration(
                      label: Text("Nom du fichier"),
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
                                  "$videoPath/$_fileName.$format";
                              final String inputFile = widget.file.path;
                              debugPrint(inputFile);

                              debugPrint(outputFile);
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
                              final bool validTiming =
                                  Helpers.validDuration(startTime, endTime);
                              if (!validTiming) {
                                if (context.mounted) {
                                  await showDialog(
                                    context: context,
                                    builder: (_) => const AlertInfoOkWidget(
                                      title: "Attention !",
                                      message:
                                          "Horaires de début et fin incohérents !",
                                    ),
                                  );
                                  return;
                                }
                              }

                              setState(() {
                                _isNotDone = false;
                              });
                              await FfmpegCommands.cutPartFromMedia(
                                  inputFile, outputFile, startTime, endTime);
                              // await FfmpegCommands.removeAudioFromVideo(
                              //     inputFile, outputFile);

                              if (context.mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FilesListWidget(
                                      mediaCategory: widget.mediaCategory,
                                    ),
                                  ),
                                );
                              } else {
                                return;
                              }
                            }
                          },
                          child: const Text("Créer l'extrait"),
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

  // callback(selectedItem) {
  //   setState(
  //     () {
  //       format = selectedItem;
  //     },
  //   );
  // widget.audioFormat(selectedItem);
}

  // openDialog(String title) {
  //   showDialog<String>(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text(title),
  //       content: Column(
  //         children: [
  //           TextField(
  //             autofocus: true,
  //             controller: _startTimeController,
  //             keyboardType: const TextInputType.numberWithOptions(decimal: false),
  //             decoration: const InputDecoration(hintText: 'Heure'),
  //           ),
  //           TextField(
  //             autofocus: true,
  //             controller: _startTimeController,
  //             keyboardType: const TextInputType.numberWithOptions(decimal: false),
  //             decoration: const InputDecoration(hintText: 'Minute'),
  //           ),
  //         ],
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () {
  //             print(_startTimeController.text);
  //             setState(() {
  //               duration = _startTimeController.text;
  //             });
  //             print('duration $duration');
  //             Navigator.of(context).pop();
  //           },
  //           child: const Text('Valider'),
  //         )
  //       ],
  //     ),
  //   );
  // }

