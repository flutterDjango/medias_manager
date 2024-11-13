import 'dart:io';

import 'package:flutter/material.dart';

import '../utils/utils.dart';
import 'widgets.dart';

class JuxtaposeImagesCardWidget extends StatefulWidget {
  const JuxtaposeImagesCardWidget(
      {super.key, required this.file});
  // final String fileName;
  final FileSystemEntity file;

  @override
  State<JuxtaposeImagesCardWidget> createState() =>
      _JuxtaposeImagesCardWidgetState();

}

class _JuxtaposeImagesCardWidgetState extends State<JuxtaposeImagesCardWidget> {
  List<String> imagesFilesList = [];
  var getFilesPath = DirectoriesPath();
  String secondImage = "";
  

  // imagesFiles() async {
  //   List<String> filesList = [];
  //   String fileNameWithExtension = "";
  //   // var filesJsonList = [];
  //   List<FileSystemEntity> files = await getFilesPath.localFiles("Image");
  //   debugPrint("-->> ${files.toString()}");
  //   for (int i = 0; i < files.length; i++) {
  //     fileNameWithExtension = files[i].path.split('/').last;
  //     if (fileNameWithExtension != widget.fileName) {
  //       filesList.add(fileNameWithExtension);
  //     }
  //   }
  //   debugPrint('list $filesList');
  //   setState(() {
  //     imagesFilesList = filesList;
  //     // filesList = filesJsonList;
  //   });
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   imagesFiles();
  // }

  @override
  Widget build(BuildContext context) {
    debugPrint('in juxtapose ${widget.file.path}');
    return Card(
      elevation: 10,
      shadowColor: Colors.grey.shade100,
      child: Padding(
        padding:
            const EdgeInsets.only(top: 10.0, left: 15, right: 15, bottom: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Juxtaposer 2 images",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 5,
              ),
                 DropdownItems(
                itemsList: imagesFilesList,
                initialItem: "Sélectionner une image",
                label: 'Image à juxtaposer',
                callback: callback,
              ),
              const SizedBox(
                height: 5,
              ),
              FutureBuilder<Map<String, dynamic>?>(
                future: FfmpegCommands.fetchMetadatas(widget.file),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressWidget();
                  }
                  if (snapshot.hasError) {
                    return Text('Erreur : ${snapshot.error}');
                  }
                  if (snapshot.hasData) {
                    Map<String, dynamic>? data = snapshot.data;

                    return Column(
                      children: [
                        Text('Taille : ${data!['size'] ?? ""}'),
                        const Divider(
                          thickness: 1.5,
                          color: Colors.grey,
                          indent: 20,
                          endIndent: 20,
                        ),
                        Text(
                            "Largeur : ${data['streams']['stream_1']['width'] ?? '-'} px"),
                        Text(
                            "Hauteur : ${data['streams']['stream_1']['height'] ?? '-'} px"),
                      ],
                    );
                  }
                  return const Text('no data');
                },
              ),
              
              // Text('file ${widget.fileName}'),
              // Text(imagesFilesList.length.toString()),
              // Text(imagesFilesList.toString()),
           

              // for (int i = 0; i < filesList.length; i++)
              //   Text("$i, ${filesList[i].path.split('/').last}")
              // Text("$i, ${filesList[i].toString().split('/').last}"),
              // Text(file.toString()),
              // Text('files ${File(file)}'),
            ],
          ),
        ),
      ),
    );
  }

  callback(selectedItem) {
    setState(() {
      secondImage = selectedItem;
      Future<Map<String, dynamic>?> result = FfmpegCommands.fetchMetadatas(widget.file);
      print('res  ${result.toString()}');
    });
    debugPrint("***--- $secondImage");
    // widget.audioFormat(selectedItem);
  }
}
