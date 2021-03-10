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
      body: StreamBuilder<QuerySnapshot>(
        stream: getData(),
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
