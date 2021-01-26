import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class CreateDialog extends StatefulWidget {
  @override
  _CreateDialogState createState() => _CreateDialogState();
}

class _CreateDialogState extends State<CreateDialog> {
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
                final _fireStore = FirebaseFirestore.instance;
                FirebaseAuth auth = FirebaseAuth.instance;
                String code;

                code = randomAlphaNumeric(7);

                // If by chance code is already generated.
                try {
                  while (true) {
                    var event = await _fireStore
                        .collection('classes')
                        .where("code", isEqualTo: code)
                        .get();
                    if (event.docs.isNotEmpty) {
                      code = randomAlphaNumeric(7);
                    } else {
                      break;
                    }
                  }
                } catch (e) {
                  print(e);
                }

                try {
                  String docId = auth.currentUser.email;
                  await _fireStore.collection('classes').doc(code).set({
                    'class code': code,
                    'title': title,
                    'subject': subject,
                    'short name': shortName,
                    'description': description,
                    'teachers': [docId],
                    'students': [],
                    'created by': docId,
                  }).then((value) => (print('Class added successfully!')));
                  await _fireStore.collection('users').doc(docId).update({
                    'teacher of': [code]
                  }).then((value) => print("Users successfully updated!"));
                  Navigator.pop(context);
                } catch (e) {
                  print(e);
                }
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
