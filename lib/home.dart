import 'package:flutter/material.dart';
import 'package:unicollab/Drawer.dart';

import 'assignments.dart';
import 'notices.dart';
import 'recents.dart';
import 'resources.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    Recent(),
    Resource(),
    Notice(),
    Assignment(),
  ];
  final List<Widget> _floatchildren = [
    RecentFloat(),
    Resource(),
    Notice(),
    Assignment(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerMain(),
      appBar: AppBar(
        /*leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),*/
        title: Text(
          'UniCollab',
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: _floatchildren[_currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (value) {
          setState(() => _currentIndex = value);
        },
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Resources',
            icon: Icon(Icons.description),
          ),
          BottomNavigationBarItem(
            label: 'Notices',
            icon: Icon(Icons.announcement),
          ),
          BottomNavigationBarItem(
            label: 'Assignments',
            icon: Icon(Icons.assignment),
          ),
        ],
      ),
      body: _children[_currentIndex],
    );
  }
}
