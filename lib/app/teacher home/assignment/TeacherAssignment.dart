import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unicollab/app/teacher%20home/assignment/TeacherSubmittedAssignment.dart';
import 'package:unicollab/app/teacher%20home/assignment/TeacherViewInstruction.dart';

class TeacherAssignment extends StatefulWidget {
  final DocumentSnapshot document;
  final String code;
  const TeacherAssignment(this.document, this.code);
  @override
  _TeacherAssignmentState createState() => _TeacherAssignmentState();
}

class _TeacherAssignmentState extends State<TeacherAssignment> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Assignment'),
            bottom: TabBar(
              tabs: [
                Tab(
                  text: "Instructions",
                ),
                Tab(
                  text: "Student's work",
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              TeacherViewInstruction(widget.document, widget.code),
              TeacherSubmittedAssignment(widget.document, widget.code),
            ],
          ),
        ),
      ),
    );
  }
}
