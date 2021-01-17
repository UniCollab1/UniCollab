import 'package:flutter/material.dart';

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
                  title: Text('Join Class'),
                  onTap: () {},
                ),
                ListTile(
                  title: Text('Create Class'),
                  onTap: () {},
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
