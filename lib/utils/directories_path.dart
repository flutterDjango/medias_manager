import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DirectoriesPath {
  // getVideoPath() async {
  //   final Directory appStorage = await getApplicationDocumentsDirectory();
  //   final filePath = Directory("${appStorage.path}/Video");
  //   if (await filePath.exists()) {
  //     return filePath.path;
  //   } else {
  //     await filePath.create(recursive: true);
  //     return filePath.path;
  //   }
  // }
  // getAudioPath() async {
  //   final Directory appStorage = await getApplicationDocumentsDirectory();
  //   final filePath = Directory("${appStorage.path}/Audio");
  //   if (await filePath.exists()) {
  //     return filePath.path;
  //   } else {
  //     await filePath.create(recursive: true);
  //     return filePath.path;
  //   }
  // }
  Future<String>getPath(folder) async {
    final Directory appStorage = await getApplicationDocumentsDirectory();
    final filePath = Directory("${appStorage.path}/$folder");
    if (await filePath.exists()) {
      return filePath.path;
    } else {
      await filePath.create(recursive: true);
      return filePath.path;
    }
  }
  Future<List<FileSystemEntity>> localFiles(folder) async {
    final path = await getPath(folder);
    debugPrint('***$path');
    return Directory(path).listSync();}

}



// Future<List<FileSystemEntity>> get _localFiles async {
//   final path = await _localPathAudio;
//   debugPrint('***$path');
//   return Directory(path).listSync();
// }

// Future<String> get _localPathAudio async {
//     final directory = await getApplicationDocumentsDirectory();

//     return "${directory.path}/Audio";