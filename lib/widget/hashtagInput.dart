import 'package:flutter/material.dart';
import 'package:team/helper/DatabaseService.dart';
import 'package:team/helper/ProjectCRUD.dart';

class Hashtags extends StatefulWidget {
  final List<dynamic> hashtags;
  final Function(List<String> tags) setter;
  final String projectid;
  final String type;
  const Hashtags({
    Key? key,
    required this.hashtags,
    required this.setter,
    required this.projectid,
    required this.type,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _hashtagsInputState();
}

class _hashtagsInputState extends State<Hashtags> {
  List<String> tags = [];

  @override
  void initState() {
    setState(() {
      widget.hashtags.forEach((value) {
        tags.add(value.toString());
      });

      Future.delayed(Duration.zero, () {
        widget.setter(tags);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
        shrinkWrap: true,
        itemCount: tags.length + 1,
        itemBuilder: (ctx, ind) {
          if (ind != tags.length) {
            return Row(children: <Widget>[
              Flexible(
                flex: 9,
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "해시태그",
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(15, 20, 20, 0),
                    hintStyle: const TextStyle(
                      fontFamily: "GmarketSansTTF",
                      fontSize: 12,
                    ),
                  ),
                  initialValue: tags[ind],
                  onChanged: (value) {
                    setState(() {
                      tags[ind] = value.trim();
                      widget.setter(tags);
                    });
                  },
                ),
              ),
              Flexible(
                  flex: 1,
                  child: IconButton(
                    icon: Icon(Icons.remove,
                        color: Colors.blue.shade400, size: 15),
                    onPressed: () {
                      setState(() {
                        tags.removeAt(ind);
                        widget.setter(tags);
                      });
                    },
                  )),
            ]);
          } else {
            return TextButton(
              child: const Text(
                '+ 새 태그 추가',
                style: TextStyle(
                  fontFamily: "GmarketSansTTF",
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                setState(() {
                  tags.add("");
                });
              },
            );
          }
        });
  }
}
