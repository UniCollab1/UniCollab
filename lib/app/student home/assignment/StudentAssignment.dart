import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:unicollab/app/student%20home/assignment/StudentViewAssignment.dart';
import 'package:unicollab/app/teacher%20home/assignment/comments.dart';
import 'package:unicollab/services/firestore_service.dart';

class StudentAssignment extends StatefulWidget {
  final DocumentSnapshot document;
  final String code;
  const StudentAssignment(this.document, this.code);
  @override
  _StudentAssignmentState createState() => _StudentAssignmentState();
}

class _StudentAssignmentState extends State<StudentAssignment> {
  List<String> result = [];
  List<PlatformFile> files = [];
  var grades, status;

  @override
  void initState() {
    super.initState();
    getData();
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
      child: Scaffold(
        floatingActionButton: _getFAB(),
        body: Container(
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
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .color,
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
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .color,
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
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        .color,
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
                              InputChip(
                                backgroundColor: Colors.white,
                                label: Text(
                                  adjustText(result[index - 1].toString()),
                                ),
                                onDeleted: () {
                                  print(index);
                                  setState(() {
                                    print('deleted');
                                    result.removeAt(index - 1);
                                  });
                                },
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
      ),
    );
  }

  Widget _getFAB() {
    return SpeedDial(
      backgroundColor: Colors.blue,
      animatedIcon: AnimatedIcons.menu_close,
      visible: true,
      children: [
        SpeedDialChild(
          child: Icon(Icons.attachment_outlined),
          onTap: () {
            takeFile();
          },
          label: 'Add attachment',
          labelBackgroundColor: Colors.white,
          backgroundColor: Colors.blue,
        ),
        SpeedDialChild(
          child: Icon(Icons.assignment_turned_in),
          labelBackgroundColor: Colors.white,
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Center(
                  child: AlertDialog(
                    title: Text('Confirmation'),
                    content: Text(
                        'Your are going to submit assignment. Do you want submit?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          submit();
                          Navigator.pop(context);
                        },
                        child: Text('Submit'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          label: 'Submit',
          backgroundColor: Colors.blue,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverSafeArea(
                    top: false,
                    sliver: SliverAppBar(
                      title: Text(
                        'Assignment',
                      ),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: IconButton(
                            icon: Icon(Icons.message),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ShowComments(widget.document),
                                  // fullscreenDialog: true,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                      floating: true,
                      pinned: true,
                      snap: false,
                      primary: true,
                      bottom: TabBar(
                        enableFeedback: true,
                        indicatorWeight: 5.0,
                        labelStyle: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                        tabs: [
                          Tab(
                            text: "INSTRUCTIONS",
                          ),
                          Tab(
                            text: "SUBMISSION",
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                StudentViewAssignment(widget.document, widget.code),
                submitAssignment(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
