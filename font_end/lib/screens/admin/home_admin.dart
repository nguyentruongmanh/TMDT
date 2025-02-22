import 'package:e_commerce_project/SQLite/ad_fuction_data.dart';
import 'package:e_commerce_project/authentication/Verify_otp/verify_signup_screen.dart';
import 'package:e_commerce_project/constants.dart';
import 'package:e_commerce_project/screens/admin/add_product.dart';
import 'package:e_commerce_project/screens/admin/delete_product.dart';
import 'package:e_commerce_project/screens/admin/edit_product.dart';
import 'package:e_commerce_project/screens/admin/orders_detail.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeAdmin extends StatefulWidget {
  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {

  int? totalproduct;
  int? totalorder;
  @override
  void initState(){
    super.initState();
    countproduct();
    countorder();
  }
  Future<void> countproduct()async {
    int? result = await DatabaseHelper2().countProducts();
    setState(() {
      totalproduct = result;
    });
  }
  Future<void> countorder()async {
    int? result = await DatabaseHelper2().countOrders();
    setState(() {
      totalorder = result;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Layer Apps",
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorcontent,
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          right: 16,
          left: 16,
          top: 25,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(3, 3),
                        )
                      ],
                    ),
                    child: _buildBox(
                      context,
                      title: "Add",
                      description: "Add data",
                      color: Colors.blue[100]!,
                      icon: Icons.add,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> AddDataScreen()));
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8), // Spacing between boxes
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(3, 3),
                        )
                      ],
                    ),
                    child: _buildBox(
                      context,
                      title: "Delete",
                      description: "Delete data",
                      color: Colors.red[100]!,
                      icon: Icons.delete,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> DeleteProductScreen()));
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8), // Spacing between boxes
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(3, 3),
                        )
                      ],
                    ),
                    child: _buildBox(
                      context,
                      title: "Edit",
                      description: "Edit data",
                      color: Colors.green[100]!,
                      icon: Icons.edit,
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProductScreen()));
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Các box khác (Total Products, Orders)
            SizedBox(
              width: double.infinity,
              child: Container(
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
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Products in Stock",
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$totalproduct',
                        style: GoogleFonts.nunito(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Container(
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
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>OrdersDetails()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total Orders in Delivery",
                          style: GoogleFonts.nunito(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$totalorder',
                          style: GoogleFonts.nunito(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm tạo box
  Widget _buildBox(BuildContext context,
      {required String title,
      required String description,
      required Color color,
      required IconData icon,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: Colors.black54),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.nunito(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: GoogleFonts.nunito(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
