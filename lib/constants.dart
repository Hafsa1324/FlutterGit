import 'package:chatapp/homepage.dart';
import 'package:flutter/material.dart';

void nextScreen (context,page){
  Navigator.push(context, MaterialPageRoute(builder: (context)=>page));
}
void nextScreenReplacement (context,page){
  Navigator.push(context, MaterialPageRoute(builder: (context)=>page));
}


void showSnackBar(context, color, message){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message, style: TextStyle(fontSize: 14, color: Colors.white),),
    backgroundColor: color,duration: Duration(seconds: 2),
     action: SnackBarAction(label: 'OK', onPressed: (){},textColor: Colors.white),
    )
  );
}