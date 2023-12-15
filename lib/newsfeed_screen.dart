import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/material.dart';
import 'package:microsoft_essths_app/models/userapp.dart';
import 'package:microsoft_essths_app/publisher_screen.dart';
import 'models/post.dart';

import 'package:page_transition/page_transition.dart';
import 'colors/colors.dart';

var db = FirebaseFirestore.instance;

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
  bool showArticle = false;
  late String postTitle;
  late String postBody;
  late String postId;
  late String postType;
  int _selectedIndex = 0;

  Future<dynamic> getPosts() async {
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
    Departments(),
    Leagues(),
    Mlsa(),
    Team(),
  ];

  Widget postsList(List<Post> posts) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          Navigator.pushReplacementNamed(context, '/Newsfeed');
          await Future.delayed(Duration(seconds: 2));
        },
        child: ListView(
          children: posts
              .map((post) => Column(
                    children: [
                      ArticleCard(
                        title: post.title,
                        type: post.type,
                        description: post.description,
                        moreInfoPressed: () {
                          setState(() {
                            postId = post.id;
                            postTitle = post.title;
                            postBody = post.body;
                            postType = post.type;
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
                postType: postType,
                postId: postId,
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
              Spacer(),
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

class Team extends StatelessWidget {
  const Team({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0),
      child: ListView(children: [
        const Text(
          'Team',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
            color: primary,
          ),
        ),
        Divider(),
        const Text(
          'Meet the Team:',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.normal,
            fontFamily: 'Lato',
            color: msBlue,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          child: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(10),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://scontent.ftun8-1.fna.fbcdn.net/v/t39.30808-6/345628900_1888966228127648_3648097638243199547_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=efb6e6&_nc_ohc=40mBQdzYcoAAX-YfThn&_nc_ht=scontent.ftun8-1.fna&oh=00_AfCWTeCvXCsSBSDgOxYlkWI9iF0bEnvHZ2eX8CH8hlZTgA&oe=6581CEEE'

                      ),
                      radius: 50,
                    ),
                    Text(
                      'Yosr Jdly',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato',
                        color: primary,
                      ),
                    ),
                    Text(
                      'President',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Lato',
                        color: primary,
                      ),
                    ),
                  ],
                ),
              ), //Yosr
              Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://scontent.ftun8-1.fna.fbcdn.net/v/t39.30808-6/408169508_1837177520065024_1242789714455100880_n.jpg?_nc_cat=101&ccb=1-7&_nc_sid=efb6e6&_nc_ohc=9rMI_w3AYd4AX_YqYWj&_nc_ht=scontent.ftun8-1.fna&oh=00_AfCXgwuoK5OG87ZDfoqE9u8gbjzEvuuaUxzihVU-v5yt7Q&oe=65823D50'
                      ),
                      radius: 50,
                    ),
                    Text(
                      'Oumaima Hizaoui',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato',
                        color: primary,
                      ),
                    ),
                    Text(
                      'Vice President',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Lato',
                        color: primary,
                      ),
                    ),
                  ],
                ),
              ), //Hizaoui
              Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://scontent.ftun8-1.fna.fbcdn.net/v/t39.30808-6/377760792_686384276741969_5810005707900876775_n.jpg?_nc_cat=111&ccb=1-7&_nc_sid=efb6e6&_nc_ohc=ZVMIgiInnkAAX8Gfdtg&_nc_ht=scontent.ftun8-1.fna&oh=00_AfASl7p8EL5Jj0oe72SU37TfKDT41mbUKarpc4lmMjsxTA&oe=6581F08D'
                      ),
                      radius: 50,
                    ),
                    Text(
                      'Ferdaws Hamrouni',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato',
                        color: primary,
                      ),
                    ),
                    Text(
                      'General Secretary',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Lato',
                        color: primary,
                      ),
                    ),
                  ],
                ),
              ), //Ferdaws
              Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://scontent.ftun8-1.fna.fbcdn.net/v/t39.30808-1/243153534_2978274052491033_605849107930222494_n.jpg?stp=dst-jpg_p320x320&_nc_cat=110&ccb=1-7&_nc_sid=5740b7&_nc_ohc=zNgzxeIotvkAX_W8Pyr&_nc_ht=scontent.ftun8-1.fna&oh=00_AfCNSM0vWykOJlRFwvHuxrzbkUnBUta_qywEatVrmNkB4g&oe=65820030'
                      ),
                      radius: 50,
                    ),
                    Text(
                      'Rayen Balghouthi',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato',
                        color: primary,
                      ),
                    ),
                    Text(
                      'HR Manager',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Lato',
                        color: primary,
                      ),
                    ),
                  ],
                ),
              ), //Rayen
              Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://scontent.ftun8-1.fna.fbcdn.net/v/t39.30808-6/274982274_1642189432800678_6446763987152434127_n.jpg?_nc_cat=102&ccb=1-7&_nc_sid=efb6e6&_nc_ohc=aS8QvzvNsXAAX8k0ggf&_nc_ht=scontent.ftun8-1.fna&oh=00_AfBgsVQ-Na4AsJsAKX80glUTcEj_h_f65-yN_2AHwpRDgw&oe=658182D3'
                      ),
                      radius: 50,
                    ),
                    Text(
                      'Med Khalil Khalfallah',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato',
                        color: primary,
                      ),
                    ),
                    Text(
                      'Marketing Manager',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Lato',
                        color: primary,
                      ),
                    ),
                  ],
                ),
              ), //Khalil
              Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://scontent.ftun8-1.fna.fbcdn.net/v/t39.30808-1/279029557_1581637255543937_2969994156134004323_n.jpg?stp=dst-jpg_s320x320&_nc_cat=102&ccb=1-7&_nc_sid=5740b7&_nc_ohc=Ntcub3nyYh8AX8hGqoN&_nc_ht=scontent.ftun8-1.fna&oh=00_AfAeEVAQdF-v8ngSRr1R2KUk9XP3sh3NWDEakxheDO5lhg&oe=6581E198'
                      ),
                      radius: 50,
                    ),
                    Text(
                      'Med Ikbel Kassem',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato',
                        color: primary,
                      ),
                    ),
                    Text(
                      'Sponsoring Manager',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Lato',
                        color: primary,
                      ),
                    ),
                  ],
                ),
              ), //Ikbel
              Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://scontent.ftun8-1.fna.fbcdn.net/v/t1.6435-1/163397651_1153265001772964_2203600689214149693_n.jpg?stp=dst-jpg_p320x320&_nc_cat=110&ccb=1-7&_nc_sid=2b6aad&_nc_ohc=erXI33Zc1AQAX-1nXMA&_nc_ht=scontent.ftun8-1.fna&oh=00_AfAT3DXQJzwT6ZhQzT4x-nuPexDfmfgDTCCy1xLK9h0dPw&oe=65A3EB34'
                      ),
                      radius: 50,
                    ),
                    Text(
                      'Omar Lammouchi',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato',
                        color: primary,
                      ),
                    ),
                    Text(
                      'Logistics Manager',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Lato',
                        color: primary,
                      ),
                    ),
                  ],
                ),
              ), //Omar
              Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        'https://scontent.ftun8-1.fna.fbcdn.net/v/t39.30808-6/274524322_3119029734977734_6056299590349882380_n.jpg?_nc_cat=110&ccb=1-7&_nc_sid=efb6e6&_nc_ohc=PvQfY25XNqAAX-f6U_M&_nc_ht=scontent.ftun8-1.fna&oh=00_AfCJu53kwmQTNtgWVsnCLsL-v9OA4K6ccrWOYfh-VJ7LiA&oe=65809920'
                      ),
                      radius: 50,
                    ),
                    Text(
                      'Khalil Othmani',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lato',
                        color: primary,
                      ),
                    ),
                    Text(
                      'Finance Manager',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Lato',
                        color: primary,
                      ),
                    ),
                  ],
                ),
              ), //khalilFinance
            ],
          ),
        )
      ]),
    );
  }
}

