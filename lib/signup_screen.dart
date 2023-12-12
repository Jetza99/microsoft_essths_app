import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:microsoft_essths_app/global/common/toast.dart';
import 'models/userapp.dart';
import 'package:page_transition/page_transition.dart';

import 'user_manager.dart';
import 'newsfeed_screen.dart';

import 'colors/colors.dart';

class SignUpScreen extends StatefulWidget {



  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  var db = FirebaseFirestore.instance;

  bool _passwordVisible = true;

  final UserManager _auth = UserManager();

  bool isSigningUp = false;

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        backgroundColor: primary,
      body: SingleChildScrollView(
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
                Form(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(35, 70, 35, 0),
                    child:  Column(
                      children: [
                         TextField(
                          controller: fullNameController,
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
                          hintText: 'Full Name',
                          hintStyle: TextStyle(
                            fontFamily: 'Lato',
                            fontWeight: FontWeight.w200,
                            fontSize: 16,
                          ),
                        ),

                ),
                        SizedBox(height: 25),
                         TextField(
                          controller: emailController,
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
                            hintText: 'Email Address',
                            hintStyle: TextStyle(
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w200,
                              fontSize: 16,
                            ),
                          ),

                        ),
                        SizedBox(height: 25),
                         TextField(
                           controller: passwordController,
                           obscureText: _passwordVisible,
                           enableSuggestions: false,
                           autocorrect: false,
                          decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(color: tertiary)
                            ),
                            enabledBorder: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(color: tertiary)
                            ),
                            fillColor: tertiary,
                            filled: true,
                            hintText: 'Password',
                            hintStyle: const TextStyle(
                              fontFamily: 'Lato',
                              fontWeight: FontWeight.w200,
                              fontSize: 16,
                              color: primary
                            ),

                            suffixIcon: IconButton(
                              icon: const Icon(
                                  Icons.remove_red_eye_sharp,
                                  color: primary,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;


                                });
                            },

                            ),
                            helperText: 'Enter a minimum 8 character password',
                            helperStyle: TextStyle(
                              color: tertiary
                            ),
                          ),


                        ),
                        SizedBox(height: 35),
                        ElevatedButton(
                          child: isSigningUp ? CircularProgressIndicator(color: Colors.white): Text(
                            'Sign Up',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Lato',
                                fontSize: 26,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(secondary),
                              shape: MaterialStateProperty.all(
                                const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5.0)
                                    )
                                ),
                              ),
                              fixedSize: MaterialStateProperty.all(Size(320, 55))
                          ),
                          onPressed: signUp,
                        ),
                        SizedBox(height: 35),
                         Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Flexible(
                              flex: 3,
                                child: Divider(
                                  color: tertiary,
                                  thickness: 1,
                                )
                            ),
                            Flexible(
                                flex: 1,
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: const Text(
                                      'or',
                                    style: TextStyle(
                                      color: tertiary
                                    ),

                                  ),
                                )
                            ),
                            const Flexible(
                                flex: 3,
                                child: Divider(
                                  color: tertiary,
                                  thickness: 1,

                                )
                            ),
                          ],
                        ),
                        SizedBox(height: 15.0),
                        ElevatedButton.icon(
                          icon: Icon(
                            Icons.facebook,
                            color: Colors.white,
                            size: 35.0,
                          ),
                          label: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'Sign Up With Facebook',
                                      style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Lato',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold
                                      ),
                                  softWrap: false,
                                  ),
                                ),

                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Color(0xFF0966FF)),
                              shape: MaterialStateProperty.all(
                                const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5.0)
                                    )
                                ),
                              ),
                              fixedSize: MaterialStateProperty.all(Size(320, 55))
                          ),

                          onPressed: (){
                          },
                        ),
                        SizedBox(height: 10.0),
                        ElevatedButton.icon(
                          icon: Icon(
                            Icons.android_rounded,
                            color: primary,
                            size: 35.0,
                          ),
                          label: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Sign Up With Google',
                              style: TextStyle(
                                  color: primary,
                                  fontFamily: 'Lato',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                              ),
                              softWrap: false,
                            ),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.white),
                              shape: MaterialStateProperty.all(
                                const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5.0)
                                    )
                                ),
                              ),
                              fixedSize: MaterialStateProperty.all(Size(320, 55))
                          ),

                          onPressed: (){
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ),
      ),
    );
  }

  void signUp() async {
    setState(() {
      isSigningUp = true;
    });
    String fullName = fullNameController.text;
    String email = emailController.text;
    String password = passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    setState(() {
      isSigningUp = false;
    });


    if(user != null){
      user!.sendEmailVerification();
      showToast(message: 'Please check your email for verification');

      UserApp userApp = UserApp(email: email, author: false);
      db.collection("users").add(userApp.toFirestore()).then((DocumentReference doc) => print('DocumentSnapshot added with ID: ${doc.id}'));

      Navigator.pop(context);

    }else{
      print('error');
    }

  }

}
