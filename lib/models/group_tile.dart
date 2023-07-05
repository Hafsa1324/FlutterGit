import 'package:chatapp/screens/chat_screen.dart';
import 'package:chatapp/models/constants.dart';
import 'package:flutter/material.dart';


class GroupTile extends StatefulWidget {
  final String userName;
  final String groupID;
  final String groupName;
  GroupTile({Key? key, required this.userName, required this.groupID, required this.groupName}) : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        nextScreen(context, ChatScreen(userName: widget.userName, groupID: widget.groupID, groupName: widget.groupName,));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey.shade700, radius: 30,
            child: Text(widget.groupName.substring(0,1).toUpperCase(), textAlign: TextAlign.center,),
          ),
          title: Text(widget.groupName, style: TextStyle(fontWeight: FontWeight.w900, fontFamily: 'Poppins', fontSize: 16),),
          subtitle: Text('Join the conversation as ${widget.userName}'),
        ),
      ),
    );
  }
}
