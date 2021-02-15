import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class StudentsWork extends StatefulWidget {
  final String email;
  final String id;
  final String code;

  const StudentsWork(this.email, this.id, this.code);
  @override
  _StudentsWorkState createState() => _StudentsWorkState();
}

class _StudentsWorkState extends State<StudentsWork> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  var fireStore = FirebaseFirestore.instance;
  var name = 'anonymous';
  var diff;
  void initState() {
    super.initState();
    getStudent();
  }

  Timestamp due;
  Timestamp submit;
  getStudent() {
    var student;
    try {
      var student_name = fireStore
          .collection('users')
          .doc(widget.email)
          .get()
          .then((value) => name =
              value.data()['first name'] + " " + value.data()['last name']);

      student = fireStore
          .collection('classes')
          .doc(widget.code)
          .collection('assignment')
          .doc(widget.id)
          .collection(widget.email)
          .snapshots();

      fireStore
          .collection('classes')
          .doc(widget.code)
          .collection('assignment')
          .doc(widget.id)
          .get()
          .then((value) => due = value.data()['Due Date']);

      fireStore
          .collection('classes')
          .doc(widget.code)
          .collection('assignment')
          .doc(widget.id)
          .collection(widget.email)
          .doc(widget.email)
          .get()
          .then((value) => setState(() {
                submit = value.data()['submit_date'];
              }));
    } catch (e) {}

    return student;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("work"),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: getStudent(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  semanticsLabel: 'loading your Work',
                ),
                // ignore: missing_return
              );
            } else {
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text("name : $name "),
                  Text("Email : ${widget.email} "),
                  Text((() {
                    if (name == 'anonymous') {
                      return "Work not Submitted";
                    }

                    return ("Submitted at : " +
                        new DateFormat.MMMd('en_US').add_jm().format(
                            DateTime.fromMicrosecondsSinceEpoch(snapshot
                                .data.docs[0]
                                .data()['submit_date']
                                .microsecondsSinceEpoch)));
                  })()),
                  Text((() {
                    try {
                      if (submit.compareTo(due) > 0) {
                        return "Late submission";
                      }
                    } catch (e) {
                      return ('');
                    }
                  })()),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot student = snapshot.data.docs[0];
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: student['files'].length,
                          itemBuilder: (context, i) {
                            return InputChip(
                              label: Text(snapshot.data.docs[0]
                                  .data()['files'][i]
                                  .toString()),
                              onPressed: () async {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Center(
                                        child: CircularProgressIndicator(
                                          semanticsLabel: 'Logging you in',
                                        ),
                                      );
                                    });
                                Directory appDocDir =
                                    await getApplicationDocumentsDirectory();
                                File downloadToFile = File(
                                    '${appDocDir.path}/${student['files'][i].toString()}');
                                print(appDocDir.path);

                                try {
                                  DownloadTask task = storage
                                      .ref(
                                          '${widget.code}/assignment/${widget.id}/${widget.email}/${student['files'][i].toString()}')
                                      .writeToFile(downloadToFile);
                                  task.snapshotEvents.listen((event) {
                                    if (event.state.toString() ==
                                        "TaskState.success") {
                                      Navigator.pop(context);
                                    }
                                  });
                                  await task;
                                } catch (e) {
                                  print(e);
                                }
                                OpenFile.open(
                                    '${appDocDir.path}/${student['files'][i].toString()}');
                              },
                            );
                          });
                    },
                  ),
                ],
              );
            }
          }),
    );
  }
}
