import 'dart:io';
import 'package:diacritic/diacritic.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DirectoriesPath {
  Future<String> getPath(folder) async {
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
    return Directory(path).listSync();
  }

  Future<void> saveFilePermanently(PlatformFile file, String folder) async {
    // stockage permanent et non en cache

    final appStorage = await getPath(folder);
    final newFile = File('$appStorage/${file.name}');

    File(file.path!).copy(newFile.path);
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }


  Future<bool> exportFile(FileSystemEntity file, String mediaCategory) async {
    Directory? directory;
    try {
      if (Platform.isAndroid) {
       
        if (await _requestPermission(Permission.storage)) {
          directory = await getExternalStorageDirectory();
          String newPath = "";
          String fileName = file.path.split('/').last;
          List<String> folders = directory!.path.split('/');
          for (int x = 1; x < folders.length; x++) {
            String folder = folders[x];
            if (folder != "Android") {
              newPath += "/$folder";
            } else {
              break;
            }
          }
          newPath = "$newPath/mediasManager/$mediaCategory";        
          directory = Directory(newPath);
          if (!await directory.exists()) {
            await directory.create(recursive: true);
          }
          if (await directory.exists()) {
            File exportFile = File("${directory.path}/$fileName");
            await File(file.path).copy(exportFile.path);
          }
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("erreur directory $e");
    }
    return true;
  }
}