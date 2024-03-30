import 'package:flutter/material.dart';

class AppBarBackButton extends StatelessWidget {
  const AppBarBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back_ios_new,
        color: Colors.black,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}//Đây là một widget IconButton có một mũi tên trở lại (icon) màu đen. Widget này được sử dụng để hiển thị nút quay lại trên thanh tiêu đề. Khi người dùng nhấn vào nút này, nó sẽ đóng màn hình hiện tại và quay lại màn hình trước đó bằng cách sử dụng 

class YellowBackButton extends StatelessWidget {
  const YellowBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back_ios_new,
        color: Colors.yellow,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}//Tương tự như AppBarBackButton, widget này cũng là một IconButton với mũi tên trở lại màu vàng. Cũng như trên, khi người dùng nhấn vào nút này, nó sẽ đóng màn hình hiện tại và quay lại màn hình trước đó.

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
          color: Colors.black,
          fontFamily: 'Acme',
          fontSize: 28,
          letterSpacing: 1.5),
    );
  }
}//AppBarTitle: Đây là một widget Text được sử dụng để hiển thị tiêu đề của thanh tiêu đề (AppBar). Tiêu đề này có thể được tùy chỉnh thông qua thuộc tính title. Trong ví dụ này, tiêu đề được thiết lập thành một chuỗi cố định và được định dạng với một số thuộc tính như màu sắc, kiểu chữ, kích thước và khoảng cách giữa các ký tự.
