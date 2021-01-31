import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unicollab/CreateMaterial.dart';
import 'package:unicollab/EditMaterial.dart';

import 'CreateNotice.dart';

class TeacherHome extends StatefulWidget {
  final dynamic code;
  const TeacherHome(this.code);
  @override
  _TeacherHomeState createState() => _TeacherHomeState();
}

class _TeacherHomeState extends State<TeacherHome> {
  FirebaseAuth auth = FirebaseAuth.instance;
  var fireStore = FirebaseFirestore.instance;

  getData() {
    var lol = fireStore
        .collection('classes')
        .doc(widget.code["class code"])
        .collection('general')
        .snapshots();
    return lol;
  }

  getNotice() {
    var lol = fireStore
        .collection('classes')
        .doc(widget.code["class code"])
        .collection('notice')
        .snapshots();
    return lol;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.code["title"]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return SimpleDialog(
                  title: Text('I want to create a'),
                  children: [
                    ListTile(
                      leading: Icon(Icons.assignment),
                      title: Text('Assignment'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.announcement),
                      title: Text('Notice'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                CreateNotice(widget.code['class code']),
                            // fullscreenDialog: true,
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.description),
                      title: Text('Material'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                CreateMaterial(widget.code["class code"]),
                            fullscreenDialog: true,
                          ),
                        );
                      },
                    ),
                  ],
                );
              });
        },
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Center(child: Text(widget.code['subject'])),
                  Center(child: Text(widget.code['class code'])),
                ],
              ),
            ),
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: getData(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        semanticsLabel: 'loading your Material',
                      ),
                      // ignore: missing_return
                    );
                  } else {
                    return SizedBox(
                      height: 250.0,
                      child: ListView(
                        children:
                            snapshot.data.docs.map((DocumentSnapshot document) {
                          return Container(
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          EditMaterial(
                                              document,
                                              widget.code["class code"]
                                                  .toString()),
                                    ),
                                  );
                                });
                              },
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: Icon(Icons.description),
                                      title: Text('Material: ' +
                                          document.data()["title"]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }
                },
              ),
            ),
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: getNotice(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data.docs;
                    var now = DateTime.now().millisecondsSinceEpoch / 1000;
                    for (var d in data) {
                      if (now > d.data()['time'].seconds) {
                        fireStore
                            .collection('classes')
                            .doc(widget.code['class code'])
                            .collection('notice')
                            .doc(d.id)
                            .delete();
                      }
                    }
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        semanticsLabel: 'loading your Notice',
                      ),
                      // ignore: missing_return
                    );
                  } else {
                    return SizedBox(
                      height: 200.0,
                      child: ListView(
                        children:
                            snapshot.data.docs.map((DocumentSnapshot document) {
                          return Container(
                            child: TextButton(
                              onPressed: () {
                                // setState(() {
                                //   Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (BuildContext context) =>
                                //           EditMaterial(
                                //               document.data(),
                                //               widget.code["class code"]
                                //                   .toString()),
                                //     ),
                                //   );
                                // });
                              },
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: Icon(Icons.description),
                                      title: Text('Notice: ' +
                                          document.data()["title"]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
