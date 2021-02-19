import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'StudentsWork.dart';

class EditAssignment extends StatefulWidget {
  final String code;
  final DocumentSnapshot ds;
  final String id;
  const EditAssignment(this.ds, this.id, this.code);
  @override
  _EditAssignmentState createState() => _EditAssignmentState();
}

class _EditAssignmentState extends State<EditAssignment> {
  FilePickerResult result;

  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  var fireStore = FirebaseFirestore.instance;
  var temp, id;
  var title = TextEditingController();

  @override
  void initState() {
    super.initState();
    getData();
    getStudentWork();
    setState(() {});
  }

  void getData() async {
    var data = widget.ds.data();
    temp = data["files"];
    setState(() {});
    title.text = data["title"];
    //description.text = data["description"];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Material'),
          bottom: TabBar(tabs: <Widget>[
            Tab(
              text: 'Assignment',
            ),
            Tab(
              text: 'Student Work',
            ),
          ]),

          /*actions: [
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
                onPressed: () async {},
                child: Text('Create'),
              ),
            )
          ],*/
        ),
        body: TabBarView(children: [Edit(), StudentWork()]),
      ),
    );
  }

  Widget Edit() {
    return Container(
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
    );
  }

  var students_email = [];
  getStudentWork() async {
    await fireStore
        .collection('classes')
        .doc(widget.code)
        .get()
        .then((value) => students_email = value.data()['students']);
    print(students_email);
    setState(() {});

    //return students_email.length;
    //print(students);

    // var raj = fireStore
    //     .collection('classes')
    //     .doc(widget.code)
    //     .collection('assignment')
    //     .doc(widget.id)
    //     .collection('rajs@gmail.com')
    //     .get();

    //return students;
  }

  Widget StudentWork() {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: students_email.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: TextButton(
              onPressed: () {
                print(students_email[index]);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => StudentsWork(
                        students_email[index], widget.id, widget.code),
                  ),
                );
              },
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.supervised_user_circle),
                      title: Text(students_email[index]),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
