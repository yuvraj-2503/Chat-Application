import 'package:chat_application/helper/constants.dart';
import 'package:chat_application/helper/helper_functions.dart';
import 'package:chat_application/screens/search.dart';
import 'package:chat_application/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Auth auth= Auth();

  @override
  void initState() {
    getCurrentLoggedInUser();
    super.initState();
  }

  getCurrentLoggedInUser() async{
    currentLoggedInUser = await HelperFunctions.getUsernameSharedPreferences();
    print(currentLoggedInUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/logo.png', height: 50,),
        centerTitle: false,
        elevation: 0,
        actions: [
          GestureDetector(
            onTap: (){
              auth.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) { return const LoginScreen(); }
              ));
            },
            child: Container(
                child: const Icon(Icons.exit_to_app,),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
              builder: (context) { return const SearchScreen(); }
          ));
        },
        child: const Icon(Icons.search),
        backgroundColor: primaryColor,
      ),
    );
  }
}
