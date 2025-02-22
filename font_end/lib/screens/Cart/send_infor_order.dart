import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

Future<void> sendPaymentDetailsEmail(
  String email,
  String phone,
  String address,
  double totalPrice,
  double discountValue,
  double deliveryFee,
) async {
  // Thông tin tài khoản email (ví dụ: Gmail)
  final String username = 'layerappcompany@gmail.com'; // Thay bằng email của bạn
  final String password = 'szml yrdk pwfo qjhc'; // Thay bằng mật khẩu hoặc mật khẩu ứng dụng (app password)

  // Cấu hình SMTP server
  final smtpServer = gmail(username, password); // Nếu dùng Gmail

  // Tạo nội dung email
  final message = Message()
    ..from = Address(username, 'LayerApps') // Tên hiển thị
    ..recipients.add(email) // Người nhận
    ..subject = 'Payment Details for Your Order' // Tiêu đề
    ..html = '''
      <p style="font-family: Nunito, sans-serif; font-size: 16px;">
        <b>Dear Customer,</b><br><br>
        Thank you for your order. Here are the payment details:<br><br>
        
        <b>Phone Number:</b> $phone<br>
        <b>Delivery Address:</b> $address<br>
        <b>Order Total:</b> ${formatPrice(totalPrice)} VND<br>
        <b>Discount:</b> ${formatPrice(discountValue)} VND<br>
        <b>Delivery Fee:</b> ${formatPrice(deliveryFee)} VND<br>
        <b>Total Amount to Pay:</b> ${formatPrice(totalPrice - discountValue + deliveryFee)} VND<br><br>

        If you have any questions, please contact us.<br><br>
        Thank you for choosing LayerApps.<br><br>
        Best regards,<br>
        <b>LayerApp</b>
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

String formatPrice(double price) {
  // Hàm để định dạng giá tiền
  return NumberFormat("#,##0", "vi_VN").format(price);
}
