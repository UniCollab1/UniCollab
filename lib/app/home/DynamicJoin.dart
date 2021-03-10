import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unicollab/app/home/Home.dart';
import 'package:unicollab/app/student%20home/home/StudentHome.dart';
import 'package:unicollab/services/firestore_service.dart';

class DynamicJoin extends StatelessWidget {
  const DynamicJoin(this.code);
  final String code;

  Future<void> _joinClass(context) async {
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
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => HomePage()),
                      );
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
    _joinClass(context);
    return Container();
  }
}
