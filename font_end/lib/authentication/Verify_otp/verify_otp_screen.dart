import 'package:e_commerce_project/SQLite/fuction_data.dart';
import 'package:e_commerce_project/authentication/resetpw_screen.dart';
import 'package:e_commerce_project/constants.dart';
import 'package:e_commerce_project/provider/provider_user.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class VerifyOTP_Screen extends StatefulWidget {
  const VerifyOTP_Screen({super.key});

  @override
  State<VerifyOTP_Screen> createState() => _VerifyOTP_ScreenState();
}

final formKey = GlobalKey<FormState>();
final db = DatabaseHelper();
String? result;
List<TextEditingController> OTP = List.generate(6, (_)=> TextEditingController() );
List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

int index= 0;
class _VerifyOTP_ScreenState extends State<VerifyOTP_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          String codeOTP = OTP.map((e) => e.text).join();
                          String emailSentCode = Provider.of<ProviderUser>(context, listen: false).getuserEmail;
                          String? otpSaved = await db.getStoredOTP(emailSentCode);
                          if(codeOTP != otpSaved){
                            result = "OTP code is not valid";
                          }
                          else{
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> ResetPassWord_Screen()));
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