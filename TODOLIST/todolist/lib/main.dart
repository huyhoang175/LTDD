import 'package:flutter/material.dart';
import 'package:todolist/modal/iteams.dart';

import 'package:todolist/widget/card_modal_bottom.dart';

import 'widget/card_body_widget.dart';

void main(List<String> args) {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: Colors.blueAccent,
    ),
    home: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<DataItems> items = [];

  void _handleAddTask(String name) {
    final newItem = DataItems(id: DateTime.now().toString(), name: name);

    setState(() {
      items.add(newItem);
    });
  }

  void _handleDeleteTask(String id) {
    setState(() {
      items.removeWhere((item) => item.id == id);
    });
  }

  void _handleEdit(String id) {
    var itemToEdit = items.firstWhere((item) => item.id == id);
    showModalBottomSheet(
      backgroundColor: Colors.grey,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return ModalBottom(
          itemToEdit: itemToEdit,
          saveChanges: (editedItem) {
            setState(() {
              items[items.indexWhere((item) => item.id == id)] = editedItem;
            });
            Navigator.pop(context);
          },
          addTask: _handleAddTask, 
        );
      },
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'ToDoList',
            style: TextStyle(fontSize: 40),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 31, vertical: 20),
          child: Column(
            children: items
                .map((item) => CardBody(
                      index: items.indexOf(item),
                      item: item,
                      handleDelete: _handleDeleteTask,
                      handleEdit: _handleEdit,
                    ))
                .toList(),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              backgroundColor: Colors.grey,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20))),
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return ModalBottom(
                  addTask: _handleAddTask,
                  saveChanges: (editedItem) {},
                );
              },
            );
          },
          child: const Icon(
            Icons.add,
            size: 40,
          ),
        ));
  }
}
