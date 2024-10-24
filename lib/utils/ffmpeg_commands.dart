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
    debugPrint("video $video");
    debugPrint("audio $audio");

    String commandToExecute = '-i $video -c:a libmp3lame -y $audio';
    // await FFmpegKitConfig.getVersion()
    //     .then((value) => debugPrint('version $value'));
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
          if (ReturnCode.isSuccess(returnCode)) {
            // Map outputMap = json.decode(output!);
            // int nbStreams = outputMap['format']['nb_streams'];
            // print("----------------nbStreams $nbStreams");
            // double duration = double.parse(outputMap['streams'][0]['duration']);
            // double startTime =
            //     double.parse(outputMap['streams'][0]['start_time']);
            // double size = double.parse(outputMap['format']['size']);
            // Map<String, dynamic>? tags = outputMap['streams'][0]['tags'];
            // streamsdatas['stream_${nbStreams-1}'] = {
            //   "duration":
            //       Helpers.secondsToHoursMinutesSeconds(duration.toInt()),
            //   'start_time':
            //       Helpers.secondsToHoursMinutesSeconds(startTime.toInt())
            // };
            // metadatas['streams'] = streamsdatas;
            // // metadatas['duration'] =
            // //     Helpers.secondsToHoursMinutesSeconds(duration.toInt());
            // // metadatas['start_time'] =
            // //     Helpers.secondsToHoursMinutesSeconds(startTime.toInt());
            // // metadatas['duration'] = duration;
            // metadatas['size'] = Helpers.bytesToKilobyteOrMegabyte(size);
            metadatas = getMetadatas(output);

            // debugPrint('----------------------->>>');
            // debugPrint("tags ${tags??'no tags'}");
            // if (tags != null){
            //   String? language = tags["language"];
            //   debugPrint("language ${language?? 'nc' }");
            // }

            // return outputMap as Map<String, dynamic>?;
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
    print("----------------nbStreams $nbStreams");
    double size = double.parse(outputMap['format']['size']);
    for (int i = 0; i < nbStreams; i++) {
      Map<String, dynamic>? tags = outputMap['streams'][i]['tags'];
      double duration = double.parse(outputMap['streams'][i]['duration']);
      double startTime = double.parse(outputMap['streams'][i]['start_time']);
      String codecType = outputMap['streams'][i]['codec_type'];
      String codecName = outputMap['streams'][i]['codec_name'];
      String? channelLayout = outputMap['streams'][i]['channel_layout'];

      streamsdatas['stream_${i + 1}'] = {
        "codec_type": codecType,
        "codec_name": codecName,
        "channel_layout": channelLayout,
        "duration": Helpers.secondsToHoursMinutesSeconds(duration.toInt()),
        "start_time": Helpers.secondsToHoursMinutesSeconds(startTime.toInt()),
        "language": (tags != null) ? tags['language'] : null,
      };
    }
    metadatas['streams'] = streamsdatas;
    metadatas['size'] = Helpers.bytesToKilobyteOrMegabyte(size);
    return metadatas;
  }
}
