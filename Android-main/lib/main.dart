import 'dart:io';

import 'package:flutter/material.dart';
import 'package:todolists/modal/Item.dart';
import 'package:todolists/width/ItemBody.dart';
import 'package:todolists/width/ModalBottom.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<DataItems> items = [];

  void _handleAddTask(String name, DateTime date) {
    // print(name);
    // print(date);

    final newItem =
        DataItems(id: DateTime.now().toString(), name: name, date: date);
    setState(() {
      items.add(newItem);
    });
  }

  void _handleDeleteTas(String id) {
    setState(() {
      items.removeWhere((items) => items.id == id);
    });
  }

  void _handleEditTask(var item) {
    items.removeWhere((items) => items.name == item.name);
    showModalBottomSheet(
      // dongf shape làm cho cái container bị bo cong 5px
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(5))),
      //hiển thị khi xoay ngang không bị lỗi
      isScrollControlled: true,
      context: context,
      builder: (BuildContext content) {
        //khi bấm vào dấu cộng sẽ hiện lên chỗ nhập nhiệm vụ(task)
        return ModalBottom(
          addTask: _handleAddTask,
          valuedef: item.name,
          name: "Edit Task",
          defDate: item.date,
          date: item.date,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
        child: Column(
            children: items
                .map((item) => ItemBody(
                    item: item,
                    handleDelete: _handleDeleteTas,
                    handleEdit: _handleEditTask))
                .toList()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            // dongf shape làm cho cái container bị bo cong 5px
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(5))),
            //hiển thị khi xoay ngang không bị lỗi
            isScrollControlled: true,
            context: context,
            builder: (BuildContext content) {
              //khi bấm vào dấu cộng sẽ hiện lên chỗ nhập nhiệm vụ(task)
              return ModalBottom(
                addTask: _handleAddTask,
                valuedef: "",
                name: "Add Task",
                defDate: DateTime.now(),
                date: DateTime.now(),
              );
            },
          );
        },
        child: const Icon(
          Icons.add,
          size: 40,
        ),
      ),
    );
  }
}
