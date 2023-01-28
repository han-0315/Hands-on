import 'package:flutter/material.dart';
import 'package:team/professor/profprojectList.dart';
import 'package:team/helper/DatabaseService.dart';
import 'package:team/student/team/MyTeamInfo.dart';
import 'package:team/student/student_info/MyStudentInfo.dart';
import 'package:team/student/student_info/OthersStudentInfo.dart';

class Student_tile extends StatefulWidget {
  final String name;
  final String info;
  final String id;
  final String projectid;
  final String projectname;
  final bool isMine;
  //final String opponent;
  const Student_tile(
      {Key? key,
      required this.projectname,
      required this.name,
      required this.info,
      required this.id,
      required this.projectid,
      required this.isMine
      //required this.opponent,
      })
      : super(key: key);

  @override
  State<Student_tile> createState() => _StudenttileState();
}

class _StudenttileState extends State<Student_tile> {
  final textStyle_title = const TextStyle(
      fontFamily: "GmarketSansTTF",
      fontSize: 18,
      color: Colors.black,
      fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    String secretId = widget.id.substring(0, 4) + "##" + widget.id.substring(6);
    return GestureDetector(
      onTap: () {
        if (widget.isMine) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MyStudentInfoPage(widget.projectid, widget.projectname)));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OthersStudentInfoPage(widget.projectid,
                      widget.projectname, widget.id, secretId, widget.name)));
        }
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 3, 10, 0),
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: Colors.black26),
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          child: ListTile(
            title: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(Icons.person),
                  SizedBox(width: 10),
                  Text(
                    textAlign: TextAlign.left,
                    "[" + secretId + "] " + widget.name, //DB에서 가져옴
                    style: textStyle_title,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 2),
                      // Chip(
                      //   avatar: CircleAvatar(
                      //       backgroundColor: Colors.transparent,
                      //       child: Icon(Icons.people,
                      //           color: Colors.black87, size: 15)),
                      //   backgroundColor: Colors.white,
                      //   shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(15),
                      //     side: BorderSide(
                      //       width: 1,
                      //       color: Colors.black26,
                      //     ),
                      //   ),
                      //   labelStyle: TextStyle(
                      //       fontFamily: "GmarketSansTTF",
                      //       fontSize: 14,
                      //       color: Colors.black87,
                      //       fontWeight: FontWeight.bold),
                      //   visualDensity:
                      //       VisualDensity(horizontal: 0, vertical: -3.5),
                      //   label: Container(
                      //       width: 20,
                      //       alignment: Alignment(0.0, 0.0),
                      //       child: Text(widget.memNum.toString() + "명")),
                      // ),
                      // SizedBox(
                      //   height: 2,
                      // ),
                      // RichText(
                      //   text: TextSpan(
                      //     children: [
                      //       TextSpan(
                      //           text: "구성 완료 ",
                      //           style: TextStyle(
                      //               fontFamily: "GmarketSansTTF",
                      //               color: Colors.black87,
                      //               fontSize: 10,
                      //               fontWeight: FontWeight.bold)),
                      //       WidgetSpan(
                      //           child: widget.isfinished
                      //               ? Icon(Icons.check_box_outlined,
                      //                   size: 12, color: Colors.black87)
                      //               : Icon(
                      //                   Icons.check_box_outline_blank_outlined,
                      //                   size: 12,
                      //                   color: Colors.black87)),
                      //     ],
                      //   ),
                      // ),
                      SizedBox(height: 5),
                    ],
                  ),
                ]),
            // subtitle: Text(
            //   //같은 수업에 여러가지 팀플을 대비한 공간
            //   widget.info, // 일단은 걍 이거 두기
            //   style: const TextStyle(fontSize: 10),
            // ),
          ),
        ),
      ),
    );
  }
}
