import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todolists/customer/customer_signin.dart';
import 'package:todolists/customer/customner_signup.dart';
// import 'package:provider/provider.dart';
import 'package:todolists/customer/home.dart';
import 'package:todolists/customer/homemain.dart';
// import 'package:todolists/providers/cart_provider.dart';
// import 'package:todolists/providers/wish_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/customer_signup',
      routes: {
        '/customer_signup': (context) => const CustomerRegister(),
        '/customer_login': (context) => const CustomerLogin(),
        '/home': (context) => const AddTask(),
        '/home_main': (context) => const HomeMain(),
      },
    );
  }
}
