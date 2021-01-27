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
  String title, description, id;
  FilePickerResult result;
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  var fireStore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Material'),
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
                      .collection('general')
                      .add({
                    'title': title,
                    'description': description,
                    'files': [],
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
                          .collection('general')
                          .doc(id)
                          .update({
                        'files': FieldValue.arrayUnion([element.name])
                      });
                      await storage
                          .ref(widget.code + "/general/" + element.name)
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
                initialValue: widget.data.get("title").toString(),
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
                initialValue: widget.data.get("description").toString(),
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Description',
                ),
                onChanged: (value) {
                  description = value;
                },
              ),
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
