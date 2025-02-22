import 'package:flutter/material.dart';

class Product extends ChangeNotifier {
  int _quantity = 0;

  int get getquantity =>_quantity;
  void setquantity(int quantity){
    _quantity = quantity;
    notifyListeners();
  }
}