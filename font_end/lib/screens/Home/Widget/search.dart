import 'package:e_commerce_project/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration:BoxDecoration(
        color: colors,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.transparent),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      child: Row(
        children:[
          Icon(
            Icons.search, 
            color: Colors.grey,
            size: 30,
          ),
          SizedBox(width: 10),
          Flexible(
            flex: 4,
            child: TextField(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10),
                hintText: "Search",
                hintStyle: GoogleFonts.nunito(fontSize: 16),
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            height: 25,
            width: 1.5,
            color: Colors.grey,
          ),
          IconButton(
          onPressed: (){}, 
          icon: const Icon(
            Icons.tune, 
            color: Colors.grey,
            ),
          ),
        ],
      )
    );
  }
}