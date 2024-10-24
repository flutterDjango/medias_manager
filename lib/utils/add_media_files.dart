import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:medias_manager/utils/utils.dart';

class AddMediaFiles {
  addFiles(mediaCategory) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: getFileType(mediaCategory),
    );
    if (result == null) return;
    for (var file in result.files) {
      debugPrint(file.path);
      debugPrint(file.toString());
      DirectoriesPath().saveFilePermanently(file, mediaCategory);
    }
  }

  FileType getFileType(mediaCategory) {
    debugPrint("mediaCategory $mediaCategory");
    if (mediaCategory == "Audio") {
      return FileType.audio;
    }
    if (mediaCategory == "Vidéo") {
      debugPrint("VIDEO");
      return FileType.video;
    }
    return FileType.any;
  }
}
