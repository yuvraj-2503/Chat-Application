import 'package:chat_application/helper/constants.dart';
import 'package:chat_application/services/database.dart';
import 'package:chat_application/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Conversation extends StatefulWidget {
  final String chatroomId;
  const Conversation({required this.chatroomId, Key? key}) : super(key: key);

  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<Conversation> {

  Database db= Database();
  TextEditingController sendTextEditingController= TextEditingController();
  Stream<QuerySnapshot>? chatMessagesStream;
  Widget chatMessageList(){
    return StreamBuilder<QuerySnapshot>(
      stream: chatMessagesStream,
      builder: (context, snapshot){
        return (snapshot.hasData && snapshot.data != null) ? ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index){
            return MessageTile(
              message: snapshot.data!.docs[index].get("message"),
              isSentByMe: snapshot.data!.docs[index].get("sentBy")== currentLoggedInUser!.displayName,
            );
          },
        ) : Container();
      },
    );
  }

  sendMessage(){
    if(sendTextEditingController.text.isNotEmpty){
      Map<String, dynamic> messageMap= {
        "message": sendTextEditingController.text.trim(),
        "sentBy": currentLoggedInUser!.displayName,
        "timestamp": DateTime.now().millisecondsSinceEpoch,
      };
      db.sendMessages(widget.chatroomId, messageMap);
      sendTextEditingController.text = "";
    }
  }

  @override
  void initState() {
    getChatMessages();
    super.initState();
  }

  getChatMessages() async{
    await db.getChatMessages(widget.chatroomId).then((value) {
      setState(() {
        chatMessagesStream= value;
      });
      print(chatMessagesStream);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Stack(
        children: [
          chatMessageList(),
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0x54FFFFFF),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(child: TextField(
                    controller: sendTextEditingController,
                    style: const TextStyle(
                        color: Colors.white
                    ),
                    decoration: const InputDecoration(
                        hintText: 'Type your message here..',
                        hintStyle: TextStyle(
                            color: Colors.white54
                        ),
                        border: InputBorder.none
                    ),
                  )),
                  GestureDetector(
                    onTap: (){
                      sendMessage();
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
                        child: Image.asset('assets/images/send.png')
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSentByMe;
  const MessageTile({ required this.message , required this.isSentByMe , Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: isSentByMe ? 0 : 24, right: isSentByMe ? 24 : 0),
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(vertical: 8),
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSentByMe ? [
              const Color(0xff007EF4),
              const Color(0xff2A75BC),
            ] : [
              const Color(0x1AFFFFFF),
              const Color(0x1AFFFFFF),
            ],
          ),
        borderRadius: isSentByMe ? 
          BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
            bottomLeft: Radius.circular(23)
          ) : BorderRadius.only(
            topLeft: Radius.circular(23),
            topRight: Radius.circular(23),
            bottomRight: Radius.circular(23)
        ),
        ),
        child: Text(message, style: TextStyle(
          color: Colors.white,
          fontSize: 17
        ),),
      ),
    );
  }
}

