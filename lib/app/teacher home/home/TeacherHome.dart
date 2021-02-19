import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:unicollab/services/firestore_service.dart';

import 'TeacherCardView.dart';

class TeacherHome extends StatefulWidget {
  final dynamic data;
  const TeacherHome(this.data);
  @override
  _TeacherHomeState createState() => _TeacherHomeState();
}

class _TeacherHomeState extends State<TeacherHome> {
  Stream<QuerySnapshot> _getData() {
    var fireStore = Provider.of<FireStoreService>(context);
    var data;
    try {
      data = fireStore.getSubjectData(code: widget.data['class code']);
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
      MaterialCard(document, widget.data['class code']),
      NoticeCard(document, widget.data['class code']),
      AssignmentCard(document, widget.data['class code'])
    ];
    return _cardView[document.data()['type']];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Teacher"),
      ),
      body: Container(
        color: Colors.black12,
        padding: EdgeInsets.all(5.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: _getData(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Expanded(
              child: ListView(
                children: snapshot.data.docs.map((DocumentSnapshot document) {
                  return Container(
                    child: cardView(document),
                  );
                }).toList(),
              ),
            );
          },
        ),
      ),
    );
  }
}

class TeacherCreate extends StatelessWidget {
  const TeacherCreate(this.data);
  final dynamic data;
  @override
  Widget build(BuildContext context) {
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
            // Navigator.pop(context);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (BuildContext context) =>
            //         CreateNotice(widget.code['class code']),
            //     // fullscreenDialog: true,
            //   ),
            // );
          },
        ),
        ListTile(
          leading: Icon(Icons.description),
          title: Text('Material'),
          onTap: () {
            // Navigator.pop(context);
            // Navigator.push(
            //   context,
            //   // MaterialPageRoute<void>(
            //   //   builder: (BuildContext context) =>
            //   //       CreateMaterial(widget.code["class code"]),
            //   //   fullscreenDialog: true,
            //   // ),
            // );
          },
        ),
      ],
    );
  }
}
