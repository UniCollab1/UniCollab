
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unicollab/services/firestore_service.dart';

class CreateDialog extends StatefulWidget {
  @override
  _CreateDialogState createState() => _CreateDialogState();
}

class _CreateDialogState extends State<CreateDialog> {
  var classRoom;
  Future<void> _createClass(context) async {
    try {
      var fireStore = Provider.of<FireStoreService>(context, listen: false);
      classRoom = await fireStore.addNewClass(
          title: title,
          subject: subject,
          shortName: shortName,
          description: description);
    } catch (e) {
      print(e);
    }
  }

  bool titleValidation = false,
      subjectValidation = false,
      shortNameValidation = false;
  String errorMsg;
  var tcon = TextEditingController(),
      scon = TextEditingController(),
      sscon = TextEditingController();
  String title, subject, shortName, description;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create class'),
        actions: [
          Container(
            margin: EdgeInsets.all(10.0),
            child: IconButton(
              onPressed: () async {
                setState(() {
                  tcon.text.isEmpty
                      ? titleValidation = true
                      : titleValidation = false;
                  scon.text.isEmpty
                      ? subjectValidation = true
                      : subjectValidation = false;
                  sscon.text.isEmpty
                      ? shortNameValidation = true
                      : shortNameValidation = false;
                });

                if (tcon.text.isNotEmpty &&
                    scon.text.isNotEmpty &&
                    sscon.text.isNotEmpty &&
                    sscon.text.length <= 5) {
                  _createClass(context);
                  Navigator.pop(context);
                }
              },
              icon: Icon(Icons.send),
            ),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(5.0),
                child: TextFormField(
                  controller: tcon,
                  autofocus: true,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'Class title',
                    errorText:
                    titleValidation ? 'Title can not be empty' : null,
                  ),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (value) {
                    title = value;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.all(5.0),
                child: TextFormField(
                  controller: scon,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'Subject',
                    errorText:
                    subjectValidation ? 'Subject can not be empty' : null,
                  ),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (value) {
                    subject = value;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.all(5.0),
                child: TextFormField(
                  maxLength: 5,
                  controller: sscon,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'Short name of subject',
                    errorText: shortNameValidation
                        ? 'Short name can not be empty'
                        : null,
                  ),
                  textCapitalization: TextCapitalization.characters,
                  onChanged: (value) {
                    shortName = value;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.all(5.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'Description',
                  ),
                  onChanged: (value) {
                    description = value;
                  },
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}