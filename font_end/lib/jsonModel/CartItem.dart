class CartItem {
  final int cartID;
  final int userID;
  final int productID;
  final String productName;
  final double productPrice;
  int quantity;
  final String imageURL;
  final String color;
  final String size;

  CartItem({
    required this.cartID,
    required this.userID,
    required this.productID,
    required this.productName,
    required this.productPrice,
    required this.quantity,
    required this.imageURL,
    required this.color,
    required this.size,
  });

  // Hàm tạo CartItem từ Map (để ánh xạ kết quả truy vấn)
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      cartID: map['cartID'],
      userID: map['userID'],
      productID: map['productID'],
      productName: map['productName'],
      productPrice: map['productPrice'],
      quantity: map['quantity'],
      imageURL: map['imageURL'],
      color: map['color'],
      size: map['size'], 
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'cartID':cartID,
      'userID': userID,
      'productID': productID,
      'productName': productName,
      'productPrice': productPrice,
      'quantity': quantity,
      'imageURL': imageURL,
      'color': color,
      'size': size,
    };
  }
  static List<CartItem> fromList(List<Map<String, dynamic>> list) {
    return list.map((map) => CartItem.fromMap(map)).toList();
  }
}
