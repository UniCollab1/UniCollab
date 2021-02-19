import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:unicollab/services/firestore_service.dart';

class TeacherViewSubmittedAssignment extends StatefulWidget {
  TeacherViewSubmittedAssignment(this.data, this.assignment);
  final DocumentSnapshot data, assignment;
  @override
  _TeacherViewSubmittedAssignmentState createState() =>
      _TeacherViewSubmittedAssignmentState();
}

class _TeacherViewSubmittedAssignmentState
    extends State<TeacherViewSubmittedAssignment> {
  FirebaseStorage storage = FirebaseStorage.instance;
  var grades = TextEditingController(), status, code;
  var files, date;

  @override
  void initState() {
    super.initState();
    print(widget.assignment.data());
    files = widget.assignment.data()["files"];
    if (widget.assignment.data()['created at'] != null) {
      date = widget.assignment.data()['created at'].toDate();
    } else {
      date = "Not submitted";
    }
    code = widget.data.data()['class code'];
    if (widget.assignment.data()['grades'] != null) {
      grades.text = widget.assignment.data()['grades'].toString();
    }
  }

  void openFile(index) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    File downloadToFile = File('${appDocDir.path}/${files[index].toString()}');

    try {
      DownloadTask task = storage
          .ref(
              '${code.toString()}/general/${widget.assignment.id.toString()}/${files[index].toString()}')
          .writeToFile(downloadToFile);
      task.snapshotEvents.listen((event) {
        if (event.state.toString() == "TaskState.success") {}
      });
      await task;
    } catch (e) {
      print(e);
    }
    OpenFile.open('${appDocDir.path}/${files[index].toString()}');
  }

  adjustText(String text) {
    if (text.length > 45) {
      return text.substring(0, 45) + "...";
    }
    return text;
  }

  _submitGrades() async {
    var fireStore = Provider.of<FireStoreService>(context, listen: false);
    await fireStore.submitGrade(
      code: widget.data.data()['class code'],
      id: widget.data.id,
      email: widget.assignment.id,
      grades: int.parse(grades.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    //var data = widget.data.data();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.assignment.id),
          actions: [
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                _submitGrades();
              },
            ),
          ],
        ),
        body: Container(
          color: Colors.black12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: files.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.all(10.0),
                                child: TextFormField(
                                  autofocus: true,
                                  controller: grades,
                                  decoration: InputDecoration(
                                      labelText:
                                          'Enter marks out of ${widget.data.data()['marks']}'),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              Container(
                                margin:
                                    EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                                child: Text(
                                  'Submission date and time:',
                                  style: GoogleFonts.sourceSansPro(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(10.0),
                                child: Text(
                                  date.toString(),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(10.0),
                                child: Text(
                                  'Attachments: ',
                                  style: GoogleFonts.sourceSansPro(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                        if (files.length == 0) {
                          return Container(
                            margin: EdgeInsets.all(10.0),
                            child: Text(
                              'No attachments',
                            ),
                          );
                        }
                        return Container(
                          margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InputChip(
                                backgroundColor: Colors.white,
                                label: Text(
                                  adjustText(files[index - 1].toString()),
                                ),
                                onPressed: () {
                                  openFile(index - 1);
                                },
                              ),
                            ],
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
