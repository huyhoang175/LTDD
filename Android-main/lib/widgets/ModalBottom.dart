import 'package:datetime_picker_formfield_new/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ModalBottom extends StatefulWidget {
  ModalBottom({
    super.key,
    required this.addTask,
    required this.valuedef,
    required this.name,
    required this.date,
    required this.defDate,
  });
  final Function addTask;
  String valuedef;
  var defDate;
  var name;
  var date;

  @override
  State<ModalBottom> createState() => _ModalBottomState();
}

class _ModalBottomState extends State<ModalBottom> {
  // TextEditingController controller = TextEditingController();
  // TextEditingController controller = TextEditingController();

  void _handleOnClick(BuildContext context) {
    final name = widget.valuedef;
    final date = widget.defDate;
    if (name.isEmpty) {
      return;
    }
    // print(name);
    // print(date);
    widget.addTask(name, date);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // final format = DateFormat("yyyy-MM-dd");
    final format = DateFormat("yyyy-MM-dd HH:mm");
    return Padding(
      //fix khi hiện bàn phím không lỗi
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),

        // ignore: prefer_const_literals_to_create_immutables
        child: Column(children: [
          TextFormField(
            initialValue: widget.valuedef,
            // controller: controller,
            onChanged: (text) {
              widget.valuedef = text;
            },
            decoration: const InputDecoration(
                border: OutlineInputBorder(), labelText: "Your Task"),
          ),
          // ignore: prefer_const_constructors
          SizedBox(
            height: 20,
          ),

          Column(children: <Widget>[
            DateTimeField(
              // controller: controller,
              initialValue: widget.defDate,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                // labelText: "Deadline: yyyy-MM-dd HH:mm",
              ),
              format: format,
              onShowPicker: (context, currentValue) async {
                return await showDatePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  initialDate: currentValue ?? DateTime.now(),
                  lastDate: DateTime(2100),
                ).then((DateTime? date) async {
                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                          currentValue ?? DateTime.now()),
                    );

                    widget.defDate = (DateTimeField.combine(date, time));

                    // print(DateTimeField.combine(date, time));
                    return DateTimeField.combine(date, time);
                  } else {
                    return currentValue;
                  }
                });
              },
            ),
          ]),
          const SizedBox(
            height: 20,
          ),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
                onPressed: () => _handleOnClick(context),
                child: Text(widget.name)),
          ),
        ]),
      ),
    );
  }
}
