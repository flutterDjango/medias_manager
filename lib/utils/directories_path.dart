import 'dart:io';

import 'package:diacritic/diacritic.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DirectoriesPath {
  Future<String>getPath(folder) async {
    final Directory appStorage = await getApplicationDocumentsDirectory();
    final directory = removeDiacritics(folder);
    final filePath = Directory("${appStorage.path}/$directory");
    if (await filePath.exists()) {
      return filePath.path;
    } else {
      await filePath.create(recursive: true);
      return filePath.path;
    }
  }
  Future<List<FileSystemEntity>> localFiles(folder) async {
    final directory = removeDiacritics(folder);
    final path = await getPath(directory);
    debugPrint('***$path');
    return Directory(path).listSync();}


  Future<void> saveFilePermanently(PlatformFile file, String folder) async {
    // stockage permanent et non en cache
    
    final appStorage = await getPath(folder);
    // final appStorage = await getApplicationDocumentsDirectory();
    final newFile = File('$appStorage/${file.name}');

    File(file.path!).copy(newFile.path);
  }

  // Future<FileSystemEntity> delete({bool recursive = false});

}



// Future<List<FileSystemEntity>> get _localFiles async {
//   final path = await _localPathAudio;
//   debugPrint('***$path');
//   return Directory(path).listSync();
// }

// Future<String> get _localPathAudio async {
//     final directory = await getApplicationDocumentsDirectory();

//     return "${directory.path}/Audio";