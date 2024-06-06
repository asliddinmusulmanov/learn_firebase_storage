import 'dart:io';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/storage_service.dart';

class Mp3Page extends StatefulWidget {
  const Mp3Page({super.key});

  @override
  State<Mp3Page> createState() => _Mp3PageState();
}

class _Mp3PageState extends State<Mp3Page> {
  File? file;
  List<String> linkList = [];
  (List<String>, List<String>) allList = ([], []);
  List<String> nameList = [];
  bool isLoading = false;
  AudioPlayer audioPlayer = AudioPlayer();
  String? currentlyPlaying;

  Future<File?> takeFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      file = File(result.files.single.path!);
      return file;
    } else {
      return null;
    }
  }

  Future<void> uploadFile() async {
    file = await takeFile();
    if (file != null) {
      isLoading = true;
      setState(() {});

      await StorageService.upload(path: "mp3", file: file!);

      isLoading = false;
      setState(() {});
      await getItems();

      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Successfully uploaded")));
    }
  }

  Future<void> getItems() async {
    isLoading = true;
    allList = await StorageService.getData("mp3");
    linkList = allList.$1;
    nameList = allList.$2;
    isLoading = false;
    setState(() {});
  }

  Future<void> delete(String url) async {
    isLoading = true;
    setState(() {});
    await StorageService.delete(url);
    await getItems();
  }

  @override
  void initState() {
    getItems();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: !isLoading
            ? ListView.separated(
                itemCount: linkList.length,
                padding: const EdgeInsets.symmetric(vertical: 10),
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) => InkWell(
                  onLongPress: () async => await delete(linkList[index]),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Container(
                    height: 80,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        width: 2,
                        color: Colors.black.withOpacity(0.1),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: IconButton(
                            onPressed: () async {
                              if (currentlyPlaying == linkList[index]) {
                                await audioPlayer.pause();
                                currentlyPlaying = null;
                                setState(() {});
                              } else {
                                await audioPlayer
                                    .play(UrlSource(linkList[index]));
                                currentlyPlaying = linkList[index];
                                setState(() {});
                              }
                            },
                            icon: Icon(currentlyPlaying == linkList[index]
                                ? CupertinoIcons.pause
                                : CupertinoIcons.play),
                          ),
                        ),
                        const SizedBox(width: 10),
                        StreamBuilder<Duration>(
                          stream: audioPlayer.onPositionChanged,
                          builder: (context, positionSnapshot) {
                            return StreamBuilder<Duration>(
                              stream: audioPlayer.onDurationChanged,
                              builder: (context, durationSnapshot) {
                                return Expanded(
                                  child: Align(
                                    alignment: const Alignment(0, 0.5),
                                    child: ProgressBar(
                                      thumbColor: Colors.black,
                                      baseBarColor:
                                          Colors.grey.withOpacity(0.4),
                                      progressBarColor: Colors.blue,
                                      progress: positionSnapshot.data ??
                                          Duration.zero,
                                      buffered: positionSnapshot.data ??
                                          Duration.zero,
                                      total: durationSnapshot.data ??
                                          Duration.zero,
                                      onSeek: (duration) {
                                        audioPlayer.seek(duration);
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(width: 20)
                      ],
                    ),
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(
                  color: Colors.blue,
                  strokeCap: StrokeCap.round,
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await uploadFile();
        },
        backgroundColor: Colors.pink.shade300,
        child: const Icon(
          Icons.audiotrack,
        ),
      ),
    );
  }
}
