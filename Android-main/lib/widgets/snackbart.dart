// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';

class MyMessageHandler {
  static void showSnackBar(_scaffoldKey, String message) {
    _scaffoldKey.currentState!.hideCurrentSnackBar();
    _scaffoldKey.currentState!.showSnackBar(SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.yellow,
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        )));
  }
}
// Ignore Directive: Dòng // ignore_for_file: no_leading_underscores_for_local_identifiers là một chỉ thị ignore_for_file được sử dụng để_exclude_ những cảnh báo liên quan đến việc sử dụng các biến bắt đầu bằng dấu gạch dưới _. Trong trường hợp này, nó được sử dụng để loại bỏ cảnh báo liên quan đến việc sử dụng biến _scaffoldKey.

// Class MyMessageHandler: Đây là một class được sử dụng để xử lý hiển thị SnackBar.

// Phương thức showSnackBar: Phương thức này là static, nghĩa là bạn có thể gọi nó mà không cần tạo ra một thể hiện của MyMessageHandler. Nó nhận vào hai đối số:

// _scaffoldKey: Đây là một key của Scaffold được sử dụng để truy cập đến Scaffold trong widget tree. Chú ý rằng đối số này được bắt đầu bằng dấu gạch dưới _, và việc sử dụng dấu gạch dưới ở đây được bỏ qua bằng cách sử dụng ignore_for_file.
// message: Đây là nội dung của SnackBar sẽ được hiển thị.
// Trong phương thức showSnackBar, trước tiên, nó gọi hideCurrentSnackBar() để ẩn bất kỳ SnackBar hiện tại nào đang hiển thị. Sau đó, nó gọi showSnackBar() để hiển thị một SnackBar mới với các thuộc tính được cung cấp như duration, backgroundColor và content.