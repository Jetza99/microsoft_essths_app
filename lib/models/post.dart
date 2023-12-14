import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  late String title;
  late String description;
  late String type;
  late String body;
  late String authorEmail;

  Post({required this.title, required this.description, required this.type, required this.body, required this.authorEmail});

  factory Post.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Post(
      title: data?['Title'],
      description: data?['Description'],
      type: data?['Type'],
      body: data?['Body'],
      authorEmail: data?['Author Email'],
    );

  }

  Post.fromJson(Map<String, dynamic> json) {
    title = json['Title'];
    description = json['Description'];
    type = json['Type'];
    body = json['Body'];
    authorEmail = json['Author Email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Title'] = this.title;
    data['Description'] = this.description;
    data['Type'] = this.type;
    data['Body'] = this.body;
    data['Author Email'] = this.authorEmail;
    return data;
  }
}
