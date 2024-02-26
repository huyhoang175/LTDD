import 'package:flutter/material.dart';
import 'package:todolist/modal/iteams.dart';

// ignore: must_be_immutable
class ModalBottom extends StatelessWidget {
  ModalBottom(
      {Key? key,
      required this.addTask,
      this.itemToEdit,
      required Null Function(dynamic editedItem) saveChanges})
      : super(key: key);

  final Function addTask;
  final DataItems? itemToEdit;
  TextEditingController controller = TextEditingController();

  void _handleOnClick(BuildContext context) {
    final name = controller.text;
    if (name.isEmpty) {
      return;
    }

    if (itemToEdit != null) {
      // Nếu itemToEdit tồn tại, tạo một bản sao của nó với giá trị name mới
      DataItems updatedItem = DataItems(id: itemToEdit!.id, name: name);
      // Truyền bản sao đã được cập nhật vào hàm addTask
      addTask(updatedItem);
    } else {
      // Nếu itemToEdit không tồn tại, thực hiện thêm mới
      addTask(DataItems(id: DateTime.now().toString(), name: name));
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Your Task',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => _handleOnClick(context),
                child: const Text('Add Task'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
