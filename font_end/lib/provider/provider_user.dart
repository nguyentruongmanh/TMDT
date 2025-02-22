import 'package:flutter/material.dart';

class ProviderUser extends ChangeNotifier {
  int _userID = 0;
  String _username = '';
  String _useremail = '';
  String _password = '';
  String? otp;
  String get getuserName => _username;
  String get getuserEmail => _useremail;
  String get getuserPassword => _password;
  int get getuserID =>_userID;


  void setUser(String userName, String password, String email, String otp1) {
    _username = userName;
    _useremail = email;
    _password = password;
    otp = otp1;
    notifyListeners();
  }
  void setEmail(String email){
    _useremail = email;
    notifyListeners(); 
  }
  bool verifyOtp(String enteredOtp) {
    return otp == enteredOtp;
  }
   void setuserID(int userID){
    _userID = userID;
    notifyListeners();
  }
}