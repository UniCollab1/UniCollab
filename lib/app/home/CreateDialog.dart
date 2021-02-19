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

  String title, subject, shortName, description;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create class'),
        actions: [
          Container(
            margin: EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () async {
                _createClass(context);
                /*Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => TeacherHome(classRoom),
                  ),
                );*/
              },
              child: Text('Create'),
            ),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(5.0),
              child: TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Class title',
                ),
                onChanged: (value) {
                  title = value;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(5.0),
              child: TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Subject',
                ),
                onChanged: (value) {
                  subject = value;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(5.0),
              child: TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Short name of subject',
                ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
