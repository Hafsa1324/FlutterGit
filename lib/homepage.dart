import 'package:chatapp/auth.dart';
import 'package:chatapp/constants.dart';
import 'package:chatapp/db_services.dart';
import 'package:chatapp/group_tile.dart';
import 'package:chatapp/helper_fucntions.dart';
import 'package:chatapp/profile.dart';
import 'package:chatapp/search_page.dart';
import 'package:chatapp/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 Auth authSevice=Auth();
  String? username;
  String? email ='';
  Stream? groups;
  bool isLoading=false;
  String groupName='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingUserData();
  }
//string  manipulation
  String getID(String res){
    return res.substring(0,res.indexOf('_'));
  }
  String getName(String res){
    return res.substring(res.indexOf('_')+1);
  }

  gettingUserData()async{
    await Helperfunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email=value;
      });
    });
    await Helperfunctions.getUsernameFromSF().then((val) {
      setState(() {
        username=val;
      });
      print('---------');
      print(username);
    });
    // getting the list of snapshot
    await DatabaseService(uid:FirebaseAuth.instance.currentUser!.uid).getUserGroups().then((snapshot){
      setState(() {
        groups=snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Groups', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w900, fontFamily: 'Poppins'),),
      elevation: 0, centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            nextScreenReplacement(context, SearchPage());
          }, icon:Icon(Icons.search_outlined))
        ],
      ),
      drawer: Drawer(
         child: ListView(
           padding: EdgeInsets.symmetric(vertical: 50),
           children: [
             Icon(Icons.account_circle, size: 150,color: Colors.grey.shade700,),
             SizedBox(height: 15,),
             Text(username ?? 'kjk', textAlign: TextAlign.center,style: TextStyle(fontSize: 16, fontFamily: 'Poppins',
                 fontWeight: FontWeight.w900, color: Colors.black),),
             SizedBox(height: 30,),
             Divider(
               height: 2,
             ),
             ListTile(
               onTap: (){},
               selectedColor: Colors.blue,
               selected: true,
               contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
               leading: Icon(Icons.group),
               title: Text('Groups', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontFamily: 'Poppins', fontSize: 14),),
             ),
             ListTile(
               onTap: (){
                 nextScreenReplacement(context, Profile(username: username, email: email,));
               },
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
      body: groupList(),
      floatingActionButton: FloatingActionButton(elevation: 0,
        child: Icon(Icons.add, color: Colors.white,size: 30,),
        onPressed: (){
          popUpDialog(context);
        },
      ),
    );
  }

  popUpDialog(BuildContext context){
    showDialog(
        barrierDismissible: false,
        context: context, builder: (context){
      return StatefulBuilder(
        builder: ((context, setState){
          return AlertDialog(
            title: Text('Create a Group',textAlign: TextAlign.left,),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                isLoading == true? Center(child: CircularProgressIndicator(color: Colors.red,),):
                TextField(
                  onChanged: (val){
                    setState(() {
                      groupName=val;
                    });
                  },
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius: BorderRadius.circular(20),
                      )

                  ),
                ),
              ],
            ),
            actions: [
              ElevatedButton(onPressed: (){
                Navigator.pop(context);
              },
                  style: ElevatedButton.styleFrom(foregroundColor: Colors.red, backgroundColor: Colors.blue.withOpacity(0.5),elevation: 0),
                  child: Text('Cancel')),
              ElevatedButton(onPressed: ()async{
                if(groupName!=''){
                  setState(() {
                    isLoading=false;
                  });
                  Navigator.pop(context);
                  showSnackBar(context, Colors.green, 'Group Created Successfully');
                  DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                      .createGroup(username!, FirebaseAuth.instance.currentUser!.uid, groupName).whenComplete(() {
                    isLoading=false;
                  });
                }
              },
                  style: ElevatedButton.styleFrom(foregroundColor: Colors.red, backgroundColor: Colors.blue.withOpacity(0.5),elevation: 0),
                  child: Text('Create')),
            ],
          );
        }),
      );
    });
  }

  groupList(){
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot){
        //make some checks
        if(snapshot.hasData){
          if(snapshot.data['groups']!= null){
            if(snapshot.data['groups'].length!=0){
              return ListView.builder(
                itemCount: snapshot.data['groups'].length,
                itemBuilder: (context, index){
                  int reverseIndex=snapshot.data['groups'].length-index-1;
                  return GroupTile(
                      userName: snapshot.data['fullname'], groupID: getID(snapshot.data['groups'][reverseIndex]), groupName:getName(snapshot.data['groups'][reverseIndex]));
                },
              );
            }else{
              return noGroupWidget();
            }
          }else{
            return noGroupWidget();
          }
        }else{
          return Center(
            child: CircularProgressIndicator(color: Colors.red,),
          );
        }
      },
    );
  }
  
  noGroupWidget(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
              onTap: (){
                popUpDialog(context);
              },
              child: Icon(Icons.add_circle_outline, color:Colors.grey[700],size: 75,)),
          SizedBox(height: 20,),
          Text("You've not joined any groups, tap on the add icon to create a group or also search from top button",textAlign: TextAlign.center,)
        ],
      ),
    );
  }
}
