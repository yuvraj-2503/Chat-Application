// import 'package:chat_application/helper/constants.dart';
// import 'package:chat_application/screens/signup_screen.dart';
// import 'package:chat_application/widgets/widget.dart';
// import 'package:flutter/material.dart';
//
// import 'login_screen.dart';
//
// class WelcomeScreen extends StatelessWidget {
//   const WelcomeScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       body: Container(
//         alignment: Alignment.center,
//         height: size.height,
//         width: double.infinity,
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'WELCOME',
//                 style: headingTextStyle(),
//               ),
//               SizedBox(height: size.height * 0.03,),
//               SizedBox(height: size.height * 0.05,),
//               GestureDetector(
//                 onTap: (){
//                   Navigator.push(context, MaterialPageRoute(builder: (context){
//                     return const LoginScreen();
//                   }));
//                 },
//                 child: Container(
//                   alignment: Alignment.center,
//                   width: size.width,
//                   padding: const EdgeInsets.symmetric(vertical: 20),
//                   margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
//                   decoration: BoxDecoration(
//                     color: primaryColor,
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   child: Text('LOGIN', style: simpleButtonStyle(),),
//                 ),
//               ),
//
//               GestureDetector(
//                 onTap: (){
//                   Navigator.push(context, MaterialPageRoute(builder: (context){
//                     return const SignUpScreen();
//                   }));
//                 },
//                 child: Container(
//                   alignment: Alignment.center,
//                   width: size.width,
//                   padding: const EdgeInsets.symmetric(vertical: 20),
//                   margin: EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: size.height * 0.02),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   child: const Text('SIGN UP', style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: primaryColor
//                   ),),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
