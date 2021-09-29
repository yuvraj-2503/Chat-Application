import 'package:chat_application/helper/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Database{
  final FirebaseFirestore _database= FirebaseFirestore.instance;
  Future getUserByUsername(String username) async{
    return await _database.collection('users')
        .where('username', isEqualTo: username, isNotEqualTo: currentLoggedInUser).get();
  }

  Future getUserByUserEmail(String userEmail) async{
    return await _database.collection('users')
        .where('email', isEqualTo: userEmail).get();
  }

  Future saveUserData(userData) async{
    await _database.collection('users').add(userData);
  }

  Future createChatRoom(String chatroomId, usersMap) async{
    await FirebaseFirestore.instance.collection('chatrooms')
        .doc(chatroomId).set(usersMap);
  }

  Future sendMessages(String chatroomId, messageMap) async{
    await FirebaseFirestore.instance.collection('chatrooms')
        .doc(chatroomId)
        .collection('chats')
        .add(messageMap);
  }

  Future getChatMessages(String chatroomId) async{
    var snapshot= await FirebaseFirestore.instance.collection('chatrooms')
        .doc(chatroomId)
        .collection('chats')
    .orderBy("timestamp", descending: false)
        .snapshots();
    return snapshot;
  }

  Future getChatRooms(String username) async{
    return await FirebaseFirestore.instance.collection('chatrooms')
        .where('users', arrayContains: username)
        .snapshots();
  }
}