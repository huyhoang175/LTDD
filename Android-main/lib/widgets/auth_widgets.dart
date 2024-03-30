import 'package:flutter/material.dart';

class AuthMainButton extends StatelessWidget {
  final String mainButtonLabel;
  final Function() onPressed;
  const AuthMainButton(
      {Key? key, required this.mainButtonLabel, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Material(
        color: Colors.purple,
        borderRadius: BorderRadius.circular(25),
        child: MaterialButton(
            minWidth: double.infinity,
            onPressed: onPressed,
            child: Text(
              mainButtonLabel,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            )),
      ),
    );
  }
}

class HaveAccount extends StatelessWidget {
  final String haveAccount;
  final String actionLabel;
  final Function() onPressed;
  const HaveAccount(
      {Key? key,
      required this.actionLabel,
      required this.haveAccount,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          haveAccount,
          style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
        ),
        TextButton(
            onPressed: onPressed,
            child: Text(
              actionLabel,
              style: const TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ))
      ],
    );
  }
}

class AuthHeaderLabel extends StatelessWidget {
  final String headerLabel;
  const AuthHeaderLabel({Key? key, required this.headerLabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            headerLabel,
            style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          IconButton(
              onPressed: () {
                // Navigator.pushReplacementNamed(context, '/welcome_screen');
              },
              icon: const Icon(
                Icons.home_work,
                size: 40,
              ))
        ],
      ),
    );
  }
}

var textFormDecoration = InputDecoration(
  labelText: 'Full Name',
  hintText: 'Enter your full name',
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
  enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.purple, width: 1),
      borderRadius: BorderRadius.circular(25)),
  focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.deepPurpleAccent, width: 2),
      borderRadius: BorderRadius.circular(25)),
);

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$').hasMatch(this);
  }
}
//AuthMainButton: Đây là một widget button được tạo ra để sử dụng trong các tác vụ chính liên quan đến xác thực, như đăng nhập, đăng ký, hoặc đặt lại mật khẩu. Widget này nhận vào hai thuộc tính: mainButtonLabel là nhãn của nút và onPressed là hàm được gọi khi nút được nhấn.

// HaveAccount: Widget này chứa một văn bản và một nút chuyển hướng. Nó thường được sử dụng để hiển thị câu thông báo có chứa một hành động cụ thể, chẳng hạn như "Already have an account? Sign in". Widget này nhận vào ba thuộc tính: haveAccount là văn bản thông báo, actionLabel là nhãn của nút chuyển hướng, và onPressed là hàm được gọi khi nút được nhấn.

// AuthHeaderLabel: Đây là một widget chứa tiêu đề chính và một nút chuyển hướng. Nó thường được sử dụng để hiển thị tiêu đề của trang xác thực. Widget này nhận vào một thuộc tính là headerLabel để thiết lập tiêu đề, thông thường là tiêu đề của trang xác thực.

// textFormDecoration: Biến này được sử dụng để cấu hình trang trí cho các trường văn bản trong các mẫu nhập liệu. Nó định nghĩa các thuộc tính như labelText, hintText, border, enabledBorder, và focusedBorder để tạo ra các hiệu ứng trực quan khi người dùng tương tác với các trường nhập liệu.

// EmailValidator (Extension): Đây là một phương thức mở rộng (extension) cho kiểu dữ liệu String để kiểm tra tính hợp lệ của một địa chỉ email. Phương thức này kiểm tra xem chuỗi có khớp với mẫu định dạng email hay không và trả về kết quả tương ứng.