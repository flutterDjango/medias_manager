

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

  static List<String> getFormatList(mediaCategory, extract) {
    final String media = removeDiacritics(mediaCategory);

    if ((media == "Audio") | (extract)) {
      return ['mp3', "wav", "wma", "au", "m4a", "aac"];
    }
    if (media == "Video") {
      return ['mp4', "mov"];
    }
    return [];
  }
}