import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unicollab/app/teacher%20home/assignment/TeacherViewSubmittedAssignment.dart';
import 'package:unicollab/services/firestore_service.dart';

class TeacherSubmittedAssignment extends StatefulWidget {
  final DocumentSnapshot document;
  final String code;
  const TeacherSubmittedAssignment(this.document, this.code);
  @override
  _TeacherSubmittedAssignmentState createState() =>
      _TeacherSubmittedAssignmentState();
}

class _TeacherSubmittedAssignmentState
    extends State<TeacherSubmittedAssignment> {
  _getData() {
    var fireStore = Provider.of<FireStoreService>(context, listen: false);
    return fireStore.getStudentSubmission(
        code: widget.code, id: widget.document.id);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.black12,
        child: StreamBuilder<QuerySnapshot>(
          stream: _getData(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CupertinoActivityIndicator(),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                      var data = document.data();
                      return Container(
                        margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (_) =>
                                      TeacherViewSubmittedAssignment(
                                          widget.document, document),
                                  fullscreenDialog: true),
                            );
                          },
                          child: Card(
                            elevation: 0.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            shadowColor: Colors.white,
                            clipBehavior: Clip.antiAlias,
                            child: ListTile(
                              leading: Icon(
                                CupertinoIcons.person_alt_circle,
                                size: 40.0,
                              ),
                              title: Text(document.id.toString()),
                              subtitle: Text(
                                "Status: " + data['status'],
                              ),
                            ),
                          ),
                        ),
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
