import 'package:e_commerce_project/jsonModel/categories.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Categories_screen extends StatelessWidget {
  const Categories_screen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder:(context, index){
          return Column(
            children: [
              Container(
                height: 65,
                width: 65,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(categories[index].image), 
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(60),
                ),
              ),
              SizedBox(height: 10,),
              Text(
                categories[index].title.replaceFirst(' ', '\n'),
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );
        },
        separatorBuilder: (context, index) => SizedBox(height: 30, width: 30),
      )
    );
  }
}