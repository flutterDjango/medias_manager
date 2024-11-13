import 'dart:io';

import 'package:flutter/material.dart';

import '../utils/utils.dart';
import 'widgets.dart';

class JuxtaposeImagesCardTestWidget extends StatefulWidget {
  const JuxtaposeImagesCardTestWidget(
      {super.key,
      required this.file,
      required this.fileName,
      required this.mediaCategory,
      required this.fileList});
  // final String fileName;
  final FileSystemEntity file;
  final String fileName;
  final String mediaCategory;
  final List<dynamic> fileList;

  @override
  State<JuxtaposeImagesCardTestWidget> createState() =>
      _JuxtaposeImagesCardTestWidgetState();
}

class _JuxtaposeImagesCardTestWidgetState
    extends State<JuxtaposeImagesCardTestWidget> {
  // @override
  // void initState() {
  //   super.initState();
  //   print('---------------------');
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     await showDialog(
  //       context: context,
  //       barrierDismissible: true,
  //       builder: (BuildContext context) => const AlertDialog(
  //         title: Text("coucou"),
  //       ),
  //     );
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    debugPrint('in juxtapose ${widget.file.path}');
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.mediaCategory)),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: const NavigatorDrawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HorizontalButtonBarWidget(
              homeScreen: false,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(widget.fileName),
            Text(widget.fileList.toString())
            // Expanded(
            //           child: ListView.builder(
            //             itemCount: filesList.length,
            //             itemBuilder: (BuildContext context, int index) {
            //               var file = filesList[index];
            //               return Padding(
            //                 padding: const EdgeInsets.only(top: 8.0),
            //                 child: TileList(
            //                     file: file,
            //                     mediaCategory: widget.mediaCategory),
            //               );
            //               // fileName: file['fileName'],
            //               // path: file['path'],
            //             },
            //           ),
            //         )
            // const FilesListWidget(
            //   mediaCategory: "Image",
            // ),
          ],
        ),
      ),
    );
  }
}

// const AlertInfoOkWidget(
//         title: "Attention !",
//         message: "Horaires de début et fin incohérents !",
//       );
//   }
