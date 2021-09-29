import 'package:chat_application/helper/constants.dart';
import 'package:chat_application/services/database.dart';
import 'package:chat_application/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chat.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchTextEditingController= TextEditingController();
  Database db= Database();
  QuerySnapshot? snapshot;

  @override
  void initState(){
    super.initState();
  }

  Widget searchUserList(){
    return snapshot != null ? ListView.builder(
      shrinkWrap: true,
      itemCount: snapshot!.docs.length,
      itemBuilder: (context, index){
        return userTile(
          userEmail: snapshot!.docs[index].get('email'),
          username: snapshot!.docs[index].get('username'),
        );
      },
    ) : Container();
  }

  search(){
    var username= searchTextEditingController.text.trim();
    db.getUserByUsername(username).then((val){
      setState(() {
        snapshot = val;
      });
    });
  }

  createChatRoom(String username){
    List<String> users= [username, currentLoggedInUser];
    String chatRoomId = getChatRoomId(currentLoggedInUser, username);
    Map<String, dynamic> usersMap= {
      "chatroom_id": chatRoomId,
      "users" : users,
    };
    db.createChatRoom(chatRoomId, usersMap);
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) => Conversation(
        chatroomId: chatRoomId,
      )
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0x54FFFFFF),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(child: TextField(
                    controller: searchTextEditingController,
                    style: const TextStyle(
                      color: Colors.white
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Search Username...',
                      hintStyle: TextStyle(
                        color: Colors.white54
                      ),
                      border: InputBorder.none
                    ),
                  )),
                  GestureDetector(
                    onTap: (){
                      search();
                    },
                    child: Container(
                      height: 40,
                        width: 40,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0x36FFFFFF),
                              Color(0x0FFFFFFF),
                            ]
                          ),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Image.asset('assets/images/search_white.png')
                    ),
                  ),
                ],
              ),
            ),
            searchUserList()
          ],
        ),
      ),
    );
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  Widget userTile({required String username, required String userEmail}){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(username, style: const TextStyle(
                  color: Colors.white, fontSize: 16
              ),),
              const SizedBox(height: 6,),
              Text(userEmail, style: const TextStyle(
                  color: Colors.white, fontSize: 16
              ),),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: (){
              createChatRoom(username);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(24)
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: const Text('Message', style: TextStyle(
                  color: Colors.white,
                  fontSize: 17
              ),),
            ),
          ),
        ],
      ),
    );
  }
}


