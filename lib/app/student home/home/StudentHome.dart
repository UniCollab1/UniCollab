import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unicollab/app/student%20home/home/StudentCardView.dart';
import 'package:unicollab/models/classroom.dart';
import 'package:unicollab/services/firestore_service.dart';

class StudentHome extends StatefulWidget {
  StudentHome(this.classRoom);
  final ClassRoom classRoom;
  @override
  _StudentHomeState createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  var fireStore = FirebaseFirestore.instance;

  Widget cardView(DocumentSnapshot document) {
    var _cardView = [
      MaterialCard(document, widget.classRoom.classCode),
      NoticeCard(document, widget.classRoom.classCode),
      AssignmentCard(document, widget.classRoom.classCode)
    ];
    return _cardView[document.data()['type']];
  }

  getData() {
    var lol = Provider.of<FireStoreService>(context, listen: false);
    var data = lol.getSubjectData(code: widget.classRoom.classCode);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subject'),
      ),
      body: Container(
        color: Colors.black12,
        padding: EdgeInsets.all(5.0),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: getData(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CupertinoActivityIndicator(),
                  );
                } else {
                  return Flexible(
                    child: ListView(
                      children:
                          snapshot.data.docs.map((DocumentSnapshot document) {
                        return cardView(document);
                      }).toList(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
