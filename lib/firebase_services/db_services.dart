

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{
  final String? uid;
  DatabaseService({this.uid});
  //reference for our collection
  final CollectionReference userCollection =FirebaseFirestore.instance.collection('users');
  final CollectionReference groupCollection =FirebaseFirestore.instance.collection('groups');



  //saving user data
  Future saveUserData(String email, String fullname)async{
    return await userCollection.doc(uid).set({
      'fullname':fullname,
      'email': email,
      'groups': [],
      'profilepic':'',
      'uid':uid,

    });
}
// getting user data
  Future gettingUserData(String email)async{
    QuerySnapshot snapshot = await userCollection.where('email', isEqualTo: email).get();
    return snapshot;
  }
  //getting user groups
  getUserGroups()async{
    return await userCollection.doc(uid).snapshots();
  }
  //creating a group
  Future createGroup(String userName, String id, String groupName)async{
    DocumentReference groupDocumentReference= await groupCollection.add({
      'groupName': groupName,
      'groupIcon':'',
      'admin':'${id}_$userName',
      'members':[],
      'groupID':'',
      'recentMessage':'',
      'recentMessageSender':'',
    });
    //update the members
    await groupDocumentReference.update({
      'members':FieldValue.arrayUnion(['${id}_$userName']),
      'groupID':groupDocumentReference.id,
    });
    DocumentReference userDocumnentReference = await userCollection.doc(uid);
    return await userDocumnentReference.update({
      'groups':FieldValue.arrayUnion(['${groupDocumentReference.id}_$groupName']),
    });
  }
  //getting chats
  getChats(String groupID) async{
    return groupCollection.doc(groupID).collection('messages').orderBy('time', descending: true).snapshots();
  }
  Future getGroupAdmin(String groupID)async{
    DocumentReference d = groupCollection.doc(groupID);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }
  //getting  group members
  getGroupMembers(groupID)async{
    return groupCollection.doc(groupID).snapshots();
  }
  //search
  searchByName(String groupName){
    return groupCollection.where('groupName', isEqualTo: groupName).get();
  }
  // function bool
  Future<bool> isUserJoined(String groupName, String groupID, String userName)async{
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if(groups.contains("${groupID}_$groupName")){
      return true;
    }else{
      return false;
    }
  }
  //toggling the group join / exit
  Future toggleGroupJoin(String groupID, String groupName, String userName,)async{
    //doc reference
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupID);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    //if the user has our groups , then remove and also in other part rejoin
    if (groups.contains("${groupID}_$groupName")){
      await userDocumentReference.update({
        'groups': FieldValue.arrayRemove(["${groupID}_$groupName"])
      });
      await groupDocumentReference.update({
        'members': FieldValue.arrayRemove(["${uid}_$userName"])
      });
    } else {
      await userDocumentReference.update({
        'groups': FieldValue.arrayUnion(["${groupID}_$groupName"])
      });
      await groupDocumentReference.update({
        'members': FieldValue.arrayUnion(["${uid}_$userName"])
      });
    }
  }
  // send messages
  sendMessages(String groupID, Map<String, dynamic> chatMessageData)async{
    groupCollection.doc(groupID).collection('messages').add(chatMessageData);
    groupCollection.doc(groupID).update({
      'recentMessage':chatMessageData['message'],
      'recentMessageSender': chatMessageData['sender'],
      'recentMessageTime': chatMessageData['time'].toString(),
    });
  }

}