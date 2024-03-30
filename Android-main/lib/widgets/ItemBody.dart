import 'dart:typed_data';

import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';

class ItemBody extends StatefulWidget {
  ItemBody({
    super.key,
    required this.item,
    required this.handleDelete,
    required this.handleEdit,
  });
  var item;
  bool isChecked = false;

  final Function handleDelete;
  final Function handleEdit;

  @override
  State<ItemBody> createState() => _ItemBodyState();
}

class _ItemBodyState extends State<ItemBody> {
  @override
  Widget build(BuildContext context) {
    // print((widget.item.date).runtimeType);
    // print(DateTime.now().runtimeType);

    return Container(
      width: double.infinity,
      height: 70,
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: (widget.isChecked)
              ? Color.fromARGB(255, 124, 255, 129)
              : (widget.item.date.compareTo(DateTime.now()) > 0)
                  ? Colors.white
                  : Color.fromARGB(255, 255, 103, 92),
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 5,
              offset: Offset(0, 2),
            )
          ]),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Checkbox(
                  value: widget.isChecked,
                  onChanged: (bool? value) {
                    // This is where we update the state when the checkbox is tapped
                    setState(() {
                      widget.isChecked = value!;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.name,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.item.date.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color.fromARGB(255, 99, 99, 99),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // ignore: prefer_const_constructors
            Row(
              children: [
                InkWell(
                  onTap: () {
                    widget.handleEdit(widget.item);
                  },
                  child: const Icon(
                    Icons.edit,
                  ),
                ),
                const Text("  "),
                InkWell(
                  onTap: () async {
                    if (await confirm(context)) {
                      widget.handleDelete(widget.item.id);
                    }
                    return;
                  },
                  child: const Icon(
                    Icons.delete,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
// Constructor: Widget này có một constructor được sử dụng để truyền các giá trị cần thiết như item, handleDelete, và handleEdit.

// State: ItemBody là một StatefulWidget và có một State được quản lý bởi _ItemBodyState.

// build() Method: Phương thức này xây dựng giao diện người dùng cho ItemBody. Trong phần giao diện này:

// Container được sử dụng để chứa nội dung của mỗi mục trong danh sách.

// Trạng thái của mục (checked hoặc unchecked) được thể hiện bằng màu nền của container. Nếu mục đã được đánh dấu là đã hoàn thành, màu nền sẽ là màu xanh. Nếu mục sắp đến hạn (theo ngày), màu nền sẽ là màu đỏ. Trong trường hợp khác, màu nền sẽ là màu trắng.

// Trong phần nội dung, mỗi mục hiển thị tên và ngày của nó.

// Hai biểu tượng cho phép chỉnh sửa và xóa mục. Khi nhấn vào biểu tượng xóa, một hộp thoại xác nhận sẽ hiển thị để xác nhận hành động xóa.

// Checkbox: Được sử dụng để chọn hoặc bỏ chọn mục. Khi trạng thái của checkbox thay đổi, trạng thái của mục được cập nhật thông qua setState().

// onTap: Được sử dụng trong InkWell để xử lý sự kiện nhấn vào biểu tượng chỉnh sửa và xóa mục. Khi nhấn vào biểu tượng xóa, một hộp thoại xác nhận sẽ hiển thị. Nếu người dùng xác nhận, handleDelete được gọi với item.id là tham số.