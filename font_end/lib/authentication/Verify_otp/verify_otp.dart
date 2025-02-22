import 'dart:math';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

String generateOTP() {
  var rng = Random();
  String otp = '';
  for (int i = 0; i < 6; i++) {
    otp += rng.nextInt(10).toString();
  }
  return otp;
}

Future<void> sendOTPEmail(String email, String otp) async {
  // Thông tin tài khoản email (ví dụ: Gmail)
  final String username = 'layerappcompany@gmail.com'; // Thay bằng email của bạn
  final String password = 'szml yrdk pwfo qjhc'; // Thay bằng mật khẩu hoặc mật khẩu ứng dụng (app password)
  // Cấu hình SMTP server
  final smtpServer = gmail(username, password); // Nếu dùng Gmail

  // Tạo nội dung email
  final message = Message()
    ..from = Address(username, 'LayerApps') // Tên hiển thị
    ..recipients.add(email) // Người nhận
    ..subject = 'Verify Your Account with OTP' // Tiêu đề
    ..html = '''
      <p style="font-family: Nunito, sans-serif; font-size: 16px;">
        <b>Dear Esteemed Sir and Madam;</b><br><br>
        Your One-Time Password (OTP) for LayersApp is <b>$otp</b>. 
        This code is valid for the next 5 minutes.<br><br>
        Please do not share this code with anyone. If you did not request this, please contact our support team immediately.<br><br>
        Thank you,<br><b>LayerApp</b>
      </p>
    ''';
   try {
    // Gửi email
    final sendReport = await send(message, smtpServer);
    print('Message sent: ${sendReport.toString()}');
  } catch (e) {
    // Xử lý lỗi khi gửi email
    print('Error occurred: $e');
  }
}