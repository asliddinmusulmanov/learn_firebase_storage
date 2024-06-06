import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learn_firebase_storage/pages/mp3_page.dart';
import 'package:learn_firebase_storage/pages/mp4_page.dart';
import 'package:learn_firebase_storage/pages/pdf_page.dart';
import 'package:learn_firebase_storage/pages/png_page.dart';

import '../services/storage_service.dart';
import '../services/utils_service.dart';

class HomePage extends StatefulWidget {
  final User? user;
  const HomePage({super.key, this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? file;
  List<String> linkList = [];
  (List<String>, List<String>) allList = ([], []);
  List<String> nameList = [];
  bool isLoading = false;

  Future<File?> takeFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      file = File(result.files.single.path!);
      return file;
    } else {
      return null;
    }
  }

  // upload
  Future<void> uploadFile() async {
    file = await takeFile();
    if (file != null) {
      String link = await StorageService.upload(path: "G10", file: file!);
      // log(link);
      Utils.fireSnackBar("Successfully Uploaded", context);
    }
  }

  // getData
  Future<void> getItems() async {
    isLoading = false;
    allList = await StorageService.getData("G10");
    linkList = allList.$1;
    nameList = allList.$2;
    // log(linkList.toString());
    isLoading = true;
    setState(() {});
  }

  // delete
  Future<void> delete(String url) async {
    isLoading = false;
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
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey,
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.audiotrack_outlined),
                child: Text("Mp3"),
              ),
              Tab(
                icon: Icon(Icons.photo_camera_back),
                child: Text("Png"),
              ),
              Tab(
                icon: Icon(Icons.video_camera_back),
                child: Text("Mp4"),
              ),
              Tab(
                icon: Icon(Icons.picture_as_pdf_outlined),
                child: Text("Pdf"),
              ),
            ],
          ),
          title: const Text(
            "Home Page",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: TabBarView(
          children: [
            const Mp3Page(),
            const PngPage(),
            Mp4Page(
              url: '',
            ),
            const PdfPage(),
          ],
        ),
      ),
    );
  }
}
