import 'package:firebase_auth/firebase_auth.dart';

import 'global/common/toast.dart';

class UserManager {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }on FirebaseAuthException catch (e){
      if(e.code == 'email-already-in-use'){
        showToast(message: 'This email is already in-use!');

      }else if (e.code == 'weak-password'){
        showToast(message: 'Password must be 8 characters minimum');
      }else{
        showToast(message: 'An error occurred: ${e.code}');
      }
    }
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }on FirebaseAuthException catch (e){
      if(e.code == 'invalid-credential'){
        showToast(message: 'Invalid email or password.');

      }else{
        showToast(message: 'An error occurred: ${e.code}');
      }
    }
  }

}