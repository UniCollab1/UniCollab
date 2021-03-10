import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unicollab/app/Drawer/Drawer.dart';
import 'package:unicollab/app/home/CreateDialog.dart';
import 'package:unicollab/app/home/JoinDialog.dart';
import 'package:unicollab/app/home/StudentSubjects.dart';
import 'package:unicollab/app/home/TeacherSubjects.dart';
import 'package:unicollab/services/dynamic_link_service.dart';
import 'package:unicollab/services/firestore_service.dart';
import 'package:unicollab/services/notification_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final DynamicLinkService _dynamicLinkService = DynamicLinkService();
  Timer _timerLink;

  receive() async {
    final _fireStore = Provider.of<FireStoreService>(context, listen: false);
    await _fireStore.checkTokenUpdate();
    await receiveNotification(context);
  }

  @override
  void initState() {
    super.initState();
    receive();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _timerLink = new Timer(
        const Duration(milliseconds: 1000),
        () {
          _dynamicLinkService.retrieveDynamicLink(context);
        },
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_timerLink != null) {
      _timerLink.cancel();
    }
    super.dispose();
  }

  _addUserToFireStore() async {
    try {
      final fireStore = Provider.of<FireStoreService>(context, listen: false);
      await fireStore.addUserToFireStore();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    _addUserToFireStore();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: RecentFloat(),
        drawer: DrawerMain(),
        body: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverSafeArea(
                  top: false,
                  sliver: SliverAppBar(
                    title: Text(
                      'UniCollab',
                    ),
                    floating: true,
                    pinned: true,
                    snap: false,
                    primary: true,
                    bottom: TabBar(
                      enableFeedback: true,
                      indicatorWeight: 5.0,
                      labelStyle: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                      ),
                      tabs: [
                        Tab(
                          text: "I'M STUDENT",
                        ),
                        Tab(
                          text: "I'M TEACHER",
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              Student(),
              Teacher(),
            ],
          ),
        ),
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
              title: Text('I want to'),
              children: [
                ListTile(
                  leading: Icon(Icons.create),
                  title: Text('Create a class'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => CreateDialog(),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.add),
                  title: Text('Join a class'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => JoinDialog(),
                        fullscreenDialog: true,
                      ),
                    );
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
