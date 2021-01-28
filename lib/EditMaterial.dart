import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditMaterial extends StatefulWidget {
  final dynamic data;
  final String code;
  const EditMaterial(this.data, this.code);
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
    var lol = await fireStore
        .collection('classes')
        .doc(widget.code)
        .collection('general')
        .doc(widget.data.id)
        .get();
    temp = lol.data()["files"];
    setState(() {});
    title.text = widget.data.get("title");
    description.text = widget.data.get("description");
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
                id = widget.data.id;
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
                    .update({'files': temp});
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
