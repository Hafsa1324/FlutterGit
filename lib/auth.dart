import 'package:chatapp/db_services.dart';
import 'package:chatapp/helper_fucntions.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Auth{
  Future signIn(String email, password, context)async{
    try{
      User user=(await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)).user!;
      if(user!=null){
        return true;
      }
    }on FirebaseAuthException catch(e){
      return e.message;
    }
  }
  Future signUp(String fullname, email, password, context)async{
    try{
      User user=(await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password)).user!;
      if(user!=null){
        //but before we call our database services
        await DatabaseService(uid: user.uid).saveUserData(email, fullname);
        return true;
      }
    }on FirebaseAuthException catch(e){
      return e.message;
    }
  }
  Future signOut()async{
    try{
      await Helperfunctions.saveUserLoggedInStatus(false);
      await Helperfunctions.saveUsernameSF('');
      await Helperfunctions.saveUseremailSF('');
      await FirebaseAuth.instance.signOut();
    }catch(e){
      return null;
    }
  }
  }
