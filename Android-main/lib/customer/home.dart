import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todolists/widgets/appbar_widgets.dart';
import 'package:todolists/widgets/yellow_button.dart';
import 'package:uuid/uuid.dart';

class AddTask extends StatefulWidget {
  //AddTask là một StatefulWidget để hiển thị màn hình thêm công việc mới.
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final GlobalKey<FormState> formKey = GlobalKey<
      FormState>(); //formKey: GlobalKey để quản lý trạng thái của Form.
  final GlobalKey<ScaffoldMessengerState>
      scaffoldKey = //scaffoldKey: GlobalKey để hiển thị các snackbars hoặc scaffold.
      GlobalKey<ScaffoldMessengerState>();
  late String task =
      ''; // Khởi tạo task rỗng//task: Chuỗi để lưu tên công việc.
  late DateTime selectedDate =
      DateTime.now(); //selectedDate: DateTime để lưu ngày được chọn.
  late TimeOfDay selectedTime =
      TimeOfDay.now(); //selectedTime: TimeOfDay để lưu thời gian được chọn.
  List<String> taskOptions = [
    //taskOptions: Một danh sách các tùy chọn công việc.
    'Go to shopping',
    'Go to Soccer',
    'Go to bed',
    'Go swimming',
    'Go joging',
    'Go to school',
    'Go driver',
    'Task orther',
  ];
  late String
      selectedTaskOption = //selectedTaskOption: Chuỗi để lưu tùy chọn công việc được chọn.
      'Go to shopping'; // Khởi tạo giá trị mặc định
  bool isOtherTaskSelected =
      false; // Biến để kiểm tra xem có chọn Task orther không

  @override
  Widget build(BuildContext context) {
    //Phương thức build xây dựng cấu trúc của màn hình:
// Hiển thị một Scaffold có tiêu đề "Add Task".
// Trong body, có một Form chứa Column để hiển thị nội dung.
// Column chứa các phần tử như TextFormField hoặc DropdownButtonFormField để nhập thông tin công việc.
// Có một biến isOtherTaskSelected để xác định xem có hiển thị TextFormField cho "Task orther" hay không.
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
                              //Phần tiếp theo của build chứa các TextFormField để chọn ngày và thời gian:
// Sử dụng GestureDetector để mở hộp thoại DatePicker hoặc TimePicker khi người dùng nhấn vào.
// AbsorbPointer được sử dụng để ngăn người dùng nhập trực tiếp vào TextFormField.
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
                  //Cuối cùng, build chứa một nút YellowButton để thêm công việc mới.
// Khi nút này được nhấn, dữ liệu từ Form được lưu và thêm vào Firestore. Nếu dữ liệu hợp lệ, người dùng sẽ được chuyển đến màn hình chính.
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

// Biến textFormDecoration được khai báo để cung cấp các thuộc tính trang trí cho các TextFormField trong ứng dụng. Dưới đây là giải thích cho mỗi thuộc tính:

// labelText: Văn bản hiển thị như một nhãn trên TextFormField khi nó không rỗng.
// hintText: Văn bản hiển thị như một gợi ý trong TextFormField khi nó rỗng.
// border: Định dạng viền của TextFormField khi không được focus.
// enabledBorder: Định dạng viền của TextFormField khi nó được kích hoạt nhưng không được focus.
// borderSide: Định dạng đường biên của viền, bao gồm màu sắc và độ dày.
// borderRadius: Định dạng góc bo của viền.
// focusedBorder: Định dạng viền của TextFormField khi nó được focus.
// borderSide: Định dạng đường biên của viền, bao gồm màu sắc và độ dày.
// borderRadius: Định dạng góc bo của viền.