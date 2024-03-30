// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todolists/providers/auth_repo.dart';
import 'package:todolists/widgets/auth_widgets.dart';
import 'package:todolists/widgets/snackbart.dart';

class CustomerLogin extends StatefulWidget {
  const CustomerLogin({Key? key}) : super(key: key);

  @override
  _CustomerLoginState createState() => _CustomerLoginState();
}

class _CustomerLoginState extends State<CustomerLogin> {
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');////Tạo một tham chiếu tới collection "customers" trong Firestore.
  Future<bool> checkIfDocExists(String docId) async {////Tạo một hàm để kiểm tra xem một tài liệu có tồn tại trong Firestore không. Hàm này trả về một giá trị boolean.
    
    try {
      var doc = await customers.doc(docId).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  bool docExists =
      false;////Khởi tạo một biến boolean docExists để kiểm tra xem tài liệu có tồn tại hay không.

  Future<UserCredential> signInWithGoogle() async {
    
    final GoogleSignInAccount? googleUser = await GoogleSignIn()
        .signIn(); //Tạo một hàm để xử lý quá trình đăng nhập bằng tài khoản Google.
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      //Lấy thông tin tài khoản Google và xác thực từ Google.
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await FirebaseAuth
        .instance //Tạo một thông tin chứng thực từ dữ liệu xác thực của Google.
        .signInWithCredential(credential)
        .whenComplete(() async {
      User user = FirebaseAuth.instance
          .currentUser!; //Sử dụng thông tin chứng thực để đăng nhập vào Firebase Authentication.
      print(googleUser!.id);
      print(FirebaseAuth.instance.currentUser!.uid);
      print(googleUser);
      print(user);
      // _uid = FirebaseAuth.instance.currentUser!.uid;
      docExists = await checkIfDocExists(
          user.uid); //Lấy thông tin người dùng đã đăng nhập.
      docExists == false
          ? await customers.doc(user.uid).set({
              //Kiểm tra xem tài liệu người dùng đã tồn tại trong Firestore chưa.
              'name': user.displayName,
              'email': user.email,
              'profileimage': user.photoURL,
              'phone': '',
              'address': '',
              'cid': user.uid
            }).then((value) => navigate())
          : navigate();
    });
  }

  late String email;//Khai báo các biến cần thiết để lưu thông tin email, mật khẩu và trạng thái xử lý đang được thực hiện hay không.
  late String password;
  bool processing = false;
  final GlobalKey<FormState> _formKey = GlobalKey<//Khởi tạo các GlobalKey cho Form và ScaffoldMessenger.
      FormState>(); 
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool passwordVisible = false;//Biến này được sử dụng để xác định xem mật khẩu nên được hiển thị hay không.
  void navigate() {
    Navigator.pushReplacementNamed(context, '/home_main');//Hàm này dùng để chuyển hướng đến màn hình khác.
  }

  void logIn() async {//Khởi tạo hàm để xử lý quá trình đăng nhập.
    setState(() {
      processing = true;//Đặt trạng thái xử lý thành true để hiển thị tiến trình đang được thực hiện.
    });
    if (_formKey.currentState!.validate()) {//Kiểm tra xem dữ liệu nhập vào từ form có hợp lệ không.
      try {//Gọi các hàm xử lý đăng nhập và tải lại dữ liệu người dùng.
        await AuthRepo.singInWithEmailAndPassword(email, password);
        await AuthRepo.reloadUserData();
        if (await AuthRepo.checkEmailVerification()) {//Xử lý quá trình đăng nhập và hiển thị thông báo nếu có lỗi.
          _formKey.currentState!.reset();
          navigate();

          // Navigator.pushReplacementNamed(context, '/customer_home');
        } else {
          MyMessageHandler.showSnackBar(
              _scaffoldKey, 'please check your inbox');
          setState(() {
            processing = false;
          });
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          processing = false;
        });
        MyMessageHandler.showSnackBar(_scaffoldKey, e.message.toString());
      }
    } else {
      setState(() {
        processing = false;
      });
      MyMessageHandler.showSnackBar(_scaffoldKey, 'Please fill all fields');
    }
  }

  @override
  Widget build(BuildContext context) {//Ghi đè phương thức build.
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              reverse: true,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AuthHeaderLabel(headerLabel: 'Log In'),
                      const SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your email ';
                            } else if (value.isValidEmail() == false) {
                              return 'invalid email';
                            } else if (value.isValidEmail() == true) {
                              return null;
                            }
                            return null;
                          },
                          onChanged: (value) {
                            email = value;
                          },
                          //  controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: textFormDecoration.copyWith(
                            labelText: 'Email Address',
                            hintText: 'Enter your email',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your password';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            password = value;
                          },
                          //   controller: _passwordController,
                          obscureText: passwordVisible,
                          decoration: textFormDecoration.copyWith(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                                icon: Icon(
                                  passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.purple,
                                )),
                            labelText: 'Password',
                            hintText: 'Enter your password',
                          ),
                        ),
                      ),

                      HaveAccount(
                        haveAccount: 'Don\'t Have Account? ',
                        actionLabel: 'Sign Up',
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/customer_signup');
                        },
                      ),
                      processing == true
                          ? FutureBuilder(
                              future:
                                  Future.delayed(const Duration(seconds: 2)),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.purple,
                                    ),
                                  );
                                } else {
                                  return AuthMainButton(
                                    mainButtonLabel: 'Log In',
                                    onPressed: () {
                                      logIn();
                                    },
                                  );
                                }
                              },
                            )
                          : AuthMainButton(
                              mainButtonLabel: 'Log In',
                              onPressed: () {
                                logIn();
                              },
                            ),
                      divider(),
                      // googleLogInButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
          Text(
            ' Or ',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(
            width: 80,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
