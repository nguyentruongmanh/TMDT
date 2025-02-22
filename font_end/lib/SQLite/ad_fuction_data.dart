import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper2 {
  Future<Database> initDB() async {
    final directory = Directory('/Users/kans_12/Downloads/E-commerce_project/font_end/data');
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    final path = join(directory.path, "Ecommerce_project.db");
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {},
    );
  }
  
  Future<void> closeDB() async {
    final Database db = await initDB();
    await db.close();
  }
  //Add Data
  Future<void> insertData(String tableName, Map<String, dynamic> data) async {
    final db = await initDB();
    await db.insert(
      tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace, // Nếu trùng khóa chính, ghi đè
    );
  }

  //delete
  Future<void> deleteData(String tableName, Map<String, dynamic> conditions) async {
    final db = await initDB();
    try {
      // Thêm dấu ngoặc kép nếu tên bảng chứa khoảng trắng
      final tableNameSafe = tableName.contains(' ') ? '"$tableName"' : tableName;

      final whereClause = conditions.keys.map((key) => '$key = ?').join(' AND ');
      final whereArgs = conditions.values.toList();

      final count = await db.delete(
        tableNameSafe,
        where: whereClause,
        whereArgs: whereArgs,
      );

      print('Deleted $count rows from $tableNameSafe');
    } catch (e) {
      print('Error deleting data from $tableName: $e');
      throw e;
    }
  }

  //update
  Future<void> updateData(String tableName,Map<String, dynamic> formData,) async {
    final db = await initDB();
    // Xác định các trường tìm kiếm ưu tiên
    final List<String> searchFields = ['productID', 'productColorID', 'discountID', 'imageID'];

    // Tìm trường đầu tiên trong formData phù hợp với searchFields
    String? searchField;
    dynamic searchValue;

    for (String field in searchFields) {
      if (formData.containsKey(field) && formData[field] != null && formData[field].toString().isNotEmpty) {
        searchField = field;
        searchValue = formData[field];
        break;
      }
    }

    if (searchField == null || searchValue == null) {
      throw Exception("At least one search field must be provided.");
    }

    // Tạo map chỉ chứa các trường cần cập nhật (bỏ qua các trường null hoặc rỗng)
    final Map<String, dynamic> updateData = {};
    formData.forEach((key, value) {
      if (value != null && value.toString().isNotEmpty) {
        updateData[key] = value;
      }
    });

    // Loại bỏ trường tìm kiếm ra khỏi updateData (vì không cần cập nhật)
    updateData.remove(searchField);

    if (updateData.isEmpty) {
      throw Exception("No fields to update.");
    }

    // Thực hiện cập nhật trong cơ sở dữ liệu
    try {
      final int rowsAffected = await db.update(
        tableName,
        updateData,
        where: '$searchField = ?',
        whereArgs: [searchValue],
      );

      if (rowsAffected == 0) {
        print("No matching rows found to update.");
      } else {
        print("$rowsAffected row(s) updated successfully in $tableName.");
      }
    } catch (e) {
      print("Error updating database: $e");
      throw Exception("Failed to update database.");
    }
  }

  // đếm số lượng sản phẩm
  Future<int> countProducts() async {
    final db = await initDB(); // Hàm khởi tạo kết nối đến cơ sở dữ liệu
    try {
      var result = await db.rawQuery('SELECT COUNT(*) as count FROM products');
      if (result.isNotEmpty) {
        return result.first['count'] as int;
      }
      return 0;
    } catch (e) {
      print("Error counting products: $e");
      return 0;
    }
  }
  // đếm số lượng sản phẩm
  Future<int> countOrders() async {
    final db = await initDB(); // Hàm khởi tạo kết nối đến cơ sở dữ liệu
    try {
      var result = await db.rawQuery('SELECT COUNT(*) as count FROM orders');
      if (result.isNotEmpty) {
        return result.first['count'] as int;
      }
      return 0;
    } catch (e) {
      print("Error counting products: $e");
      return 0;
    }
  }

  // lấy thông tin order
  Future<List<Map<String, dynamic>>> getOrderDetails() async {
    final db = await initDB();
    // Truy vấn từ bảng orders, kết hợp với bảng users và discounts
    var result = await db.rawQuery('''
      SELECT o.orderID, o.productID, o.productName, o.productPrice, o.quantity, o.imageURL, o.color, o.size, 
            o.discountID, -- Thêm discountID từ bảng orders
            u.username, 
            d.discountPercentage
      FROM orders o
      JOIN users u ON o.userID = u.userID
      LEFT JOIN discounts d ON o.discountID = d.discountID
    ''');
    return result;
  }

  Future<Map<String, dynamic>> getDiscountDetails(int discountID) async {
    final db = await initDB();
    var result = await db.query(
      'discounts',
      where: 'discountID = ?',
      whereArgs: [discountID],
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      throw Exception("Discount not found for discountID: $discountID");
    }
  }
  // xoá sản phẩm có trong bảng orders
  Future<void> clearOrdersTable() async {
    final db = await initDB();
    await db.delete('orders');
  }
}
