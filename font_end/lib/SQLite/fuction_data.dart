import "dart:io";
import "dart:math";
import "package:e_commerce_project/jsonModel/CartItem.dart";
import "package:e_commerce_project/jsonModel/users.dart";
import "package:path/path.dart";
import "package:sqflite/sqflite.dart";
class DatabaseHelper {
  final databaseName = "Ecommerce_project.db";
  
  String productTable = '''
    CREATE TABLE products (
      productID INTEGER PRIMARY KEY AUTOINCREMENT,
      productName TEXT NOT NULL,
      productDescription TEXT,
      productPrice REAL NOT NULL,
      productCategory TEXT NOT NULL,
    );
  ''';
  
  String productColor = '''
    CREATE TABLE productColors (
      productID INTEGER NOT NULL,
      colorCode TEXT NOT NULL,
      FOREIGN KEY (productID) REFERENCES products (productID)
    );
  ''';
  
  String productReview = '''
    CREATE TABLE reviews (
      productID INTEGER NOT NULL,
      userID INTEGER NOT NULL,
      reviewText TEXT,
      rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
      reviewDate DATETIME DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (productID) REFERENCES products (productID)
    );
  ''';
  
  String productImage = '''
    CREATE TABLE productImages (
      productID INTEGER NOT NULL,
      imageURL TEXT NOT NULL,
      FOREIGN KEY (productID) REFERENCES products (productID)
    );
  ''';
  
  String userTable = '''
    CREATE TABLE users (
      userID INTEGER PRIMARY KEY AUTOINCREMENT,
      userName TEXT UNIQUE,
      userPassword TEXT NOT NULL,
      userEmail TEXT NOT NULL,
      userPhone TEXT,
      userAddress TEXT,
      userImage TEXT,
      otp TEXT,
      admin BOOL
    );
  ''';
  String productAmount ='''
    CREATE TABLE productSizes (
      productID INTEGER NOT NULL,
      SizeM INTEGER,
      SizeL INTEGER,
      SizeXL INTEGER,
      SizeXXL INTEGER,
      FOREIGN KEY (productID) REFERENCES products (productID),
    );
  ''';


