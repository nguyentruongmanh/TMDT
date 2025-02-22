// To parse this JSON data, do
//
//     final categories = categoriesFromMap(jsonString);

import 'dart:convert';

Product  categoriesFromMap(String str) => Product .fromMap(json.decode(str));

String categoriesToMap(Product  data) => json.encode(data.toMap());

class Product {
    final int productId;
    final String? productName;
    final String? productImage;
    final double? productPrice;
    final String? productDescription;
    final String? productColor;
    final String? productAmount;
    final String? productReview;

    Product ({
        required this.productId,
        this.productName,
        this.productImage,
        this.productPrice,
        this.productDescription,
        this.productColor,
        this.productAmount,
        this.productReview,
    });

    factory Product .fromMap(Map<String, dynamic> json) => Product(
        productId: json["productID"],
        productName: json["productName"],
        productImage: json["productImage"],
        productPrice: json["productPrice"],
        productDescription: json["productDescription"],
        productColor: json["productColor"],
        productAmount: json["productAmount"],
        productReview: json["productReview"],
    );

    Map<String, dynamic> toMap() => {
        "productID": productId,
        "productName": productName,
        "productImage": productImage,
        "productPrice": productPrice,
        "productDescription": productDescription,
        "productColor": productColor,
        "productAmount": productAmount,
        "productReview": productReview,
    };
}
