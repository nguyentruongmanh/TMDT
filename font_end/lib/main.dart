import 'package:e_commerce_project/SQLite/fuction_data.dart';
import 'package:e_commerce_project/authentication/log_in_screen.dart';
import 'package:e_commerce_project/provider/provider_user.dart';
import 'package:e_commerce_project/screens/Cart/check_out.dart';
import 'package:e_commerce_project/screens/Detail/details_screen.dart';
import 'package:e_commerce_project/screens/Detail/widget/details_appbar.dart';
import 'package:e_commerce_project/screens/Home/home_screen.dart';
import 'package:e_commerce_project/screens/admin/add_product.dart';
import 'package:e_commerce_project/screens/admin/home_admin.dart';
import 'package:e_commerce_project/screens/nav_bar_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider( 
      providers: [ 
        ChangeNotifierProvider(create: (context) => ProviderUser()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      textTheme:GoogleFonts.mulishTextTheme(),
    ),
    home: Login_Screen(),
  );
}