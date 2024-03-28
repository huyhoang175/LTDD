import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todolists/widgets/appbar_widgets.dart';
import 'package:todolists/widgets/yellow_button.dart';
import 'package:uuid/uuid.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  late String task = ''; // Khởi tạo task rỗng
  late DateTime selectedDate = DateTime.now();
  late TimeOfDay selectedTime = TimeOfDay.now();
  List<String> taskOptions = [
    'Go to shopping',
    'Go to Soccer',
    'Go to bed',
    'Go swimming',
    'Go joging',
    'Go to school',
    'Go driver',
    'Task orther',
  ];
  late String selectedTaskOption =
      'Go to shopping'; // Khởi tạo giá trị mặc định
  bool isOtherTaskSelected =
      false; // Biến để kiểm tra xem có chọn Task orther không

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Add Task',
          ),
        ),
        body: SafeArea(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 40, 30, 40),
                  child: Column(
                    children: [
                      // Dropdown hoặc TextFormField dựa vào isOtherTaskSelected
                      isOtherTaskSelected
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                height: MediaQuery.of(context).size.width * 0.3,
                                child: TextFormField(
                                  onChanged: (value) {
                                    task = value; // Lưu dữ liệu nhập vào task
                                  },
                                  decoration: textFormDecoration.copyWith(
                                    labelText: 'Task',
                                    hintText: 'Enter your task',
                                  ),
                                ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: DropdownButtonFormField<String>(
                                value: selectedTaskOption,
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedTaskOption = newValue!;
                                    isOtherTaskSelected =
                                        newValue == 'Task orther';
                                  });
                                },
                                items: taskOptions.map((String taskOption) {
                                  return DropdownMenuItem<String>(
                                    value: taskOption,
                                    child: Text(taskOption),
                                  );
                                }).toList(),
                                decoration: textFormDecoration.copyWith(
                                  labelText: 'Task',
                                  hintText: 'Select or enter your task',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select or enter your task';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  task = value!;
                                },
                              ),
                            ),
                      // Các phần còn lại không thay đổi
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: GestureDetector(
                          onTap: () async {
                            final DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
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
                                text: selectedDate != null
                                    ? DateFormat.yMd().format(selectedDate)
                                    : '',
                              ),
                              decoration: textFormDecoration.copyWith(
                                labelText: 'Date',
                                hintText: 'Select date',
                                suffixIcon: const Icon(Icons.calendar_today),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: GestureDetector(
                          onTap: () async {
                            final TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
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
                                text: selectedTime != null
                                    ? selectedTime.format(context)
                                    : '',
                              ),
                              decoration: textFormDecoration.copyWith(
                                labelText: 'Time',
                                hintText: 'Select time',
                                suffixIcon: const Icon(Icons.access_time),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: YellowButton(
                    label: 'Add New Task',
                    onPressed: () async {
                      if (formKey.currentState != null &&
                          formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        CollectionReference addressRef = FirebaseFirestore
                            .instance
                            .collection('customers')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection('custTask');
                        var addressId = const Uuid().v4();
                        String formattedTime =
                            '${selectedTime.hour}:${selectedTime.minute}';
                        await addressRef.doc(addressId).set({
                          'addressid': addressId,
                          'task':
                              isOtherTaskSelected ? task : selectedTaskOption,
                          'date': selectedDate,
                          'time': formattedTime,
                          'default': true,
                        }).whenComplete(() => Navigator.pushReplacementNamed(
                            context, '/home_main'));
                      }
                    },
                    width: 0.8,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

var textFormDecoration = InputDecoration(
  labelText: 'Task',
  hintText: 'Enter your task',
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
  enabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.purple, width: 1),
    borderRadius: BorderRadius.circular(25),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(color: Colors.deepPurpleAccent, width: 2),
    borderRadius: BorderRadius.circular(25),
  ),
);
