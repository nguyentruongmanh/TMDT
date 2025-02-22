import 'package:e_commerce_project/SQLite/fuction_data.dart';
import 'package:e_commerce_project/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ItemsDetails extends StatefulWidget {
  final int productId;

  const ItemsDetails({super.key, required this.productId});

  @override
  State<ItemsDetails> createState() => _ItemsDetailsState();
}

class _ItemsDetailsState extends State<ItemsDetails> {
  late Future<List<Map<String, dynamic>>> _detailsFuture;
  String formatPrice(double price) {
    return NumberFormat("#,##0", "vi_VN").format(price);
  }

  @override
  void initState() {
    super.initState();
    _detailsFuture = DatabaseHelper().getDetailsByProductid(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _detailsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No details available'));
        } else {
          // Tìm sản phẩm theo productId
          final product = snapshot.data!.firstWhere(
            (item) => item['productID'] == widget.productId,
            orElse: () => {},
          );

          // Kiểm tra nếu không tìm thấy sản phẩm
          if (product.isEmpty) {
            return const Center(child: Text('Product not found'));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tên sản phẩm
              Text(
                product['productName'].toUpperCase(), // Lấy tên sản phẩm
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              // Giá sản phẩm
              Text(
                '${formatPrice(product['productPrice'])} VND', // Lấy giá sản phẩm
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              // Rating và số lượt đánh giá
              Row(
                children: [
                  Container(
                    width: 55,
                    height: 25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: colorcontent,
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 15,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          product['averageRating']
                              .toStringAsFixed(1), // Rating trung bình
                         style: GoogleFonts.nunito(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${product['totalReviews']} reviews', // Tổng số lượt đánh giá
                    style: GoogleFonts.nunito(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ],
          );
        }
      },
    );
  }
}
