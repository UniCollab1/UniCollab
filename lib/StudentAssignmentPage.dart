import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class StudentAssignmentPage extends StatefulWidget {
  final dynamic data;
  final String id;
  final String code;

  const StudentAssignmentPage(this.data, this.id, this.code);

  @override
  _StudentAssignmentPageState createState() => _StudentAssignmentPageState();
}

class _StudentAssignmentPageState extends State<StudentAssignmentPage> {
  var files;
  List<String> picked_files;
  FilePickerResult result;
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  var fireStore = FirebaseFirestore.instance;
  bool isSubmit = false;
  isSubmitted() async {
    try {
      var snap = await fireStore
          .collection('classes')
          .doc(widget.code)
          .collection('assignment')
          .doc(widget.id)
          .collection(auth.currentUser.email)
          .get();

      if (snap.docs.isNotEmpty) {
        print('submitted');
        setState(() {
          isSubmit = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    isSubmitted();
    files = widget.data["files"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Assignment"),
        ),
        body: SlidingUpPanel(
          border: Border(
            top: BorderSide(width: 1.0, color: Colors.blue[900]),
          ),
          panel: sliding(),
          body: Container(
            child: Column(
              children: [
                Container(
                  child: Text(
                    widget.data["title"].toString(),
                  ),
                ),
                Container(
                  child: Text(
                    widget.data["description"].toString(),
                  ),
                ),
                Container(
                  child: Text(
                    "Due Date : " +
                        new DateFormat.yMMMMd('en_US').format(
                            DateTime.fromMicrosecondsSinceEpoch(widget
                                .data['Due Date'].microsecondsSinceEpoch)),
                  ),
                ),
                Container(
                  child: Text("Created at : " +
                      new DateFormat.MMMMd('en_US').format(
                          DateTime.fromMicrosecondsSinceEpoch(widget
                              .data['Created Date'].microsecondsSinceEpoch))),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: files.length,
                    itemBuilder: (context, index) {
                      return InputChip(
                        label: Text(files[index].toString()),
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
                              '${appDocDir.path}/${files[index].toString()}');
                          print(appDocDir.path);

                          try {
                            DownloadTask task = storage
                                .ref(widget.code +
                                    "/assignment/" +
                                    widget.id +
                                    "/" +
                                    files[index].toString())
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
                              '${appDocDir.path}/${files[index].toString()}');
                        },
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Container sliding() {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      child: Column(
        children: [
          Text("you want to Submit......."),
          SizedBox(
            height: 70,
          ),
          Text((() {
            if (isSubmit == true) {
              return "Submitted";
            }
            return '';
          })()),
          OutlineButton(
            highlightColor: Colors.blue,
            onPressed: () async {
              result = await FilePicker.platform.pickFiles(allowMultiple: true);
              setState(() {
                if (result != null) {
                  result.files.forEach((element) {
                    picked_files.add(element.name);
                    print(element.path);
                    print(element.name +
                        " " +
                        element.size.toString() +
                        " " +
                        element.extension);
                  });
                }
              });
            },
            child: Container(
                child: Row(
              children: [
                Text('Add Your Attachment'),
              ],
            )),
          ),
          RaisedButton(
            color: Colors.blue[900],
            child: const Text(
              'Submit Assignment',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            onPressed: () async {
              if (result != null) {
                await fireStore
                    .collection('classes')
                    .doc(widget.code)
                    .collection('assignment')
                    .doc(widget.id)
                    .collection(auth.currentUser.email)
                    .doc(auth.currentUser.email)
                    .set({
                  "submit_date": new DateTime.now(),
                  "files": '',
                });

                result.files.forEach((element) async {
                  print(element.path);
                  File file = File(element.path);

                  try {
                    await fireStore
                        .collection('classes')
                        .doc(widget.code)
                        .collection('assignment')
                        .doc(widget.id)
                        .collection(auth.currentUser.email)
                        .doc(auth.currentUser.email)
                        .update({
                      "files": FieldValue.arrayUnion([element.name]),
                    });
                  } catch (e) {
                    print(e);
                  }
                  await storage
                      .ref(widget.code +
                          "/assignment/" +
                          widget.id +
                          "/" +
                          auth.currentUser.email +
                          "/" +
                          element.name)
                      .putFile(file);
                });

                print(picked_files);
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
