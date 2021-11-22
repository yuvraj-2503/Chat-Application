import 'package:chat_application/screens/chat_room.dart';
import 'package:chat_application/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authenticate{
  User? user;

  Widget? getLoggedInUser(BuildContext context){
    user = FirebaseAuth.instance.currentUser;

    if(user != null){
      return const ChatRoom();
    }else{
      return const LoginScreen();
    }
  }
}