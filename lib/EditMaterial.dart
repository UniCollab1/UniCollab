import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class EditMaterial extends StatefulWidget {
  final String code;
  final DocumentSnapshot ds;
  const EditMaterial(this.ds, this.code);
  @override
  _EditMaterialState createState() => _EditMaterialState();
}

class _EditMaterialState extends State<EditMaterial> {
  FilePickerResult result;

  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  var fireStore = FirebaseFirestore.instance;
  var temp, id;
  var title = TextEditingController();
  var description = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    var data = widget.ds.data();
    temp = data["files"];
    setState(() {});
    title.text = data["title"];
    description.text = data["description"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Material'),
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
                      temp.add(element.name);
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
                id = widget.ds.id;
                if (result != null) {
                  result.files.forEach((element) async {
                    print(element.path);
                    File file = File(element.path);
                    try {
                      await storage
                          .ref(widget.code + "/general/" + element.name)
                          .putFile(file);
                    } catch (e) {
                      print(e);
                    }
                  });
                }
                await fireStore
                    .collection('classes')
                    .doc(widget.code)
                    .collection('general')
                    .doc(id)
                    .update({
                  'files': temp,
                  'title': title.text,
                  'description': description.text,
                });
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
              child: TextField(
                controller: title,
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Title',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(5.0),
              child: TextField(
                controller: description,
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Description',
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: temp != null ? temp.length : 0,
                  itemBuilder: (context, index) {
                    return InputChip(
                      label: Text(temp[index].toString()),
                      onDeleted: () {
                        print(index);
                        setState(() {
                          temp.removeAt(index);
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

class EditNotice extends StatefulWidget {
  final String code;
  final dynamic data;
  final String id;
  const EditNotice(this.data, this.id, this.code);
  @override
  _EditNoticeState createState() => _EditNoticeState();
}

class _EditNoticeState extends State<EditNotice> {
  FilePickerResult result;
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  var fireStore = FirebaseFirestore.instance;
  var temp, id;
  var title = TextEditingController();
  var description = TextEditingController();
  var time;
  @override
  void initState() {
    super.initState();
    getNotice();
    print(widget.data);
  }

  void getNotice() async {
    temp = widget.data["files"];
    setState(() {});
    title.text = widget.data["title"];
    description.text = widget.data["description"];
  }

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now().millisecondsSinceEpoch / 1000;
    if (now > widget.data['time'].seconds) {
      fireStore
          .collection('classes')
          .doc(widget.code)
          .collection('notice')
          .doc(widget.id)
          .delete();
      Navigator.pop(context);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Notice'),
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
                      temp.add(element.name);
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
                id = widget.id;
                if (result != null) {
                  result.files.forEach((element) async {
                    print(element.path);
                    File file = File(element.path);
                    try {
                      await storage
                          .ref(widget.code + "/notice/" + element.name)
                          .putFile(file);
                    } catch (e) {
                      print(e);
                    }
                  });
                }
                await fireStore
                    .collection('classes')
                    .doc(widget.code)
                    .collection('notice')
                    .doc(id)
                    .update({
                  'files': temp,
                  'title': title.text,
                  'description': description.text,
                  'time': time,
                });
                Navigator.pop(context);
              },
              child: Text('Update'),
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
              child: TextField(
                controller: title,
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Title',
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(5.0),
              child: TextField(
                controller: description,
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Description',
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                DatePicker.showDateTimePicker(context,
                    showTitleActions: true,
                    minTime: DateTime.now(), onChanged: (date) {
                  print('change $date');
                }, onConfirm: (date) {
                  time = date;
                }, currentTime: DateTime.now(), locale: LocaleType.en);
              },
              child: Text(
                'Select Time',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: temp != null ? temp.length : 0,
                  itemBuilder: (context, index) {
                    return InputChip(
                      label: Text(temp[index].toString()),
                      onDeleted: () {
                        print(index);
                        setState(() {
                          temp.removeAt(index);
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
