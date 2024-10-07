import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';



class CreateFolders {

  
Future<String> createOutputFileAudio(PlatformFile file) async {
    final Directory appStorage = await getApplicationDocumentsDirectory();
    // String storagePath = '/storage/emulated/0/Download';
    String fileNameWithoutExtention = file.name.split('.').first;
    debugPrint('---------- $fileNameWithoutExtention');
    final Directory appDocDirFolder =  Directory('${appStorage.path}/Audio/');
    bool exist = await appDocDirFolder.exists();
    debugPrint("appDocDirFolder $appDocDirFolder $exist");
    if(!exist){
      debugPrint("already exist");
      final Directory appDocDirNewFolder = await appDocDirFolder.create(recursive: true);
      return "${appDocDirNewFolder.path}/$fileNameWithoutExtention.mp3";}
    debugPrint("not exist");
    return "${appStorage.path}/Audio/$fileNameWithoutExtention.mp3";

    // return File(file.path!).copy(newFile.path);
  }
}