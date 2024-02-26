import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CardBody extends StatelessWidget {
  CardBody(
      {Key? key,
      required this.item,
      required this.handleDelete,
      required this.handleEdit,
      required this.index})
      : super(key: key);

  final Function handleDelete;
  // ignore: prefer_typing_uninitialized_variables
  var item;
  // ignore: prefer_typing_uninitialized_variables
  var index;
  final Function handleEdit;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      width: double.infinity,
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: (index % 2 == 0)
            ? const Color.fromARGB(255, 51, 240, 246)
            : const Color.fromARGB(255, 236, 145, 19),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xff4B4B4B),
              ),
            ),
            InkWell(
              onTap: () async {
                if (await confirm(context)) {
                  handleDelete(item.id);
                }
                return;
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.delete_outline,
                    color: Color(0xff4B4B4B),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    // Sử dụng GestureDetector cho icon sửa
                    onTap: () {
                      handleEdit(item
                          .id); // Gọi hàm xử lý sự kiện sửa và truyền item.id vào
                    },
                    child: const Icon(
                      Icons.edit,
                      color: Color(0xff4B4B4B),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
