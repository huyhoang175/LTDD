// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todolists/customer/edit.dart'; // Import EditTaskScreen

class HomeMain extends StatefulWidget {
  const HomeMain({Key? key}) : super(key: key);

  @override
  State<HomeMain> createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  late List<Map<String, dynamic>> tasks = []; // List to store tasks
  late List<Color> cardColors = [
    // Colors.blue,
    // Colors.green,
    // Colors.orange,
    Colors.pink,
    // Colors.purple,
  ]; // List of colors for cards

  @override
  void initState() {
    super.initState();
    // Load tasks from Firestore when the widget initializes
    loadTasks();
  }

  Future<void> loadTasks() async {
    try {
      // Reference to the Firestore collection
      CollectionReference addressRef = FirebaseFirestore.instance
          .collection('customers')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('custTask');

      // Fetch documents from Firestore
      QuerySnapshot querySnapshot = await addressRef.get();
      // Clear the tasks list before updating it with new data
      tasks.clear();
      // Process each document and add it to the tasks list
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('task')) {
          Map<String, dynamic> taskData = {
            'taskId': doc['addressid'],
            'task': doc['task'],
            'dateTime': DateFormat('dd/MM/yyyy')
                .format((doc['date'] as Timestamp).toDate()),
            'time': doc['time'],
            'default': doc['default'] ?? false, // Add default status
          };
          tasks.add(taskData);
        }
      });

      // Update UI after fetching tasks
      setState(() {});
    } catch (e) {
      print('Error loading tasks: $e');
    }
  }

  void navigateToEditScreen(String taskId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskScreen(taskId: taskId),
      ),
    ).then((_) {
      // Refresh tasks after editing
      loadTasks();
    });
  }

  void showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Đóng hộp thoại và trả về giá trị false
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Thực hiện đăng xuất ở đây
                Navigator.pushReplacementNamed(context, '/customer_login');
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showCompletionConfirmationDialog(BuildContext context, int index) async {
    bool isDefault = tasks[index]['default'] ?? false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Completion'),
          content: const Text(
              'Are you sure you want to mark this task as completed?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context)
                    .pop(true); // Dismiss the dialog and return true

                setState(() {
                  // Toggle completion status
                  tasks[index]['isCompleted'] = !isDefault;

                  // Update default status based on completion status
                  tasks[index]['default'] = !isDefault;

                  // Update color based on default status
                  tasks[index]['color'] =
                      !isDefault ? Colors.red : Colors.green;
                });

                // Update the default status on Firestore
                try {
                  String taskIdToUpdate = tasks[index]['taskId'];
                  await FirebaseFirestore.instance
                      .collection('customers')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('custTask')
                      .doc(taskIdToUpdate)
                      .update({'default': !isDefault});
                } catch (e) {
                  print('Error updating default status: $e');
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Center(
          child: Text(
            "ToDoList",
            style: TextStyle(
              fontSize: 30,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/home');
        },
        child: const Icon(
          Icons.add,
          size: 40,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Your Tasks',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Center(
              child: IconButton(
                onPressed: () {
                  showLogoutConfirmationDialog(context);
                },
                icon: const Icon(
                  Icons.logout,
                  size: 24.0,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: tasks.isEmpty
                  ? const Center(
                      child: Text(
                        'No tasks available',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        // Determine color for each task based on default status
                        Color color = tasks[index]['default'] == true
                            ? Colors.red
                            : Colors.green;

                        return Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          color: color, // Use color based on default status
                          child: ListTile(
                            title: Text(
                              tasks[index]['task'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white, // Text color on the card
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Date: ${tasks[index]['dateTime']}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color:
                                        Colors.white, // Text color on the card
                                  ),
                                ),
                                Text(
                                  'Time: ${tasks[index]['time']}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color:
                                        Colors.white, // Text color on the card
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    // Handle edit button pressed
                                    navigateToEditScreen(
                                        tasks[index]['taskId']);
                                  },
                                  icon: const Icon(Icons.edit),
                                  color: Colors.white, // Icon color on the card
                                ),
                                IconButton(
                                  onPressed: () async {
                                    // Handle delete button pressed
                                    // Show a confirmation dialog before deleting
                                    bool confirmDelete = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Confirm Delete"),
                                          content: const Text(
                                              "Are you sure you want to delete this task?"),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(
                                                    false); // Dismiss the dialog and return false
                                              },
                                              child: const Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(
                                                    true); // Dismiss the dialog and return true
                                              },
                                              child: const Text("Delete"),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    if (confirmDelete == true) {
                                      // Get the taskId of the task to delete
                                      String taskIdToDelete =
                                          tasks[index]['taskId'];

                                      try {
                                        // Reference to the Firestore document to delete
                                        DocumentReference docRef =
                                            FirebaseFirestore
                                                .instance
                                                .collection('customers')
                                                .doc(FirebaseAuth
                                                    .instance.currentUser!.uid)
                                                .collection('custTask')
                                                .doc(taskIdToDelete);

                                        // Delete the document from Firestore
                                        await docRef.delete();

                                        // Remove the task from the tasks list
                                        tasks.removeAt(index);

                                        // Update UI after deleting task
                                        setState(() {});
                                      } catch (e) {
                                        print('Error deleting task: $e');
                                      }
                                    }
                                  },
                                  icon: const Icon(Icons.delete),
                                  color: Colors.white, // Icon color
// Icon color on the card
                                ),
                                IconButton(
                                  onPressed: () {
                                    showCompletionConfirmationDialog(
                                        context, index);
                                  },
                                  icon: tasks[index]['default'] == true
                                      ? const Icon(
                                          Icons.check_box_outline_blank)
                                      : const Icon(Icons.check_box),
                                  color: Colors.white, // Icon color
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
