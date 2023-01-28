import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ControlBtn extends StatefulWidget {
  const ControlBtn({Key? key, required this.data, required this.setter})
      : super(key: key);
  final bool data;
  final Function() setter;

  @override
  State<ControlBtn> createState() => _ControlBtnState();
}

class _ControlBtnState extends State<ControlBtn> {
  bool isUserProf = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isUserProf = widget.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoSlidingSegmentedControl<bool>(
      thumbColor: Colors.lightBlueAccent,
      padding: const EdgeInsets.symmetric(horizontal: 0),
      groupValue: isUserProf,
      // Callback that sets the selected segmented control.
      onValueChanged: (bool? value) {
        widget.setter();
        setState(() {
          isUserProf = !isUserProf;
        });
      },
      children: <bool, Widget>{
        false: Padding(
            padding: EdgeInsets.symmetric(horizontal: 13),
            child: isUserProf
                ? Text('학생',
                    style: TextStyle(
                      fontFamily: "GmarketSansTTF",
                      fontSize: 14,
                    ))
                : Text('학생',
                    style: TextStyle(
                        fontFamily: "GmarketSansTTF",
                        fontSize: 14,
                        color: Colors.white))),
        true: Padding(
            padding: EdgeInsets.symmetric(horizontal: 13),
            child: isUserProf
                ? Text('교수님',
                    style: TextStyle(
                        fontFamily: "GmarketSansTTF",
                        fontSize: 14,
                        color: Colors.white))
                : Text('교수님',
                    style: TextStyle(
                      fontFamily: "GmarketSansTTF",
                      fontSize: 14,
                    ))),
      },
    );
  }
}
