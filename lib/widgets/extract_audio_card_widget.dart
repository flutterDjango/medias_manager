import 'dart:io';

import 'package:flutter/material.dart';
import 'package:medias_manager/utils/directories_path.dart';
import 'package:medias_manager/utils/ffmpeg_commands.dart';
import 'package:medias_manager/utils/helpers.dart';
import 'package:medias_manager/utils/medias_format.dart';
import 'package:medias_manager/widgets/circular_progress_widget.dart';
import 'package:medias_manager/widgets/dropdown_items_widget.dart';
import 'package:medias_manager/widgets/files_list_widget.dart';

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
      debugPrint("---------------------------------  $path");
      audioPath = path;
      // filesList = filesJsonList;
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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text(
                  "Extraire l'audio de la vidéo.",
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
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
                  height: 20,
                ),
                DropdownItems(
                  itemsList:
                      MediasFormat.getFormatList(widget.mediaCategory, true),
                  initialItem: format,
                  callback: callback,
                ),
                const SizedBox(
                  height: 20,
                ),
                _isNotDone ? ElevatedButton(
                  onPressed: () async {
                    if (_formGlobalKey.currentState!.validate()) {
                      _formGlobalKey.currentState!.save();
                      String audio = "$audioPath/$_fileName.$format";
                      final String video = widget.file.path;
                      debugPrint(video);
                      debugPrint("audio path $audio $_isNotDone");
                     
                      setState(() {
                        _isNotDone = false;
                      });
                      await FfmpegCommands.extractAudioFromVideo(video, audio);
                      debugPrint('not spin $_isNotDone');

                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FilesListWidget(
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
                ):const CircularProgressWidget()
              ],
            ),
          ),
        ),
      ),
    );
  }

  callback(selectedItem) {
    setState(() {
      format = selectedItem;
    });
    // widget.audioFormat(selectedItem);
  }

}


