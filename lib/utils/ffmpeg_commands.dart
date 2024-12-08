import 'dart:convert';

import 'package:ffmpeg_kit_flutter_audio/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_audio/ffprobe_kit.dart';
// import 'package:ffmpeg_kit_flutter_audio/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_audio/return_code.dart';
import 'package:flutter/material.dart';
import 'package:medias_manager/utils/utils.dart';

class FfmpegCommands {
  FfmpegCommands._();
  static Future<void> extractAudioFromVideo(video, audio) async {
    // String commandToExecute = '-i $video -c:a libmp3lame -y $audio';
    String commandToExecute = '-i $video $audio';
    // String commandToExecute = '-i $video -c copy -map 0:a:0 $audio';
    // await FFmpegKitConfig.getVersion()
    //     .then((value) => debugPrint('version $value'));
    try {
      await FFmpegKit.execute(commandToExecute).then(
        (session) async {
          final returnCode = await session.getReturnCode();
          if (ReturnCode.isSuccess(returnCode)) {
            debugPrint('Done');
            return "Done";
          } else if (ReturnCode.isCancel(returnCode)) {
            debugPrint('canceled');
            return "Canceled";
          } else {
            debugPrint("error ! $returnCode");
            return "error ! $returnCode";
          }
        },
      );
    } catch (e) {
      debugPrint('erreur :$e');
    }
  }

  static Future<void> removeAudioFromVideo(inputVideo, outputVideo) async {
    String commandToExecute =
        '-y -v error -i $inputVideo -c copy -an $outputVideo';
    try {
      await FFmpegKit.execute(commandToExecute).then(
        (session) async {
          final returnCode = await session.getReturnCode();

          if (ReturnCode.isSuccess(returnCode)) {
            debugPrint('Done');
            // return "Done";
          } else if (ReturnCode.isCancel(returnCode)) {
            debugPrint('canceled');
            // return "Canceled";
          } else {
            debugPrint("error ! $returnCode");
            // return "error ! $returnCode";
          }
        },
      );
    } catch (e) {
      debugPrint('erreur :$e');
    }
  }

  static Future<void> cutPartFromMedia(
      inputVideo, outputVideo, startTime, endTime) async {
    String duration = Helpers.durationInSeconde(startTime, endTime);
    String commandToExecute =
        '-y -v error -ss $startTime -i $inputVideo -t $duration -c copy $outputVideo';
    try {
      await FFmpegKit.execute(commandToExecute).then(
        (session) async {
          final returnCode = await session.getReturnCode();

          if (ReturnCode.isSuccess(returnCode)) {
            debugPrint('Done');
            // return "Done";
          } else if (ReturnCode.isCancel(returnCode)) {
            debugPrint('canceled');
            // return "Canceled";
          } else {
            debugPrint("error ! $returnCode");
            // return "error ! $returnCode";
          }
        },
      );
    } catch (e) {
      debugPrint('erreur :$e');
    }
  }

  static Future<Map<String, dynamic>?> fetchMetadatas(file) async {
    String commandToExecute =
        '-v error ${file.path} -show_format -show_streams -print_format json';
    Map<String, dynamic>? metadatas = {};
    // Map<String, dynamic>? streamsdatas = {};
    try {
      Map<String, dynamic>? result =
          await FFprobeKit.execute(commandToExecute).then(
        (session) async {
          final returnCode = await session.getReturnCode();
          final output = await session.getOutput();
          // debugPrint('---> :  $output');
          if (ReturnCode.isSuccess(returnCode)) {
            metadatas = getMetadatas(output);
            return metadatas;
          }
          return null;
        },
      );
      return result;
    } catch (e) {
      debugPrint('erreur :$e');
      return null;
    }
  }

  static Map<String, dynamic>? getMetadatas(datas) {
    Map<String, dynamic>? metadatas = {};
    Map<String, dynamic>? streamsdatas = {};
    Map outputMap = json.decode(datas);
    int nbStreams = outputMap['format']['nb_streams'];

    double size = double.parse(outputMap['format']['size']);
    for (int i = 0; i < nbStreams; i++) {
      Map<String, dynamic>? tags = outputMap['streams'][i]['tags'];
      double duration = double.parse(outputMap['streams'][i]['duration']);
      String? startTime = outputMap['streams'][i]['start_time'];
      String codecType = outputMap['streams'][i]['codec_type'];
      String codecName = outputMap['streams'][i]['codec_name'];

      String? channelLayout = outputMap['streams'][i]['channel_layout'];
      int? width = outputMap['streams'][i]['width'];
      int? height = outputMap['streams'][i]['height'];

      streamsdatas['stream_${i + 1}'] = {
        "codec_type": codecType,
        "codec_name": codecName,
        "channel_layout": channelLayout,
        "duration": Helpers.secondsToHoursMinutesSeconds(duration.toInt()),
        "start_time": startTime == null
            ? 'NC'
            : Helpers.secondsToHoursMinutesSeconds(
                double.parse(startTime).toInt()),
        "language": (tags != null) ? tags['language'] : null,
        "width": width,
        "height": height,
      };
    }
    metadatas['streams'] = streamsdatas;
    metadatas['size'] = Helpers.bytesToKilobyteOrMegabyte(size);
    return metadatas;
  }

  static Future<void> juxtaposeTwoImageH(
      image1, image2, heightImage, outputImage) async {
    String commandToExecute =
        "-y -v error -i $image1 -i $image2 -filter_complex [0]scale=-1:$heightImage[left];[left][1]hstack $outputImage";
        
    debugPrint(commandToExecute);
    try {
      await FFmpegKit.execute(commandToExecute).then(
        (session) async {
          final returnCode = await session.getReturnCode();

          if (ReturnCode.isSuccess(returnCode)) {
            debugPrint('Done');
            // return "Done";
          } else if (ReturnCode.isCancel(returnCode)) {
            debugPrint('canceled');
            // return "Canceled";
          } else {
            debugPrint("error ! $returnCode");
            // return "error ! $returnCode";
          }
        },
      );
    } catch (e) {
      debugPrint('erreur :$e');
    }
  }
}
