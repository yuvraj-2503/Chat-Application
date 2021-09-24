import 'package:chat_application/helper/constants.dart';
import 'package:chat_application/helper/helper_functions.dart';
import 'package:chat_application/screens/chat_room.dart';
import 'package:chat_application/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  init();
  runApp(const MyApp());
}

void init() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? userIsLoggedIn;

  @override
  initState(){
    getLoggedInUser();
    super.initState();
  }

  getLoggedInUser() async{
    await HelperFunctions.getUserLoggedInSharedPreferences().then((value) {
      setState(() {
        userIsLoggedIn = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Let\'s Connect',
      theme: ThemeData(
        primaryColor: primaryColor,
        scaffoldBackgroundColor: scaffoldBackground,
      ),
      home: userIsLoggedIn != null ? (userIsLoggedIn! ? const ChatRoom() : const WelcomeScreen())
        : const WelcomeScreen(),
    );
  }
}