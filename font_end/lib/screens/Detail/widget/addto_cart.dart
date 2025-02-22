import 'dart:math';

import 'package:e_commerce_project/SQLite/fuction_data.dart';
import 'package:e_commerce_project/authentication/Verify_otp/verify_otp_screen.dart';
import 'package:e_commerce_project/constants.dart';
import 'package:e_commerce_project/jsonModel/CartItem.dart';
import 'package:flutter/material.dart';

class AddToCart extends StatefulWidget {
  final int userID;
  final bool isButtonEnabled;
  final int productId;
  final String productName;
  final double productPrice;
  final String productImage;
  final String color;
  final String size;
  const AddToCart({super.key, required this.isButtonEnabled, required this.productId, required this.color, required this.size, required this.userID, required this.productName, required this.productPrice, required this.productImage});

  @override
  State<AddToCart> createState() => _AddToCartState();
}
final db = DatabaseHelper();
class _AddToCartState extends State<AddToCart> {
  int currentIndex = 1;
  late CartItem newItem;
  void addToCart() async {
    try {
      // Lấy số lượng tồn kho của sản phẩm
      var productStock = await DatabaseHelper().getProductStock(widget.productId, widget.color, widget.size);
      int stockQuantity = productStock['stockQuantity'];

      // Kiểm tra số lượng giỏ hàng không vượt quá tồn kho
      if (currentIndex <= stockQuantity) {
        await db.insertCart(
          userID: widget.userID,
          productID: widget.productId,
          productName: widget.productName,
          productPrice: widget.productPrice,
          quantity: currentIndex,
          imageURL: widget.productImage,
          color: widget.color,
          size: widget.size,
        );

        // Hiển thị thông báo nếu thêm vào giỏ hàng thành công
        const snackBar = SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            "Successfully added!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Colors.white,
            ),
          ),
          duration: Duration(seconds: 1),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        // Thông báo nếu số lượng vượt quá tồn kho
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'Cannot add more. Only $stockQuantity items in stock.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          duration: Duration(seconds: 1),
        ));
      }
    } catch (e) {
      print("Error adding to cart: $e");  // In lỗi nếu có lỗi xảy ra
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.black,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 25),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Widget điều chỉnh số lượng
            Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (currentIndex != 1) {
                        setState(() {
                          currentIndex--;
                        });
                      }
                    },
                    iconSize: 18,
                    icon: const Icon(
                      Icons.remove,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    currentIndex.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 5),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        currentIndex++;
                      });
                    },
                    iconSize: 18,
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            // Nút Add to Cart
            GestureDetector(
              onTap: widget.isButtonEnabled
                  ? () async {
                   addToCart();
                }:null,
               // Vô hiệu hóa nếu chưa chọn đủ
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: widget.isButtonEnabled
                      ? colorcontent // Kích hoạt nút với màu chính
                      : Colors.grey, // Màu xám khi bị vô hiệu hóa
                  borderRadius: BorderRadius.circular(50),
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: const Text(
                  "Add to Cart",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}