import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({Key? key, required this.data, required this.setter})
      : super(key: key);
  final DateTime data;
  final Function(DateTime selected) setter;

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  final textStyle = const TextStyle(
    fontFamily: "GmarketSansTTF",
    fontSize: 16,
  );

  DateTime dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    setState(() {
      dateTime = widget.data;
    });
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: DefaultTextStyle(
        style: textStyle,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CupertinoButton(
                // Display a CupertinoDatePicker in dateTime picker mode.
                onPressed: () => _showDialog(
                  CupertinoDatePicker(
                    initialDateTime: dateTime,
                    use24hFormat: true,
                    // This is called when the user changes the dateTime.
                    onDateTimeChanged: (DateTime newDateTime) {
                      widget.setter(newDateTime);
                      setState(() => dateTime = newDateTime);
                    },
                  ),
                ),
                // In this example, time value is formatted manually. You can use intl package to
                // format the value based on the user's locale settings.
                child: Text(
                  '${dateTime.year}/${dateTime.month < 10 ? '0' + dateTime.month.toString() : dateTime.month}/${dateTime.day < 10 ? '0' + dateTime.day.toString() : dateTime.day} ${dateTime.hour < 10 ? '0' + dateTime.hour.toString() : dateTime.hour}:${dateTime.minute < 10 ? '0' + dateTime.minute.toString() : dateTime.minute}',
                  style: textStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
