import 'package:flutter/material.dart';
import 'package:team/professor/profprojectList.dart';
import 'package:team/helper/DatabaseService.dart';
import 'package:team/student/team/MyTeamInfo.dart';
import 'package:team/student/student_info/MyStudentInfo.dart';
import 'package:team/student/student_info/OthersStudentInfo.dart';

class Student_tile_small extends StatefulWidget {
  final String name;
  final String info;
  final String id;
  final String projectid;
  final String projectname;
  final bool isMine;
  final bool isLeader;
  //final String opponent;
  const Student_tile_small(
      {Key? key,
      required this.projectname,
      required this.name,
      required this.info,
      required this.id,
      required this.projectid,
      required this.isMine,
      required this.isLeader
      //required this.opponent,
      })
      : super(key: key);

  @override
  State<Student_tile_small> createState() => _StudenttileSmallState();
}

class _StudenttileSmallState extends State<Student_tile_small> {
  final textStyle_title = const TextStyle(
      fontFamily: "GmarketSansTTF",
      fontSize: 16,
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
        // height: 45,
        padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
        alignment: Alignment.center,
        child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(widget.isLeader ? Icons.star_rate_rounded : Icons.person,
                  size: 20,
                  color:
                      widget.isLeader ? Colors.lightBlueAccent : Colors.grey),
              SizedBox(width: 8),
              Text(
                textAlign: TextAlign.left,
                "[" + secretId + "] " + widget.name, //DB에서 가져옴
                style: textStyle_title,
              ),
            ]),
        // subtitle: Text(
        //   //같은 수업에 여러가지 팀플을 대비한 공간
        //   widget.info, // 일단은 걍 이거 두기
        //   style: const TextStyle(fontSize: 10),
        // ),
      ),
    );
  }
}
