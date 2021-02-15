import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unicollab/CreateMaterial.dart';
import 'package:unicollab/Drawer.dart';
import 'package:unicollab/EditMaterial.dart';
import 'package:unicollab/assignments.dart';
import 'package:unicollab/notices.dart';
import 'package:unicollab/resources.dart';

import 'CreateAssignment.dart';
import 'CreateNotice.dart';
import 'EditAssignment.dart';

class TeacherHome extends StatefulWidget {
  final dynamic code;
  const TeacherHome(this.code);
  @override
  _TeacherHomeState createState() => _TeacherHomeState();
}

class _TeacherHomeState extends State<TeacherHome> {
  FirebaseAuth auth = FirebaseAuth.instance;
  var fireStore = FirebaseFirestore.instance;

  int _currentIndex = 0;
  List<Widget> _children;

  @override
  void initState() {
    super.initState();
    _children = [
      THome(widget.code),
      Resource(),
      Notice(),
      Assignment(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerMain(),
      appBar: AppBar(
        title: Text(widget.code["title"]),
      ),
      floatingActionButton: TeacherFloat(widget.code),
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

class THome extends StatefulWidget {
  final dynamic code;
  const THome(this.code);
  @override
  _THomeState createState() => _THomeState();
}

class _THomeState extends State<THome> {
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

  getAssignment() {
    var lol = fireStore
        .collection('classes')
        .doc(widget.code["class code"])
        .collection('assignment')
        .snapshots();
    return lol;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                              setState(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        EditNotice(
                                            document.data(),
                                            document.id,
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
                                    title: Text(
                                        'Notice: ' + document.data()["title"]),
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
              stream: getAssignment(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data.docs;
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      semanticsLabel: 'loading your assignment',
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
                              setState(() {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        EditAssignment(
                                            document,
                                            document.id,
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
                                    title: Text('Assignment: ' +
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
        ],
      ),
    );
  }
}

class TeacherFloat extends StatefulWidget {
  final dynamic code;
  const TeacherFloat(this.code);
  @override
  _TeacherFloatState createState() => _TeacherFloatState();
}

class _TeacherFloatState extends State<TeacherFloat> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
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
    );
  }
}
