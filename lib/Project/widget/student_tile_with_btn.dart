import 'package:flutter/material.dart';
import 'package:team/professor/profprojectList.dart';
import 'package:team/helper/DatabaseService.dart';
import 'package:team/student/team/MyTeamInfo.dart';
import 'package:team/student/student_info/MyStudentInfo.dart';
import 'package:team/student/student_info/OthersStudentInfo.dart';
import 'package:team/helper/ProjectCRUD.dart';

class Student_tile_with_btn extends StatefulWidget {
  final String name;
  final String info;
  final String id;
  final String projectid;
  final String projectname;
  final bool isMine;
  //final String opponent;
  const Student_tile_with_btn(
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
  State<Student_tile_with_btn> createState() => _StudenttileWithBtnState();
}

class _StudenttileWithBtnState extends State<Student_tile_with_btn> {
  final textStyle_title = const TextStyle(
      fontFamily: "GmarketSansTTF",
      fontSize: 18,
      color: Colors.black,
      fontWeight: FontWeight.bold);

  String team_id = "";
  String team_name = "";
  String attend_id = "";
  late ProjectCRUD projectCRUD = ProjectCRUD(widget.projectid);
  bool isfinished = false;

  @override
  void initState() {
    gettingData();
    super.initState();
  }

  gettingData() async {
    await projectCRUD.getTeamname().then((value) {
      team_name = value;
    });
    projectCRUD.getTeamIDHDM(team_name).then((value) {
      team_id = value;
    });
    await projectCRUD.getAttendeeIDhdm(widget.id).then((value) {
      attend_id = value;
    });
  }

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
      child: isfinished
          ? Container(
              padding: const EdgeInsets.fromLTRB(10, 3, 10, 0),
              child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Colors.black26),
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
                child: ListTile(
                  title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          textAlign: TextAlign.left,
                          "[" + secretId + "] " + widget.name, //DB에서 가져옴
                          style: textStyle_title,
                        ),
                        Row(
                          children: <Widget>[
                            ActionChip(
                                backgroundColor: Colors.lightBlueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  // side: BorderSide(
                                  //   width: 1,
                                  //   color: Colors.black26,
                                  // ),
                                ),
                                labelStyle: TextStyle(
                                    fontFamily: "GmarketSansTTF",
                                    fontSize: 12,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold),
                                visualDensity: VisualDensity(
                                    horizontal: -1, vertical: -3.5),
                                label: Text(
                                  "수락",
                                  style: TextStyle(
                                      fontFamily: "GmarketSansTTF",
                                      fontSize: 13,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () async {
                                  try {
                                    bool flag = false;
                                    await DatabaseService()
                                        .responseteam(
                                            widget.projectid,
                                            attend_id,
                                            team_id,
                                            team_name,
                                            true,
                                            widget.id)
                                        .then((value) {
                                      flag = value!;
                                    });
                                    if (flag) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                          "팀원 신청을 수락했습니다. ",
                                          style: TextStyle(
                                            fontFamily: "GmarketSansTTF",
                                            fontSize: 14,
                                          ),
                                        ),
                                        backgroundColor: Colors.lightBlueAccent,
                                      ));
                                      setState(() {
                                        isfinished = false;
                                      });
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                        "팀원 신청 수락을 실패하였습니다. ",
                                        style: TextStyle(
                                          fontFamily: "GmarketSansTTF",
                                          fontSize: 14,
                                        ),
                                      ),
                                      backgroundColor: Colors.lightBlueAccent,
                                    ));
                                  }
                                }),
                            SizedBox(width: 5),
                            ActionChip(
                                backgroundColor: Colors.lightBlueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  // side: BorderSide(
                                  //   width: 1,
                                  //   color: Colors.black26,
                                  // ),
                                ),
                                labelStyle: TextStyle(
                                    fontFamily: "GmarketSansTTF",
                                    fontSize: 12,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold),
                                visualDensity: VisualDensity(
                                    horizontal: -1, vertical: -3.5),
                                label: Text(
                                  "거절",
                                  style: TextStyle(
                                      fontFamily: "GmarketSansTTF",
                                      fontSize: 13,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () async {
                                  try {
                                    bool flag = false;
                                    await DatabaseService()
                                        .responseteam(
                                            widget.projectid,
                                            attend_id,
                                            team_id,
                                            team_name,
                                            false,
                                            widget.id)
                                        .then((value) {
                                      flag = value!;
                                    });
                                    if (flag) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                          "팀원 신청을 거절했습니다. ",
                                          style: TextStyle(
                                            fontFamily: "GmarketSansTTF",
                                            fontSize: 14,
                                          ),
                                        ),
                                        backgroundColor: Colors.lightBlueAccent,
                                      ));
                                      setState(() {
                                        isfinished = false;
                                      });
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(
                                        "팀원 신청 거절을 실패하였습니다. ",
                                        style: TextStyle(
                                          fontFamily: "GmarketSansTTF",
                                          fontSize: 14,
                                        ),
                                      ),
                                      backgroundColor: Colors.lightBlueAccent,
                                    ));
                                  }
                                }),
                          ],
                        )
                      ]),
                  // subtitle: Text(
                  //   //같은 수업에 여러가지 팀플을 대비한 공간
                  //   widget.info, // 일단은 걍 이거 두기
                  //   style: const TextStyle(fontSize: 10),
                  // ),
                ),
              ),
            )
          : Container(),
    );
  }
}
