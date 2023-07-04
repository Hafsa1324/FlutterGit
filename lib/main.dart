import 'package:chatapp/helper_fucntions.dart';
import 'package:chatapp/homepage.dart';
import 'package:chatapp/signin.dart';
import 'package:chatapp/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isSignedIn=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLoggedInStatus();
  }
  getUserLoggedInStatus()async{
    await Helperfunctions.getUserLoggedInStatus().then((value){
      if(value!=null){
       setState(() {
         isSignedIn=value;
       });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: isSignedIn?HomePage():SignIn(),
    );
  }
}


