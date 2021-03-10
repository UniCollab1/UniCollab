import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:unicollab/app/teacher%20home/home/TeacherHome.dart';
import 'package:unicollab/models/classroom.dart';
import 'package:unicollab/services/firestore_service.dart';

class Teacher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var teacherSubject = Provider.of<FireStoreService>(context);
    return Container(
      color: Colors.white,
      child: StreamBuilder<List<ClassRoom>>(
        stream: teacherSubject.getTeacherSubject(),
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
                      MaterialPageRoute(builder: (_) => TeacherHome(data)),
                    );
                  },
                  child: new Card(
                    color: Theme.of(context).cardColor,
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: GridTile(
                      header: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ContextMenu(data.classCode),
                        ],
                      ),
                      footer: Container(
                        margin: EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Text(
                              data.createdBy,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color:
                                    Theme.of(context).textTheme.headline2.color,
                              ),
                            ),
                            Text(
                              data.subject,
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
                            child: new Text(
                              data.shortName,
                              style: TextStyle(
                                fontSize: 80.0,
                                fontWeight: FontWeight.w900,
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

Future<Uri> createDynamicLink(String classCode) async {
  final DynamicLinkParameters parameters = DynamicLinkParameters(
    uriPrefix: 'https://unicollab.page.link/',
    link: Uri.parse('https://www.unicollab.com/?code=$classCode'),
    androidParameters: AndroidParameters(
      packageName: 'com.prs.unicollab',
    ),
  );
  var dynamicUrl = await parameters.buildUrl();

  return dynamicUrl;
}

class ContextMenu extends StatelessWidget {
  const ContextMenu(this.code);
  final String code;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: Theme.of(context).canvasColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry>[
        PopupMenuItem(
          child: ListTile(
            title: Text('Copy class code'),
            onTap: () {
              Clipboard.setData(new ClipboardData(text: code));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Class code $code is copied!!!")));
            },
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            title: Text('Share this classroom'),
            onTap: () async {
              var link = await createDynamicLink(code);
              print(link.toString());
              Share.share(link.toString());
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
