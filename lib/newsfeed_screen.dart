import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:microsoft_essths_app/models/userapp.dart';
import 'models/post.dart';

import 'package:page_transition/page_transition.dart';
import 'colors/colors.dart';
import 'main.dart';



class NewsFeedScreen extends StatefulWidget {
  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {

  var currentUserEmail = FirebaseAuth.instance.currentUser?.email;

  Future<dynamic> getUserData() async{
    var db = FirebaseFirestore.instance;
    final snapshot = await db.collection("users").where("Email", isEqualTo: currentUserEmail).get();
    final userData = snapshot.docs.map((e) => UserApp.fromFirestore(e)).single;
    return userData;

  }

  Future<dynamic> getPosts() async{
    var db = FirebaseFirestore.instance;
    final snapshot = await db.collection("posts").get();
    final postData = snapshot.docs.map((e) => Post.fromFirestore(e)).toList();
    return postData;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  int _selectedIndex = 0;

  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    fontFamily: 'Montserrat',
    color: tertiary,
  );

  final List<Widget> _widgetOptions = <Widget>[
    SizedBox.expand(
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'News',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                color: primary,
              ),
            ),
            Divider(),
            StreamBuilder(
                stream: FirebaseFirestore.instance.collection('Posts').snapshots(),
                builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text(
                        'No Data...',
                      );
                }else{
                      var items = snapshot.data?.docs;
                      return ArticleCard(title: items?[0]["Title"]);
                    }
  },
            ),
            //ArticleCard(title: 'hello',),

          ],
        ),
      ),
    ),
    Text(
      'Index 1: Departments',
      style: optionStyle,
    ),
    Text(
      'Index 2: Leagues',
      style: optionStyle,
    ),
    Text(
      'Index 2: MLSA',
      style: optionStyle,
    ),
    Text(
      'Index 2: Team',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FutureBuilder(
          future: getUserData(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.deepPurpleAccent,
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'An ${snapshot.error} occurred',
                    style: const TextStyle(fontSize: 18, color: Colors.red),
                  ),
                );
              } else if (snapshot.hasData) {
                final data = snapshot.data;
                if(data.author == true){
                  return FloatingActionButton(
                    onPressed: (){},
                    backgroundColor: primary,
                    child: Icon(Icons.add, color: tertiary),
                  );
                }

              }
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: primary,
          title: Image.asset(
            'assets/logos/horizontal_white.png',
            fit: BoxFit.cover,
            scale: 20,
          ),
        ),
        body: Center(
          child: _widgetOptions[_selectedIndex],
        ),
        drawer: Drawer(
          backgroundColor: primary,
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.fromLTRB(15, 50, 0, 0),
            children: [
              ListTile(
                title: const Text(
                  'Home',
                  style: optionStyle,
                ),
                selected: _selectedIndex == 0,
                onTap: () {
                  // Update the state of the app
                  _onItemTapped(0);
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text(
                  'Departments',
                  style: optionStyle,
                ),
                selected: _selectedIndex == 1,
                onTap: () {
                  // Update the state of the app
                  _onItemTapped(1);
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text(
                  'Leagues',
                  style: optionStyle,
                ),
                selected: _selectedIndex == 2,
                onTap: () {
                  // Update the state of the app
                  _onItemTapped(2);
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text(
                  'MLSA',
                  style: optionStyle,
                ),
                selected: _selectedIndex == 2,
                onTap: () {
                  // Update the state of the app
                  _onItemTapped(3);
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text(
                  'Team',
                  style: optionStyle,
                ),
                selected: _selectedIndex == 2,
                onTap: () {
                  // Update the state of the app
                  _onItemTapped(4);
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              SizedBox(
                height: 300,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: GestureDetector(
                  child: Text(
                    'Sign Out',
                    style: TextStyle(
                        color: tertiary.withOpacity(0.5), fontSize: 20.0),
                  ),
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (route) => false);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getWidgetByRole() {



  }
}

class ArticleCard extends StatelessWidget {
  final String title;
  const ArticleCard({
    super.key,
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat',
                color: primary,
              ),
            ),
            SizedBox(width: 15),
            Icon(
              Icons.circle,
              color: secondary,
              size: 10,
            ),
            SizedBox(width: 5),
            Text(
              'Type',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                fontFamily: 'Montserrat',
                color: secondary,
              ),
            ),
          ],
        ),
        const Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut accumsan urna in dui feugiat maximus.',
          style: TextStyle(
            fontFamily: 'Lato',
            fontWeight: FontWeight.w200,
            fontSize: 16,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        ElevatedButton.icon(
          label: const Text(
            'More Info',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              fontFamily: 'Montserrat',
              color: tertiary,
            ),
          ),
          icon: const Icon(
            Icons.arrow_forward_sharp,
            color: tertiary,
          ),
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
        ),
      ],
    );
  }
}