class Mlsa extends StatelessWidget {
  const Mlsa({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0),
      child: ListView(children: [
        const Text(
          'Microsoft Learn Student Ambassadors',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
            color: primary,
          ),
        ),
        Divider(),
        const Text(
          'Become a Student Ambassador',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.normal,
            fontFamily: 'Lato',
            color: msBlue,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        const Text(
          'Join Microsoft\'s global community of students who are passionate about building AI-driven solutions with Microsoft technology. Accelerate innovation and grow the skills you need to have greater impact in the projects and communities that matter to you.',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            fontFamily: 'Lato',
            color: primary,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Image(
          image: AssetImage('assets/img/mlsa_p.png'),
          height: 180,
        ),
        SizedBox(
          height: 10,
        ),
        Center(
          child: Text(
            'Omar Marnissi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Lato',
              color: primary,
            ),
          ),
        ),
        Center(
          child: Text(
            'Beta MLSA (ESSTHS)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.normal,
              fontFamily: 'Lato',
              color: primary,
            ),
          ),
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF0077d3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            onPressed: () async {
              String urlString =
                  'https://mvp.microsoft.com/en-US/studentambassadors/profile/05f353e6-69e5-44c0-9907-569820c82147';
              Uri uri = Uri.parse(urlString);
              print(uri);
              try {
                await launchUrl(uri);
              } catch (e) {
                throw e;
              }
            },
            child: Text(
              'Check Our Registered Events',
              style: TextStyle(
                fontFamily: 'Lato',
                fontWeight: FontWeight.bold,
                color: tertiary,
                fontSize: 16,
              ),
            )),
      ]),
    );
  }
}

