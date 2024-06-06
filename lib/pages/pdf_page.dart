import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import '../services/storage_service.dart';

class PdfPage extends StatefulWidget {
  const PdfPage({super.key});

  @override
  State<PdfPage> createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  File? file;
  List<String> linkList = [];
  (List<String>, List<String>) allList = ([], []);
  List<String> nameList = [];
  bool isLoading = false;

  Future<File?> takeFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
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

      await StorageService.upload(path: "pdf", file: file!);

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
    allList = await StorageService.getData("pdf");
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
      body: !isLoading
          ? ListView.separated(
              itemCount: linkList.length,
              padding: const EdgeInsets.symmetric(vertical: 10),
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const PdfPage(),
                    ),
                  );
                },
                onLongPress: () async => await delete(linkList[index]),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Container(
                  height: 60,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    nameList[index],
                    style: const TextStyle(color: Colors.white),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await uploadFile();
        },
        backgroundColor: Colors.deepPurple.shade300,
        child: const Icon(
          Icons.picture_as_pdf,
        ),
      ),
    );
  }
}
