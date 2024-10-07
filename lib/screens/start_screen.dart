import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:medias_manager/widgets/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file_plus/open_file_plus.dart';


class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'start screen',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 30),
          OutlinedButton(
            onPressed: () async {
            final result = await FilePicker.platform.pickFiles();
              if (result == null) return;
              final file = result.files.first;
              debugPrint("Name: ${file.name}");
             
              debugPrint("Bytes: ${file.bytes}");
              debugPrint("Size: ${file.size}");
              debugPrint("Extension: ${file.extension}");
              debugPrint("Path: ${file.path}");
              final outputFile = await CreateFolders().createOutputFileAudio(file);
              debugPrint('out------------------------ $outputFile');
              await FfmpegCommands().extractAudioFromVideo(file.path, outputFile);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
            ),
            child: const Text("Convert mp4 -> mp3"),
          ),
          const SizedBox(height: 30),
          OutlinedButton(
            onPressed: () async {
              List<FileSystemEntity> files = await _localFiles;
              debugPrint('files! $files');
              debugPrint('--------------------');
              
              debugPrint('file ${files[0].path}');
              // debugPrint('file size ${files[0].size}');
              final myFile = File(files[0].path);
              // debugPrint(myFile);
            
              debugPrint(myFile.path);
              // await openFile(myFile);
              OpenFile.open(files[0].path);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
            ),
            child: const Text("get all files"),
          ),
        ],
      ),
    );
  }
  
Future<String> get _localPathAudio async {
    final directory = await getApplicationDocumentsDirectory();

    return "${directory.path}/Audio";
    // debugPrint('** $directory');
    // debugPrint('** ${directory.path}');
    // return directory.path;
  }

Future<List<FileSystemEntity>> get _localFiles async {
  final path = await _localPathAudio;
  debugPrint('***$path');
  return Directory(path).listSync();
}
}
