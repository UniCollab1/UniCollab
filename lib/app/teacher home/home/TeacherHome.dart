import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:unicollab/app/teacher%20home/assignment/CreateAssignment.dart';
import 'package:unicollab/app/teacher%20home/material/CreateMaterial.dart';
import 'package:unicollab/app/teacher%20home/notice/CreateNotice.dart';
import 'package:unicollab/models/classroom.dart';
import 'package:unicollab/services/firestore_service.dart';

import 'TeacherCardView.dart';

class TeacherHome extends StatefulWidget {
  TeacherHome(this.classRoom);
  final ClassRoom classRoom;
  @override
  _TeacherHomeState createState() => _TeacherHomeState();
}

class _TeacherHomeState extends State<TeacherHome> {
  Stream<QuerySnapshot> _getData() {
    var fireStore = Provider.of<FireStoreService>(context);
    var data;
    try {
      data = fireStore.getSubjectData(code: widget.classRoom.classCode);
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
      MaterialCard(document, widget.classRoom.classCode),
      NoticeCard(document, widget.classRoom.classCode),
      AssignmentCard(document, widget.classRoom.classCode)
    ];
    return _cardView[document.data()['type']];
  }

  Future<Uri> createDynamicLink() async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://unicollab.page.link/',
      link: Uri.parse(
          'https://www.unicollab.com/?code=${widget.classRoom.classCode}'),
      androidParameters: AndroidParameters(
        packageName: 'com.prs.unicollab',
      ),
    );
    var dynamicUrl = await parameters.buildUrl();

    return dynamicUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: TeacherCreate(widget.classRoom),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getData(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_outlined),
                  ),
                  title: Text(widget.classRoom.title),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.share),
                      onPressed: () async {
                        var link = await createDynamicLink();
                        print(link.toString());
                        Share.share(link.toString());
                      },
                    ),
                  ],
                  expandedHeight: 100.0,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(widget.classRoom.subject),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Container(
                        child: cardView(snapshot.data.docs[index]),
                      );
                    },
                    childCount: snapshot.data.docs.length,
                  ),
                ),
              ],
            );
          }
        },
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
