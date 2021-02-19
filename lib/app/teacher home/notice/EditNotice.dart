import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:unicollab/services/firestore_service.dart';

class EditNotice extends StatefulWidget {
  final String code;
  final DocumentSnapshot data;
  const EditNotice(this.data, this.code);
  @override
  _EditNoticeState createState() => _EditNoticeState();
}

class _EditNoticeState extends State<EditNotice> {
  var title = TextEditingController(),
      description = TextEditingController(),
      id,
      data,
      time;
  List<String> result = [];
  List<PlatformFile> files = [];

  @override
  void initState() {
    super.initState();
    data = widget.data.data();
    id = widget.data.id;
    time = data['due date'].toDate();
    title.text = data['title'];
    description.text = data['description'];
    data['files'].forEach((element) {
      result.add(element.toString());
    });
  }

  Future<void> _editNotice() async {
    var fireStore = Provider.of<FireStoreService>(context, listen: false);
    try {
      await fireStore.edit(
        code: widget.code,
        id: id,
        title: title.text,
        type: data['type'],
        dueDate: time,
        description: description.text,
        files: files,
        temp: result,
      );
    } catch (e) {
      print(e);
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit a notice',
        ),
        actions: [
          IconButton(
            onPressed: () => takeFile(),
            icon: Icon(Icons.attachment_outlined),
          ),
          IconButton(
            onPressed: () {
              _editNotice();
              Navigator.pop(context);
            },
            icon: Icon(Icons.send),
          ),
        ],
      ),
      body: Container(
        color: Colors.black12,
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
                                  labelText: "Title(required)",
                                ),
                                textCapitalization: TextCapitalization.words,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(10.0),
                              child: TextFormField(
                                controller: description,
                                decoration: InputDecoration(
                                  filled: true,
                                  labelText: "Description",
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(10.0),
                              child: Text(
                                'Deadline of notice: ',
                                style: GoogleFonts.sourceSansPro(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
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
                                style: GoogleFonts.sourceSansPro(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            )
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
            )
          ],
        ),
      ),
    );
  }
}
