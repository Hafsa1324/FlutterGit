import 'package:chatapp/firebase_services/auth.dart';
import 'package:chatapp/models/constants.dart';
import 'package:chatapp/firebase_services/db_services.dart';
import 'package:chatapp/models/helper_fucntions.dart';
import 'package:chatapp/screens/homepage.dart';
import 'package:chatapp/screens/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';


class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String? email;String?fullname;
  final _formkey = GlobalKey<FormState>();
  String? password;
  bool hidePassword = true;
  bool isLoading=false;
  Auth authSevice=Auth();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              key: _formkey,
              child: isLoading?Center(child: CircularProgressIndicator(color: Colors.red),):SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 50,),
                    Text('Chat App', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25,fontFamily: 'Poppins' ),),
                    Text('Login now to see what they are talking', style: TextStyle(fontSize: 13,fontFamily: 'Poppins' ),),
                    SizedBox(height: 50,),
                    Image.network('https://img.freepik.com/free-vector/group-people-with-speech-bubbles_24877-56560.jpg',fit: BoxFit.cover,),
                    SizedBox(height: 50,),
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email, color: email != null ? Colors.black : Colors.grey, size: 16,),
                        hintText: "Email",hintStyle: TextStyle(fontSize: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(),
                        ),
                        //fillColor: Colors.green
                      ),
                      onChanged: (value)=> setState(()=> email = value),
                      validator: (value){
                        return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value!) ? null : 'Please enter a valid email';
                      },
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      cursorColor: Colors.black,
                      obscureText: hidePassword,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: (){
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                          icon: hidePassword == true ? const Icon(Icons.visibility_off, color: Colors.black,) : const Icon(Icons.visibility, color: Colors.black) ,
                        ),
                        prefixIcon: Icon(Icons.lock, color: password != null ? Colors.black : Colors.grey, size: 16,),
                        hintText: "Password",hintStyle: TextStyle(fontSize: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(),
                        ),
                        //fillColor: Colors.green
                      ),
                      onChanged: (value)=> setState(()=> password = value),
                      validator: (value){
                        return value!.length >= 6 ? null : "Please enter atleast 6 or more charcaters";
                      },
                    ),
                    SizedBox(height: 30,),
                    SizedBox(width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formkey.currentState!.validate()){
                            setState(() {
                              isLoading=true;
                            });
                            await authSevice.signIn(email!,password,context).then((value)async{
                              if(value==true){
                               QuerySnapshot snapshot=  await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                                   .gettingUserData(email!);
                                nextScreenReplacement(context, HomePage());
                                //saving values to SF
                               await Helperfunctions.saveUserLoggedInStatus(true);
                               await Helperfunctions.saveUseremailSF(email!);
                               await Helperfunctions.saveUsernameSF(
                                 snapshot.docs[0]['fullname']
                               );
                              }else{
                                showSnackBar(context, Colors.red, value);
                                setState(() {
                                  isLoading=false;
                                });
                              }
                            });
                          }
                        }, child: Text('LOGIN'),

                      ),
                    ),
                    SizedBox(height: 20,),
                    Text.rich(
                      TextSpan(
                        text: "Don't have an account?",
                        style: TextStyle(color: Colors.black),
                        children:<TextSpan>[
                          TextSpan(
                            text: 'Register here',style: TextStyle(decoration: TextDecoration.underline),
                            recognizer:TapGestureRecognizer()..onTap=(){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp()));
                            },),
                        ]
                      )
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}