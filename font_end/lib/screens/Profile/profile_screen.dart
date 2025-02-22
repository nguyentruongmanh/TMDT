import 'package:e_commerce_project/authentication/log_in_screen.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final int userID;
  const ProfileScreen({super.key, required this.userID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      body: Center(
        child: TextButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Login_Screen()));
          }, 
          child: Text(
            'Log out'
          ),
        ),
      )
    );
  }
}