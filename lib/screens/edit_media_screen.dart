import 'dart:io';

import 'package:flutter/material.dart';
import 'package:medias_manager/widgets/widgets.dart';

class EditMediaScreen extends StatefulWidget {
  const EditMediaScreen(
      {super.key,
      required this.mediaCategory,
      required this.fileName,
      required this.file});

  final String mediaCategory;
  final String fileName;
  final FileSystemEntity file;

  @override
  State<EditMediaScreen> createState() => _EditMediaScreenState();
}

class _EditMediaScreenState extends State<EditMediaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.fileName),
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
        automaticallyImplyLeading: false,
      ),
      drawer: const NavigatorDrawerWidget(),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                const HorizontalButtonBarWidget(
                  homeScreen: false,
                ),
                const SizedBox(height: 10,),
                if (widget.mediaCategory == "Vidéo")
                  Column(
                    children: [
                      Center(
                        child: ExtractAudioCardWidget(
                          mediaCategory: widget.mediaCategory,
                          file: widget.file,
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Center(
                        child: RemoveAudioCardWidget(
                          mediaCategory: widget.mediaCategory,
                          file: widget.file,
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Center(
                        child: CutUpMediaCardWidget(
                          mediaCategory: widget.mediaCategory,
                          file: widget.file,
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Center(
                        child: ChangeFormatCardWidget(
                          mediaCategory: widget.mediaCategory,
                          file: widget.file,
                        ),
                      ),
                    ],
                  )
                else
                  (widget.mediaCategory == "Audio")
                      ? Column(
                          children: [
                            Center(
                              child: CutUpMediaCardWidget(
                                mediaCategory: widget.mediaCategory,
                                file: widget.file,
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Center(
                              child: ChangeFormatCardWidget(
                                mediaCategory: widget.mediaCategory,
                                file: widget.file,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Center(
                              child: ChangeFormatCardWidget(
                                mediaCategory: widget.mediaCategory,
                                file: widget.file,
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Center(
                              child: MirorImageEffectCard(
                                mediaCategory: widget.mediaCategory,
                                file: widget.file,
                              ),
                            ),
                          ],
                        ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
