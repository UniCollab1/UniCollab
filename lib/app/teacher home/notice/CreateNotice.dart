import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:unicollab/app/home/mail.dart';
import 'package:unicollab/services/firestore_service.dart';

class CreateNotice extends StatefulWidget {
  const CreateNotice(this.data);
  final String data;
  @override
  _CreateNoticeState createState() => _CreateNoticeState();
}

class _CreateNoticeState extends State<CreateNotice> {
  var title = TextEditingController(),
      description = TextEditingController(),
      time;
  List<PlatformFile> result = [];
  FirebaseAuth auth = FirebaseAuth.instance;
  var recipients, classname;

  bool titlevalidation = false;

  void initstate() {
    super.initState();
    getStudents();
    setState(() {});
  }

  adjustText(String text) {
    if (text.length > 45) {
      return text.substring(0, 45) + "...";
    }
    return text;
  }

  Future<void> _createNotice() async {
    var fireStore = Provider.of<FireStoreService>(context, listen: false);
    try {
      await fireStore.create(
          code: widget.data,
          title: title.text,
          description: description.text,
          type: 1,
          dueDate: time,
          files: result);
    } catch (e) {
      print(e);
    }
  }

  takeFile() async {
    FilePickerResult res =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    setState(() {
      if (res != null) {
        res.files.forEach((element) {
          result.add(element);
        });
      }
    });
  }

  getStudents() {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    var students = _firestore
        .collection('classes')
        .doc(widget.data)
        .get()
        .then((value) => {
              {
                recipients = value.data()['students'].cast<String>(),
                classname = value.data()['subject'],
              }
            });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getStudents();
    SendMail sendMail = SendMail();
    var body = auth.currentUser.email + " announce something in ";
    return Scaffold(
      appBar: AppBar(
        title: Text("Create a notice"),
        actions: [
          IconButton(
            onPressed: () => takeFile(),
            icon: Icon(Icons.attachment_outlined),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                title.text.isEmpty
                    ? titlevalidation = true
                    : titlevalidation = false;
              });
              if (title.text.isNotEmpty) {
                _createNotice();
                Navigator.pop(context);
                sendMail.mail(
                    recipients, "Notice: ${title.text}", body + classname);
              }
            },
            icon: Icon(Icons.send),
          ),
        ],
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
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
                              margin: EdgeInsets.all(10.0),
                              child: TextFormField(
                                autofocus: true,
                                controller: title,
                                decoration: InputDecoration(
                                  filled: true,
                                  labelText: 'Title',
                                  errorText: titlevalidation
                                      ? 'Title can not be empty'
                                      : null,
                                ),
                                textCapitalization:
                                    TextCapitalization.sentences,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(10.0),
                              child: TextFormField(
                                controller: description,
                                decoration: InputDecoration(
                                  filled: true,
                                  labelText: 'Description',
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(10.0),
                              child: Text(
                                'Deadline of notice: ',
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
                            TextButton(
                              onPressed: () {
                                DatePicker.showDateTimePicker(context,
                                    showTitleActions: true,
                                    minTime: DateTime.now(),
                                    currentTime: DateTime.now(),
                                    locale: LocaleType.en, onConfirm: (date) {
                                  setState(() {
                                    time = date;
                                  });
                                });
                              },
                              child: Text(
                                (time == null)
                                    ? 'No deadline'
                                    : time.toString(),
                                style: TextStyle(color: Colors.black),
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
                          ],
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
                                adjustText(result[index - 1].name.toString()),
                              ),
                              onDeleted: () {
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
            )
          ],
        ),
      ),
    );
  }
}
