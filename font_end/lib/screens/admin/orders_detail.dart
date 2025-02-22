import 'package:e_commerce_project/SQLite/ad_fuction_data.dart';
import 'package:e_commerce_project/SQLite/fuction_data.dart';
import 'package:e_commerce_project/constants.dart';
import 'package:e_commerce_project/screens/admin/home_admin.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class OrdersDetails extends StatefulWidget {
  const OrdersDetails({super.key});

  @override
  State<OrdersDetails> createState() => _OrdersDetailsState();
}
class _OrdersDetailsState extends State<OrdersDetails> {
  late Future<Map<String, Map<String, dynamic>>> groupedOrderDetails;

  String formatPrice(double price) {
    return NumberFormat("#,##0", "vi_VN").format(price);
  }

  @override
  void initState() {
    super.initState();
    groupedOrderDetails = fetchGroupedOrderDetails();
  }

  Future<Map<String, Map<String, dynamic>>> fetchGroupedOrderDetails() async {
  var result = await DatabaseHelper2().getOrderDetails();
  Map<String, Map<String, dynamic>> groupedOrders = {};

  for (var order in result) {
    String userID = order['userID'].toString();
    if (!groupedOrders.containsKey(userID)) {
      groupedOrders[userID] = {
        'userName': order['userName'],
        'totalPrice': 0.0,
        'totalQuantity': 0,
        'products': [],
      };
    }

    double totalPrice = order['productPrice'] * order['quantity'];

    // Kiểm tra nếu có discountID thì áp dụng giảm giá
    if (order['discountID'] != null) {
      var discountDetails = await DatabaseHelper2().getDiscountDetails(order['discountID']);

      if (discountDetails != null) {
        double discountPercentage = discountDetails['discountPercentage'] ?? 0.0;
        totalPrice -= totalPrice * discountPercentage; // Áp dụng giảm giá
      }
    }

    // Cộng giá trị sản phẩm đã tính vào tổng tiền
    groupedOrders[userID]!['totalPrice'] += totalPrice;

    // Tăng số lượng sản phẩm
    groupedOrders[userID]!['totalQuantity'] += order['quantity'];

    // Thêm sản phẩm vào danh sách sản phẩm của nhóm
    groupedOrders[userID]!['products'].add(order);
  }

  return groupedOrders;
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Details of Orders',
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeAdmin()));
          },
        ),
      ),
      body: FutureBuilder<Map<String, Map<String, dynamic>>>(
        future: groupedOrderDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders found.'));
          } else {
            var groupedOrders = snapshot.data!;
            return ListView.builder(
              itemCount: groupedOrders.keys.length,
              itemBuilder: (context, index) {
                String userID = groupedOrders.keys.elementAt(index);
                var orderDetails = groupedOrders[userID]!;

                return Padding(
                  padding: const EdgeInsets.only(
                    left: 5,
                    right: 5,
                  ),
                  child: Card(
                    color: Colors.white,
                    margin: const EdgeInsets.all(10),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tên người dùng
                          Text(
                            'Username: ${orderDetails['userName']}',
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Hiển thị tổng số lượng và tổng giá trị
                          Text(
                            'Total Quantity: ${orderDetails['totalQuantity']}',
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Total Price: ${formatPrice(orderDetails['totalPrice'])} VND',
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Hiển thị danh sách các sản phẩm
                          Column(
                            children: orderDetails['products']
                                .map<Widget>((order) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Row(
                                      children: [
                                        Image.network(order['imageURL'], width: 50, height: 50, fit: BoxFit.cover),
                                        const SizedBox(width: 16),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              order['productName'],
                                              style: GoogleFonts.nunito(fontSize: 16),
                                            ),
                                            Text(
                                              'Size: ${order['size']}, Color: ${order['color']}',
                                              style: GoogleFonts.nunito(fontSize: 14),
                                            ),
                                            Text(
                                              'Quantity: ${order['quantity']}',
                                              style: GoogleFonts.nunito(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                })
                                .toList(),
                          ),
                          TextButton(
                            onPressed: () async {
                              var products = orderDetails['products'];
                              if (products != null && products is List<dynamic>) {
                                for (var product in products) {
                                  bool result = await DatabaseHelper().deleteProductQuantityByColorCode(
                                    product['productID'], // Truyền productID
                                    product['color'],     // Truyền color
                                    product['size'],      // Truyền size
                                    product['quantity'],  // Truyền quantity
                                  );
                                  if (!result) {
                                    print('Failed to delete product: ${product['productID']}');
                                  }
                                }
                                await DatabaseHelper2().clearOrdersTable();
                                setState(() {
                                  groupedOrderDetails = fetchGroupedOrderDetails();
                                });
                              }
                            },
                            child: Text(
                              'Đã Giao',
                              style: GoogleFonts.nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}