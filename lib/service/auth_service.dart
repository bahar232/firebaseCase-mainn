import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  final authInstance = FirebaseAuth.instance;

  Future<void> signIn(String email, int password)async{
    await authInstance.signInWithEmailAndPassword(email: email, password: password.toString());
  }
  
  Future<void> signUp(String email, int password)async{
    await authInstance.createUserWithEmailAndPassword(email: email, password: password.toString());
  }

  Future<void> signOut()async{
   await authInstance.signOut();
  }

}