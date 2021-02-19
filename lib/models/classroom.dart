import 'package:cloud_firestore/cloud_firestore.dart';

class ClassRoom {
  ClassRoom(this.classCode, this.createdBy, this.description, this.shortName,
      this.subject, this.title, this.createdAt, this.students, this.teachers);
  final String classCode;
  final String createdBy;
  final String description;
  final String shortName;
  final String subject;
  final String title;
  final Timestamp createdAt;
  final List<dynamic> students;
  final List<dynamic> teachers;

  factory ClassRoom.fromMap(dynamic json) {
    final String classCode = json['class code'];
    final String createdBy = json['created by'];
    final String description = json['description'];
    final String shortName = json['short name'];
    final String subject = json['subject'];
    final String title = json['title'];
    final Timestamp createdAt = json['created at'];
    final List<dynamic> students = json['students'];
    final List<dynamic> teachers = json['teachers'];
    return ClassRoom(classCode, createdBy, description, shortName, subject,
        title, createdAt, students, teachers);
  }

  Map<String, dynamic> toMap() {
    return {
      'class code': classCode,
      'created by': createdBy,
      'description': description,
      'short name': shortName,
      'subject': subject,
      'title': title,
      'created at': createdAt,
      'students': students,
      'teachers': teachers,
    };
  }
}
