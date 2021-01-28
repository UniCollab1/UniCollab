import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class StudentMaterialPage extends StatefulWidget {
  final dynamic data;
  final String code;
  const StudentMaterialPage(this.data, this.code);
  @override
  _StudentMaterialPageState createState() => _StudentMaterialPageState();
}

class _StudentMaterialPageState extends State<StudentMaterialPage> {
  var files;
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  var fireStore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    files = widget.data["files"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Material"),
      ),
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
                      File downloadToFile =
                          File('${appDocDir.path}/${files[index].toString()}');
                      print(appDocDir.path);

                      try {
                        DownloadTask task = storage
                            .ref(
                                '${widget.code}/general/${files[index].toString()}')
                            .writeToFile(downloadToFile);
                        task.snapshotEvents.listen((event) {
                          if (event.state.toString() == "TaskState.success") {
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
    );
  }
}
