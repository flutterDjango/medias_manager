import 'package:ffmpeg_kit_flutter_audio/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_audio/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_audio/return_code.dart';
import 'package:flutter/material.dart';

class FfmpegCommands {
  Future<void> extractAudioFromVideo(video, audio) async {
    debugPrint("video $video");
    debugPrint("audio $audio");

    String commandToExecute = '-i $video -c:a libmp3lame -y $audio';
    await FFmpegKitConfig.getVersion()
        .then((value) => debugPrint('version $value'));
    await FFmpegKit.execute(commandToExecute).then(
      (session) async {
        final returnCode = await session.getReturnCode();
        if (ReturnCode.isSuccess(returnCode)) {
          debugPrint('Done');
        } else if (ReturnCode.isCancel(returnCode)) {
          debugPrint('canceled');
        } else {
          debugPrint("error ! $returnCode");
        }
      },
    );
  }
}