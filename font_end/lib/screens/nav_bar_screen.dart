import 'package:e_commerce_project/constants.dart';
import 'package:e_commerce_project/screens/Cart/cart_screen.dart';
import 'package:e_commerce_project/screens/Favorite/favorite_screen.dart';
import 'package:e_commerce_project/screens/Home/home_screen.dart';
import 'package:e_commerce_project/screens/Profile/profile_screen.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final int userID;

  const BottomNavBar({super.key, required this.userID});

  @override
  State<BottomNavBar> createState() => BottomNavBarState();
}

class BottomNavBarState extends State<BottomNavBar> {
  int cuttentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(userID: widget.userID),
      Scaffold(),
      FavoriteScreen(userID: widget.userID),
      CartScreen(userID: widget.userID),
      ProfileScreen(userID: widget.userID),
    ];

    return Scaffold(
      extendBody: true,
      body: screens[cuttentIndex],
      bottomNavigationBar: cuttentIndex == 3 
          ? null 
       :BottomAppBar(
        color: Colors.transparent,
        notchMargin: 10,
        padding: const EdgeInsets.fromLTRB(30, 5, 30, 15),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          decoration: BoxDecoration(
            color: Colors.black,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 4,
                offset: const Offset(0, 0),
              ),
            ],
            borderRadius: const BorderRadius.all(Radius.circular(30)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    cuttentIndex = 0;
                  });
                },
                icon: Icon(
                  cuttentIndex == 0
                      ? Icons.home_rounded
                      : Icons.home_outlined,
                  size: 30,
                  color: buttonColor2,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    cuttentIndex = 1;
                  });
                },
                icon: Icon(
                  cuttentIndex == 1
                      ? Icons.grid_view_rounded
                      : Icons.grid_view_outlined,
                  size: 26,
                  color: buttonColor2,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    cuttentIndex = 2;
                  });
                },
                icon: Icon(
                  cuttentIndex == 2
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_outlined,
                  size: 30,
                  color: buttonColor2,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    cuttentIndex = 3;
                  });
                },
                icon: Icon(
                  cuttentIndex == 3
                      ? Icons.shopping_cart_rounded
                      : Icons.shopping_cart_outlined,
                  size: 30,
                  color: buttonColor2,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    cuttentIndex = 4;
                  });
                },
                icon: Icon(
                  cuttentIndex == 4
                      ? Icons.person
                      : Icons.person_outline,
                  size: 30,
                  color: buttonColor2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
