import 'package:e_commerce_project/SQLite/fuction_data.dart';
import 'package:e_commerce_project/constants.dart';
import 'package:e_commerce_project/jsonModel/CartItem.dart';
import 'package:e_commerce_project/screens/Cart/send_infor_order.dart';
import 'package:e_commerce_project/screens/nav_bar_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CheckOut extends StatefulWidget {
  final int userID;
  final double totalprice;
  final String? discountCode;
  final double? discountpercent;

  const CheckOut({super.key, required this.userID, required this.totalprice, required this.discountCode, required this.discountpercent,});

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  late Future<List<Map<String, dynamic>>> productDetails;
  String formatPrice(double price) {
    return NumberFormat("#,##0", "vi_VN").format(price);
  }
  List<int> cartIDsInCart = [];
  double delivery = 50000;
  double? isPrice;
  double? discountValue;
  String? email;
  bool isEmailChecked = true; 
  bool emailSent= false; 
  int? discountID;
  int? productID;

  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print(widget.discountCode);
    checkPrice();
    loadUserContactInfo();  // Gọi hàm lấy thông tin số điện thoại và địa chỉ
    getValueDiscountID();

    productDetails = _fetchProductDetails();
    DatabaseHelper().getcartIDsFromCart(widget.userID).then((cartIDs){
      setState(() {
        cartIDsInCart = cartIDs;
      });
    });
  }
  Future<void> getValueDiscountID() async {
    var result = await DatabaseHelper().getDiscountIDAndProductIDByCode(widget.discountCode);
    setState(() {
      discountID = result?['discountID'];
      productID = result?['productID'];
    });
    print(productID);
    print(discountID);
  }


  // Lấy thông tin số điện thoại và địa chỉ người dùng
  Future<void> loadUserContactInfo() async {
    var contactInfo = await DatabaseHelper().getUserContactInfo(widget.userID);
    setState(() {
      phoneController.text = contactInfo['userPhone'] ?? '';
      addressController.text = contactInfo['userAddress'] ?? '';
      email = contactInfo['userEmail'] ?? '';
    });
  }


  Future<void> checkPrice() async {
    var result = await DatabaseHelper().getProductPriceWithDiscountCode(widget.discountCode);
    setState(() {
      isPrice = result as double?;
      discountValue = calculateDiscount();
    });
  }
  Future<List<Map<String, dynamic>>> _fetchProductDetails() async {
    List<Map<String, dynamic>> details = [];
    
    // Lấy danh sách sản phẩm từ giỏ hàng của người dùng từ DB
    List<CartItem> cartItems = await DatabaseHelper().getCartItemsByUserID(widget.userID);
    
    for (var cartItem in cartItems) {
      var detail = await DatabaseHelper().getDetailsByProductId(cartItem.productID);
      details.add({
        "productId": cartItem.productID,
        "title": detail['productName']?.toString() ?? "Unknown Product",
        "image": detail['imageURL']?.toString() ?? "default_image.png", // Hình ảnh mặc định
        "unitPrice": detail['productPrice'],
        "totalPrice": detail['productPrice'] * cartItem.quantity, // Giá tổng = giá sản phẩm * số lượng
        "size": cartItem.size,
        "color": cartItem.color,
        "quantity": cartItem.quantity,
      });
    }
    return details;
  }
  double calculateDiscount() {
    if (isPrice == null) {
      return widget.discountpercent != null 
        ? widget.discountpercent! * widget.totalprice 
        : widget.totalprice;
    } else {
      return widget.discountpercent != null 
        ? widget.discountpercent! * isPrice! 
        : isPrice!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'My Cart', 
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                right: 10,
                bottom: 20,
                left: 10,
              ),
              child: Text("Your product is expected to be delivered to you within 4-7 days, depending on your location. Please keep your phone available to receive the delivery and make the payment before receiving the product. Layer sincerely thanks you for your support!",
                textAlign: TextAlign.justify,
                style: GoogleFonts.nunito(
                  fontSize: 15,
                ),
              ),
            ),
            ListTile(
              title: Text(
                'Order Summary',
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Order'),
                      Text(
                        '${formatPrice(widget.totalprice)} VND',
                        style: GoogleFonts.nunito(),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Delivery'),
                      Text(
                        '${formatPrice(delivery)} VND',
                        style: GoogleFonts.nunito(),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  if (widget.discountCode != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Discount'),
                        Text(
                          '${formatPrice(discountValue ?? 0)} VND',
                          style: GoogleFonts.nunito(),
                        ),
                      ],
                    ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total', 
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        ),
                      if(widget.discountCode == null)
                        Text(
                          '${formatPrice(delivery + widget.totalprice)} VND',
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      if(widget.discountCode != null)
                        Text(
                          '${formatPrice(widget.totalprice  + delivery - (discountValue ?? 0.0) )} VND',
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              child: Column(
                children: [
                  SizedBox(height: 16),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      hintStyle: GoogleFonts.nunito(),
                    ),
                    onChanged: (value) {
                      // Lưu lại số điện thoại nếu cần
                    },
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: addressController,
                    decoration: InputDecoration(
                      labelText: 'Address',
                      hintStyle: GoogleFonts.nunito(),
                    ),
                    onChanged: (value) {
                      // Lưu lại địa chỉ nếu cần
                    },
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: isEmailChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isEmailChecked = value ?? false;

                          });
                        },
                      ),
                      Text(
                        'Send your order information to your email',
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            Container(
              padding: const EdgeInsets.only(
                bottom: 30,
                right: 5,
                left: 5,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: colorcontent,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                onPressed: () async {
                  // Kiểm tra xem số điện thoại và địa chỉ có được điền đầy đủ không
                  if (phoneController.text.isEmpty || addressController.text.isEmpty) {
                    // Hiển thị thông báo yêu cầu điền đầy đủ thông tin
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter both phone number and address.')),
                    );
                  } else {
                    // Cập nhật số điện thoại và địa chỉ khi bấm "Order Now"
                    DatabaseHelper().updateUserContactInfo(
                      widget.userID,
                      phoneController.text,
                      addressController.text,
                    );

                    // Nếu checkbox được tick và thông tin đầy đủ, gọi hàm gửi email
                    if (isEmailChecked) {
                      sendPaymentDetailsEmail(
                        email!,  // Email người nhận, thay bằng email người dùng nếu cần
                        phoneController.text,
                        addressController.text,
                        widget.totalprice,
                        discountValue ?? 0,
                        delivery,
                      );
                      setState(() {
                        emailSent = true;
                      });
                    }
                    if (emailSent == true) {
                      for (int cartID in cartIDsInCart) {
                        await DatabaseHelper().saveDataToOrder(cartID, discountID, productID);
                      }
                      print(cartIDsInCart);
                      // Lấy danh sách sản phẩm trong giỏ hàng
                      List<CartItem> cartItems = await DatabaseHelper().getCartItemsByUserID(widget.userID);
                      await DatabaseHelper().clearCart(widget.userID);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>BottomNavBar(userID: widget.userID)));
                    }
                  }
                },
                child: Text(
                  'Order Now',
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
