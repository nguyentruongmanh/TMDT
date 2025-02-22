import 'dart:ffi';
import 'dart:math';
import 'package:e_commerce_project/SQLite/fuction_data.dart';
import 'package:e_commerce_project/constants.dart';
import 'package:e_commerce_project/screens/Home/Widget/categories.dart';
import 'package:e_commerce_project/screens/Home/Widget/image_slider.dart';
import 'package:e_commerce_project/screens/Home/Widget/product_card.dart';
import 'package:e_commerce_project/screens/Home/Widget/search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  final userID;
  const HomeScreen({super.key, required this.userID});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentSlider = 0;
  late Future<List<Map<String, dynamic>>> futureProducts;
  final Random _random = Random(); // Biến random để xáo trộn sản phẩm

  @override
  void initState() { 
    super.initState(); 
    futureProducts = DatabaseHelper().getRandomProducts(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40.0),
              const CustomAppBar(),
              const SizedBox(height: 10),
              const Search(),
              const SizedBox(height: 30),
              ImageSlider(
                CurrentSlider: currentSlider,
                onChange: (value) {
                  setState(() {
                    currentSlider = value;
                  });
                },
              ),
              const SizedBox(height: 30),
              const Categories_screen(),
              const SizedBox(height: 5),
              // Special Product Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Special Product",
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "See all",
                      style: GoogleFonts.nunito(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              // GridView with FutureBuilder
              FutureBuilder<List<Map<String, dynamic>>>(
                future: futureProducts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No products found'));
                  } else {
                    List<Map<String, dynamic>> products = snapshot.data!;

                    // Tạo một danh sách chỉ số ngẫu nhiên và xáo trộn
                    List<int> randomIndexes = List.generate(products.length, (index) => index);
                    randomIndexes.shuffle(_random);

                    return GridView.builder(
                      padding: const EdgeInsets.only(bottom: 10),
                      shrinkWrap: true, // Quan trọng để tránh lỗi cuộn vô hạn
                      physics: const NeverScrollableScrollPhysics(), // Vô hiệu hóa cuộn riêng cho GridView
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Số cột trong lưới
                        childAspectRatio: 0.8, // Tỉ lệ giữa chiều rộng và chiều cao
                        crossAxisSpacing: 45, // Khoảng cách ngang giữa các ô
                        mainAxisSpacing: 30, // Khoảng cách dọc giữa các ô
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        var product = products[randomIndexes[index]]; // Lấy sản phẩm theo chỉ số ngẫu nhiên
                        String productName = product['productName'] ?? 'Unknown';
                        String productImage = product['imageURL'] ?? 'https://via.placeholder.com/150';
                        double productPrice = product['productPrice'] ?? 'Unknow';
                        int productId = product['productID'] ?? 'Unknow';
                        return Center(
                          child: ProductCard(
                            productName: productName,
                            productImage: productImage,
                            productPrice: productPrice,
                            productId: productId, 
                            userID: widget.userID,
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          style: IconButton.styleFrom(
            backgroundColor: colors,
            padding: const EdgeInsets.all(20),
          ),
          onPressed: () {},
          icon: Image.asset(
            "lib/images/icon.png",
            height: 20,
          ),
        ),
        SizedBox(
          height: 120,
          child: Image.asset("lib/images/logo_app 2.jpg", width: 230),
        ),
        IconButton(
          style: IconButton.styleFrom(
            backgroundColor: colors,
            padding: const EdgeInsets.all(15),
          ),
          onPressed: () {},
          iconSize: 30,
          icon: const Icon(
            Icons.notifications_outlined,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
