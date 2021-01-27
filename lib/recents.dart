import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unicollab/studentSubject.dart';
import 'package:unicollab/teacherSubject.dart';

import 'Join.dart';
import 'create.dart';

class Recent extends StatefulWidget {
  @override
  _RecentState createState() => _RecentState();
}

class _RecentState extends State<Recent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Classes joined by you',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListPage('join'),
          TextButton(
            onPressed: () {},
            child: Text(
              'Classes created by you',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListPage('create'),
        ],
      ),
    );
  }
}

class ListPage extends StatefulWidget {
  final String which;
  const ListPage(this.which);
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  var fireStore = FirebaseFirestore.instance;
  Future getClass() async {
    var lol;
    if (widget.which == 'join') {
      lol = await fireStore
          .collection('classes')
          .where("students", arrayContains: auth.currentUser.email)
          .get();
    } else {
      lol = await fireStore
          .collection('classes')
          .where("teachers", arrayContains: auth.currentUser.email)
          .get();
    }
    return lol.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: getClass(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                semanticsLabel: 'loading your classes',
              ),
            );
          } else {
            return SizedBox(
              height: 200.0,
              child: Container(
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return TextButton(
                        onPressed: () async {
                          var data = await fireStore
                              .collection('classes')
                              .doc(snapshot.data[index].get("class code"))
                              .get();
                          if (widget.which == 'join') {
                            print("redirecting");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => StudentHome(
                                  data.data(),
                                ),
                              ),
                            );
                          } else {
                            print(data.data());
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => TeacherHome(
                                  data.data(),
                                ),
                              ),
                            );
                          }
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.all(5.0),
                              width: 130.0,
                              height: 130.0,
                              color: Colors.grey,
                            ),
                            Container(
                              width: 130.0,
                              child: Text(
                                snapshot.data[index].get("subject"),
                                maxLines: 1,
                              ),
                            ),
                            Container(
                              width: 130.0,
                              child: Text(
                                snapshot.data[index].get("created by"),
                                maxLines: 1,
                              ),
                            )
                          ],
                        ),
                      );
                    }),
              ),
            );
          }
        },
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
