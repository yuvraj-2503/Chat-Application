import 'package:chat_application/helper/constants.dart';
import 'package:chat_application/helper/helper_functions.dart';
import 'package:chat_application/screens/signup_screen.dart';
import 'package:chat_application/services/auth.dart';
import 'package:chat_application/services/database.dart';
import 'package:chat_application/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'chat_room.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool isLoading = false;
  Auth auth= Auth();
  Database db= Database();
  final formKey = GlobalKey<FormState>();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  late QuerySnapshot snapshot;

  login() async{
    if(formKey.currentState!.validate()){
      var email = emailTextEditingController.text.trim();
      var password = passwordTextEditingController.text.trim();
      setState(() {
        isLoading = true;
      });
      await auth.signInWithEmailAndPassword(email, password).then((user) async{
        if(user != null){
          HelperFunctions.saveUserLoggedInSharedPreferences(true);
          await db.getUserByUserEmail(email.toString())
          .then((val){
            snapshot = val;
          });
          // print(snapshot);
          HelperFunctions.saveUsernameSharedPreferences(snapshot.docs[0].get('username'));
          HelperFunctions.saveUserEmailSharedPreferences(email);
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) { return const ChatRoom(); }
          ));
        }else{
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) { return const LoginScreen(); }
          ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size= MediaQuery.of(context).size;
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: size.height,
        child: isLoading ? const Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('LOGIN', style: headingTextStyle(),),
              SizedBox(height: size.height * 0.05,),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextFormField(
                        controller: emailTextEditingController,
                        validator: (val){
                          return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val!)
                              ? null : "Please provide a valid email address.";
                        },
                        decoration: textFieldsInputDecoration('Email', Icons.email),
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        onChanged: null,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      width: size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextFormField(
                        controller: passwordTextEditingController,
                        validator: (val){
                          return val!.isEmpty || val.length<6 ? "Please enter 6+ characters." : null;
                        },
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        decoration: textFieldsInputDecoration('Password', Icons.lock),
                        onChanged: null,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: login,
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text('LOGIN', style: simpleButtonStyle()),
                ),
              ),

              SizedBox(height: size.height * 0.03,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account? ', style: TextStyle(
                      color: Colors.white,
                      fontSize: 16
                  ),),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context){return const SignUpScreen();},
                      ));
                    },
                    child: const Text('Sign Up', style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),),
                  )
                ],
              ),
              SizedBox(height: size.height * 0.03,),
            ],
          ),
        ),
        ),
      );
  }
}
