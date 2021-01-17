import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Join.dart';
import 'create.dart';

class Recent extends StatefulWidget {
  @override
  _RecentState createState() => _RecentState();
}

class _RecentState extends State<Recent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Recent'),
      ),
    );
  }
}

class RecentFloat extends StatefulWidget {
  @override
  _RecentFloatState createState() => _RecentFloatState();
}

class _RecentFloatState extends State<RecentFloat> {
  Join _join = Join();
  Create _create = Create();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              children: [
                ListTile(
                  title: Text('Create Class'),
                  onTap: () {
                    _create.createAlert(context);
                  },
                ),
                ListTile(
                  title: Text('Join Class'),
                  onTap: () {
                    _join.joinAlert(context);
                  },
                ),
              ],
            );
          },
        );
      },
      child: Icon(Icons.add),
    );
  }
}
