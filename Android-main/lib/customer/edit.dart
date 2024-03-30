// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditTaskScreen extends StatefulWidget {
  final String taskId;

  const EditTaskScreen({Key? key, required this.taskId}) : super(key: key);

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController
      taskController; //Khai báo các biến taskController để điều khiển TextField, selectedDate để lưu ngày được chọn và selectedTime để lưu thời gian được chọn.
  late DateTime selectedDate;
  late TimeOfDay selectedTime;

  @override
  void initState() {
    //Phương thức initState được gọi khi widget được khởi tạo. Ở đây, chúng ta khởi tạo các biến và gọi fetchTaskData để lấy dữ liệu công việc.
    super.initState();
    // Initialize controller and fetch task data
    taskController = TextEditingController();
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
    fetchTaskData();
  }

  Future<void> fetchTaskData() async {
    //Phương thức fetchTaskData được sử dụng để lấy dữ liệu của công việc từ Firestore.
    try {
      // Fetch task data based on widget.taskId
      DocumentSnapshot taskSnapshot = await FirebaseFirestore.instance
          .collection('customers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('custTask')
          .doc(widget.taskId)
          .get();

      if (taskSnapshot.exists) {
        //Dữ liệu công việc được lấy từ Firestore và gán vào các biến. Nếu không có công việc nào tìm thấy, thông báo "Task not found" sẽ được in ra.
        Map<String, dynamic> taskData =
            taskSnapshot.data() as Map<String, dynamic>;
        // Set task data to the controller and state
        taskController.text = taskData['task'];
        selectedDate = (taskData['date'] as Timestamp).toDate();
        selectedTime = TimeOfDay.fromDateTime(selectedDate);
        setState(() {});
      } else {
        // Handle task not found
        print('Task not found');
      }
    } catch (e) {
      // Handle error
      print('Error fetching task data: $e');
    }
  }

  Future<void> updateTask() async {
    //Phương thức updateTask được sử dụng để cập nhật thông tin của công việc vào Firestore.
    try {
      // Reference to the Firestore document to update
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('customers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('custTask')
          .doc(widget.taskId);

      // Convert TimeOfDay to a string in "HH:mm" format
      String formattedTime =
          '${selectedTime.hour}:${selectedTime.minute}'; //Thời gian được chọn được chuyển đổi thành chuỗi theo định dạng "HH:mm".

      // Update the document in Firestore
      await docRef.update({
        //Cập nhật các trường task, date, time trong Firestore với thông tin mới của công việc.
        'task': taskController.text,
        'date': selectedDate,
        'time': formattedTime,
      });

      // Navigate back to HomeMain screen after updating
      Navigator.pop(
          context); //Sau khi cập nhật xong, màn hình sẽ chuyển về màn hình trước đó.
    } catch (e) {
      // Handle error
      print('Error updating task: $e');
    }
  }

  @override
  void dispose() {
    // Clean up controller when widget is disposed
    taskController
        .dispose(); //Phương thức dispose được gọi khi widget được hủy. Ở đây, chúng ta giải phóng bộ nhớ cho taskController.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              //Hiển thị TextField để nhập thông tin công việc.
              'Task:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: taskController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter task',
              ),
            ),
            const SizedBox(
                height:
                    16), //Khi người dùng nhấn vào, một hộp thoại hiển thị cho phép họ chọn ngày.
            const Text(
              'Date:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
              child: AbsorbPointer(
                //Hiển thị TextFormField để hiển thị ngày được chọn.
                child: TextFormField(
                  controller: TextEditingController(
                    text: DateFormat.yMd().format(selectedDate),
                  ),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ),
            ),
            const SizedBox(
                height:
                    16), //Khi người dùng nhấn vào, một hộp thoại hiển thị cho phép họ chọn thời gian.
            const Text(
              'Time:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: selectedTime,
                );
                if (pickedTime != null) {
                  setState(() {
                    selectedTime = pickedTime;
                  });
                }
              },
              child: AbsorbPointer(
                //Hiển thị TextFormField để hiển thị thời gian được chọn.
                child: TextFormField(
                  controller: TextEditingController(
                    text: selectedTime.format(context),
                  ),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.access_time),
                  ),
                ),
              ),
            ),
            const SizedBox(
                height:
                    24), //Hiển thị nút "Update Task" để người dùng có thể cập nhật thông tin của công việc.
            ElevatedButton(
              onPressed: updateTask,
              child: const Text('Update Task'),
            ),
          ],
        ),
      ),
    );
  }
}
