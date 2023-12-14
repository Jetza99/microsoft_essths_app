import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:microsoft_essths_app/models/userapp.dart';
import 'package:microsoft_essths_app/publisher_screen.dart';
import 'models/post.dart';

import 'package:page_transition/page_transition.dart';
import 'colors/colors.dart';

int _selectedIndex = 0;
late String postTitle;
late String postBody;
bool showArticle = false;

Future<dynamic> getUserData() async {
  var db = FirebaseFirestore.instance;
  var currentUserEmail = FirebaseAuth.instance.currentUser?.email;
  final snapshot = await db
      .collection("users")
      .where("Email", isEqualTo: currentUserEmail)
      .get();
  final userData = snapshot.docs.map((e) => UserApp.fromFirestore(e)).single;
  return userData;
}

class NewsFeedScreen extends StatefulWidget {
  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  Future<dynamic> getPosts() async {
    var db = FirebaseFirestore.instance;
    final snapshot = await db.collection("posts").get();
    final postData = snapshot.docs.map((e) => Post.fromFirestore(e)).toList();
    return postData;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    fontFamily: 'Montserrat',
    color: tertiary,
  );

  late final List<Widget> _widgetOptions = <Widget>[
    Padding(
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
          FutureBuilder(
            future: getPosts(),
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: primary,
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
                  List<Post> posts = snapshot.data;
                  return postsList(posts);
                }
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
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
      'Index 3: MLSA',
      style: optionStyle,
    ),
    Text(
      'Index 4: Team',
      style: optionStyle,
    ),
  ];

  Widget postsList(List<Post> posts) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          Navigator.pushReplacementNamed(context, '/Newsfeed');
          await Future.delayed(Duration(seconds: 2));
        },
        child: ListView(
          //itemCount: posts.length,

          children: posts
              .map((post) => Column(
                    children: [
                      ArticleCard(
                        title: post.title,
                        type: post.type,
                        description: post.description,
                        moreInfoPressed: () {
                          setState(() {
                            postTitle = post.title;
                            postBody = post.body;
                            showArticle = true;
                          });
                        },
                      ),
                      SizedBox(height: 20),
                    ],
                  ))
              .toList(),
        ),
      ),
    );
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
                  color: primary,
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
                if (data.author == true) {
                  return FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: PublisherScreen(),
                              type: PageTransitionType.rightToLeft));
                    },
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
        body: showArticle
            ? Article(
                postTitle: postTitle,
                postBody: postBody,
                goBack: () {
                  setState(() {
                    print(showArticle);
                    showArticle = false;
                  });
                },
              )
            : _widgetOptions[_selectedIndex],
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
                  setState(() {
                    showArticle = false;
                  });
                  _onItemTapped(0);
                  // Then close the drawer
                  Navigator.pop(context);
                  setState(() {
                    showArticle = false;
                  });
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
                  setState(() {
                    showArticle = false;
                  });
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
                  setState(() {
                    showArticle = false;
                  });
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
                  setState(() {
                    showArticle = false;
                  });
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
                  setState(() {
                    showArticle = false;
                  });
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
}

class Article extends StatefulWidget {
  final String postTitle;
  final String postBody;
  final VoidCallback goBack;

  const Article({
    super.key,
    required this.postTitle,
    required this.postBody,
    required this.goBack,
  });

  @override
  State<Article> createState() => _ArticleState();
}

class _ArticleState extends State<Article> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.postTitle,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                color: primary,
              ),
            ),
            Divider(),
            Text(
              widget.postBody,
              style: TextStyle(fontSize: 18),
            ),
            FutureBuilder(
              future: getUserData(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: primary,
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
                    if (data.author == true) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton(
                            child: const Text(
                              'Delete',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Lato',
                                color: tertiary,
                              ),
                            ),
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  }
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  child: const Text(
                    'Go Back',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Lato',
                      color: primary,
                    ),
                  ),
                  onPressed: () {
                    widget.goBack();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tertiary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ArticleCard extends StatefulWidget {
  final String title;
  final String type;
  final String description;
  final VoidCallback moreInfoPressed;

  const ArticleCard({
    super.key,
    required this.title,
    required this.type,
    required this.description,
    required this.moreInfoPressed,
  });

  @override
  State<ArticleCard> createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.title,
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
              widget.type,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                fontFamily: 'Montserrat',
                color: secondary,
              ),
            ),
          ],
        ),
        Text(
          widget.description,
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
          onPressed: widget.moreInfoPressed,
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
