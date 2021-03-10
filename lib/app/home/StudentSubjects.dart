import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unicollab/app/student%20home/home/StudentHome.dart';
import 'package:unicollab/models/classroom.dart';
import 'package:unicollab/services/firestore_service.dart';

class Student extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var studentSubject = Provider.of<FireStoreService>(context);
    return Container(
      color: Colors.white,
      child: StreamBuilder<List<ClassRoom>>(
        stream: studentSubject.getStudentSubject(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final subject = snapshot.data;
            if (subject == null || subject.length == 0) {
              return Center(
                child: Text('No classroom'),
              );
            }

            return GridView.builder(
              padding: EdgeInsets.only(top: 0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: subject.length,
              itemBuilder: (context, index) {
                var data = subject[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => StudentHome(data)),
                    );
                  },
                  child: new Card(
                    color: Theme.of(context).cardColor,
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    shadowColor: Colors.white,
                    child: new GridTile(
                      footer: Container(
                        margin: EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Text(
                              data.title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color:
                                    Theme.of(context).textTheme.headline2.color,
                              ),
                            ),
                            Text(
                              data.createdBy,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color:
                                    Theme.of(context).textTheme.headline2.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.all(10.0),
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              data.shortName,
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 80.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
