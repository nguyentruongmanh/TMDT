import 'package:e_commerce_project/SQLite/fuction_data.dart';
import 'package:e_commerce_project/constants.dart';
import 'package:e_commerce_project/jsonModel/CartItem.dart';
import 'package:e_commerce_project/screens/Cart/check_out.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

class CheckOutBox extends StatefulWidget {
  final int userID;
  final double totalprice;
  CheckOutBox({super.key, required this.totalprice, required this.userID});

  @override
  State<CheckOutBox> createState() => _CheckOutBoxState();
}

class _CheckOutBoxState extends State<CheckOutBox> {
  String formatPrice(double price) {
    return NumberFormat("#,##0", "vi_VN").format(price);
  }

  final discount = TextEditingController();
  List<int> productIDsInCart = [];
  String? noDiscount;
  double? discountPercent;
  String? discounterror;
  String? discountCode;

  @override
  void initState() {
    super.initState();
    // Lấy productID theo userID có trong giỏ hàng
    DatabaseHelper().getProductIDsFromCart(widget.userID).then((productIDs) {
      setState(() {
        productIDsInCart = productIDs;
      });
    });
  }

  Future<void> checkDiscountForCart() async {
  String discountCodeEntered = discount.text.trim();
  bool isDiscountApplied = false;

  // Check for the discount code in the cart
  for (int productID in productIDsInCart) {
    Map<String, dynamic>? checkDiscountCode =
        await DatabaseHelper().checkDiscountCode(discountCodeEntered, productID);
    if (checkDiscountCode != null && checkDiscountCode.isNotEmpty) {
      setState(() {
        discountPercent = checkDiscountCode['discountPercentage'];
        noDiscount = null;
      });
      isDiscountApplied = true;
      break;
    }
  }
  if (!isDiscountApplied) {
    setState(() {
      noDiscount = "Don’t find any discount code!";
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (noDiscount!= null)? 250: 230,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          TextField(
            controller: discount,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 15,
              ),
              filled: true,
              fillColor: colors,
              hintText: "Enter Discount Code",
              hintStyle: GoogleFonts.nunito(
                color: Colors.grey,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          if (discounterror != null)
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                "$noDiscount",
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  color: Colors.red, // Màu chữ đỏ
                ),
              ),
            ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.only(
              right: 10,
              left: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total",
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  "${formatPrice(widget.totalprice)} VND",
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.only(
              left: 5,
              right: 5,
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorcontent,
                minimumSize: const Size(double.infinity, 50),
              ),
             onPressed: () async {
                await checkDiscountForCart();
                setState(() {
                  discounterror = null;
                });
                if (discount.text.trim().isEmpty || discountPercent!= null) {
                  if(discount.text.trim().isEmpty){
                    setState(() {
                      discountCode == null;
                    });
                  }
                  else{
                    setState(() {
                      discountCode = discount.text.trim();
                    });
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckOut(
                        userID: widget.userID,
                        totalprice: widget.totalprice, 
                        discountCode: discountCode,
                        discountpercent: discountPercent, 
                      ),
                    ),
                  );            
                  } else {
                  setState(() {
                    discounterror = "true";
                  });
                }
              },
              child: Text(
                "Check Out",
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
    );
  }
}
