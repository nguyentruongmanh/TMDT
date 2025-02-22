import 'package:e_commerce_project/SQLite/fuction_data.dart';
import 'package:e_commerce_project/constants.dart';
import 'package:e_commerce_project/screens/Detail/widget/addto_cart.dart';
import 'package:e_commerce_project/screens/Detail/widget/description.dart';
import 'package:e_commerce_project/screens/Detail/widget/details_appbar.dart';
import 'package:e_commerce_project/screens/Detail/widget/image_slider.dart';
import 'package:e_commerce_project/screens/Detail/widget/items_details.dart';
import 'package:e_commerce_project/screens/Home/Widget/image_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailsScreen extends StatefulWidget {
  final int userID;
  final int productId;
  DetailsScreen({super.key, required this.productId, required this.userID});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late Future<List<String>> colorsFuture;
  late Future<List<int>> sizedFuture;
  late Future<Map<String, dynamic>> productDetails;

  int currentImage = 0;
  int? selectedColorIndex;
  String selectedColorHex = '';
  int? selectedSizeIndex;
  String selectedSize = '';
  double? productPrice;

  @override
  void initState() {
    super.initState();
    colorsFuture = DatabaseHelper().getColorsByProductID(widget.productId);
    sizedFuture = DatabaseHelper().getProductSizes(widget.productId);
    productDetails = DatabaseHelper().getDetailsByProductId(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors,
      floatingActionButton: FutureBuilder<Map<String, dynamic>>(
        future: productDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            return Text('No product details available');
          } else {
            Map<String, dynamic> product = snapshot.data!;
            productPrice = product['productPrice']; // Lấy giá sản phẩm từ chi tiết

            return AddToCart(
              userID: widget.userID,
              isButtonEnabled: selectedColorIndex != null && selectedSizeIndex != null,
              productId: widget.productId,
              color: selectedColorHex,
              size: selectedSize,
              productName: product['productName'], // Truyền tên sản phẩm
              productPrice: productPrice!,
              productImage: product['imageURL'],
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                Stack(
                  children: [
                    MyImageSlider(
                      productId: widget.productId,
                      onChange: (index) {
                        setState(() {
                          currentImage = index;
                        });
                      },
                    ),
                    DetailsAppbar(),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    6,
                    (index) => AnimatedContainer(
                      duration: const Duration(microseconds: 500),
                      width: currentImage == index ? 15 : 8,
                      height: 8,
                      margin: const EdgeInsets.only(right: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: currentImage == index
                            ? Colors.black
                            : Colors.transparent,
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    ),
                  ),
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 20,
                    bottom: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ItemsDetails(productId: widget.productId),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: FutureBuilder<List<String>>(
                              future: colorsFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  return Text('No colors available');
                                } else {
                                  List<String> colors = snapshot.data!;
                                  return Row(
                                    children: List.generate(
                                      colors.length,
                                      (index) {
                                        String hexColor = colors[index];
                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedColorIndex = index;
                                              sizedFuture = DatabaseHelper().getProductSizesByColor(widget.productId, hexColor);
                                              selectedColorHex = hexColor;
                                            });
                                          },
                                          child: AnimatedContainer(
                                            duration: Duration(milliseconds: 300),
                                            width: 30,
                                            height: 30,
                                            margin: EdgeInsets.symmetric(horizontal: 5),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(int.parse("0xFF$hexColor")),
                                              border: Border.all(
                                                color: selectedColorIndex == index
                                                    ? Color(int.parse("0xFF$hexColor"))
                                                    : Colors.transparent,
                                                width: 2,
                                              ),
                                              boxShadow: [
                                                if (selectedColorIndex == index)
                                                  BoxShadow(
                                                    color: Colors.black.withOpacity(0.2),
                                                    spreadRadius: 5,
                                                    blurRadius: 10,
                                                  ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          Container(
                            child: FutureBuilder<List<int>>(
                              future: sizedFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  return Text('No sizes available');
                                } else {
                                  List<int> sizes = snapshot.data!;
                                  List<String> sizeLabels = ['M', 'L', 'XL', 'XXL'];
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      sizes.length,
                                      (index) {
                                        final isOutOfStock = sizes[index] == 0;
                                        final isSelected = selectedSizeIndex == index;

                                        return GestureDetector(
                                          onTap: isOutOfStock
                                              ? null
                                              : () {
                                                  setState(() {
                                                    selectedSizeIndex = index;
                                                    selectedSize = sizeLabels[index];
                                                  });
                                                },
                                          child: AnimatedContainer(
                                            duration: Duration(milliseconds: 300),
                                            width: 30,
                                            height: 30,
                                            margin: EdgeInsets.symmetric(horizontal: 5),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                              border: Border.all(
                                                color: isOutOfStock
                                                    ? Colors.grey
                                                    : isSelected
                                                        ? colorcontent
                                                        : Colors.black,
                                                width: 2,
                                              ),
                                              boxShadow: isSelected && !isOutOfStock
                                                  ? [
                                                      BoxShadow(
                                                        color: Colors.black.withOpacity(0.1),
                                                        spreadRadius: 2,
                                                        blurRadius: 3,
                                                      ),
                                                    ]
                                                  : [],
                                            ),
                                            child: Center(
                                              child: Text(
                                                sizeLabels[index],
                                                style: GoogleFonts.nunito(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: isOutOfStock
                                                      ? Colors.grey
                                                      : isSelected
                                                        ? colorcontent
                                                        : Colors.black,
                                                ),
                                              ),
                                            ),
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
                      SizedBox(height: 30),
                      Description(productId: widget.productId),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
