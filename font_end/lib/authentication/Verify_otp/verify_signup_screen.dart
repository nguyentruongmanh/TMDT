import 'package:e_commerce_project/SQLite/fuction_data.dart';
import 'package:e_commerce_project/constants.dart';
import 'package:e_commerce_project/jsonModel/users.dart';
import 'package:e_commerce_project/provider/provider_user.dart';
import 'package:e_commerce_project/screens/Home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Verify_Signup_Screen extends StatefulWidget {
  const Verify_Signup_Screen({super.key});

  @override
  State<Verify_Signup_Screen> createState() => _Verify_Signup_ScreenState();
}

final formKey = GlobalKey<FormState>();
String? result;

final db = DatabaseHelper();
List<TextEditingController> OTP = List.generate(6, (_)=> TextEditingController() );
List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());
class _Verify_Signup_ScreenState extends State<Verify_Signup_Screen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "OTP Verification",
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
                    SizedBox(height: 40),
                    Container(
                        child: Image.asset("lib/images/VerifyOTP.png", width: 300,),
                    ),
                    SizedBox(height:40),
                    Text(
                      "Please enter the 6-digit OTP sent to your registered Gmail address to verify your account. Make sure to check your spam folder if you don't see it in your inbox.",
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.nunito(
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height:40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(6, (index) {
                        return SizedBox(
                          height: 60,
                          width: 40,
                          child: TextFormField(
                            controller: OTP[index],
                            focusNode: focusNodes[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: buttonColor,
                                ), // Viền khi focus
                              ),
                              counterText: "", // Xóa bộ đếm kí tự
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            onChanged: (value) {
                              // Chuyển focus sang ô kế tiếp
                              if (value.isNotEmpty && index < 5) {
                                FocusScope.of(context).nextFocus();
                              }
                              else if (value.isEmpty && index > 0) {
                                // Khi xóa, chuyển focus ngược về ô trước đó
                                FocusScope.of(context).previousFocus();
                              }
                            },
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 10,),
                    if (result != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              result!,
                              style: GoogleFonts.nunito(
                                fontSize: 14,
                                color: Colors.red, // Màu chữ đỏ
                              ),
                            ),
                          ),
                    SizedBox(height:40),
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
                          // liên kết textfield thành một chuỗi 6 số
                          String enteredOtp = OTP.map((e) => e.text).join();
                          bool isVerifyOTP = Provider.of<ProviderUser>(context, listen: false)
                            .verifyOtp(enteredOtp);
                          if(isVerifyOTP == false) {
                            result = "OTP code is not valid";
                          }
                          else{
                            Users newuser = Users(
                              userEmail: Provider.of<ProviderUser>(context, listen: false).getuserEmail,
                              userName: Provider.of<ProviderUser>(context, listen: false).getuserName,
                              userPassword: Provider.of<ProviderUser>(context, listen: false).getuserPassword,
                            );
                            db.signup(newuser);
                            int? userID = await db.getUserIDByEmail(Provider.of<ProviderUser>(context, listen: false).getuserEmail);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(userID:userID,),));
                          }
                        }, 
                        child: Text(
                          "Verify OTP",
                          style: GoogleFonts.nunito(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ),
                  ]
                ),
              ),
            ),
          ),
        ))
    );
  }
}