import 'package:chatapp/constants.dart';
import 'package:chatapp/db_services.dart';
import 'package:chatapp/group_info.dart';
import 'package:chatapp/message_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String userName;
  final String groupID;
  final String groupName;
  ChatScreen({Key? key, required this.userName, required this.groupID, required this.groupName}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Stream<QuerySnapshot>? chats;
  String admin='';
  TextEditingController messageController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getChatAndAdmin();
  }

  getChatAndAdmin()async {
    await DatabaseService().getChats(widget.groupID).then((val){
      setState(() {
        chats = val;
      });
    });
    await DatabaseService().getGroupAdmin(widget.groupID).then((val){
      setState(() {
        admin = val;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0, centerTitle: true,
        title: Text(widget.groupName),
        actions: [
          IconButton(onPressed: (){
            nextScreen(context, GroupInfo(groupName: widget.groupName, groupID: widget.groupID, adminName: admin,

            ));
          }, icon: Icon(Icons.info_outline)),
        ],
      ),
      body: Stack(
        children: [
          //chat messages here
           Padding(
             padding: EdgeInsets.only(bottom: 100),
             child: chatMessages(),
           ),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
              color: Colors.grey.shade700,
              child: Row(
                children: [
                  Expanded(child: TextFormField(

                    controller:messageController ,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Send a message..........',
                      hintStyle: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Poppins',),
                      border: InputBorder.none,
                    ),
                  )),
                  SizedBox(width: 12,),
                  GestureDetector(
                    onTap: (){
                      sendMessages();
                    },
                    child: Container(
                      height: 50, width: 50,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(child: Icon(Icons.send, color: Colors.white,),),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  chatMessages(){
    return StreamBuilder(
        builder: (context, AsyncSnapshot snapshot){
          return snapshot.hasData? ListView.builder(
              itemCount: snapshot.data.docs.length, reverse: true,
              itemBuilder: (context, index){
                return MessageTile(message: snapshot.data.docs[index]['message'],
                    sender: snapshot.data.docs[index]['sender'],
                    sentByMe: widget.userName == snapshot.data.docs[index]['sender']);
              })
              : Container();
        },
      stream: chats,

    );
  }
  sendMessages() async {
    if(messageController.text.isNotEmpty){
      Map<String, dynamic> chatMessageMap = {
        'message' : messageController.text,
        'sender': widget.userName,
        'time': DateTime.now().millisecondsSinceEpoch
      };
      await DatabaseService().sendMessages(widget.groupID, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }
}
