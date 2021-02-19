import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unicollab/app/student%20home/home/StudentHome.dart';
import 'package:unicollab/services/firestore_service.dart';

class JoinDialog extends StatefulWidget {
  @override
  _JoinDialogState createState() => _JoinDialogState();
}

class _JoinDialogState extends State<JoinDialog> {
  String code;

  Future<void> _joinClass() async {
    var fireStore = Provider.of<FireStoreService>(context, listen: false);
    try {
      var event = await fireStore.doesClassExist(code: code);
      if (event.exists) {
        var users = await fireStore.getUsers(code: code);
        var studentOf = users.data()['student of'];
        if (studentOf.contains(code)) {
          //already joined
          var data = await fireStore.getClass(code: code);
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => StudentHome(data)),
          );
        } else {
          await fireStore.joinClass(code: code);
          var data = await fireStore.getClass(code: code);
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => StudentHome(data)),
          );
        }
      } else {
        //class does not exist at all
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: AlertDialog(
                title: Text('Class not found'),
                content: Text(
                    'Class with given code does not found. Try to reach you teacher for correct code.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        code = null;
                      });

                      Navigator.pop(context);
                    },
                    child: Text('Dismiss'),
                  )
                ],
              ),
            );
          },
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join class'),
        actions: [
          Container(
            margin: EdgeInsets.all(10.0),
            child: IconButton(
              onPressed: () async {
                _joinClass();
              },
              icon: Icon(Icons.send),
            ),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.all(5.0),
              child: Text('Enter the code given by your teacher'),
            ),
            Container(
              margin: EdgeInsets.all(5.0),
              child: TextFormField(
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Class code',
                ),
                onChanged: (value) {
                  code = value;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
