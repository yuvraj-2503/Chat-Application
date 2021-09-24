import 'package:chat_application/helper/constants.dart';
import 'package:flutter/material.dart';

TextStyle headingTextStyle(){
  return const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.white
  );
}

AppBar appBarMain(BuildContext context){
  return AppBar(
    title: Image.asset('assets/images/logo.png' , height: 50,),
    elevation: 0,
  );
}

TextStyle simpleButtonStyle(){
  return const TextStyle(
    fontSize: 18,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );
}

InputDecoration textFieldsInputDecoration(String hint, IconData icon){
  return InputDecoration(
    hintText: hint,
    icon: Icon(icon, color: primaryColor,),
    hintStyle: const TextStyle(
      color: primaryColor
    ),
    border: InputBorder.none
  );
}