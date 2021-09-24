import 'package:cloud_firestore/cloud_firestore.dart';

class Database{
  final FirebaseFirestore _database= FirebaseFirestore.instance;
  Future getUserByUsername(String username) async{
    return await _database.collection('users')
        .where('username', isEqualTo: username).get();
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
}