import 'dart:io';

import 'package:ffmpeg_kit_flutter_audio/ffprobe_kit.dart';
import 'package:flutter/material.dart';
import 'package:medias_manager/utils/ffmpeg_commands.dart';
import 'package:medias_manager/widgets/circular_progress_widget.dart';

class DetailMediaWidget extends StatelessWidget {
  const DetailMediaWidget({super.key, required this.file});

  final FileSystemEntity file;
  Future<String?> fetchMetadas(file) async {
    String commandToExecute =
        '-v error ${file.path} -show_format -show_streams -print_format json';
    try {
      String? result = await FFprobeKit.execute(commandToExecute).then(
        (session) async {
          // final returnCode = await session.getReturnCode();
          final output = await session.getOutput();
          return output;
        },
      );
      return result;
    } catch (e) {
      debugPrint('zut $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                file.path.split('/').last,
              ),
              // SizedBox(
              //   width: 10,
              // ),
            ],
          ),
          const Divider(
            thickness: 1.5,
            color: Colors.blue,
          ),

          Column(
            children: [
              FutureBuilder<Map<String, dynamic>?>(
                future: FfmpegCommands.fetchMetadatas(file),
                builder: (context, snapshot) {
                  // Data is not loading, you should show progress indicator to user
                  if (!snapshot.hasData) {
                    return const CircularProgressWidget();
                  }
                  if (snapshot.hasError) {
                    return Text('Erreur : ${snapshot.error}');
                  }
                  if (snapshot.hasData) {
                    Map<String, dynamic>? data = snapshot.data;
                   
                    return Column(
                      children: [
                        Text('Taille : ${data!['size'] ?? ""}'),
                        const Divider(
                          thickness: 1.5,
                          color: Colors.grey,
                          indent: 20,
                          endIndent: 20,
                        ),
                        for (int i = 1; i <= data['streams'].length; i++)
                          _displayStream(data, i),
                      ],
                    );
                  }
                  return const Text('Aucune donnée disponible');
                  // https://tuto-flutter.fr/widget/futurebuilder
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Fermer'),
              ),
            ],
          )
          // SizedBox(
          //   height: 10,
          // ),
        ],
      ),
    );
  }

  _displayStream(data, i) {
    String? channelLayout = data!['streams']['stream_$i']['channel_layout'];
    return Column(
      children: [
        Text("Piste : ${data['streams']['stream_$i']['codec_type']}"),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Début : ${data['streams']['stream_$i']['start_time'] ?? ""}'),
            Text('Durée : ${data['streams']['stream_$i']['duration'] ?? ""}'),
          ],
        ),
        Row(
          mainAxisAlignment: (channelLayout != null)
              ? MainAxisAlignment.spaceAround
              : MainAxisAlignment.center,
          children: [
            Text('Codec : ${data['streams']['stream_$i']['codec_name'] ?? ""}'),
            Text(channelLayout ?? ''),
          ],
        ),
        // if (i > 1)
        const Divider(
          thickness: 1.5,
          color: Colors.grey,
          indent: 20,
          endIndent: 20,
        ),
        const SizedBox(
          height: 5,
        )
      ],
    );

    // return const Text('tatta');
  }
}
