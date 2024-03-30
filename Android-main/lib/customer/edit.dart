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
  late TextEditingController taskController;
  late DateTime selectedDate;
  late TimeOfDay selectedTime;

  @override
  void initState() {
    super.initState();
    // Initialize controller and fetch task data
    taskController = TextEditingController();
    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
    fetchTaskData();
  }

  Future<void> fetchTaskData() async {
    try {
      // Fetch task data based on widget.taskId
      DocumentSnapshot taskSnapshot = await FirebaseFirestore.instance
          .collection('customers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('custTask')
          .doc(widget.taskId)
          .get();

      if (taskSnapshot.exists) {
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
    try {
      // Reference to the Firestore document to update
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('customers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('custTask')
          .doc(widget.taskId);

      // Convert TimeOfDay to a string in "HH:mm" format
      String formattedTime = '${selectedTime.hour}:${selectedTime.minute}';

      // Update the document in Firestore
      await docRef.update({
        'task': taskController.text,
        'date': selectedDate,
        'time': formattedTime,
      });

      // Navigate back to HomeMain screen after updating
      Navigator.pop(context);
    } catch (e) {
      // Handle error
      print('Error updating task: $e');
    }
  }

  @override
  void dispose() {
    // Clean up controller when widget is disposed
    taskController.dispose();
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
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
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
            const SizedBox(height: 24),
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
