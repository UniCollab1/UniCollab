import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'StudentAssignmentPage.dart';

class Assignment extends StatefulWidget {
  final dynamic code;

  const Assignment(this.code);

  @override
  _AssignmentState createState() => _AssignmentState();
}

class _AssignmentState extends State<Assignment> {
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

  getAssignment() {
    var lol = fireStore
        .collection('classes')
        .doc(widget.code)
        .collection('assignment');
    return lol;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: getAssignment().snapshots(),
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
                                    StudentAssignmentPage(document.data(),
                                        document.id, widget.code),
                              ),
                            );
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
        ],
      ),
    );
  }
}
