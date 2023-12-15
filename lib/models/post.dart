import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class Post {
  late String id;
  late String title;
  late String description;
  late String type;
  late String body;
  late String authorEmail;

  Post({String? id,
    required this.title,
    required this.description,
    required this.type,
    required this.body,
    required this.authorEmail}): id = id ?? Uuid().v4();

  factory Post.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Post(
      id: snapshot.id,
      title: data?['Title'],
      description: data?['Description'],
      type: data?['Type'],
      body: data?['Body'],
      authorEmail: data?['Author Email'],
    );

  }

  Post.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    title = json['Title'];
    description = json['Description'];
    type = json['Type'];
    body = json['Body'];
    authorEmail = json['Author Email'];
  }

  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Title'] = this.title;
    data['Description'] = this.description;
    data['Type'] = this.type;
    data['Body'] = this.body;
    data['Author Email'] = this.authorEmail;
    return data;
  }
}
