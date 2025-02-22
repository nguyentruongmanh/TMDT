import 'package:flutter/material.dart';

class FavoriteScreen extends StatefulWidget{
  final int userID;
  const FavoriteScreen({super.key, required this.userID});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return  const Scaffold();
  }
}