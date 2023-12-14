import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:microsoft_essths_app/models/post.dart';

import 'colors/colors.dart';

class PublisherScreen extends StatefulWidget {
  const PublisherScreen({super.key});

  @override
  State<PublisherScreen> createState() => _PublisherScreenState();
}

class _PublisherScreenState extends State<PublisherScreen> {
  var currentUserEmail = FirebaseAuth.instance.currentUser?.email;
  var db = FirebaseFirestore.instance;

  String typeInitialValue = "Leagues";
  var typeItems = [
    'Leagues',
    'Departments',
    'MLSA',
    'Events',
  ];

  final titleController = TextEditingController();
  late final typeController = TextEditingController(text: typeInitialValue);
  final descriptionController = TextEditingController();
  final bodyController = TextEditingController();
  late final authorController;

  @override
  void initState() {
    super.initState();
    currentUserEmail = FirebaseAuth.instance.currentUser?.email ?? '';
    authorController = TextEditingController(text: currentUserEmail);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                const Text(
                'Publisher',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                  color: primary,
                ),
              ),
                  Divider(),
                  Text(
                    'Title',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Montserrat',
                      color: primary,
                    ),
                  ),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: tertiary)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: tertiary)
                      ),
                      fillColor: tertiary,
                      filled: true,
                      hintStyle: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w200,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 25,),
                  Text(
                    'Type',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Montserrat',
                      color: primary,
                    ),
                  ),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: tertiary,
                      filled: true
                    ),
                    value: typeInitialValue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: typeItems.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        typeInitialValue = newValue!;
                      });
                    },
                  ),
                  SizedBox(height: 25,),
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Montserrat',
                      color: primary,
                    ),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: tertiary)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: tertiary)
                      ),
                      fillColor: tertiary,
                      filled: true,
                      hintStyle: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w200,
                        fontSize: 16,
                      ),
                    ),
                    minLines: 1,
                    maxLines: 5,
                  ),
                  SizedBox(height: 25,),
                  Text(
                    'Body',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Montserrat',
                      color: primary,
                    ),
                  ),
                  TextField(
                    controller: bodyController,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: tertiary)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: tertiary)
                      ),
                      fillColor: tertiary,
                      filled: true,
                      hintStyle: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w200,
                        fontSize: 16,
                      ),
                    ),
                    maxLines: null,
                  ),
                  SizedBox(height: 25,),
                  ElevatedButton(
                    child: const Text(
                      'Publish',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        color: tertiary,
                      ),
                    ),
                    onPressed: publishPost,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        color: secondary,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: secondary),
                      ),
                    ),
                  ),
                  SizedBox(height: 25,),

          
                ],
                      ),
            ),
                ),
        ),
      ),
    );
  }

  void publishPost() async{
    String title = titleController.text;
    String type = typeController.text;
    String description = descriptionController.text;
    String body = bodyController.text;
    String authorEmail = authorController.text;

    Post post = Post(id: '', title: title, description: description, type: type, body: body, authorEmail: authorEmail);
    await db.collection('posts').add(post.toFirestore());
    Navigator.pop(context);

  }


}
