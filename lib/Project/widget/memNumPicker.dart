import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MemCntPicker extends StatefulWidget {
  const MemCntPicker({Key? key, required this.data, required this.setter})
      : super(key: key);
  final int data;
  final Function(int selected) setter;

  @override
  State<MemCntPicker> createState() => _MemCntPickerState();
}

class _MemCntPickerState extends State<MemCntPicker> {
  final textStyle = const TextStyle(
    fontFamily: "GmarketSansTTF",
    fontSize: 16,
  );

  int _selectedNumInd = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      _selectedNumInd = widget.data - 1;
    });
  }

  final _numList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];

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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CupertinoButton(
                padding: EdgeInsets.zero,
                // Display a CupertinoPicker with list of fruits.
                onPressed: () => _showDialog(
                  CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                        initialItem: _selectedNumInd),
                    magnification: 1.22,
                    squeeze: 1.2,
                    useMagnifier: true,
                    itemExtent: 32.0,
                    // This is called when selected item is changed.
                    onSelectedItemChanged: (int selectedItem) {
                      widget.setter(_numList[selectedItem]);
                      setState(() {
                        _selectedNumInd = selectedItem;
                      });
                    },
                    children:
                        List<Widget>.generate(_numList.length, (int index) {
                      return Center(
                        child: Text(
                          _numList[index].toString(),
                        ),
                      );
                    }),
                  ),
                ),
                // This displays the selected fruit name.
                child: Text(_numList[_selectedNumInd].toString() + '명',
                    style: textStyle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
