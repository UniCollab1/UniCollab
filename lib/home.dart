import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unicollab/Drawer.dart';
import 'assignments.dart';
import 'notices.dart';
import 'recents.dart';
import 'resources.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  void initState() {
    super.initState();
    getImage();
  }

  Future<void> getImage() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    File downloadToFile =
        File('${appDocDir.path}/${auth.currentUser.email.toString()}');
    print(appDocDir.path + '/' + auth.currentUser.email.toString());

    try {
      await storage
          .ref('images/' + auth.currentUser.email)
          .writeToFile(downloadToFile);
    } catch (e) {
      print("notfound");
      await storage
          .ref(
              "https://firebasestorage.googleapis.com/v0/b/collab-627c8.appspot.com/o/images%2Fdownload.jpg?alt=media&token=a4f8c09d-af58-45f2-a34c-5c05eb007334")
          .writeToFile(downloadToFile);
    }
  }

  int _currentIndex = 0;
  final List<Widget> _children = [
    Recent(),
    Resource(),
    Notice(),
    Assignment(),
  ];
  final List<Widget> _floatchildren = [
    RecentFloat(),
    Resource(),
    Notice(),
    Assignment(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerMain(),
      appBar: AppBar(
        /*leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),*/
        title: Text(
          'UniCollab',
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: _floatchildren[_currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (value) {
          setState(() => _currentIndex = value);
        },
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Resources',
            icon: Icon(Icons.description),
          ),
          BottomNavigationBarItem(
            label: 'Notices',
            icon: Icon(Icons.announcement),
          ),
          BottomNavigationBarItem(
            label: 'Assignments',
            icon: Icon(Icons.assignment),
          ),
        ],
      ),
      body: _children[_currentIndex],
    );
  }
}
