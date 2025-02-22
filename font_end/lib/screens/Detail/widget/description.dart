import 'package:e_commerce_project/SQLite/fuction_data.dart';
import 'package:flutter/material.dart';
import 'package:e_commerce_project/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class Description extends StatelessWidget {
  final int productId;
  const Description({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final dbHelper = DatabaseHelper();

    return Container(
      padding: EdgeInsets.only(
        right: 5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 120,
                height: 40,
                decoration: BoxDecoration(
                  color: colorcontent,
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Description",
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16
                  ),
                ),
              ),
              Text(
                "Specifications",
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16
                ),
              ),
              Text(
                "Reviews",
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          FutureBuilder<String?>(
            future: dbHelper.getDescription(productId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                );
              } else if (!snapshot.hasData || snapshot.data == null) {
                return const Text(
                  'No description available.',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                );
              } else {
                return Container(
                  padding: EdgeInsets.only(left:5),
                  child: Text(
                    snapshot.data!,
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}
