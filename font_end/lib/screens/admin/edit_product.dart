import 'package:e_commerce_project/SQLite/ad_fuction_data.dart';
import 'package:e_commerce_project/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProductScreen extends StatefulWidget {
  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final DatabaseHelper2 db = DatabaseHelper2();
  void updateInfoProduct(String tableName, Map<String, dynamic> formData) async {
    try {
      await db.updateData(tableName, formData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Data saved successfully!"),
          backgroundColor: Colors.green,
        ),
      );
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
          "Edit Data",
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorcontent,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: tables.length,
          itemBuilder: (context, index) {
            String keyname = tables.keys.toList()[index];
            String tableName = tables.values.toList()[index];// Sửa lỗi truy cập Map
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
                    offset: Offset(3, 3),
                  )
                ],
              ),
              child: ListTile(
                title: Text(
                  keyname, // Sửa lỗi
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: const Icon(Icons.edit, color: colorcontent),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EditTableDataScreen(tableName: tableName, keyname: keyname,),
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

class EditTableDataScreen extends StatefulWidget {
  final String keyname;
  final String tableName;

  const EditTableDataScreen({Key? key, required this.tableName, required this.keyname})
      : super(key: key);

  @override
  _EditTableDataScreenState createState() => _EditTableDataScreenState();
}

class _EditTableDataScreenState extends State<EditTableDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};
  final DatabaseHelper2 db = DatabaseHelper2();
  void updateInfoProduct(String tableName, Map<String, dynamic> formData) async {
    try {
      await db.updateData(tableName, formData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Data saved successfully!"),
          backgroundColor: Colors.green,
        ),
      );
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
          "Edit ${widget.keyname} Infor",
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorcontent,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Edit Details for ${widget.keyname}:",
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
                      initialValue: _formData[field['key']]?.toString() ?? '',
                      decoration: InputDecoration(
                        focusColor: Colors.white,
                        labelText: field['label'],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      onSaved: (value) {
                        if (value != null && value.isNotEmpty) {
                          _formData[field['key'] ?? ''] = value;
                        }
                      },
                      validator: (value) {
                        // Kiểm tra nếu trường là bắt buộc
                        if ((field['key'] == 'productID' ||
                            field['key'] == 'productColorID' ||
                            field['key'] == 'discountID' ||
                            field['key'] == 'imageID') &&
                            (value == null || value.isEmpty)) {
                          return "${field['label']} is required.";
                        }
                        // Các trường không bắt buộc thì không cần báo lỗi
                        return null;
                      },
                    ),
                  );
                }).toList(),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        updateInfoProduct(widget.tableName, _formData);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorcontent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Update Data",
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
          {'key': 'productName', 'label': 'Product Name', 'type': 'TEXT'},
          {'key': 'productDescription', 'label': 'Product Description', 'type': 'TEXT'},
          {'key': 'productPrice', 'label': 'Product Price', 'type': 'REAL'},
          {'key': 'productCategory', 'label': 'Product Category', 'type': 'TEXT'},
        ];
      case "productSizes":
        return [
          {'key': 'productID', 'label': 'Product ID', 'type': 'INTEGER'},
          {'key': 'productColorID', 'label': 'Product Color ID', 'type': 'INTEGER'},
          {'key': 'SizeM', 'label': 'Size M Quantity', 'type': 'INTEGER'},
          {'key': 'SizeL', 'label': 'Size L Quantity', 'type': 'INTEGER'},
          {'key': 'SizeXL', 'label': 'Size XL Quantity', 'type': 'INTEGER'},
          {'key': 'SizeXXL', 'label': 'Size XXL Quantity', 'type': 'INTEGER'},
        ];
      case "productImages":
        return [
          {'key': 'productID', 'label': 'Product ID', 'type': 'INTEGER'},
          {'key': 'imageID', 'label': 'Image ID', 'type': 'INTEGER'},
          {'key': 'imageURL', 'label': 'Image URL', 'type': 'TEXT'},
        ];
      case "productColors":
        return [
          {'key': 'productID', 'label': 'Product ID', 'type': 'INTEGER'},
          {'key': 'productColorID', 'label': 'Product Color ID', 'type': 'INTEGER'},
          {'key': 'colorCode', 'label': 'Color Code', 'type': 'TEXT'},
        ];
      case "discounts":
        return [
          {'key': 'discountID', 'label': 'Discount ID', 'type': 'INTEGER'},
          {'key': 'discountName', 'label': 'Discount Name', 'type': 'TEXT'},
          {'key': 'discountCode', 'label': 'Discount Code', 'type': 'TEXT'},
          {'key': 'discountPercentage', 'label': 'Discount Percentage', 'type': 'REAL'},
          {'key': 'applyToAllProducts', 'label': 'Apply To All Products (true/false)', 'type': 'BOOLEAN'},
          {'key': 'productID', 'label': 'Product ID', 'type': 'INTEGER'},
          {'key': 'startDate', 'label': 'Start Date (YYYY-MM-DD)', 'type': 'DATE'},
          {'key': 'endDate', 'label': 'End Date (YYYY-MM-DD)', 'type': 'DATE'},
        ];
      default:
        return [];
    }
  }
}
