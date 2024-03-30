import 'package:flutter/material.dart';

class YellowButton extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final double width;
  const YellowButton(
      {Key? key,
      required this.label,
      required this.onPressed,
      required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: MediaQuery.of(context).size.width * width,
      decoration: BoxDecoration(
          color: Colors.yellow, borderRadius: BorderRadius.circular(25)),
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
// Trong đoạn mã trên, chúng ta có một widget là YellowButton, được sử dụng để tạo ra một nút màu vàng có kích thước và chức năng tùy chỉnh. Dưới đây là một số điểm chính:

// Class YellowButton: Đây là một StatelessWidget được sử dụng để xây dựng nút màu vàng.

// Các thuộc tính:

// label: Đây là nội dung văn bản hiển thị trên nút.
// onPressed: Đây là hàm được gọi khi nút được nhấn.
// width: Độ rộng của nút, được chỉ định dưới dạng một phần trăm của chiều rộng màn hình.
// Phương thức build: Trong phương thức này, chúng ta xây dựng nút sử dụng một Container với kích thước và trang trí tùy chỉnh. Container này chứa một MaterialButton để xử lý sự kiện nhấn nút và hiển thị nội dung văn bản (label). Kích thước của nút được xác định bằng cách sử dụng MediaQuery để lấy kích thước của màn hình và nhân với width được cung cấp.