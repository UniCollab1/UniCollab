import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:unicollab/app/student%20home/assignment/StudentViewAssignment.dart';
import 'package:unicollab/services/firestore_service.dart';

class StudentAssignment extends StatefulWidget {
  final DocumentSnapshot document;
  final String code;
  const StudentAssignment(this.document, this.code);
  @override
  _StudentAssignmentState createState() => _StudentAssignmentState();
}

class _StudentAssignmentState extends State<StudentAssignment> {
  int _sliding = 0;
  List<String> result = [];
  List<PlatformFile> files = [];
  var grades, status;
  var _children = {
    0: Container(
      child: Text("Instruction"),
    ),
    1: Container(
      child: Text("Submit"),
    )
  };

  @override
  void initState() {
    super.initState();
    getData();
  }

  Widget _body() {
    var lol = [
      StudentViewAssignment(widget.document, widget.code),
      submitAssignment(),
    ];
    return lol[_sliding];
  }

  submit() async {
    var fireStore = Provider.of<FireStoreService>(context, listen: false);
    status = 'On time';
    var now = DateTime.now();
    if (now.compareTo(widget.document.data()['due date'].toDate()) > 0) {
      status = 'Late';
    }
    await fireStore.submit(
        code: widget.code,
        id: widget.document.id,
        status: status,
        files: files,
        temp: result);
    setState(() {});
  }

  adjustText(String text) {
    if (text.length > 45) {
      return text.substring(0, 45) + "...";
    }
    return text;
  }

  takeFile() async {
    FilePickerResult res =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    setState(() {
      if (res != null) {
        res.files.forEach((element) {
          result.add(element.name);
          files.add(element);
        });
      }
    });
  }

  getData() async {
    var fireStore = Provider.of<FireStoreService>(context, listen: false);
    var user = Provider.of<User>(context, listen: false);
    var data = await fireStore.getSubmission(
        code: widget.code, id: widget.document.id, email: user.email);
    setState(() {
      data['files'].forEach((element) {
        result.add(element.toString());
      });
      status = data['status'];
      grades = (data['grades'] == null)
          ? ("Marks is not given.")
          : (data['grades'].toString());
    });
  }

  Widget submitAssignment() {
    return SafeArea(
      child: Container(
        color: Colors.black12,
        child: Column(
          children: [
            Flexible(
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: result.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin:
                                  EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                              child: Text(
                                'Your submission status:',
                                style: GoogleFonts.sourceSansPro(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(10.0),
                              child: Text(
                                status,
                              ),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                              child: Text(
                                'Your marks:',
                                style: GoogleFonts.sourceSansPro(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(10.0),
                              child: Text(
                                grades,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(10.0),
                              child: Text(
                                'Attachments: ',
                                style: GoogleFonts.sourceSansPro(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => takeFile(),
                              child: Container(
                                margin: EdgeInsets.all(10.0),
                                child: Text(
                                  'Click here to add attachments',
                                ),
                              ),
                            )
                          ],
                        );
                      }
                      if (result.length == 0) {
                        return Container(
                          margin: EdgeInsets.all(10.0),
                          child: Text(
                            'No attachments',
                          ),
                        );
                      }
                      return Container(
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Card(
                              elevation: 0.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              shadowColor: Colors.white,
                              child: Container(
                                margin: EdgeInsets.all(12.0),
                                child: Text(
                                  adjustText(result[index - 1].toString()),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  result.removeAt(index - 1);
                                });
                              },
                              child: Icon(CupertinoIcons.clear_circled),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Assignment'),
            bottom: TabBar(
              tabs: [
                Tab(
                  text: "Instructions",
                ),
                Tab(
                  text: "Submission",
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              StudentViewAssignment(widget.document, widget.code),
              submitAssignment(),
            ],
          ),
        ),
      ),
    );
  }
}
