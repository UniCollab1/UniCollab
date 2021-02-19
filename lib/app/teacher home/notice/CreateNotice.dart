import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:unicollab/services/firestore_service.dart';

class CreateNotice extends StatefulWidget {
  const CreateNotice(this.data);
  final dynamic data;
  @override
  _CreateNoticeState createState() => _CreateNoticeState();
}

class _CreateNoticeState extends State<CreateNotice> {
  var title = TextEditingController(),
      description = TextEditingController(),
      time;
  List<PlatformFile> result = [];

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
          code: widget.data['class code'],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Notice"),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                child: Text(
                  'Create a notice',
                  style: GoogleFonts.sourceSansPro(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
              SizedBox(
                width: 25.0,
              ),
              TextButton(
                onPressed: () => takeFile(),
                child: Icon(Icons.attachment_outlined),
              ),
              TextButton(
                onPressed: () {
                  _createNotice();
                  Navigator.pop(context);
                },
                child: Icon(Icons.send),
              ),
            ],
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
                              child: CupertinoTextField(
                                autofocus: true,
                                controller: title,
                                placeholder: 'Title(required)',
                                textCapitalization:
                                    TextCapitalization.sentences,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(10.0),
                              child: CupertinoTextField(
                                controller: description,
                                placeholder: 'Description',
                                maxLines: null,
                                minLines: null,
                                expands: true,
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
                            ),
                          ],
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
                                  adjustText(result[index - 1].name.toString()),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  print('deleted');
                                  result.removeAt(index - 1);
                                });
                              },
                              child: Icon(Icons.highlight_off_outlined),
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
