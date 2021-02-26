import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:unicollab/app/student%20home/assignment/StudentAssignment.dart';
import 'package:unicollab/app/student%20home/material/StudentMaterial.dart';
import 'package:unicollab/app/student%20home/notice/StudentNotice.dart';

adjustText(String text) {
  if (text.length > 45) {
    return text.substring(0, 45) + "...";
  }
  return text;
}

Future<void> sendNotification({
  @required int type,
  @required String title,
  @required String classCode,
  @required String docId,
  String description,
}) async {
  var _firebaseMessaging = FirebaseMessaging.instance;
  var token = await _firebaseMessaging.getToken();
  print('My token is $token');
  var serverToken =
      'AAAAWniPM6w:APA91bFJkjAV3lE1C8KEf4P5kc9fG83Flgyj1NRCGSOv5xM_9_fkq6_652OwtZy3QonvxrvkD4Jn4FPnfkbj3-k715YbMCCfGHeTL9iVoqfS0JjkEC36pKDqsJxzeTVmtWv5ss0zqE67';

  final _fireStore = FirebaseFirestore.instance;
  var data = await _fireStore.collection('classes').doc(classCode).get();
  var tokens = data.data()['tokens'];
  print(tokens);
  var newTitle, newBody = adjustText(description);

  if (type == 0) {
    newTitle = "New material: ";
  } else if (type == 1) {
    newTitle = "New notice: ";
  } else {
    newTitle = "New assignment: ";
  }
  newTitle += title;

  for (var token in tokens) {
    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'title': '$newTitle',
            'body': '$newBody',
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'classCode': '$classCode',
            'docId': '$docId',
            'docType': '$type',
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': token,
        },
      ),
    );
    print('Notification sent to $token');
  }
}

Future<void> receiveNotification(BuildContext context) async {
  FirebaseMessaging.onMessage.listen((message) async {
    print("Notification received");
    onNotificationReceived(message, context);
  });
}

Future<void> onNotificationReceived(
    RemoteMessage message, BuildContext context) async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  //configuring channel(adding channel)
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.max,
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  print("Notification received");
  //Initialization of flutter_local_notification
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('app_icon');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (value) =>
          selectNotification(message.data, context));

  //getting data
  RemoteNotification notification = message.notification;
  AndroidNotification android = message.notification?.android;

  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channel.description,
          importance: channel.importance,
          icon: android?.smallIcon,
        ),
      ),
    );
  }
}

Future<void> selectNotification(
    Map<String, dynamic> data,
    BuildContext context,
    ) async {
  var classCode = data['classCode'],
      docId = data['docId'],
      type = int.parse(data['docType']),
      document;
  final _fireStore = FirebaseFirestore.instance;
  try {
    document = await _fireStore
        .collection('classes')
        .doc(classCode)
        .collection('general')
        .doc(docId)
        .get();
  } catch (e) {
    print(e);
  }
  if (type == 0) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudentMaterial(
          document.data(),
          classCode,
          document.id,
        ),
      ),
    );
  } else if (type == 1) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudentNotice(
          document,
          classCode,
        ),
      ),
    );
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StudentAssignment(
          document,
          classCode,
        ),
      ),
    );
  }
}
