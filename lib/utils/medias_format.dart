

import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';

class MediasFormat{
  MediasFormat._();
  
  static Icon getIconMedia(mediaCategory) {
    if (mediaCategory == "Audio") {
      return const Icon(Icons.music_note);
    } else if (mediaCategory == "Vidéo") {
      return const Icon(Icons.play_circle_outline);
    } else if (mediaCategory == "Image") {
      return const Icon(Icons.photo);
    }
    return const Icon(Icons.warning_amber);
  }

  static List<String> getFormatList(mediaCategory, filePath) {
    final String media = removeDiacritics(mediaCategory);
    final String format = filePath.split('/').last.split('.').last;
    

    if (media == "Audio") {
      List<String> formats = ['mp3', "wav", "ogg"];
      formats.remove(format);
      return formats;
    }
    if (media == "Video") {
      List<String> formats = ['mp4', "avi", "mov"];
      formats.remove(format);
      return formats;
    }
    if (media == "Image") {
      List<String> formats = ['jpg', "tiff", "png"];
      formats.remove(format);
      return formats;
    }
    return [];
  }
}