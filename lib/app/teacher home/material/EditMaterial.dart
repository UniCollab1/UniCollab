import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unicollab/services/firestore_service.dart';

class EditMaterial extends StatefulWidget {
  final String code;
  final DocumentSnapshot ds;
  const EditMaterial(this.ds, this.code);
  @override
  _EditMaterialState createState() => _EditMaterialState();
}

class _EditMaterialState extends State<EditMaterial> {
  var title = TextEditingController(),
      description = TextEditingController(),
      id,
      data;
  bool tv = false;
  List<String> result = [];
  List<PlatformFile> files = [];

  @override
  void initState() {
    super.initState();
    data = widget.ds.data();
    id = widget.ds.id;
    title.text = data['title'];
    description.text = data['description'];
    data['files'].forEach((element) {
      result.add(element.toString());
    });
  }

  Future<void> _editMaterial() async {
    var fireStore = Provider.of<FireStoreService>(context, listen: false);
    try {
      await fireStore.edit(
        code: widget.code,
        id: id,
        title: title.text,
        type: data['type'],
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
        title: Text('Edit a material'),
        actions: [
          IconButton(
            onPressed: () => takeFile(),
            icon: Icon(Icons.attachment_outlined),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                title.text.isEmpty ? tv = true : tv = false;
              });
              if (title.text.isNotEmpty) {
                _editMaterial();
                Navigator.pop(context);
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
                                  labelText: 'Title',
                                  errorText:
                                      tv ? 'Title can not be empty' : null,
                                  filled: true,
                                ),
                                textCapitalization: TextCapitalization.words,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(10.0),
                              child: TextFormField(
                                controller: description,
                                decoration: InputDecoration(
                                  labelText: 'Description',
                                  filled: true,
                                ),
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
