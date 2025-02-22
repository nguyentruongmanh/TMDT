import 'package:e_commerce_project/SQLite/fuction_data.dart';
import 'package:e_commerce_project/jsonModel/CartItem.dart';
import 'package:e_commerce_project/screens/Cart/checkbox.dart';
import 'package:e_commerce_project/screens/Home/home_screen.dart';
import 'package:e_commerce_project/screens/nav_bar_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../constants.dart';

class CartScreen extends StatefulWidget {
  final int userID;
  const CartScreen({super.key, required this.userID});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Future<List<Map<String, dynamic>>> productDetails;
  String formatPrice(double price) {
    return NumberFormat("#,##0", "vi_VN").format(price);
  }

  @override
  void initState() {
    super.initState();
    productDetails = _fetchProductDetails();
  }

  // Tính tổng tiền của tất cả sản phẩm có trong giỏ hàng
  double _calculateTotalAmount(List<Map<String, dynamic>> products) {
    return products.fold(0.0, (sum, item) {
      double totalPrice = double.tryParse(item['totalPrice'].toString()) ?? 0.0;
      return sum + totalPrice;
    });
  }

  /// Lấy thông tin từ DB và tính tổng giá cho từng sản phẩm trong cart
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

  // Cập nhật số lượng sản phẩm trong DB và trong giỏ hàng
  void _updateQuantity(IconData icon, int productID, int userID, int index) async {
    // Thực hiện công việc bất đồng bộ ngoài setState
    List<Map<String, dynamic>> products = await productDetails;
    var product = products[index];

    // Lấy số lượng tồn kho của sản phẩm
    var productStock = await DatabaseHelper().getProductStock(product['productId'], product['color'], product['size']);
    int stockQuantity = productStock['stockQuantity'];

    // Cập nhật số lượng sản phẩm tùy theo icon
    if (icon == Icons.add) {
      // Kiểm tra xem số lượng giỏ hàng có vượt quá số lượng tồn kho không
      if (products[index]['quantity'] < stockQuantity) {
        products[index]['quantity']++;
        await DatabaseHelper().updateProductQuantity(
            widget.userID, product['productId'], products[index]['quantity']);
      } else {
        // Thông báo khi số lượng sản phẩm trong giỏ hàng không thể vượt quá tồn kho
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Cannot add more. Only $stockQuantity items in stock.'),
          duration: Duration(seconds: 1),
        ));
      }
    } else if (icon == Icons.remove && products[index]['quantity'] > 1) {
      products[index]['quantity']--;
      await DatabaseHelper().updateProductQuantity(
          widget.userID, product['productId'], products[index]['quantity']);
    } else if (icon == Icons.remove && products[index]['quantity'] == 1) {
      // Hiển thị pop-up khi số lượng bằng 1 và người dùng ấn dấu "-"
      _showRemoveDialog(index, productID, userID);
    }

    // Cập nhật lại tổng giá sản phẩm sau khi thay đổi số lượng
    product['totalPrice'] = product['unitPrice'] * product['quantity'];

    // Cập nhật trạng thái widget sau khi đã hoàn thành công việc bất đồng bộ
    setState(() {});
  }
  Future<void> _showRemoveDialog(int index, int productID, int userID) async {
    bool? shouldRemove = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Product'),
          content: const Text('Do you want to remove this product from your cart?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                await DatabaseHelper().removeProductFromCart(userID, productID);
                setState(() {
                  // Cập nhật lại danh sách sau khi xóa
                  productDetails = _fetchProductDetails();
                });
                Navigator.of(context).pop(true); // Nếu xóa
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (shouldRemove == true) {
      // Sau khi xóa, cập nhật lại giỏ hàng
      setState(() {
        // Xóa sản phẩm khỏi danh sách sản phẩm
        productDetails = _fetchProductDetails();
      });
    }
  }

  Widget productQuantity(IconData icon, int index, Function onQuantityChange) {
    return GestureDetector(
      onTap: () async {
        // Lấy thông tin về sản phẩm để truyền đúng tham số
        List<Map<String, dynamic>> products = await productDetails;
        var product = products[index];
        onQuantityChange(icon, product['productId'], widget.userID, index); // Gọi đúng hàm với đầy đủ tham số
      },
      child: Icon(
        icon,
        size: 20,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors,
      bottomSheet: FutureBuilder<List<Map<String, dynamic>>>(
        future: productDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: 60,
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return CheckOutBox(totalprice: 0.0, userID: widget.userID,); // Không có dữ liệu
          }
          final products = snapshot.data!;
          double totalAmount = _calculateTotalAmount(products);
          return CheckOutBox(totalprice: totalAmount, userID: widget.userID,);
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      padding: const EdgeInsets.only(left: 15),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> BottomNavBar(userID: widget.userID,)));
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                    ),
                  ),
                  Text(
                    "My Cart",
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  const SizedBox(width: 50,)
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: productDetails,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No products found in cart'));
                  }

                  final products = snapshot.data!;
                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];

                      return Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                              padding: const EdgeInsets.all(20),
                              child: Row(
                                children: [
                                  Container(
                                    height: 100,
                                    width: 90,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: colors,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                        product['image'],
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
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        (product['title'].split(' ').take(3).join(' ') + (product['title'].split(' ').length > 3 ? '...' : '')).toString().toUpperCase(),
                                        style: GoogleFonts.nunito(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        "\$${formatPrice(product['totalPrice'])} VND",
                                        style: GoogleFonts.nunito(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "Size: ${product['size']}",
                                        style: GoogleFonts.nunito(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                      SizedBox(height:10),
                                      Container(
                                        width: 15,
                                        height: 15,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(int.parse('0xFF${product['color']}')),
                                        ),
                                      ),
                                    ]
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 22,
                            right: 35,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    final product = products[index];  // products là danh sách sản phẩm
                                    final productID = product['productId'];
                                    await _showRemoveDialog(index, productID, widget.userID);
                                    setState(() {});
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  height: 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: buttonColor2,
                                    border: Border.all(
                                      color: Colors.grey.shade400,
                                      width: 2,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(width: 10),
                                      productQuantity(
                                        Icons.add,
                                        index,
                                        _updateQuantity,
                                      ),
                                      const SizedBox(width: 7),
                                      Text(
                                        product['quantity'].toString(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      productQuantity(
                                        Icons.remove,
                                        index,
                                        _updateQuantity,
                                      ),
                                      const SizedBox(width: 10),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
