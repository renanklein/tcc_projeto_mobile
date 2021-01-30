import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tcc_projeto_app/utils/convert_utils.dart';

class EventHourField extends StatefulWidget {
  final occupedHours;
  final hourController;
  final selectedTime;
  final isReadOnly;
  EventHourField(
      {@required this.occupedHours,
      @required this.hourController,
      @required this.selectedTime,
      @required this.isReadOnly});

  @override
  _EventHourFieldState createState() => _EventHourFieldState();
}

class _EventHourFieldState extends State<EventHourField> {
  List<String> get occupedHours => this.widget.occupedHours;
  TextEditingController get hourController => this.widget.hourController;
  String get selectedTime => this.widget.selectedTime;
  String currentValue;
  bool get isReadOnly => this.widget.isReadOnly;

  @override
  void initState() {
    this.hourController.text = this.selectedTime;
    this.currentValue = this.selectedTime;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (this.isReadOnly) {
      return TextFormField(
        readOnly: this.isReadOnly,
        obscureText: this.isReadOnly,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 20.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            hintText: this.currentValue),
      );
    }
    return DropdownButtonFormField(
        value: this.currentValue,
        isDense: true,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 20.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        items: _getAvailableHours().map((hour) {
          return DropdownMenuItem(value: hour, child: Text(hour));
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            currentValue = newValue;
            this.hourController.text = newValue;
          });
        });
  }

  List<String> _getAvailableHours() {
    var totalHours = ConvertUtils.getTotalHours();

    if (this.occupedHours == null) {
      return totalHours;
    }

    this.occupedHours.remove(this.hourController.text);

    this.occupedHours.forEach((occupedHour) {
      totalHours.remove(occupedHour);
    });

    return totalHours;
  }
}
