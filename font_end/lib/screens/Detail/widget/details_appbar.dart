import 'package:e_commerce_project/constants.dart';
import 'package:e_commerce_project/screens/Home/home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DetailsAppbar extends StatelessWidget {
  const DetailsAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          IconButton(
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(15),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          const Spacer(),
          IconButton(
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(15),
            ),
            onPressed: () {},
            icon: const Icon(
              Icons.share_outlined,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 10,),
          IconButton(
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(15),
            ),
            onPressed: () {},
            icon: const Icon(
              Icons.favorite,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}