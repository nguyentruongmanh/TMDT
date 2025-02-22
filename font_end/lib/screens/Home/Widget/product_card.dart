import 'dart:ffi';

import 'package:e_commerce_project/SQLite/fuction_data.dart';
import 'package:e_commerce_project/constants.dart';
import 'package:e_commerce_project/jsonModel/product.dart';
import 'package:e_commerce_project/screens/Detail/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ProductCard extends StatelessWidget {
  final int userID;
  final String productName;
  final String productImage;
  final double productPrice;
  final int productId;
  const ProductCard({Key? key, required this.productName, required this.productImage, required this.productPrice,required this.productId, required this.userID}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    Future<List<String>> colorsFuture = DatabaseHelper().getColorsByProductID(productId);
    String formatPrice(double price) {
      return NumberFormat("#,##0", "vi_VN").format(price);
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context)=> DetailsScreen(productId: productId, userID: userID,)
        ));
      },
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: colors, 
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      productImage,  
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network(
                          'https://via.placeholder.com/150',
                          height: 100,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 6),
                FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                    child: Text(
                      (productName.split(' ').take(3).join(' ') + (productName.split(' ').length > 3 ? '...' : '')).toUpperCase(),
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                SizedBox(height: 8,),
                FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                    child: Text(
                      "${formatPrice(productPrice)} VND",
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                SizedBox(height: 8,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                  child: FutureBuilder<List<String>>(
                    future: colorsFuture, // Gọi hàm lấy danh sách màu sắc từ cơ sở dữ liệu
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // Hiển thị loading khi dữ liệu đang tải
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}'); // Nếu có lỗi
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text('No colors available'); // Nếu không có màu sắc nào
                      } 
                      else {
                        List<String> colors = snapshot.data!;
                        return Row(
                          children: List.generate(
                            colors.length > 3 ? 3 : colors.length, // Giới hạn tối đa 3 màu
                            (index) {
                              String hexColor = colors[index];
                              return Container(
                                width: 10,
                                height: 10,
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(int.parse("0xFF$hexColor")),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}