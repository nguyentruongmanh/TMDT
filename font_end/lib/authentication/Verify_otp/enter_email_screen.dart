import 'package:e_commerce_project/SQLite/fuction_data.dart';
import 'package:e_commerce_project/authentication/Verify_otp/verify_otp.dart';
import 'package:e_commerce_project/authentication/Verify_otp/verify_otp_screen.dart';
import 'package:e_commerce_project/constants.dart';
import 'package:e_commerce_project/jsonModel/users.dart';
import 'package:e_commerce_project/provider/provider_user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Enter_Email_Screen extends StatefulWidget {
  const Enter_Email_Screen({super.key});

  @override
  _Enter_Email_ScreenState createState() => _Enter_Email_ScreenState();
}

class _Enter_Email_ScreenState extends State<Enter_Email_Screen> {
  
final dbHelper = DatabaseHelper();
final formKey = GlobalKey<FormState>();
final email = TextEditingController();
final otp = TextEditingController();
String? emailError;
String? optError;
  // Hàm gửi OTP
Future<void> sendOTP() async {
  int? userID = await dbHelper.getUserIDByEmail(email.text);

  if (userID == null) {
    // Nếu không tìm thấy userID, thông báo lỗi
    setState(() {
      emailError = 'This email is not registered';
    });
  } else {
    // Nếu tìm thấy userID, gửi OTP và cập nhật cơ sở dữ liệu
    String otp1 = generateOTP();
    await sendOTPEmail(email.text, otp1);

    // Cập nhật mã OTP trong database cho email tương ứng
    await dbHelper.updateOTP(email.text, otp1);

    print("OTP sent successfully to userID: $userID");
  }
}

// Hàm xác minh OTP
Future<void> verifyUserOTP() async {
  // Lấy OTP đã lưu trong database
  String? storedOTP = await dbHelper.getStoredOTP(email.text);
  if (storedOTP != null && storedOTP == otp) {
    print("OTP verified successfully!");
  } else {
    print("Invalid OTP!");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Enter Email",
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Container(
                child: Column(
                  children: [
                    SizedBox(height:20),
                    Container(
                      child: Image.asset("lib/images/Forgot_pass.png", width: 400),
                    ),
                    SizedBox(height: 6,),
                    Container(
                      margin:EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Text(
                        "We’ll help you regain access to your account. Please enter the email address associated with your account, and we’ll send you a verification code to reset your password.",
                        style: GoogleFonts.nunito(
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    SizedBox(height:20),
                    Container(
                      margin:EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: TextFormField(
                        controller: email,
                        decoration: InputDecoration(
                          labelText: "Enter your email"
                        ),
                        validator: (value){
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
                        padding: const EdgeInsets.only(top: 10.0),
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
              const SizedBox(height:30),
              Container(
                width: MediaQuery.of(context).size.width * .78,
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
                  onPressed: (){
                    if(formKey.currentState!.validate() && emailError == null){
                      sendOTP();
                      Provider.of<ProviderUser>(context, listen:false)
                        .setEmail(email.text);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> VerifyOTP_Screen()));
                    }
                  },
                  child: Text(
                    "Send OTP",
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
      ),
    );
  }
}
