import 'package:chatapp/chat_screen.dart';
import 'package:chatapp/constants.dart';
import 'package:chatapp/db_services.dart';
import 'package:chatapp/helper_fucntions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searcController = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  bool isJoined = false;
  String userName ='';
  User? user;
  @override
  void initState() {
    getCurrentUserIdandName();
    super.initState();
  }
  String getID(String res){
    return res.substring(0,res.indexOf('_'));
  }
  String getName(String r){
    return r.substring(r.indexOf('_')+1);
  }
  getCurrentUserIdandName()async{
    await Helperfunctions.getUsernameFromSF().then((value){
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

  initiateSearchMethod()async{
    if(searcController.text.isNotEmpty){
      setState(() {
        isLoading = true;
      });
      await DatabaseService().searchByName(searcController.text).then((snapshot){
        setState(() {
          searchSnapshot = snapshot;
          isLoading = false;
          hasUserSearched=true;
        });
      });
    }else{

    }
  }
  groupList(){
    return hasUserSearched? ListView.builder(
        shrinkWrap: true,
        itemCount: searchSnapshot!.docs.length,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index){
          return groupTile(
            userName,
            searchSnapshot!.docs[index]['groupID'],
            searchSnapshot!.docs[index]['groupName'],
            searchSnapshot!.docs[index]['admin'],

          );
        }
    ):Container();
  }
  joinedOrNot(String userName, String groupName, String groupID, String admin)async{
    await DatabaseService(uid: user!.uid).isUserJoined(groupName, groupID, userName).then((value) {
      setState(() {
        isJoined = value;
      });
    });
  }

  Widget groupTile(String userName, String groupID, String groupName, String admin,){
    //fucntion to check whether useralready exists in group
    joinedOrNot(userName, groupName, groupID, admin);
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      leading: CircleAvatar(
        radius: 30, backgroundColor: Colors.blue,
        child: Text(groupName.substring(0,1).toUpperCase(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, fontFamily: 'Poppins'),),
      ),
      title: Text(groupName, style: TextStyle(fontWeight: FontWeight.w900, fontFamily: 'Poppins', fontSize: 16),),
      subtitle: Text('Admin: ${getName(admin)}', style: TextStyle(fontFamily: 'Poppins'),),
      trailing: InkWell(
        onTap: ()async{
          await DatabaseService(uid: user!.uid).toggleGroupJoin(groupID, groupName, userName);
          if(isJoined){
            setState(() {
              isJoined =!isJoined;
            });
            showSnackBar(context, Colors.green, 'Successfully Joined');
            Future.delayed(Duration(seconds: 2),(){
              nextScreen(context, ChatScreen(userName: userName, groupID: groupID, groupName: groupName));
            });
          }else{
            setState(() {
              isJoined = !isJoined;
            });
            showSnackBar(context, Colors.red, "Left the group ${groupName}");
          }
        },
        child: isJoined ? Container(
          width: 85,height: 40,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black,
            border: Border.all(color: Colors.white),
          ),
          child: Text('Joined',style: TextStyle(color: Colors.white),),
        ): Container(
          width: 85,height: 40,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black,
            border: Border.all(color: Colors.white),
          ),
          child: Text('Join Now', style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Search', style: TextStyle(fontSize: 27, fontFamily: 'Poppins', fontWeight: FontWeight.w900),),
      centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blue,
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: searcController,
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search Groups ...',
                      hintStyle: TextStyle(color: Colors.white, fontSize: 15),
                      hoverColor: Colors.pink,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    initiateSearchMethod();
                  },
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(Icons.search_outlined, color: Colors.white,),
                  ),
                ),
              ],
            ),
          ),
          isLoading ? Center(child: CircularProgressIndicator(color: Colors.red,),):groupList(),
        ],
      )
    );
  }

}
