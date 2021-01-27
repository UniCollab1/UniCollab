import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unicollab/CreateMaterial.dart';
import 'package:unicollab/EditMaterial.dart';

class TeacherHome extends StatefulWidget {
  final dynamic code;
  const TeacherHome(this.code);
  @override
  _TeacherHomeState createState() => _TeacherHomeState();
}

class _TeacherHomeState extends State<TeacherHome> {
  FirebaseAuth auth = FirebaseAuth.instance;
  var fireStore = FirebaseFirestore.instance;

  Future<dynamic> getData() async {
    var lol = await fireStore
        .collection('classes')
        .doc(widget.code["class code"])
        .collection('general')
        .get();
    print("in teacherSubject");
    print(lol.docs);
    return lol.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.code["title"]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return SimpleDialog(
                  title: Text('I want to create a'),
                  children: [
                    ListTile(
                      leading: Icon(Icons.assignment),
                      title: Text('Assignment'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.announcement),
                      title: Text('Notice'),
                      onTap: () {},
                    ),
                    ListTile(
                      leading: Icon(Icons.description),
                      title: Text('Material'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                CreateMaterial(widget.code["class code"]),
                            fullscreenDialog: true,
                          ),
                        );
                      },
                    ),
                  ],
                );
              });
        },
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Center(child: Text(widget.code['subject'])),
                ],
              ),
            ),
            Container(
              child: FutureBuilder(
                future: getData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        semanticsLabel: 'loading your classes',
                      ),
                      // ignore: missing_return
                    );
                  } else {
                    return SizedBox(
                      height: 100.0,
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Container(
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        EditMaterial(
                                            snapshot.data[index], widget.code),
                                  ),
                                );
                              },
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: Icon(Icons.description),
                                      title: Text('Material: ' +
                                          snapshot.data[index].get("title")),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
