import 'dart:io';

import 'package:flutter/material.dart';

import '../screens/screens.dart';
import '../utils/utils.dart';
import 'widgets.dart';

class ChangeFormatCardWidget extends StatefulWidget {
  const ChangeFormatCardWidget(
      {super.key, required this.mediaCategory, required this.file});

  final String mediaCategory;
  final FileSystemEntity file;

  @override
  State<ChangeFormatCardWidget> createState() => _ChangeFormatCardWidgetState();
}

class _ChangeFormatCardWidgetState extends State<ChangeFormatCardWidget> {
  bool _isNotDone = true;
  String? mediaPath;
  String format = "";

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
      mediaPath = path;
      // filesList = filesJsonList;
    });
  }

  @override
  Widget build(BuildContext context) {
    // var isNotDone = _isNotDone;
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10),
      child: SizedBox(
        width: double.infinity,
        child: Card(
          elevation: 10,
          shadowColor: Colors.grey.shade100,
          color: Colors.grey.shade200,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 10.0, left: 15, right: 15, bottom: 20.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.mediaCategory == "Audio")
                  const Text(
                    "Changer le format de l'audio",
                    style: TextStyle(fontSize: 20),
                  )
                else if (widget.mediaCategory == "Vidéo")
                  const Text(
                    "Changer le format de la vidéo",
                    style: TextStyle(fontSize: 20),
                  )
                else if (widget.mediaCategory == "Image")
                  const Text(
                    "Changer le format de l'image",
                    style: TextStyle(fontSize: 20),
                  ),
                const SizedBox(
                  height: 10,
                ),
                DropdownItems(
                  itemsList: MediasFormat.getFormatList(
                      widget.mediaCategory, widget.file.path),
                  initialItem: format,
                  label: 'Format du fichier de sortie',
                  callback: callback,
                ),
                const SizedBox(
                  height: 10,
                ),
                // isNotDone
                ElevatedButton(
                  onPressed: () async {
                    String inputFile = widget.file.path;
                    List<String> path = inputFile.split('/');
                    String fileName = path.last.split('.').first;
                    
                    path.removeLast();
                    String outputFile = "${path.join('/')}/$fileName.$format";
                    
                    if (_isNotDone) {
                      showModalBottomSheet(
                        context: context,
                        builder: (ctx) {
                          return const WaitMessageWidget(
                            title: "Patientez !",
                            message: "Conversion en cours ...",
                          );
                        },
                      );
                    }
                    await FfmpegCommands.changeFormat(
                        inputFile, outputFile, format);

                    setState(
                      () {
                        _isNotDone = false;
                      },
                    );
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
                  },
                  child: const Text("Valider"),
                )
                // : const CircularProgressWidget(),
              ],
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
