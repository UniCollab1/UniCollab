import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class CreateAssignment extends StatefulWidget {
  final String code;
  const CreateAssignment(this.code);
  @override
  _CreateAssignmentState createState() => _CreateAssignmentState();
}

class _CreateAssignmentState extends State<CreateAssignment> {
  String title, description, id;
  FilePickerResult result;
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  var fireStore = FirebaseFirestore.instance;
  var due_date;
  var now = new DateTime.now();
  bool due_date_picked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Assignment'),
        actions: [
          Container(
            margin: EdgeInsets.all(5.0),
            child: IconButton(
              onPressed: () async {
                result =
                    await FilePicker.platform.pickFiles(allowMultiple: true);
                setState(() {
                  if (result != null) {
                    result.files.forEach((element) {
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
              icon: Icon(Icons.attach_file),
            ),
          ),
          Container(
            margin: EdgeInsets.all(5.0),
            child: ElevatedButton(
              onPressed: () async {
                try {
                  await fireStore
                      .collection('classes')
                      .doc(widget.code)
                      .collection('assignment')
                      .add({
                    'title': title,
                    'description': description,
                    'files': [],
                    'Due Date': due_date_picked ? due_date : "no due date",
                    'Created Date': now,
                  }).then((value) => id = value.id);
                } catch (e) {
                  print(e);
                }
                if (result != null) {
                  result.files.forEach((element) async {
                    print(element.path);
                    File file = File(element.path);
                    try {
                      await fireStore
                          .collection('classes')
                          .doc(widget.code)
                          .collection('assignment')
                          .doc(id)
                          .update({
                        'files': FieldValue.arrayUnion([element.name])
                      });
                      await storage
                          .ref(widget.code +
                              "/assignment/" +
                              id +
                              "/" +
                              element.name)
                          .putFile(file);
                    } catch (e) {
                      print(e);
                    }
                  });
                }
                Navigator.pop(context);
              },
              child: Text('Create'),
            ),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(5.0),
              child: TextFormField(
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter title for your post';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Title',
                ),
                onChanged: (value) {
                  title = value;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(5.0),
              child: TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Description',
                ),
                onChanged: (value) {
                  description = value;
                },
              ),
            ),
            Row(
              children: [
                Text("Select Due Date"),
                TextButton(
                  onPressed: () {
                    DatePicker.showDateTimePicker(context,
                        showTitleActions: true,
                        minTime: DateTime.now(), onChanged: (date) {
                      print('change $date');
                    }, onConfirm: (date) {
                      setState(() {
                        due_date = date;
                        due_date_picked = true;
                      });
                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                  child: Text(
                    '$due_date',
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: result != null ? result.count : 0,
                  itemBuilder: (context, index) {
                    return InputChip(
                      label: Text(result.names[index].toString()),
                      onDeleted: () {
                        print(index);
                        setState(() {
                          print('deleted');
                          result.files.removeAt(index);
                        });
                      },
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}