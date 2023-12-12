import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:microsoft_essths_app/global/common/toast.dart';
import 'package:microsoft_essths_app/resetpassword_screen.dart';
import 'package:microsoft_essths_app/user_manager.dart';
import 'package:page_transition/page_transition.dart';

import 'colors/colors.dart';
import 'newsfeed_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _passwordVisible = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isSigning = false;

  UserManager _auth = UserManager();

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
                    child: Column(
                      children: [
                         TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(color: tertiary)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(color: tertiary)),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(color: tertiary)),
                            enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                borderSide: BorderSide(color: tertiary)),
                            fillColor: tertiary,
                            filled: true,
                            hintText: 'Password',
                            hintStyle: const TextStyle(
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w200,
                                fontSize: 16,
                                color: primary),
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
                          ),
                        ),
                        SizedBox(height: 35),
                        ElevatedButton(
                          child: isSigning ? CircularProgressIndicator(color: Colors.white,): Text(
                            'Sign In',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Lato',
                                fontSize: 26,
                                fontWeight: FontWeight.bold),
                          ),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(secondary),
                              shape: MaterialStateProperty.all(
                                const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0))),
                              ),
                              fixedSize:
                                  MaterialStateProperty.all(Size(320, 55))),
                          onPressed: SignIn,
                        ),
                        SizedBox(height: 20),
                        GestureDetector(
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontSize: 15,
                              color: secondary,
                            ),
                          ),
                          onTap: (){
                            Navigator.push
                              (context,
                                PageTransition(child: ResetPasswordScreen(),
                                    type: PageTransitionType.leftToRight));
                          },
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
                              'Sign In With Facebook',
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
                              'Sign In With Google',
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
  void SignIn() async {
    setState(() {
      isSigning = true;
    });

    String email = emailController.text;
    String password = passwordController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);

    setState(() {
      isSigning = false;
    });

      if(user!.emailVerified){
        Navigator.push(
            context,
            PageTransition(
                child: NewsFeedScreen(),
                type: PageTransitionType.rightToLeft));
      }else{
        showToast(message: 'Please verify your email');
      }


  }
}
