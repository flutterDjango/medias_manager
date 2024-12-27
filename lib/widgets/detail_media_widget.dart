import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:medias_manager/utils/ffmpeg_commands.dart';
import 'package:medias_manager/widgets/circular_progress_widget.dart';

import '../utils/utils.dart';
import 'widgets.dart';

class DetailMediaWidget extends StatelessWidget {
  const DetailMediaWidget(
      {super.key, required this.file, required this.mediaCategory});

  final FileSystemEntity file;
  final String mediaCategory;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
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
                          if (mediaCategory == "Image")
                            _displayDataImage(data)
                          else
                            for (int i = 1; i <= data['streams'].length; i++)
                              _displayStream(data, i),
                        ],
                      );
                    }
                    return const Text('Aucune donnée disponible');
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Fermer'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        bool exportOk = await DirectoriesPath()
                            .exportFile(file, mediaCategory);
                        if (exportOk && context.mounted) {
                          final result = await showDialog(
                            context: context,
                            builder: (_) => AlertInfoOkWidget(
                              title: "Exportation",
                              message:
                                  "Le fichier est disponible dans le dossier: mediasManager/$mediaCategory",
                              icon: false,
                            ),
                          );
                          if (!result) {
                            return;
                          }
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        }
                      },
                      child: const Text('Exporter'),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  _displayDataImage(data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text("Largeur : ${data['streams']['stream_1']['width'] ?? '-'} px"),
        Text("Hauteur : ${data['streams']['stream_1']['height'] ?? '-'} px"),
      ],
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
  }
}
