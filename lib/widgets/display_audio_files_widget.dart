import 'dart:io';

import 'package:flutter/material.dart';

class DisplayAudioFilesWidget extends StatelessWidget {
  const DisplayAudioFilesWidget({
    super.key,
    });
  // final List<String> audios;

  @override
  Widget build(BuildContext context) {
    debugPrint("** là c'est bon");
    return const Text('hallo');
    // return Expanded(
    //   child: ListView.separated(
    //     itemCount: audios.length,
    //     itemBuilder: (BuildContext context, int index) {
    //       final audio = audios[index];
    //       return InkWell(
    //         child: Padding(
    //           padding: const EdgeInsets.all(6.0),
    //           child: SizedBox(
    //             width: MediaQuery.of(context).size.width,
    //             height: 50,
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 Padding(
    //                   padding: const EdgeInsets.only(left: 15.0),
    //                   child: Text(audio.toString()),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       );
    //     },
    //     separatorBuilder: (BuildContext context, int index) {
    //       return const Divider(
    //         height: 2,
    //         thickness: 1.5,
    //       );
    //     },
    //   ),
    // );
  }
}
