import 'dart:io';

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
    final regExp = RegExp(r'[\^$*.\[\]{}()?\-"!@#%&/\,><:;~`+='
        "'"
        ']');
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

  static String? validTimeField(value) {
    if (value.isEmpty) {
      return null;
    }
    if (int.tryParse(value) == null) {
      return "Seuls les chiffres sont autorisés";
    } else {
      if (value.trim().length > 2 || int.parse(value) >= 60) {
        return "La valeur doit être inférieure à 60";
      }
    }

    return null;
  }

  static bool validDuration(startTime, endTime) {
    if (startTime == endTime) {
      debugPrint('temps nul');
      return false;
    } else {
      int hourStart = int.parse(startTime.split(":").first);
      int minStart = int.parse(startTime.split(":")[1]);
      int secondStart = int.parse(startTime.split(":").last);

      int hourEnd = int.parse(endTime.split(":").first);
      int minEnd = int.parse(endTime.split(":")[1]);
      int secondEnd = int.parse(endTime.split(":").last);

      if (hourEnd < hourStart) {
        return false;
      }

      if (hourEnd == hourStart) {
        if (minEnd < minStart) {
          return false;
        }
      }
      if (hourEnd == hourStart && minEnd == minStart) {
        if (secondEnd < secondStart) {
          return false;
        }
      }
    }
    return true;
  }

  static String convertHourMimSecondToSecond(hourMinSecond) {
    int hourToSecond = int.parse(hourMinSecond.split(":").first) * 3600;
    int minToSecond = int.parse(hourMinSecond.split(":")[1])*60;
    int second = int.parse(hourMinSecond.split(":").last);
    return (hourToSecond + minToSecond + second).toString();
  }

  static String durationInSeconde(hourMinSecondStart, hourMinSecondEnd) {
    int startSecond = int.parse(convertHourMimSecondToSecond(hourMinSecondStart));
    int endSecond = int.parse(convertHourMimSecondToSecond(hourMinSecondEnd));
    return (endSecond-startSecond).toString();

  }

  static bool fileAlreadyExist(pathFile){
    var file=File(pathFile);
    return file.existsSync();
  }
}
