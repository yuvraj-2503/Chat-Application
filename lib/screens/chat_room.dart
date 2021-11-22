import 'package:chat_application/helper/authenticate.dart';
import 'package:chat_application/helper/constants.dart';
import 'package:chat_application/screens/chat.dart';
import 'package:chat_application/screens/login_screen.dart';
import 'package:chat_application/screens/search.dart';
import 'package:chat_application/services/auth.dart';
import 'package:chat_application/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Auth auth= Auth();
  Database db= Database();
  Stream<QuerySnapshot>? chatRooms;

  @override
  void initState() {
    getCurrentLoggedInUser();
    super.initState();
  }

  getChatRooms() async{
    await db.getChatRooms(currentLoggedInUser!.displayName).then((value) {
      setState(() {
        chatRooms = value;
      });
    });
    print(chatRooms);
  }

  Widget chatList(){
    return StreamBuilder<QuerySnapshot>(
      stream: chatRooms,
      builder: (context, snapshot){
        return (snapshot.hasData && snapshot.data != null) ?
        ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index){
            return ChatRoomTile(
              username: snapshot.data!.docs[index].get("chatroom_id")
              .toString().replaceAll(currentLoggedInUser!.displayName.toString(), "").replaceAll("_", ""),
              chatRoomId: snapshot.data!.docs[index].get("chatroom_id"),
            );
          },
        ) : Container();
      },
    );
  }

  getCurrentLoggedInUser() async{
    currentLoggedInUser = await FirebaseAuth.instance.currentUser;
    print(currentLoggedInUser);
    getChatRooms();
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
                  builder: (context) => LoginScreen()
              ));
            },
            child: Container(
                child: const Icon(Icons.exit_to_app,),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          )
        ],
      ),
      body: chatList(),
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

class ChatRoomTile extends StatelessWidget {
  final String username;
  final String chatRoomId;
  const ChatRoomTile({required this.chatRoomId , required this.username,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => Conversation(
            chatroomId: chatRoomId,
          )
        ));
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black26,
          border: Border.all(color: Colors.white54)
        ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.blue
              ),
              child: Text('${username.substring(0,1).toUpperCase()}', style: TextStyle(
                color: Colors.white
              ),),
            ),
            SizedBox(width: 16,),
            Text(username, style: TextStyle(
              color: Colors.white,
              fontSize: 17
            ),)
          ],
        ),
      ),
    );
  }
}
