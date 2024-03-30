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
//Import Packages:

// firebase_core: Được sử dụng để khởi tạo Firebase trong ứng dụng.
// flutter/material.dart: Được sử dụng để tạo giao diện người dùng trong Flutter.
// customer_signin.dart và customner_signup.dart: Chứa các widget để đăng nhập và đăng ký người dùng.
// home.dart và homemain.dart: Chứa các widget cho màn hình chính của ứng dụng.
// Hàm main():

// Khởi tạo Firebase trong ứng dụng bằng cách gọi Firebase.initializeApp().
// Gọi WidgetsFlutterBinding.ensureInitialized() để đảm bảo rằng các binding của Flutter đã được khởi tạo trước khi ứng dụng chạy.
// Gọi runApp(MyApp()) để khởi chạy ứng dụng Flutter.
// Class MyApp:

// Đây là widget gốc của ứng dụng, được sử dụng để cấu hình MaterialApp.
// Trong phương thức build(), MaterialApp được cấu hình với các thuộc tính sau:
// debugShowCheckedModeBanner: Đặt thành false để ẩn biểu tượng debug banner trên thanh tiêu đề.
// initialRoute: Đặt thành '/customer_signup' để chỉ định màn hình khởi đầu khi ứng dụng được mở.
// routes: Map các đường dẫn đến các màn hình tương ứng. Trong trường hợp này, chúng ta chỉ định các đường dẫn đến màn hình đăng ký ('/customer_signup'), đăng nhập ('/customer_login'), màn hình chính ('/home'), và màn hình chính của người dùng ('/home_main').