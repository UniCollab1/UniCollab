import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unicollab/app/teacher%20home/assignment/CreateAssignment.dart';
import 'package:unicollab/app/teacher%20home/material/CreateMaterial.dart';
import 'package:unicollab/app/teacher%20home/notice/CreateNotice.dart';
import 'package:unicollab/models/classroom.dart';
import 'package:unicollab/services/firestore_service.dart';

import 'TeacherCardView.dart';

class TeacherHome extends StatefulWidget {
  final ClassRoom data;
  const TeacherHome(this.data);
  @override
  _TeacherHomeState createState() => _TeacherHomeState();
}

class _TeacherHomeState extends State<TeacherHome> {
  Stream<QuerySnapshot> _getData() {
    var fireStore = Provider.of<FireStoreService>(context);
    var data;
    try {
      data = fireStore.getSubjectData(code: widget.data.classCode);
    } catch (e) {
      print(e);
    }
    return data;
  }

  adjustText(String text) {
    if (text.length > 200) {
      return text.substring(0, 200) + "...";
    }
    return text;
  }

  Widget cardView(DocumentSnapshot document) {
    var _cardView = [
      MaterialCard(document, widget.data.classCode),
      NoticeCard(document, widget.data.classCode),
      AssignmentCard(document, widget.data.classCode)
    ];
    return _cardView[document.data()['type']];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data.title),
      ),
      floatingActionButton: TeacherCreate(widget.data),
      body: Container(
        color: Colors.black12,
        child: StreamBuilder<QuerySnapshot>(
          stream: _getData(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LinearProgressIndicator();
            }
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                      return Container(
                        child: cardView(document),
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class TeacherCreate extends StatelessWidget {
  const TeacherCreate(this.data);
  final ClassRoom data;
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
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                CreateAssignment(data.classCode),
                            fullscreenDialog: true,
                          ),
                        );
                      },
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
                                CreateNotice(data.classCode),
                            fullscreenDialog: true,
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
                                CreateMaterial(data.classCode),
                            fullscreenDialog: true,
                          ),
                        );
                      },
                    ),
                  ],
                );
              });
        });
  }
}
