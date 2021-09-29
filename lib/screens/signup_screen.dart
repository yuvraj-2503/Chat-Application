import 'package:chat_application/helper/constants.dart';
import 'package:chat_application/helper/helper_functions.dart';
import 'package:chat_application/screens/chat_room.dart';
import 'package:chat_application/services/auth.dart';
import 'package:chat_application/services/database.dart';
import 'package:chat_application/widgets/widget.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  final Function toggleView;
  const SignUpScreen (this.toggleView ,{Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  bool isLoading = false;
  Auth auth= Auth();
  Database database= Database();
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  signUp(){
    if(formKey.currentState!.validate()){
      var username = usernameTextEditingController.text.trim();
      var email = emailTextEditingController.text.trim();
      var password = passwordTextEditingController.text.trim();
      Map<String, String> userData= {
        "username" : username,
        "email" : email
      };

      setState(() {
        isLoading = true;
      });
      auth.signUpWithEmailAndPassword(email, password).then((user) {
        // print("${user.userId}");
        if(user!=null){
          database.saveUserData(userData);
          HelperFunctions.saveUserLoggedInSharedPreferences(true);
          HelperFunctions.saveUsernameSharedPreferences(username);
          HelperFunctions.saveUserEmailSharedPreferences(email);
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) { return const ChatRoom(); }
          ));
        }else{
          setState(() {
            isLoading = false;
          });
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
              Text(
                'SIGN UP', style: headingTextStyle(),
              ),
              SizedBox(height: size.height * 0.03,),
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
                        validator: (val){
                          return val!.isEmpty || val.length<4 ?
                          "Username should be of min 4 characters." : null;
                        },
                        controller: usernameTextEditingController,
                        decoration: textFieldsInputDecoration('Username', Icons.person),
                        keyboardType: TextInputType.text,
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
                        validator: (val){
                          return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val!)
                              ? null : "Please provide a valid email address.";
                        },
                        controller: emailTextEditingController,
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
                        validator: (val){
                          return val!.isEmpty || val.length<6 ? "Password should be of min 6 characters." : null;
                        },
                        controller: passwordTextEditingController,
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
                onTap: signUp,
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text('SIGN UP', style: simpleButtonStyle()),
                ),
              ),
              SizedBox(height: size.height * 0.03,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account? ', style: TextStyle(
                      color: Colors.white,
                      fontSize: 16
                  ),),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) => LoginScreen(widget.toggleView)
                      ));
                    },
                    child: const Text('Login', style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
