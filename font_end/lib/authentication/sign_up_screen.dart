import 'dart:math';

import 'package:e_commerce_project/SQLite/fuction_data.dart';
import 'package:e_commerce_project/authentication/log_in_screen.dart';
import 'package:e_commerce_project/authentication/Verify_otp/verify_signup_screen.dart';
import 'package:e_commerce_project/authentication/Verify_otp/verify_otp.dart';
import 'package:e_commerce_project/constants.dart';
import 'package:e_commerce_project/provider/provider_user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}
final dbHelper = DatabaseHelper();
  final email = TextEditingController();
  final username = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  bool pwisVisible = false;
  bool cfisVisible = false;

  final formKey = GlobalKey<FormState>();
  String? emailError;
  String? cfpasswordError;
  String? usernameError;
  String? passwordError;
  final db = DatabaseHelper();
  String otp1 = generateOTP();

class _SignUpScreenState extends State<SignUpScreen> {
  Future<void> sendOTP() async {
    int? userID = await dbHelper.getUserIDByEmail(email.text);

    if (userID == null) {
      // Nếu email chưa được đăng ký
      setState(() {
        emailError = 'This email is not registered';
      });
    } else {
      // Nếu email đã được đăng ký
      String otp1 = generateOTP();
      
      // Gửi OTP đến email
      await sendOTPEmail(email.text, otp1);

      // Cập nhật mã OTP trong cơ sở dữ liệu
      await dbHelper.updateOTP(email.text, otp1);

      print("OTP sent successfully to userID: $userID");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin:EdgeInsets.fromLTRB(0, 0, 235, 0),
                    child: Image.asset("lib/images/logo.png", width: 100),
                  ),
                  ListTile(
                    title: Text(
                      "Register New Account",
                      style: GoogleFonts.nunito(fontSize: 40, fontWeight: FontWeight.w900)
                    ),
                  ),
                  //Gmail Field
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 3.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: Offset(3, 3),
                              )
                            ],
                          ),
                          child: TextFormField(
                            controller: email,
                            decoration: InputDecoration(
                              icon: const Icon(Icons.mail_rounded, size: 25),
                              border: InputBorder.none,
                              hintText: "Your email",
                              hintStyle: GoogleFonts.nunito(fontSize: 16),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                setState(() {
                                  emailError = 'Email is required';
                                });
                                return null; // Trả về lỗi
                              }
                              if (!value.endsWith('@gmail.com')) {
                                setState(() {
                                  emailError = 'Invalid email';
                                });
                                return null; // Trả về lỗi
                              }
                              setState(() {
                                emailError = null;
                              });
                              return null; // Không có lỗi
                            },
                          ),
                        ),
                        if (emailError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              emailError!,
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                color: Colors.red, // Màu chữ đỏ
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  SizedBox(height: 7),
                  //Username
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 3.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: Offset(3, 3),
                              )
                            ],
                          ),
                          child: TextFormField(
                            controller: username,
                            decoration: InputDecoration(
                              icon: const Icon(Icons.person, size: 25),
                              border: InputBorder.none,
                              hintText: "Username",
                              hintStyle: GoogleFonts.nunito(fontSize: 16),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                setState(() {
                                  usernameError = 'Username is required';
                                });
                                return null; // Trả về lỗi
                              }
                              setState(() {
                                usernameError = null;
                              });
                              return null; // Không có lỗi
                            },
                          ),
                        ),
                        if (usernameError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              usernameError!,
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                color: Colors.red, // Màu chữ đỏ
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 7),
                  //Password Field
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 3.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: const Color.fromARGB(255, 255, 255, 255),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: Offset(3, 3),
                              )
                            ],
                          ),
                          child: TextFormField(
                            controller: password,
                            obscureText: !pwisVisible,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical:12.0),
                              icon: const Icon(Icons.lock_person_rounded, size: 25),
                              border: InputBorder.none,
                              hintText: "Password",
                              hintStyle: GoogleFonts.nunito(fontSize: 16),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    pwisVisible = !pwisVisible;
                                  });
                                },
                                icon: Icon(pwisVisible ? Icons.visibility : Icons.visibility_off),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                setState(() {
                                  passwordError = 'Password is required';
                                });
                                return null;
                              }
                              if (password.text.isNotEmpty && confirmPassword.text.isNotEmpty && password.text != confirmPassword.text){
                                setState(() {
                                  passwordError = "Passwords don't match";
                                });
                                return null;
                              }
                              setState(() {
                                passwordError = null;
                              });
                              return null;
                            },
                          ),
                        ),
                        if (passwordError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              passwordError!,
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                color: Colors.red, // Màu chữ đỏ
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  SizedBox(height: 7),
                  //Confirm Passwword
                  Container(
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 3.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: const Color.fromARGB(255, 255, 255, 255),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: Offset(3, 3),
                              )
                            ],
                          ),
                          child: TextFormField(
                            controller: confirmPassword,
                            obscureText: !cfisVisible,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical:12.0),
                              icon: const Icon(Icons.check_circle_rounded, size: 23),
                              border: InputBorder.none,
                              hintText: "Confirm password",
                              hintStyle: GoogleFonts.nunito(fontSize: 16),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    cfisVisible = !cfisVisible;
                                  });
                                },
                                icon: Icon(cfisVisible ? Icons.visibility : Icons.visibility_off),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                setState(() {
                                  cfpasswordError = 'Confirm password is required';
                                });
                                return null;
                              }
                              if (password.text.isNotEmpty && confirmPassword.text.isNotEmpty && password.text != confirmPassword.text){
                                setState(() {
                                  cfpasswordError = "Passwords don't match";
                                });
                                return null;
                              }
                              setState(() {
                                cfpasswordError = null;
                              });
                              return null;
                            },
                          ),
                        ),
                        if (cfpasswordError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              cfpasswordError!,
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                color: Colors.red, // Màu chữ đỏ
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 50,),
                  // Button Sign Up
                  Container(
                    width: MediaQuery.of(context).size.width * .85,
                    decoration: BoxDecoration(
                      color: colorcontent,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 10,
                                offset: Offset(3, 3),
                              )
                            ],
                    ),
                    child: TextButton(
                      onPressed: () async {
                        final db = DatabaseHelper();
                        int? result = await db.getUserIDByEmail(email.text);
                        if (formKey.currentState!.validate() && emailError == null && usernameError == null && cfpasswordError == null && passwordError == null) {
                          if(result != null){
                            emailError = "This email has been registered";
                          }
                          else{
                            Provider.of<ProviderUser>(context, listen: false)
                              .setUser(username.text, password.text, email.text, otp1);
                            sendOTP();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Verify_Signup_Screen()));
                          }
                        }
                      },
                      child: Text(
                        "Sign Up",
                        style: GoogleFonts.nunito(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                          onPressed: () {
                            //Navigate to sign up
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login_Screen()));
                          },
                          child: const Text("Login"))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}