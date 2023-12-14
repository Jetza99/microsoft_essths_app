import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:microsoft_essths_app/firebase_options.dart';
import 'package:microsoft_essths_app/newsfeed_screen.dart';


import 'signup_screen.dart';
import 'signin_screen.dart';

import 'colors/colors.dart';

import 'package:page_transition/page_transition.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0x2D2D2D),
          primary: Color(0x3D96FF),
          secondary: Color(0xE8E8E8),
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {'/Newsfeed': (context) => NewsFeedScreen()},
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _incrementCounter() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(35, 50, 0, 0),
                width: 139,
                height: 32,
                child: Image(
                  image: AssetImage('assets/logos/horizontal_white.png'),
                  fit: BoxFit.contain,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(35, 70, 0, 0),
                child: Text(
                  'Welcome to our official club App!'.toUpperCase(),
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(35, 15, 0, 0),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                  child: Text(
                    'Please log in to stay connected with the vibrant community of tech enthusiasts at ESSTHS.',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: 'Lato',
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 100, 0, 0),
                  child: ElevatedButton(
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Lato',
                          fontSize: 26,
                          fontWeight: FontWeight.bold),
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(secondary),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                        ),
                        fixedSize: MaterialStateProperty.all(Size(320, 55))),
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: SignUpScreen(),
                              type: PageTransitionType.rightToLeft));
                    },
                  ),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: ElevatedButton(
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                          color: secondary,
                          fontFamily: 'Lato',
                          fontSize: 26,
                          fontWeight: FontWeight.bold),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                        ),
                        fixedSize: MaterialStateProperty.all(Size(320, 55))),
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: SignInScreen(),
                              type: PageTransitionType.rightToLeft));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
