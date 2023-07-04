import 'package:flutter/material.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sentByMe;
  MessageTile({Key? key, required this.message, required this.sender, required this.sentByMe}) : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 4, top: 4, left: widget.sentByMe?24:20, right: widget.sentByMe? 20:24),
      alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: widget.sentByMe ? EdgeInsets.only(left: 30) : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
          borderRadius: widget.sentByMe ? BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ): BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
          color: widget.sentByMe ? Colors.blue : Colors.grey.shade600,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start ,
          children: [
            Text(widget.sender.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white,letterSpacing: -0.5,
                fontFamily: 'Poppins', fontSize: 13, fontWeight: FontWeight.w900),),
            SizedBox(height: 8,),
            Text(widget.message, textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Poppins', fontSize: 16, color: Colors.white),),
          ],
        ),
      ),
    );
  }
}
