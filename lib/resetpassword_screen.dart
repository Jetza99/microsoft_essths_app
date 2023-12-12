import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:microsoft_essths_app/main.dart';
import 'package:microsoft_essths_app/user_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:page_transition/page_transition.dart';
import 'colors/colors.dart';
import 'global/common/toast.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}


class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    //emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: primary,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Container(
              margin: EdgeInsets.fromLTRB(35, 100, 0, 0),
              width: 139,
              height: 32,
              child: Image(
                image: AssetImage('assets/logos/horizontal_white.png'),
                fit: BoxFit.contain,
              ),
            ),
            Container(

              margin:  EdgeInsets.fromLTRB(35, 70, 35, 0),
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
                  helperText: 'Enter your email to receive a password reset link',
                  helperStyle: TextStyle(color: Colors.white),
                ),
              ),
                  SizedBox(height: 35),
                  ElevatedButton(
                    child: Text(
                      'Reset Password',
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
                    onPressed: ResetPassword,
                  ),
              ],
            ),
            ),
          ],
        ),
    );
  }
  void ResetPassword() async{
    String email = emailController.text;

    try{

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
      showToast(message: 'Check your email.');
      Navigator.pop(context);

    } on FirebaseAuthException catch(e){
      showToast(message: '${e.code}');
    }



  }
}
