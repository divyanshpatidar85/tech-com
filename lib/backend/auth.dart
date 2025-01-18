
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  Future<String> signUp(
      {required String email,
      required String password}) async {
    try {
      print("i ma here with my code");
      // final FirebaseAuth _auth = FirebaseAuth.instance;
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
     
      return "success";
    } catch (error) {
      print("i am called once");
      return "some error occured ${error.toString()}";
    }
  }
  Future forgotPassword({required String email})async{
    String res = "some error occure";
     try{
       await _auth.sendPasswordResetEmail(email: email);
       return res='sucess';
     }
     catch(e){
       res =e.toString();
       return res;
     }
  }
  Future logOut()async{
    
    return 'success';
  }

  Future<String> login(
      {required String email,
      required String password}) async {
    try {
      
        await _auth.signInWithEmailAndPassword(
            email:email,
            password: password);
        return "success";
     
     
    } catch (error) {
      return "some error occured ${error.toString()}";
    }
  }
}