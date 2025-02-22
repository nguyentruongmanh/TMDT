import 'package:e_commerce_project/SQLite/ad_fuction_data.dart';
import 'package:e_commerce_project/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeleteProductScreen extends StatefulWidget {
  @override
  State<DeleteProductScreen> createState() => _DeleteProductScreenState();
}

class _DeleteProductScreenState extends State<DeleteProductScreen> {
  final DatabaseHelper2 db = DatabaseHelper2();
  void deleteData(String tableName, Map<String, dynamic> formData) async {
    try {
      // Gọi hàm insertData để lưu vào bảng
      await db.deleteData(tableName, formData);

      // Hiển thị thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Data deleted successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      // Quay lại màn hình trước
      Navigator.pop(context);
    } catch (e) {
      // Xử lý lỗi nếu xảy ra
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error deleting data: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    final tables = {
        "Products": "products",
        "Product Sizes": "productSizes",
        "Product Images": "productImages",
        "Product Colors": "productColors",
        "Discounts": "discounts",
      };

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Delete Data",
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorcontent,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: tables.length,
          itemBuilder: (context, index) {
            String keyname = tables.keys.toList()[index];
            String tableName = tables.values.toList()[index]; // Lấy tên bảng từ keys của map
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(3, 3),
                  ),
                ],
              ),
              child: ListTile(
                title: Text(
                  keyname,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: const Icon(Icons.delete, color: Colors.grey),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DeleteTableDataScreen(tableName: tableName, keyname: keyname,),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class DeleteTableDataScreen extends StatefulWidget {
  final String keyname;
  final String tableName;

  const DeleteTableDataScreen({Key? key, required this.tableName, required this.keyname})
      : super(key: key);

  @override
  _DeleteTableDataScreenState createState() => _DeleteTableDataScreenState();
}

class _DeleteTableDataScreenState extends State<DeleteTableDataScreen> {
  final DatabaseHelper2 db = DatabaseHelper2();
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};
  void deleteData(String tableName, Map<String, dynamic> formData) async {
    try {
      // Gọi hàm insertData để lưu vào bảng
      await db.deleteData(tableName, formData);

      // Hiển thị thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Data deleted successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      // Quay lại màn hình trước
      Navigator.pop(context);
    } catch (e) {
      // Xử lý lỗi nếu xảy ra
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error saving data: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> fields = getFields(widget.tableName);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Delete ${widget.keyname} Info",
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorcontent,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            right: 20.0,
            bottom: 20,
            left: 20,
            top: 40,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Enter Details to Delete from ${widget.keyname}:",
                  style: GoogleFonts.nunito(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorcontent,
                  ),
                ),
                const SizedBox(height: 20),
                ...fields.map((field) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: field['label'],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      onSaved: (value) {
                        _formData[field['key'] ?? ''] = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "${field['label']} is required.";
                        }
                        return null;
                      },
                    ),
                  );
                }).toList(),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        deleteData(widget.tableName, _formData);
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Delete Data",
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  List<Map<String, String>> getFields(String tableName) {
    switch (tableName) {
      case "products":
        return [
          {'key': 'productID', 'label': 'Product ID', 'type': 'INTEGER'},
        ];
      case "productSizes":
        return [
          {'key': 'productID', 'label': 'Product ID', 'type': 'INTEGER'},
          {'key': 'productColorID', 'label': 'Product Color ID', 'type': 'INTEGER'},
        ];
      case "productImages":
        return [
          {'key': 'productID', 'label': 'Product ID', 'type': 'INTEGER'},
          {'key': 'imageID', 'label': 'Image ID', 'type': 'INTEGER'},
        ];
      case "productColors":
        return [
          {'key': 'productID', 'label': 'Product ID', 'type': 'INTEGER'},
          {'key': 'productColorID', 'label': 'Product Color ID', 'type': 'INTEGER'},
        ];
      case "discounts":
        return [
          {'key': 'productID', 'label': 'Product ID', 'type': 'INTEGER'},
          {'key': 'discountID', 'label': 'Discount ID', 'type': 'INTEGER'},
        ];
      default:
        return [];
    }
  }
}