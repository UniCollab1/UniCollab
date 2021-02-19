import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:random_string/random_string.dart';
import 'package:unicollab/models/classroom.dart';

class FireStoreService {
  FireStoreService({@required this.email}) : assert(email != null);

  final String email;
  final fireStore = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  Stream<List<ClassRoom>> getTeacherSubject() {
    var snapshots = fireStore
        .collection('classes')
        .where("teachers", arrayContains: email)
        .snapshots();
    return snapshots.map(
        (event) => event.docs.map((e) => ClassRoom.fromMap(e.data())).toList());
  }

  Stream<List<ClassRoom>> getStudentSubject() {
    var snapshots = fireStore
        .collection('classes')
        .where("students", arrayContains: email)
        .snapshots();
    return snapshots.map(
        (event) => event.docs.map((e) => ClassRoom.fromMap(e.data())).toList());
  }

  Future<ClassRoom> getClass({@required String code}) async {
    var classRoom = await fireStore.collection('classes').doc(code).get();
    return ClassRoom.fromMap(classRoom.data());
  }

  Future<void> addUserToFireStore() async {
    var result = await fireStore.collection('users').doc(email).get();
    if (!result.exists) {
      await fireStore.collection('users').doc(email).set({
        'teacher of': [],
        'student of': [],
      });
    }
  }

  Future<ClassRoom> addNewClass(
      {@required String title,
      @required String subject,
      @required String shortName,
      @required String description}) async {
    var code = randomAlphaNumeric(7);
    try {
      while (true) {
        var event = await fireStore
            .collection('classes')
            .where("code", isEqualTo: code)
            .get();
        if (event.docs.isNotEmpty) {
          code = randomAlphaNumeric(7);
        } else {
          break;
        }
      }
    } catch (e) {
      print(e);
    }

    await fireStore.collection('classes').doc(code).set({
      'class code': code,
      'title': title,
      'subject': subject,
      'short name': shortName,
      'description': description,
      'teachers': [email],
      'students': [],
      'created by': email,
      'created at': DateTime.now(),
    }).then((value) => (print('Class added successfully!')));
    await fireStore.collection('users').doc(email).update({
      'teacher of': [code]
    }).then((value) => print("Users successfully updated!"));

    var classRoom = await fireStore.collection('classes').doc(code).get();
    return ClassRoom.fromMap(classRoom.data());
  }

  Future<void> create(
      {@required String code,
      @required String title,
      String description,
      DateTime dueDate,
      @required int type,
      int marks,
      List<PlatformFile> files}) async {
    var id;
    try {
      await fireStore
          .collection('classes')
          .doc(code)
          .collection('general')
          .add({
        'title': title,
        'description': description,
        'type': type,
        'class code': code,
        'created at': DateTime.now(),
        'marks': marks,
        'due date': dueDate,
        'edited ': false,
        'files': [],
      }).then((value) => id = value.id);
    } catch (e) {
      print(e);
    }
    files.forEach((element) async {
      File file = File(element.path);
      try {
        await fireStore
            .collection('classes')
            .doc(code)
            .collection('general')
            .doc(id)
            .update({
          'files': FieldValue.arrayUnion([element.name])
        });
        await storage.ref(code + "/general/" + element.name).putFile(file);
      } catch (e) {
        print(e);
      }
    });
    if (type == 2) {
      var data = await fireStore.collection('classes').doc(code).get();
      var students = data.data()['students'];
      students.forEach((element) async {
        try {
          await fireStore
              .collection('classes')
              .doc(code)
              .collection('general')
              .doc(id)
              .collection('submission')
              .doc(email)
              .set({
            'status': 'not submitted',
            'files': [],
            'grades': null,
          });
        } catch (e) {
          print(e);
        }
      });
    }
  }

  Future<void> edit(
      {@required String code,
      @required String id,
      @required String title,
      @required int type,
      String description,
      int marks,
      DateTime dueDate,
      List<PlatformFile> files,
      List<String> temp}) async {
    try {
      await fireStore
          .collection('classes')
          .doc(code)
          .collection('general')
          .doc(id)
          .update({
        'title': title,
        'description': description,
        'type': type,
        'files': temp,
        'class code': code,
        'marks': marks,
        'edited ': true,
        'due date': dueDate,
        'created at': DateTime.now(),
      });
    } catch (e) {
      print(e);
    }
    files.forEach((element) async {
      File file = File(element.path);
      try {
        if (temp.contains(element.name)) {
          await storage.ref(code + "/general/" + element.name).putFile(file);
        }
      } catch (e) {
        print(e);
      }
    });
  }

  Future<void> delete({@required String code, @required String id}) async {
    try {
      await fireStore
          .collection('classes')
          .doc(code)
          .collection('general')
          .doc(id)
          .delete();
    } catch (e) {
      print(e);
    }
  }

  Stream<QuerySnapshot> getStudentSubmission(
      {@required String code, @required String id}) {
    var snapshots = fireStore
        .collection('classes')
        .doc(code)
        .collection('general')
        .doc(id)
        .collection('submission')
        .snapshots();
    return snapshots;
  }

  Future<dynamic> getSubmission(
      {@required String code,
      @required String id,
      @required String email}) async {
    var data;
    try {
      data = await fireStore
          .collection('classes')
          .doc(code)
          .collection('general')
          .doc(id)
          .collection('submission')
          .doc(email)
          .get();
    } catch (e) {
      print(e);
    }
    return data;
  }

  Future<void> submitGrade({
    @required String code,
    @required String id,
    @required String email,
    @required int grades,
  }) async {
    try {
      await fireStore
          .collection('classes')
          .doc(code)
          .collection('general')
          .doc(id)
          .collection('submission')
          .doc(email)
          .update({
        'grades': grades,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> submit(
      {@required String code,
      @required String id,
      @required String status,
      @required List<PlatformFile> files,
      @required List<String> temp}) async {
    try {
      await fireStore
          .collection('classes')
          .doc(code)
          .collection('general')
          .doc(id)
          .collection('submission')
          .doc(email)
          .update({
        'created at': DateTime.now(),
        'files': temp,
        'status': status,
      });
    } catch (e) {
      print(e);
    }
    files.forEach((element) async {
      File file = File(element.path);
      try {
        if (temp.contains(element.name)) {
          await storage
              .ref(code + "/general/" + email + "/" + element.name)
              .putFile(file);
        }
      } catch (e) {
        print(e);
      }
    });
  }

  Stream<QuerySnapshot> getSubjectData({@required String code}) {
    var lol = fireStore
        .collection('classes')
        .doc(code)
        .collection('general')
        .orderBy('created at', descending: true)
        .snapshots();
    return lol;
  }

  Future<void> joinClass({@required String code}) async {
    try {
      await fireStore.collection('users').doc(email).update({
        'student of': FieldValue.arrayUnion([code])
      });
      await fireStore.collection('classes').doc(code).update({
        'students': FieldValue.arrayUnion([email])
      });
    } catch (e) {
      print(e);
    }
  }

  Future<DocumentSnapshot> doesClassExist({@required String code}) async {
    return await fireStore.collection('classes').doc(code).get();
  }

  Future<DocumentSnapshot> getUsers({@required String code}) async {
    return await fireStore.collection('users').doc(email).get();
  }
}