class Leagues extends StatelessWidget {
  const Leagues({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0),
      child: ListView(children: [
        const Text(
          'Leagues',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
            color: primary,
          ),
        ),
        Divider(),
        const Text(
          'Welcome to the Club Leagues, where passion meets purpose, and like-minded individuals come together to explore, excel, and elevate their skills and interests. Each league is a vibrant community, offering a unique space for enthusiasts to connect, collaborate, and make a mark in their chosen fields.',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            fontFamily: 'Lato',
            color: primary,
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Card(
          color: msOrange,
          child: ExpansionTile(
            iconColor: tertiary,
            initiallyExpanded: true,
            title: Text(
              'I.T League: Tech Wizards Unite!',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat',
                color: tertiary,
              ),
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DIVE INTO THE DIGITAL REALM IN OUR IT LEAGUE',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                        color: tertiary,
                      ),
                    ),
                    Text(
                      'Elevate your digital prowess and join fellow enthusiasts on this excitingjourneythrough organizing events and meeting field experts',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: tertiary,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tertiary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onPressed: () async {
                          String urlString = 'http://tiny.cc/m9mivz';
                          Uri uri = Uri.parse(urlString);
                          print(uri);
                          try {
                            await launchUrl(uri);
                          } catch (e) {
                            throw e;
                          }
                        },
                        child: Text(
                          'Join Us',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                            color: msOrange,
                            fontSize: 16,
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
        Card(
          color: msGreen,
          child: ExpansionTile(
            iconColor: tertiary,
            title: Text(
              'Social Impact League: Make Change Not Noise!',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat',
                color: tertiary,
              ),
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'COLLABORATE, DRIVE CHANGE, AND CREATE A BETTER WORLD',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                        color: tertiary,
                      ),
                    ),
                    Text(
                      'Join forces for a better world in our Social I mpact League. Make a real ndifference through community action.',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: tertiary,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tertiary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onPressed: () async {
                          String urlString = 'http://tiny.cc/m9mivz';
                          Uri uri = Uri.parse(urlString);
                          print(uri);
                          try {
                            await launchUrl(uri);
                          } catch (e) {
                            throw e;
                          }
                        },
                        child: Text(
                          'Join Us',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                            color: msGreen,
                            fontSize: 16,
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
        Card(
          color: msBlue,
          child: ExpansionTile(
            iconColor: tertiary,
            title: Text(
              'Entrepreneurship League: Grow and Thrive',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat',
                color: tertiary,
              ),
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CRAFT YOUR FUTURE, HUSTLE HARD!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                        color: tertiary,
                      ),
                    ),
                    Text(
                      'Empower yourself in our Self Dev & Entrepreneurship League. Learn, grow, and launch your dreams into reality.',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: tertiary,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tertiary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onPressed: () async {
                          String urlString = 'http://tiny.cc/m9mivz';
                          Uri uri = Uri.parse(urlString);
                          print(uri);
                          try {
                            await launchUrl(uri);
                          } catch (e) {
                            throw e;
                          }
                        },
                        child: Text(
                          'Join Us',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                            color: msBlue,
                            fontSize: 16,
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
        Card(
          color: msYellow,
          child: ExpansionTile(
            iconColor: tertiary,
            title: Text(
              'Talent League: Unleash Your Inner Star!',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat',
                color: tertiary,
              ),
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'IT\'S YOUR STAGE TO DAZZLE AND INSPIRE.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                        color: tertiary,
                      ),
                    ),
                    Text(
                      'Shine in our Talent League. From music to arts, showcase your skills and let your creativity light up the stage.',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: tertiary,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tertiary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onPressed: () async {
                          String urlString = 'http://tiny.cc/m9mivz';
                          Uri uri = Uri.parse(urlString);
                          print(uri);
                          try {
                            await launchUrl(uri);
                          } catch (e) {
                            throw e;
                          }
                        },
                        child: Text(
                          'Join Us',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                            color: msYellow,
                            fontSize: 16,
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

class Departments extends StatelessWidget {
  const Departments({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0),
      child: ListView(children: [
        const Text(
          'Departments',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
            color: primary,
          ),
        ),
        Divider(),
        const Text(
          'Are you fascinated by the limitless possibilities of technology? Are you ready to embark on an exciting journey into the realms of innovation and creativity? Look no further! Our vibrant community is thrilled to welcome you into three dynamic departments:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            fontFamily: 'Lato',
            color: primary,
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Card(
          color: primary,
          child: ExpansionTile(
            iconColor: tertiary,
            initiallyExpanded: true,
            title: Text(
              'Artificial Intelligence Dept.',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat',
                color: tertiary,
              ),
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Introduction:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                        color: tertiary,
                      ),
                    ),
                    Text(
                      'Unlock the magic of AI with our beginner-friendly course! Learn the ABCs of Artificial Intelligence, from robots to chatbots. No tech guru required, just curiosity and a pinch of code.',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w200,
                        fontSize: 16,
                        color: tertiary,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Instructor: Yosr Jdly',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                        color: tertiary,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tertiary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onPressed: () async {
                          String urlString = 'https://tiny.cc/vrlivz';
                          Uri uri = Uri.parse(urlString);
                          print(uri);
                          try {
                            await launchUrl(uri);
                          } catch (e) {
                            throw e;
                          }
                        },
                        child: Text(
                          'Join Us',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                            color: primary,
                            fontSize: 16,
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
        Card(
          color: primary,
          child: ExpansionTile(
            iconColor: tertiary,
            title: Text(
              'UI/UX Design Dept.',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat',
                color: tertiary,
              ),
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Introduction:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                        color: tertiary,
                      ),
                    ),
                    Text(
                      'Unearth the magic of user interfaces and experiences in our beginner-friendly course. From buttons to empathy, craft designs that make users smile. Let\'s dive in!',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w200,
                        fontSize: 16,
                        color: tertiary,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Instructor: Ikbel Kassem',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                        color: tertiary,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tertiary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onPressed: () async {
                          String urlString = 'https://tiny.cc/vrlivz';
                          Uri uri = Uri.parse(urlString);
                          print(uri);
                          try {
                            await launchUrl(uri);
                          } catch (e) {
                            throw e;
                          }
                        },
                        child: Text(
                          'Join Us',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                            color: primary,
                            fontSize: 16,
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
        Card(
          color: primary,
          child: ExpansionTile(
            iconColor: tertiary,
            title: Text(
              'Web Development Dept.',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                fontFamily: 'Montserrat',
                color: tertiary,
              ),
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Introduction:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                        color: tertiary,
                      ),
                    ),
                    Text(
                      'beginner-friendly Web Our Development course is your passport to the digital world. From HTML basics to interactive websites, we\'ll guide you, step by step. Let\'s code!',
                      style: TextStyle(
                        fontFamily: 'Lato',
                        fontWeight: FontWeight.w200,
                        fontSize: 16,
                        color: tertiary,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Instructor: Koussay Jebali',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                        color: tertiary,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tertiary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        onPressed: () async {
                          String urlString = 'https://tiny.cc/vrlivz';
                          Uri uri = Uri.parse(urlString);
                          print(uri);
                          try {
                            await launchUrl(uri);
                          } catch (e) {
                            throw e;
                          }
                        },
                        child: Text(
                          'Join Us',
                          style: TextStyle(
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.bold,
                            color: primary,
                            fontSize: 16,
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

class Article extends StatefulWidget {
  final String postTitle;
  final String postBody;
  final String postId;
  final String postType;
  final VoidCallback goBack;

  const Article({
    super.key,
    required this.postTitle,
    required this.postBody,
    required this.postId,
    required this.goBack,
    required this.postType,
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
            Text(
              widget.postType,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
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
                            onPressed: () {
                              print(widget.postId);
                              deletePost(widget.postId);
                            },
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

  Future deletePost(postId) async {
    try {
      db.collection('posts').doc(postId).delete();
      Navigator.pushReplacementNamed(context, '/Newsfeed');
    } catch (e) {
      print(e);
    }
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
            Expanded(
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Montserrat',
                  color: primary,
                ),
              ),
            ),
            SizedBox(width: 15),
            Icon(
              Icons.circle,
              color: widget.type == 'Departments'
                  ? msOrange
                  : widget.type == 'Leagues'
                      ? msGreen
                      : widget.type == 'MLSA'
                          ? msBlue
                          : widget.type == 'Team'
                              ? msYellow
                              : primary,
              size: 10,
            ),
            SizedBox(width: 5),
            Text(
              widget.type,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                fontFamily: 'Montserrat',
                color: widget.type == 'Departments'
                    ? msOrange
                    : widget.type == 'Leagues'
                        ? msGreen
                        : widget.type == 'MLSA'
                            ? msBlue
                            : widget.type == 'Team'
                                ? msYellow
                                : primary,
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
