import 'package:e_commerce_project/SQLite/ad_fuction_data.dart';
import 'package:e_commerce_project/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:synchronized/synchronized.dart';

class AddDataScreen extends StatefulWidget {
  @override
  State<AddDataScreen> createState() => _AddDataScreenState();
}

class _AddDataScreenState extends State<AddDataScreen> {
  final DatabaseHelper2 _databaseHelper = DatabaseHelper2();
  final Lock _lock = Lock();
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
          "Add New Data",
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
            String tableName1 = tables.keys.toList()[index];
            String tableName = tables.values.toList()[index];
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
                  )
                ],
              ),
              child: ListTile(
                title: Text(
                  tableName1,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward,
                  color: colorcontent,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddTableDataScreen(tableName: tableName, tableName1: tableName1),
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

class AddTableDataScreen extends StatefulWidget {
  final String tableName;
  final String tableName1;

  const AddTableDataScreen({Key? key, required this.tableName, required this.tableName1})
      : super(key: key);

  @override
  _AddTableDataScreenState createState() => _AddTableDataScreenState();
}

class _AddTableDataScreenState extends State<AddTableDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};
  final Lock _lock = Lock();

  void saveData(String tableName, Map<String, dynamic> formData) async {
    final DatabaseHelper2 _databaseHelper = DatabaseHelper2();

    try {
      await _lock.synchronized(() async {
        await _databaseHelper.insertData(tableName, formData);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Data saved successfully!"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error saving data: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> fields = getFields(widget.tableName);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Add Data to ${widget.tableName1}",
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
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Enter Details for ${widget.tableName1}:",
                  style: GoogleFonts.nunito(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colorcontent,
                  ),
                ),
                const SizedBox(height: 20),
                ...fields.map((field) {
                  if (field['type'] == 'BOOLEAN') {
                    return DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: field['label'],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: "true",
                          child: Text("True"),
                        ),
                        DropdownMenuItem(
                          value: "false",
                          child: Text("False"),
                        ),
                      ],
                      onChanged: (value) {
                        _formData[field['key'] ?? ''] = value == "true";
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "${field['label']} is required.";
                        }
                        return null;
                      },
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: field['label'],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: field['type'] == 'REAL'
                            ? TextInputType.number
                            : TextInputType.text,
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
                  }
                }).toList(),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        saveData(widget.tableName, _formData);
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
                      "Save Data",
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
          {'key': 'imageURL', 'label': 'Image URL', 'type': 'TEXT'},
        ];
      case "productColors":
        return [
          {'key': 'productID', 'label': 'Product ID', 'type': 'INTEGER'},
          {'key': 'colorCode', 'label': 'Color Code', 'type': 'TEXT'},
        ];
      case "discounts":
        return [
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
