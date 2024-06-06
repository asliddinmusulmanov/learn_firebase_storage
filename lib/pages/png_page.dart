import 'package:flutter/material.dart';

import 'dart:io';

import 'package:file_picker/file_picker.dart';

import '../services/storage_service.dart';
import '../services/utils_service.dart';

class PngPage extends StatefulWidget {
  const PngPage({super.key});

  @override
  State<PngPage> createState() => _PngPageState();
}

class _PngPageState extends State<PngPage> {
  File? file;
  List<String> linkList = [];
  (List<String>, List<String>) allList = ([], []);
  List<String> nameList = [];
  bool isLoading = false;

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

      await StorageService.upload(path: "image", file: file!);

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
    allList = await StorageService.getData("image");
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
                    const SizedBox(height: 20),
                itemBuilder: (context, index) => InkWell(
                  onLongPress: () async => await delete(linkList[index]),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Container(
                    height: 200,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(linkList[index]))),
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
        backgroundColor: Colors.green.shade400,
        child: const Icon(
          Icons.photo,
        ),
      ),
    );
  }
}
