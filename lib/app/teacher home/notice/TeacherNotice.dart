import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:unicollab/app/teacher%20home/home/comments.dart';

class TeacherNotice extends StatefulWidget {
  final DocumentSnapshot document;
  final String code;
  const TeacherNotice(this.document, this.code);
  @override
  _TeacherNoticeState createState() => _TeacherNoticeState();
}

class _TeacherNoticeState extends State<TeacherNotice> {
  var files, data;
  FirebaseStorage storage = FirebaseStorage.instance;

  void openFile(index) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    File downloadToFile = File('${appDocDir.path}/${files[index].toString()}');

    try {
      DownloadTask task = storage
          .ref('${widget.code}/general/${files[index].toString()}')
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

  @override
  void initState() {
    super.initState();
    data = widget.document.data();
    files = data["files"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notice'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: IconButton(
              icon: Icon(Icons.message),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ShowComments(
                        widget.document.data(), widget.document.id),
                    // fullscreenDialog: true,
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView.builder(
                  itemCount: files.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                            child: Text(
                              data["edited"] == true
                                  ? ("Edited at:")
                                  : ("Created at:"),
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).textTheme.headline1.color,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                            child: Text(
                              DateFormat("dd MMMM yy KK:MM")
                                  .format(data["created at"].toDate()),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                            child: Text(
                              'Title:',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).textTheme.headline1.color,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10.0),
                            child: Text(
                              data["title"].toString(),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                            child: Text(
                              'Description:',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).textTheme.headline1.color,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10.0),
                            child: Text(
                              data["description"].toString(),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10.0),
                            child: Text(
                              'Deadline of notice: ',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).textTheme.headline1.color,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10.0),
                            child: Text((() {
                              if (data["due date"] == null) {
                                return "No Deadline";
                              }

                              return DateFormat("dd MMMM yy KK:MM")
                                  .format(data["due date"].toDate());
                            })()),
                          ),
                          Container(
                            margin: EdgeInsets.all(10.0),
                            child: Text(
                              'Attachments: ',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).textTheme.headline1.color,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                        ],
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
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
