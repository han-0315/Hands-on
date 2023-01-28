import 'package:flutter/material.dart';
import 'package:team/professor/profprojectList.dart';
import 'package:team/helper/DatabaseService.dart';
import 'package:team/student/team/MyTeamInfo.dart';
import '../../student/team/OthersTeamInfo.dart';
import 'package:team/helper/ProjectCRUD.dart';

class Teamtile_with_btn extends StatefulWidget {
  final String teamName;
  final String teaminfo;
  final String projectid;
  final String projectname;
  final bool isfinished;
  final int memNum;
  final bool isMyTeam;
  //final String opponent;
  const Teamtile_with_btn({
    Key? key,
    required this.teamName,
    required this.teaminfo,
    required this.projectid,
    required this.projectname,
    required this.isfinished,
    required this.memNum,
    required this.isMyTeam,
    //required this.opponent,
  }) : super(key: key);

  @override
  State<Teamtile_with_btn> createState() => _Teamtile_with_btnState();
}

class _Teamtile_with_btnState extends State<Teamtile_with_btn> {
  final textStyle_title = const TextStyle(
      fontFamily: "GmarketSansTTF",
      fontSize: 18,
      color: Colors.black,
      fontWeight: FontWeight.bold);

  String team_id = "";
  String attend_id = "";
  String stu_id = "";
  late ProjectCRUD projectCRUD = ProjectCRUD(widget.projectid);
  void initState() {
    gettingData();
    super.initState();
  }

  gettingData() async {
    projectCRUD.getTeamIDHDM(widget.teamName).then((value) {
      team_id = value;
    });
    await projectCRUD.getstu_id().then((value) {
      stu_id = value;
    });
    await projectCRUD.getAttendeeIDhdm(stu_id).then((value) {
      attend_id = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.isMyTeam) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MyTeamInfoPage(widget.projectid, widget.projectname)));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OthersTeamInfoPage(
                      widget.projectid, widget.projectname, widget.teamName)));
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(children: <Widget>[
                    Text(
                      widget.teamName, //DB에서 가져옴
                      style: textStyle_title,
                    ),
                    SizedBox(width: 15),
                    Chip(
                      avatar: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Icon(Icons.people,
                              color: Colors.black87, size: 15)),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(
                          width: 1,
                          color: Colors.black26,
                        ),
                      ),
                      labelStyle: TextStyle(
                          fontFamily: "GmarketSansTTF",
                          fontSize: 14,
                          color: Colors.black87,
                          fontWeight: FontWeight.bold),
                      visualDensity:
                          VisualDensity(horizontal: -1, vertical: -3.5),
                      label: Text(widget.memNum.toString()),
                    ),
                  ]),
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
                          visualDensity:
                              VisualDensity(horizontal: -1, vertical: -3.5),
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
                                  .responsestu(widget.projectid, attend_id,
                                      team_id, widget.teamName, true, stu_id)
                                  .then((value) {
                                flag = value!;
                              });
                              if (flag) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                    "팀원 신청을 수락했습니다.",
                                    style: TextStyle(
                                      fontFamily: "GmarketSansTTF",
                                      fontSize: 14,
                                    ),
                                  ),
                                  backgroundColor: Colors.lightBlueAccent,
                                ));
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
                          visualDensity:
                              VisualDensity(horizontal: -1, vertical: -3.5),
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
                                  .responsestu(widget.projectid, attend_id,
                                      team_id, widget.teamName, false, stu_id)
                                  .then((value) {
                                flag = value!;
                              });
                              if (flag) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                    "팀원 신청을 거절했습니다.",
                                    style: TextStyle(
                                      fontFamily: "GmarketSansTTF",
                                      fontSize: 14,
                                    ),
                                  ),
                                  backgroundColor: Colors.lightBlueAccent,
                                ));
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
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
