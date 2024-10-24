import 'package:flutter/material.dart';

class Helpers {
  Helpers._();

  static String bytesToKilobyteOrMegabyte(octet) {
    final kb = octet / 1024;
    final mb = kb / 1024;
    return mb >= 1
        ? '${mb.toStringAsFixed(2)} MB'
        : '${kb.toStringAsFixed(2)} KB';
  }

  static String secondsToHoursMinutesSeconds(durationInSecond) {
    debugPrint(
        "duration in hms $durationInSecond ${durationInSecond.runtimeType}");
    int h, m, s;
    if (durationInSecond == 0) {
      debugPrint('zero');
      return "00:00:00";
    }

    h = durationInSecond ~/ 3600;
    m = ((durationInSecond - h * 3600)) ~/ 60;
    s = durationInSecond - (h * 3600) - (m * 60);

    String hourLeft =
        h.toString().length < 2 ? "0${h.toString()}" : h.toString();
    String minuteLeft =
        m.toString().length < 2 ? "0${m.toString()}" : m.toString();
    String secondsLeft =
        s.toString().length < 2 ? "0${s.toString()}" : s.toString();
    return "$hourLeft:$minuteLeft:$secondsLeft";
  }

  static String? validStringField(value, nbMaxChar) {
    final regExp = RegExp(r'[\^$*.\[\]{}()?\-"!@#%&/\,><:;_~`+='
        "'"']');
    if (value.contains(regExp)) {
      return "Le nom contient au moins un caratère non valide"; 
    }
    if (value == null ||
        value.isEmpty ||
        value.trim().length <= 1 ||
        value.trim().length > nbMaxChar) {
      return 'Le nom doit avoir entre une et $nbMaxChar lettres.';
    }
    return null;
  }
}
