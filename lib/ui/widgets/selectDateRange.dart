import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:vendoorr/core/util/appColors.dart';
import 'package:vendoorr/core/util/numberInputField.dart';
import 'package:vendoorr/core/viewModels/analysisTopViewModel.dart';
import 'package:vendoorr/core/viewModels/selectDateRangeViewModel.dart';
import 'package:vendoorr/ui/baseView.dart';
import 'package:vendoorr/ui/widgets/showDialog.dart';

class SelectDateRange extends Modal {
  SelectDateRange(
      {Key key, this.fromDate, this.fromTime, this.toDate, this.toTime});
  DateTime fromDate;
  DateTime toDate;
  DateTime fromTime;
  DateTime toTime;

  @override
  Widget build(BuildContext context) {
    return BaseView<SelectDateRangeViewModel>(onModelReady: (model) {
      model.init(
        fromD: fromDate,
        toD: toDate,
        toT: toTime,
        fromT: fromTime,
      );
    }, builder: (context, model, _) {
      return buildBackdropFilter(
          width: 600,
          submitFunction: () {
            model.submit(context);
          },
          closeFunction: () {
            Navigator.of(context).pop();
          },
          header: "Select Date and Time Range",
          child: Container(
            height: 350,
            child: Row(
              children: [
                Expanded(
                  child: SfDateRangePicker(
                    maxDate: DateTime.now(),
                    selectionMode: DateRangePickerSelectionMode.range,
                    onSelectionChanged:
                        (DateRangePickerSelectionChangedArgs x) {
                      var value = x.value;
                      print(value);
                      if (value is PickerDateRange) {
                        print(value.endDate);
                        model.setDate(
                            value.startDate, value.endDate ?? value.startDate);
                      } else if (value is DateTime) {
                        model.setDate(value, value);
                      }
                    },
                    initialSelectedRange: PickerDateRange(fromDate, toDate),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TimePicker(
                            label: "From",
                            onChanged: model.setFromTime,
                            initialTime: model.fromTime,
                          ),
                        ),
                        Divider(),
                        Expanded(
                            child: TimePicker(
                          label: "To",
                          initialTime: model.toTime,
                          onChanged: model.setToTime,
                        )),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ));
    });
  }
}

class TimePicker extends StatefulWidget {
  TimePicker({Key key, this.onChanged, this.initialTime, this.label = ""})
      : super(key: key);
  final DateTime initialTime;
  final void Function(DateTime) onChanged;
  final String label;

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  String _hourValidator(String hour) {
    if (hour.contains(".")) return "Invalid";
    final _hour = double.tryParse(hour);

    if (_hour == null) return "Invalid";
    if (_hour > 23 || _hour < 0) return "Range Error";
    return null;
  }

  String _minuteValidator(String minute) {
    if (minute.contains(".")) return "Invalid";
    final _minute = double.tryParse(minute);

    if (_minute == null) return "Invalid";
    if (_minute > 59 || _minute < 0) return "Range Error";
    return null;
  }

  void onTChanged(String val) {
    DateTime now = DateTime.now();
    TimeOfDay time =
        TimeOfDay(hour: int.tryParse(hr.text), minute: int.tryParse(min.text));
    DateTime dateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);
    widget.onChanged(dateTime);
  }

  TextEditingController hr;

  TextEditingController min;
  @override
  void initState() {
    hr = TextEditingController(
        text: widget.initialTime == null
            ? "00"
            : widget.initialTime.hour.toString());
    min = TextEditingController(
        text: widget.initialTime == null
            ? "00"
            : widget.initialTime.minute.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: LocalColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 20,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Hour
              Container(
                width: 70,
                child: TimeField(
                  validator: _hourValidator,
                  controller: hr,
                  onChanged: onTChanged,
                ),
              ),
              SizedBox(width: 10),
              // Minute
              Text(":"),
              SizedBox(
                width: 10,
              ),
              Container(
                width: 70,
                child: TimeField(
                  onChanged: onTChanged,
                  controller: min,
                  validator: _minuteValidator,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class TimeField extends StatelessWidget {
  const TimeField({Key key, this.validator, this.controller, this.onChanged})
      : super(key: key);
  final String Function(String) validator;
  final TextEditingController controller;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return NumberInputField(
      controller: controller,
      canBeEmpty: false,
      onChanged: onChanged,
      isAutoValidate: true,
      validator: validator,
    );
  }
}
