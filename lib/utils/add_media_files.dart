import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:medias_manager/utils/utils.dart';

class AddMediaFiles {
  addFiles(mediaCategory) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: getFileType(mediaCategory),
      allowCompression: false,
      compressionQuality: 0,
    );
    if (result == null) return;
  
    for (var file in result.files) {
      debugPrint("file $file");
      DirectoriesPath().saveFilePermanently(file, mediaCategory);
    }
  }

  FileType getFileType(mediaCategory) {
    if (mediaCategory == "Audio") {
      return FileType.audio;
    }
    if (mediaCategory == "Vidéo") {
      return FileType.video;
    }
    if (mediaCategory == "Image") {
      return FileType.image;
    }
    return FileType.any;
  }
}