  Future<Database> initDB() async {
    // Sử dụng đường dẫn gốc hiện tại
    final directory = Directory('/Users/kans_12/Downloads/E-commerce_project/font_end/data');
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    final path = join(directory.path, databaseName);
    final file = File(path); 
    if (!await file.exists()) {
       await file.create(recursive: true); 
    } 
    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(productAmount );
    },
    readOnly: false,
    );
  }

  //Login Method
  Future<Map<String, dynamic>?> login(Users user) async {
    final Database db = await initDB();

    // Truy vấn cơ sở dữ liệu để tìm user với email và password
    var result = await db.rawQuery('''
      SELECT userID, admin
      FROM users 
      WHERE userEmail = ? AND userPassword = ?
    ''', [user.userEmail, user.userPassword]);

    // Nếu kết quả không rỗng, trả về userID và isAdmin, ngược lại trả về null
    if (result.isNotEmpty) {
      return {
        'userID': result.first['userID'] as int,
        'admin': result.first['admin'], // Sử dụng trực tiếp giá trị boolean
      };
    } else {
      return null;
    }
  }

  //Get user email
  Future<List<Map<String, dynamic>>> getUserByEmail(String email) async {
    final db = await initDB();
    return await db.query('users', where: 'userEmail = ?', whereArgs: [email]);
  }

  //check email xem đã đc tài khoản nào sử dụng không?
  Future<int?> getUserIDByEmail(String email) async {
    final db = await initDB();
    var result = await db.query(
      'users',
      columns: ['userID'], // Chỉ lấy cột userID
      where: 'userEmail = ?',
      whereArgs: [email],
    );

    if (result.isEmpty) {
      return null; // Nếu không tìm thấy email, trả về null
    } else {
      return result.first['userID'] as int; // Trả về userID
    }
  }


  // Lấy OTP từ cơ sở dữ liệu dựa trên email
  Future<String?> getStoredOTP(String email) async {
    final db = await initDB();
    List<Map> result = await db.query(
      "users",
      columns: ["otp"],
      where: "userEmail = ?",
      whereArgs: [email],
    );
    if (result.isNotEmpty) {
      return result.first["otp"] as String?;
    }
    return null;
  }

  // Update otp
  Future<void> updateOTP(String email, String otp) async {
    final db = await initDB();
    await db.rawUpdate('UPDATE users SET otp = ? WHERE userEmail = ?', [otp, email]);
  }

  //Update password
  Future<void>updatePw(String email, String password) async{
    final db = await initDB();
    await db.rawUpdate('UPDATE users set userPassword = ? WHERE userEmail = ?', [password,email]);
  }

  //Sign up Method
  Future<int>signup(Users user) async{
    final Database db = await initDB();
    return db.insert("users", user.toMap());

  }

  // function take infor for item home
  Future<List<Map<String, dynamic>>> getRandomProducts() async {
    final db = await initDB();
    String item = '''
      SELECT p.productID, p.productName, p.productPrice,
            (SELECT imageURL FROM productImages WHERE productID = p.productID LIMIT 1) AS imageURL
      FROM products p
    ''';
    List<Map<String, dynamic>> result = await db.rawQuery(item);
    if (result.isEmpty) return [];
    return result;
  }

  // Hàm lấy màu theo productID
  Future<List<String>> getColorsByProductID(int productID) async {
    final db = await initDB();
    // Thực hiện truy vấn để lấy màu của sản phẩm
    List<Map<String, dynamic>> result = await db.query(
      'productColors', // Tên bảng màu
      columns: ['colorCode'], // Cột màu
      where: 'productID = ?', // Điều kiện tìm kiếm theo productID
      whereArgs: [productID], // Truyền vào productID cần tìm
    );
    // Chuyển đổi kết quả thành danh sách các màu sắc (List<String>)
    List<String> colors = result.isNotEmpty
        ? result.map((row) => row['colorCode'] as String).toList()
        : [];
    
    return colors;
  }
  // Hàm lấy ảnh theo productID
  Future<List<Map<String, dynamic>>> getImageByProductID(int productID) async {
    final db = await initDB();
    // Thực hiện truy vấn để lấy màu của sản phẩm
    List<Map<String, dynamic>> result = await db.query(
      'productImages', // Tên bảng màu
      columns: ['imageURL'], // Cột màu
      where: 'productID = ?', // Điều kiện tìm kiếm theo productID
      whereArgs: [productID], // Truyền vào productID cần tìm
    );
    return result;
  }

  // lấy thông tin cho items_details
  Future<List<Map<String, dynamic>>> getDetailsByProductid(int productID) async {
    final db = await initDB();
    // Thực hiện truy vấn
    final result = await db.rawQuery('''
      SELECT 
          p.productID, 
          p.productName, 
          p.productPrice, 
          IFNULL(AVG(r.rating), 0) AS averageRating, 
          COUNT(r.rating) AS totalReviews
      FROM 
          products p
      LEFT JOIN 
          reviews r ON p.productID = r.productID
      GROUP BY 
          p.productID;
    '''
    );
    return result;
  }

  //số lượng sản phẩm theo từng size
  Future<List<int>> getProductSizes(int productID) async {
    final db = await initDB(); // Hàm khởi tạo kết nối DB
    final result = await db.rawQuery('''
      SELECT 
        SizeM AS sizeM,
        SizeL AS sizeL,
        SizeXL AS sizeXL,
        SizeXXL AS sizeXXL
      FROM productSizes
      WHERE productID = ?
    ''', [productID]);

    if (result.isNotEmpty) {
      // Trích xuất các giá trị và chuyển đổi sang List<int>
      final sizes = result.first.values.map((value) => value as int).toList();
      return sizes;
    } else {
      return [0, 0, 0, 0]; // Trả về danh sách mặc định nếu không có dữ liệu
    }
  }
  
  Future<List<int>> getProductSizesByColor(int productID, String colorCode) async {
    final db = await initDB();

    // Truy vấn để lấy productColorID dựa trên productID và mã màu (colorCode)
    final colorResult = await db.rawQuery('''
      SELECT productColorID
      FROM productColors
      WHERE productID = ? AND colorCode = ?
    ''', [productID, colorCode]);

    if (colorResult.isEmpty) {
      // Không tìm thấy productColorID, trả về danh sách mặc định
      return [0, 0, 0, 0];
    }

    final productColorID = colorResult.first['productColorID'] as int;

    // Truy vấn để lấy thông tin size dựa trên productID và productColorID
    final sizeResult = await db.rawQuery('''
      SELECT 
        SizeM AS sizeM,
        SizeL AS sizeL,
        SizeXL AS sizeXL,
        SizeXXL AS sizeXXL
      FROM productSizes
      WHERE productID = ? AND productColorID = ?
    ''', [productID, productColorID]);

    if (sizeResult.isNotEmpty) {
      // Trích xuất các giá trị và chuyển đổi sang List<int>
      final sizes = sizeResult.first.values.map((value) => value as int).toList();
      return sizes;
    } else {
      return [0, 0, 0, 0]; // Trả về danh sách mặc định nếu không có dữ liệu
    }
  }

  //Lấy description
  Future<String?> getDescription(int productID) async {
  final db = await initDB();
  final result = await db.query(
    'products', 
    columns: ['productDescription'], 
    where: 'productID = ?', 
    whereArgs: [productID], 
  );

  if (result.isNotEmpty) {
    return result.first['productDescription'] as String?; // Trả về mô tả
  } else {
    return null; 
  }
  }
  //lấy thông tin cho trang cart
  Future<Map<String, dynamic>> getDetailsByProductId(int productID) async {
    final db = await initDB();

    // Truy vấn lấy thông tin sản phẩm và hình ảnh đầu tiên từ bảng products và productImages
    final result = await db.rawQuery('''
      SELECT 
          p.productID, 
          p.productName, 
          p.productPrice, 
          pi.imageURL
      FROM 
          products p
      LEFT JOIN 
          productImages pi ON p.productID = pi.productID
      WHERE 
          p.productID = ?
      GROUP BY 
          p.productID
      LIMIT 1;
    ''', [productID]); // Truyền tham số tránh SQL Injection

    // Kiểm tra nếu có kết quả trả về
    if (result.isNotEmpty) {
      return result.first; // Trả về thông tin sản phẩm và ảnh đầu tiên
    } else {
      return {}; // Trả về Map rỗng nếu không có dữ liệu
    }
  }

  // insert thông tin lên cart table
  Future<void> insertCart({
    required int userID,
    required int productID,
    required String productName,
    required double productPrice,
    required int quantity,
    required String imageURL,
    required String color,
    required String size,
  }) async {
    final Database db = await DatabaseHelper().initDB();

    // Thêm dữ liệu vào bảng cart
    await db.rawInsert('''
      INSERT INTO cart (
        userID, 
        productID, 
        productName, 
        productPrice, 
        quantity, 
        imageURL, 
        color, 
        size
      ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    ''', [
      userID,
      productID,
      productName,
      productPrice,
      quantity,
      imageURL,
      color,
      size,
    ]);
  }

  Future<List<CartItem>> getCartItemsByUserID(int userID) async {
    final db = await initDB();

    // Thực hiện truy vấn lấy tất cả sản phẩm trong giỏ hàng theo userID
    final List<Map<String, dynamic>> maps = await db.query(
      'cart',
      where: 'userID = ?',
      whereArgs: [userID],
    );

    // Chuyển đổi danh sách các Map thành danh sách CartItem
    return List.generate(maps.length, (i) {
      return CartItem.fromMap(maps[i]);
    });
  }

  // Cập nhật số lượng sản phẩm trong giỏ hàng của người dùng
  Future<void> updateProductQuantity(int userID, int productID, int quantity) async {
    final db = await initDB();

    // Cập nhật số lượng sản phẩm trong bảng cart
    await db.update(
      'cart', // Tên bảng
      {'quantity': quantity}, // Cập nhật cột quantity
      where: 'userID = ? AND productID = ?', // Điều kiện lọc theo user_id và product_id
      whereArgs: [userID, productID], // Tham số điều kiện
    );
  }

  // Xóa sản phẩm khỏi giỏ hàng của người dùng
  Future<void> removeProductFromCart(int userID, int productID) async {
    final db = await initDB();
    
    await db.delete(
      'cart',
      where: 'userID = ? AND productID = ?',
      whereArgs: [userID, productID],
    );
  }
  
  //Hàm lấy productID của tất cả sản phẩm có trong giỏ hàng của theo userID
  Future<List<int>> getProductIDsFromCart(int userID) async {
    final db = await initDB();
    List<Map<String, dynamic>> result = await db.query(
      'cart', // Tên bảng giỏ hàng
      columns: ['productID'], // Chỉ lấy productID
      where: 'userID = ?', // Lọc theo userID
      whereArgs: [userID],
    );
    // Trả về danh sách productID
    return result.map((row) => row['productID'] as int).toList();
  }

  //get cartID by userID 
  Future<List<int>> getcartIDsFromCart(int userID) async {
    final db = await initDB();
    List<Map<String, dynamic>> result = await db.query(
      'cart', // Tên bảng giỏ hàng
      columns: ['cartID'], // Chỉ lấy cartID
      where: 'userID = ?', // Lọc theo userID
      whereArgs: [userID],
    );
    // Trả về danh sách productID
    return result.map((row) => row['cartID'] as int).toList();
  }

  // Hàm kiểm tra mã giảm giá
  Future<Map<String, dynamic>?> checkDiscountCode( String discountCode, int productID) async {
    final db = await initDB();

    // Truy vấn cơ sở dữ liệu để lấy thông tin mã giảm giá
    List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT discountPercentage FROM discounts 
      WHERE discountCode = ? 
      AND startDate <= ? 
      AND endDate >= ? 
      AND (
        (applyToAllProducts = 1) OR 
        (applyToAllProducts = 0 AND productID = ?)
      )
    ''', [
      discountCode,
      DateTime.now().toIso8601String(),
      DateTime.now().toIso8601String(),
      productID
    ]);

    // Kiểm tra xem mã giảm giá có hợp lệ hay không
    if (result.isNotEmpty) {
      // Nếu có, trả về thông tin mã giảm giá
      return result[0];
    } else {
      // Nếu không hợp lệ, trả về null
      return null;
    }
  }

  Future<double?> getProductPriceWithDiscountCode(String? discountCode) async {
    final db = await initDB();
    var result = await db.rawQuery('''
      SELECT p.productPrice
      FROM products p
      LEFT JOIN discounts d ON p.productID = d.productID
      WHERE d.discountCode = ? AND (d.applyToAllProducts = 1 OR p.productID = d.productID)
    ''', [discountCode]);

    if (result.isNotEmpty) {
      var product = result.first;
      if (product['productPrice'] != null) {
        return product['productPrice'] as double?;
      }
    }
  }


  //Get userPhone, userAddress, userEmail from db
  Future<Map<String, String?>> getUserContactInfo(int userID) async {
    final db = await initDB();
    var result = await db.rawQuery('''
      SELECT userPhone, userAddress, userEmail
      FROM users
      WHERE userID = ?
    ''', [userID]);

    if (result.isNotEmpty) {
      var user = result.first;
      return {
        'userPhone': user['userPhone'] as String?,
        'userAddress': user['userAddress'] as String?,
        'userEmail': user['userEmail'] as String?,
      };
    } else {
      return {
        'userPhone': null,
        'userAddress': null,
        'userEmail': null,
      };
    }
  }

  //update sđt, địa chỉ
  Future<void> updateUserContactInfo(int userID, String? userPhone, String? userAddress) async {
    final db = await initDB();
    await db.rawUpdate('''
      UPDATE users 
      SET userPhone = ?, userAddress = ? 
      WHERE userID = ?
    ''', [userPhone, userAddress, userID]);
  }

  //update thông tin số lương sản phẩm theo size, màu và productID
  Future<bool> deleteProductQuantityByColorCode(int productID, String colorCode, String size, int quantity) async {
    final db = await initDB();
    final sizeColumn = size == 'M'
        ? 'SizeM'
        : size == 'L'
            ? 'SizeL'
            : size == 'XL'
                ? 'SizeXL'
                : size == 'XXL'
                    ? 'SizeXXL'
                    : null;

    if (sizeColumn == null) {
      throw Exception('Invalid size: $size');
    }
    // Tra cứu productColorID từ bảng productColors bằng colorCode
    final colorResult = await db.query(
      'productColors',
      columns: ['productColorID'],
      where: 'productID = ? AND colorCode = ?',
      whereArgs: [productID, colorCode],
    );
    if (colorResult.isEmpty) {
      return false;
    }
    final productColorID = colorResult.first['productColorID'] as int;
    final currentQuantityResult = await db.query(
      'productSizes',
      columns: [sizeColumn],
      where: 'productID = ? AND productColorID = ?',
      whereArgs: [productID, productColorID],
    );
    if (currentQuantityResult.isEmpty) {
      return false;
    }
    int currentQuantity = currentQuantityResult.first[sizeColumn] as int;
    if (currentQuantity < quantity) {
      return false;
    }
    // Cập nhật số lượng mới
    final newQuantity = currentQuantity - quantity;
    await db.update(
      'productSizes',
      {sizeColumn: newQuantity},
      where: 'productID = ? AND productColorID = ?',
      whereArgs: [productID, productColorID],
    );

    return true;
  }


  //xoá thông tin trong giỏ hàng theo userID
  Future<int> clearCart(int userID) async {
    final db = await initDB();
    return await db.delete(
      'cart',
      where: 'userID = ?',
      whereArgs: [userID],
    );
  }

  // Hàm lấy số lượng tồn kho của sản phẩm theo ID, màu sắc và kích thước
  Future<Map<String, dynamic>> getProductStock(int productID, String colorCode, String size) async {
    final db = await initDB();
    // Lấy thông tin về productColorID từ bảng productColors theo productID và colorCode
    var colorResult = await db.query(
      'productColors',
      columns: ['productColorID'],
      where: 'productID = ? AND colorCode = ?',
      whereArgs: [productID, colorCode],
    );
    if (colorResult.isEmpty) {
      return {'stockQuantity': 0}; // Nếu không tìm thấy productColorID, trả về số lượng tồn kho = 0
    }
    // Lấy productColorID từ kết quả truy vấn
    int productColorID = colorResult.first['productColorID'] as int;
    // Xác định tên cột tương ứng với kích thước
    String sizeColumn;
    if (size == 'M') sizeColumn = 'SizeM';
    else if (size == 'L') sizeColumn = 'SizeL';
    else if (size == 'XL') sizeColumn = 'SizeXL';
    else if (size == 'XXL') sizeColumn = 'SizeXXL';
    else throw Exception('Invalid size: $size');
    // Truy vấn số lượng tồn kho của sản phẩm với điều kiện phù hợp
    var result = await db.query(
      'productSizes',
      columns: [sizeColumn],
      where: 'productID = ? AND productColorID = ?',
      whereArgs: [productID, productColorID], // Dùng productColorID
    );
    if (result.isEmpty) {
      return {'stockQuantity': 0}; // Không có dữ liệu, trả về số lượng tồn kho = 0
    }
    int stockQuantity = result.first[sizeColumn] as int? ?? 0;
    return {'stockQuantity': stockQuantity};
  }

  // Save data to order
  Future<void> saveDataToOrder(int cartID, int? discountID, int? productID) async {
    final db = await initDB();
    try {
      final List<Map<String, dynamic>> cartData = await db.query(
        'cart',
        where: 'cartID = ?',
        whereArgs: [cartID],
      );
      if (cartData.isEmpty) {
        throw Exception('Cart item not found with cartID: $cartID');
      }
      final cartItem = cartData.first;

      
      if (productID != null) {
        if (cartItem['productID'] == productID) {
          var discountInfo = await db.query(
            'discounts',
            where: 'discountID = ? AND productID = ?',
            whereArgs: [discountID, productID],
          );
          if (discountInfo.isEmpty) {
            discountID = null;
          }
        } else {
          discountID = null;
        }
      }

      // Nếu productID == null, tất cả sản phẩm sẽ có discountID
      final orderData = {
        'userID': cartItem['userID'],
        'productID': cartItem['productID'],
        'productName': cartItem['productName'],
        'productPrice': cartItem['productPrice'],
        'quantity': cartItem['quantity'],
        'imageURL': cartItem['imageURL'],
        'color': cartItem['color'],
        'size': cartItem['size'],
        'discountID': discountID,
      };

      await db.insert('orders', orderData);
    } catch (e) {
      print('Error moving cart item to orders: $e');
    }
  }

  //get discountID by discountcode
  Future<Map<String, dynamic>?> getDiscountIDAndProductIDByCode(String? discountCode) async {
    if (discountCode == null || discountCode.trim().isEmpty) return null;

    final db = await initDB();
    var result = await db.rawQuery('''
      SELECT discountID, productID, applyToAllProducts
      FROM discounts
      WHERE discountCode = ?
    ''', [discountCode.trim()]);

    if (result.isNotEmpty) {
      var discount = result.first;
      // Kiểm tra nếu mã giảm giá áp dụng cho tất cả sản phẩm
      bool isApplyToAll = discount['applyToAllProducts'] == 1;

      return {
        'discountID': discount['discountID'] as int?,
        'productID': isApplyToAll ? null : discount['productID'] as int?,
      };
    }
    return null;
  }
}