import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:unicollab/app/home/StudentSubjects.dart';
import 'package:unicollab/app/home/TeacherSubjects.dart';

import '../../Drawer.dart';
import '../../Join.dart';
import '../../create.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: DrawerMain(),
        appBar: AppBar(
          title: Text(
            'UniCollab',
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                text: "I'm Student",
              ),
              Tab(
                text: "I'm Teacher",
              )
            ],
          ),
        ),
        floatingActionButton: RecentFloat(),
        body: TabBarView(
          children: [
            Student(),
            Teacher(),
          ],
        ),
      ),
    );
  }
}

class RecentFloat extends StatefulWidget {
  @override
  _RecentFloatState createState() => _RecentFloatState();
}

class _RecentFloatState extends State<RecentFloat> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              title: Text('I want to'),
              children: [
                ListTile(
                  leading: Icon(Icons.create),
                  title: Text('Create a class'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => CreateDialog(),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.add),
                  title: Text('Join a class'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => JoinDialog(),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
      child: Icon(Icons.add),
    );
  }
}
