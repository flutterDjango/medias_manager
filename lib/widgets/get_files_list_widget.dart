import 'dart:io';

import 'package:path_provider/path_provider.dart';

class GetFilesListWidget {
  
Future<List<FileSystemEntity>> get getAudioFiles async {
  final directory = await getApplicationDocumentsDirectory();
  return Directory("${directory.path}/Audio").listSync();
}
}