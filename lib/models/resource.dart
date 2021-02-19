import 'package:cloud_firestore/cloud_firestore.dart';

class Resource {
  Resource(this.classCode, this.description, this.title, this.createdAt,
      this.editedAt, this.files, this.type, this.edited, this.dueDate);
  final String classCode;
  final String title;
  final String description;
  final Timestamp createdAt;
  final Timestamp editedAt;
  final Timestamp dueDate;
  final List<dynamic> files;
  final int type;
  final bool edited;

  factory Resource.fromMap(dynamic json) {
    final String classCode = json['class code'];
    final String title = json['title'];
    final String description = json['description'];
    final Timestamp createdAt = json['created at'];
    final Timestamp editedAt = json['edited at'];
    final Timestamp dueDate = json['due date'];
    final List<dynamic> files = json['files'];
    final int type = json['type'];
    final bool edited = json['edited'];
    return Resource(classCode, description, title, createdAt, editedAt, files,
        type, edited, dueDate);
  }

  Map<String, dynamic> toMap() {
    return {
      'class code': classCode,
      'title': title,
      'description': description,
      'created at': createdAt,
      'edited at': editedAt,
      'files': files,
      'edited': edited,
      'type': type,
      'due date': dueDate,
    };
  }
}
