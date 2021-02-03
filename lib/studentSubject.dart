import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unicollab/Drawer.dart';
import 'package:unicollab/StudentMaterialPage.dart';
import 'package:unicollab/notices.dart';
import 'package:unicollab/resources.dart';

import 'assignments.dart';

class StudentHome extends StatefulWidget {
  final dynamic code;
  const StudentHome(this.code);
  @override
  _StudentHomeState createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  FirebaseAuth auth = FirebaseAuth.instance;
  var fireStore = FirebaseFirestore.instance;

  int _currentIndex = 0;
  List<Widget> _children;

  @override
  void initState() {
    super.initState();
    _children = [
      Home(widget.code),
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

class Home extends StatefulWidget {
  final dynamic code;
  const Home(this.code);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
                Center(child: Text(widget.code["subject"])),
                Center(child: Text(widget.code["created by"])),
                GetClass(widget.code["class code"]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GetClass extends StatefulWidget {
  final String code;
  const GetClass(this.code);
  @override
  _GetClassState createState() => _GetClassState();
}

class _GetClassState extends State<GetClass> {
  FirebaseAuth auth = FirebaseAuth.instance;
  var fireStore = FirebaseFirestore.instance;

  getData() {
    var lol =
        fireStore.collection('classes').doc(widget.code).collection('general');
    return lol;
  }

  getNotice() {
    var lol =
        fireStore.collection('classes').doc(widget.code).collection('notice');
    return lol;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: getData().snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    semanticsLabel: 'loading your classes',
                  ),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    StudentMaterialPage(
                                        document.data(), widget.code),
                              ),
                            );
                          },
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Icon(Icons.description),
                                  title: Text(
                                      'Material: ' + document.data()["title"]),
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
          StreamBuilder<QuerySnapshot>(
            stream: getNotice().snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data.docs;
                var now = DateTime.now().millisecondsSinceEpoch / 1000;
                for (var d in data) {
                  if (now > d.data()['time'].seconds) {
                    fireStore
                        .collection('classes')
                        .doc(widget.code)
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => NoticePage(
                                    document.data(), document.id, widget.code),
                              ),
                            );
                          },
                          child: Card(
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Icon(Icons.description),
                                  title: Text(
                                      'Notice : ' + document.data()["title"]),
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
        ],
      ),
    );
  }
}
