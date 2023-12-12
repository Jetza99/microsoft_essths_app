import 'package:cloud_firestore/cloud_firestore.dart';

class UserApp {
  String? email;
  bool? author;

  UserApp({this.email, this.author});

  factory UserApp.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return UserApp(
      email: data?["Email"],
      author: data?["Author"]
    );
  }

  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Email'] = this.email;
    data['Author'] = this.author;
    return data;
  }
}
