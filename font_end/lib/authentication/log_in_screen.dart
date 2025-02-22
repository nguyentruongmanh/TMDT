//import 'package:e_commerce_project/constants.dart';
import 'package:e_commerce_project/SQLite/fuction_data.dart';
import 'package:e_commerce_project/authentication/sign_up_screen.dart';
import 'package:e_commerce_project/authentication/Verify_otp/enter_email_screen.dart';
import 'package:e_commerce_project/constants.dart';
import 'package:e_commerce_project/jsonModel/users.dart';
import 'package:e_commerce_project/screens/admin/home_admin.dart';
import 'package:e_commerce_project/screens/nav_bar_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Login_Screen extends StatefulWidget {
  const Login_Screen({super.key});

  @override
  State<Login_Screen> createState() => _Login_ScreenState();
}

class _Login_ScreenState extends State<Login_Screen> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool isVisible = false;
  bool isLoginTrue = false;

  final db = DatabaseHelper();
  login() async {
    // Gọi hàm login để lấy userID và isAdmin
    final result = await db.login(Users(
      userEmail: email.text,
      userPassword: password.text,
    ));

    if (result != null) {
      int userID = result['userID'];
      int isAdmin = result['admin'];

      if (!mounted) return;
      if (isAdmin==0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavBar(userID: userID),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeAdmin(),
          ),
        );
      }
    } else {
      if (emailError != null || passwordError != null) {
        isLoginTrue = false;
      } else {
        setState(() {
          isLoginTrue = true;
        });
      }
    }
  }
  final formKey = GlobalKey<FormState>();
  String? emailError;
  String? passwordError;

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
                children: [
                  // Image
                  Image.asset("lib/images/logo_app.jpg", width: 350),
                  const SizedBox(height: 80.0),
                  
                  // UserEmail field
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
                              icon: const Icon(Icons.person, size: 25),
                              border: InputBorder.none,
                              hintText: "Email",
                              hintStyle: GoogleFonts.nunito(fontSize: 16),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                setState(() {
                                  emailError = 'Email is required';
                                });
                                return null; // Trả về lỗi
                              }
                              if(!value.endsWith('@gmail.com')){
                                setState(() {
                                  emailError = 'Email is invalid';
                                });
                                return null; 
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
                  SizedBox(height: 15),
                  // Password field
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
                            obscureText: !isVisible,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical:12.0),
                              icon: const Icon(Icons.lock_person_rounded, size: 25),
                              border: InputBorder.none,
                              hintText: "Password",
                              hintStyle: GoogleFonts.nunito(fontSize: 16),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isVisible = !isVisible;
                                  });
                                },
                                icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                if (passwordError == null) {
                                  setState(() {
                                    passwordError = 'Password is required';
                                  });
                                }
                                return null;
                              }
                              if (passwordError != null) {
                                setState(() {
                                  passwordError = null;
                                });
                              }
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

                  SizedBox(height: 15,),
                  //anouncement when login
                  isLoginTrue
                    ? const Text(
                    "Email or Password is incorrect!", 
                    style: TextStyle(color: Colors.red),
                    )
                    : const SizedBox(),

                  const SizedBox(height: 30),

                  // Login button
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
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          if(passwordError != null || emailError != null){
                            isLoginTrue = false;
                          }
                          if(passwordError == null && emailError == null){                          
                            login();
                            debugPrint("Log in successful!");
                          }
                        }
                      },
                      child: Text(
                        "LOG IN",
                        style: GoogleFonts.nunito(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  //Forgot password button
                  Container(
                    child: TextButton(
                      onPressed: (){
                        setState(() {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Enter_Email_Screen()));
                        });
                      }, 
                      child: Text(
                        "Forgot Password?",
                        style: GoogleFonts.nunito(fontSize: 14),
                      ),
                    ),
                  ),
                  // Signup button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: GoogleFonts.nunito(fontSize: 14),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> const SignUpScreen()));
                          });
                        },
                        child: Text(
                          "Sign Up",
                          style: GoogleFonts.nunito(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}