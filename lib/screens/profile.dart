import 'package:chatapp/firebase_services/auth.dart';
import 'package:chatapp/models/constants.dart';
import 'package:chatapp/screens/homepage.dart';
import 'package:chatapp/screens/signin.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  String? username;
  String? email;
  Profile({Key? key, required this.email, required this.username}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Auth authSevice=Auth();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(fontWeight: FontWeight.w900, fontFamily: 'Poppins', fontSize: 27),),
        elevation: 0, centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 50),
          children: [
            Icon(Icons.account_circle, size: 150,color: Colors.grey.shade700,),
            SizedBox(height: 15,),
            Text(widget.username!, textAlign: TextAlign.center,style: TextStyle(fontSize: 16, fontFamily: 'Poppins', fontWeight: FontWeight.w900, color: Colors.black),),
            SizedBox(height: 30,),
            Divider(
              height: 2,
            ),
            ListTile(
              onTap: (){
                nextScreen(context, HomePage());
              },
              selectedColor: Colors.blue,
              selected: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Icon(Icons.group),
              title: Text('Groups', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontFamily: 'Poppins', fontSize: 14),),
            ),
            ListTile(
              onTap: (){},
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Icon(Icons.group),
              title: Text('Profile', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontFamily: 'Poppins', fontSize: 14),),
            ),
            ListTile(
              onTap: ()async{
                showDialog(
                    barrierDismissible: false,
                    context: context, builder: (context){
                  return AlertDialog(
                    title: Text('Logout'),
                    content: Text('Are you sure you want to logout?'),
                    actions: [
                      IconButton(onPressed: (){
                        Navigator.pop(context);
                      },
                        icon: Icon(Icons.cancel, color: Colors.red,),
                      ),
                      IconButton(onPressed: ()async{
                        await authSevice.signOut();
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>SignIn()), (route) => false);
                      },
                        icon: Icon(Icons.done, color: Colors.green,),
                      )
                    ],
                  );
                });

              },
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontFamily: 'Poppins', fontSize: 14),),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 40, right: 40, top: 70),
        child: Column(
         // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_circle, size: 200, color: Colors.grey,),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Full Name', style: TextStyle(fontSize: 14, fontFamily: 'Poppins'),),
                    Text(widget.username!, style: TextStyle(fontFamily: 'Poppins', fontSize: 14),)
                  ],
                ),
                Divider(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Email', style: TextStyle(fontSize: 14, fontFamily: 'Poppins'),),
                    Text(widget.email!, style: TextStyle(fontFamily: 'Poppins', fontSize: 14),)
                  ],
                ),
          ],
        ),
      )
    );
  }
}
