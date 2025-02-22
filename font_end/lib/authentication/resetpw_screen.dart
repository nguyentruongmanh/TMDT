import 'package:e_commerce_project/SQLite/fuction_data.dart';
import 'package:e_commerce_project/authentication/Verify_otp/verify_signup_screen.dart';
import 'package:e_commerce_project/authentication/log_in_screen.dart';
import 'package:e_commerce_project/authentication/sign_up_screen.dart';
import 'package:e_commerce_project/constants.dart';
import 'package:e_commerce_project/provider/provider_user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ResetPassWord_Screen extends StatefulWidget {
  const ResetPassWord_Screen({super.key});

  @override
  State<ResetPassWord_Screen> createState() => _ResetPassWord_ScreenState();
}
final formKey = GlobalKey<FormState>();
final password = TextEditingController();
final confirmPassword = TextEditingController();
bool pwisVisible = false;
bool cfisVisible = false;
String? passwordError;
String? cfpasswordError;
class _ResetPassWord_ScreenState extends State<ResetPassWord_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Reset Password",
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width*0.8,
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(height: 30,),
                    Container(
                      child: Image.asset("lib/images/resetpw.png", width: 400,),
                    ),
                    SizedBox(height: 30),
                    Text(
                      "Enter a new password to secure your account. Make sure it’s strong and easy for you to remember.",
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.nunito(
                        fontSize: 15,
                      ),
                    ),

                  SizedBox(height: 30),
                  //Password Field
                  Container(
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
                              hintText: "New password",
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

                  SizedBox(height: 30),
                  //Confirm Passwword
                  Container(
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

                  SizedBox(height: 40,),
                  //Reset Button
                  Container(
                    width: MediaQuery.of(context).size.width,
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
                        if(formKey.currentState!.validate() && emailError == null && usernameError == null && cfpasswordError == null && passwordError == null){
                          String enteredEmail = Provider.of<ProviderUser>(context,listen:false).getuserEmail;
                          await db.updatePw(enteredEmail, password.text);
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Login_Screen()));
                        }
                      },
                      child: Text(
                        "Reset password",
                        style: GoogleFonts.nunito(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  ],
                ),
              ),
            )
          ),
        )
      ),
    );
  }
}