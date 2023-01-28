import 'package:flutter/material.dart';
import 'package:team/helper/DatabaseService.dart';
import 'package:team/helper/ProjectCRUD.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ChangeStudentInfo.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:team/Project/main/studentlist.dart';
import 'package:team/Project/main/teamlist.dart';
import 'package:team/student/team/MyTeamInfo.dart';
import 'package:form_validator/form_validator.dart';

class OthersStudentInfoPage extends StatefulWidget {
  String projectId = "";
  String projectname = "";
  String stuName = "";
  String stuSecretId = "";
  String stuId = "";
  OthersStudentInfoPage(this.projectId, this.projectname, this.stuId,
      this.stuSecretId, this.stuName);

  @override
  State<OthersStudentInfoPage> createState() => _OthersStudentInfoPageState();
}

class _OthersStudentInfoPageState extends State<OthersStudentInfoPage> {
  String newComment = "";
  final textStyle = const TextStyle(
      fontFamily: "GmarketSansTTF", fontSize: 12, color: Colors.black54);

  late ProjectCRUD projectCRUD = ProjectCRUD(widget.projectId);
  var _controller = TextEditingController();
  String changedText = "";
  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }

  bool isNowLoading = false;

  String team_id = "";
  String team_name = "";
  String attend_id = "";
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
    projectCRUD.getAttendeeIDhdm(widget.stuId).then((value) {
      attend_id = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        gettingData();
      });
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black87,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          backgroundColor: Colors.white,
          title: Text(
            "학생 정보",
            style: TextStyle(
                color: Colors.black87,
                fontFamily: "GmarketSansTTF",
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: FutureBuilder(
          future: projectCRUD.getOthersAttendeeInfo(widget.stuId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(width: 10, height: 1, color: Colors.grey),
                          Text("  학번 및 이름  ", style: textStyle),
                          Flexible(
                              fit: FlexFit.loose,
                              child: Container(height: 1, color: Colors.grey)),
                        ],
                      ),
                    ),
                    Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "[" +
                                widget.stuSecretId +
                                "] " +
                                snapshot.data['name'].toString(),
                            style: TextStyle(
                                color: Colors.black87,
                                fontFamily: "GmarketSansTTF",
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Text("      "),
                          SizedBox(
                              width: 55,
                              height: 26,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    backgroundColor: Colors.lightBlueAccent,
                                    elevation: 0,
                                    disabledBackgroundColor:
                                        Colors.lightBlueAccent.shade100),
                                child: !isNowLoading
                                    ? Text(
                                        "초대",
                                        style: TextStyle(
                                            fontFamily: "GmarketSansTTF",
                                            fontSize: 13,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : Container(
                                        width: 10,
                                        height: 10,
                                        padding: const EdgeInsets.all(2.0),
                                        child: const CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                onPressed: !isNowLoading
                                    ? () async {
                                        try {
                                          bool flag = false;
                                          await DatabaseService()
                                              .requseteamTostu(widget.projectId,
                                                  attend_id, team_id, team_name)
                                              .then((value) {
                                            flag = value!;
                                          });
                                          if (flag) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                "요청을 성공적으로 보냈습니다.",
                                                style: TextStyle(
                                                  fontFamily: "GmarketSansTTF",
                                                  fontSize: 14,
                                                ),
                                              ),
                                              backgroundColor:
                                                  Colors.lightBlueAccent,
                                            ));
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                "이미 요청했습니다.",
                                                style: TextStyle(
                                                  fontFamily: "GmarketSansTTF",
                                                  fontSize: 14,
                                                ),
                                              ),
                                              backgroundColor:
                                                  Colors.lightBlueAccent,
                                            ));
                                          }
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                              "초대를 실패하였습니다. ",
                                              style: TextStyle(
                                                fontFamily: "GmarketSansTTF",
                                                fontSize: 14,
                                              ),
                                            ),
                                            backgroundColor:
                                                Colors.lightBlueAccent,
                                          ));
                                        }
                                        setState(() {
                                          isNowLoading = false;
                                        });
                                      }
                                    : null,
                              ))
                        ]),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(width: 10, height: 1, color: Colors.grey),
                          Text("  내 소개  ", style: textStyle),
                          Flexible(
                              fit: FlexFit.loose,
                              child: Container(height: 1, color: Colors.grey)),
                        ],
                      ),
                    ),
                    Text(
                      snapshot.data['introduction'].toString() == "" ||
                              snapshot.data['introduction'].toString() == "null"
                          ? "아직 소개글을 작성하지 않았습니다. "
                          : snapshot.data['introduction'].toString(),
                      style: snapshot.data['introduction'].toString() == "" ||
                              snapshot.data['introduction'].toString() == "null"
                          ? TextStyle(
                              fontFamily: "GmarketSansTTF",
                              fontSize: 14,
                              color: Colors.black87)
                          : TextStyle(
                              color: Colors.black87,
                              fontFamily: "GmarketSansTTF",
                              fontSize: 16),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(width: 10, height: 1, color: Colors.grey),
                          Text("  원하는 팀  ", style: textStyle),
                          Flexible(
                              fit: FlexFit.loose,
                              child: Container(height: 1, color: Colors.grey)),
                        ],
                      ),
                    ),
                    Text(
                      snapshot.data['finding_team_info'].toString() != "" ||
                              snapshot.data['finding_team_info'].toString() !=
                                  "null"
                          ? "아직 원하는 팀 정보를 작성하지 않았습니다. "
                          : snapshot.data['finding_team_info'].toString(),
                      style: snapshot.data['finding_team_info'].toString() !=
                                  "" ||
                              snapshot.data['finding_team_info'].toString() !=
                                  "null"
                          ? TextStyle(
                              fontFamily: "GmarketSansTTF",
                              fontSize: 14,
                              color: Colors.black87)
                          : TextStyle(
                              color: Colors.black87,
                              fontFamily: "GmarketSansTTF",
                              fontSize: 16),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(width: 10, height: 1, color: Colors.grey),
                          Text("  연락 방법  ", style: textStyle),
                          Flexible(
                              fit: FlexFit.loose,
                              child: Container(height: 1, color: Colors.grey)),
                        ],
                      ),
                    ),
                    Contact(snapshot),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(width: 10, height: 1, color: Colors.grey),
                          Text("  댓글  ", style: textStyle),
                          Flexible(
                              fit: FlexFit.loose,
                              child: Container(height: 1, color: Colors.grey)),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 150,
                      child: FutureBuilder(
                          future: projectCRUD.getAttendeeComment(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    TextEditingController _textFieldController =
                                        TextEditingController(
                                            text: snapshot.data[index]
                                                ['content']);
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              snapshot.data[index]['name'],
                                              style: TextStyle(
                                                  color: Colors.black87,
                                                  fontFamily: "GmarketSansTTF",
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                                snapshot.data[index]['content'],
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontFamily: "GmarketSansTTF",
                                                  fontSize: 14,
                                                )),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                            title: Text('댓글 수정',
                                                                style:
                                                                    textStyle),
                                                            content: TextField(
                                                              onChanged:
                                                                  (value) {
                                                                changedText =
                                                                    value;
                                                              },
                                                              controller:
                                                                  _textFieldController,
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    OutlineInputBorder(),
                                                                floatingLabelBehavior:
                                                                    FloatingLabelBehavior
                                                                        .always,
                                                                labelStyle:
                                                                    const TextStyle(
                                                                  fontFamily:
                                                                      "GmarketSansTTF",
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                            ),
                                                            actions: [
                                                              IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    projectCRUD.updateAttendeeComment(
                                                                        changedText,
                                                                        snapshot
                                                                            .data[index]
                                                                            .toString());
                                                                    Navigator.pop(
                                                                        context);
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  icon: Icon(
                                                                      Icons
                                                                          .done,
                                                                      size: 18))
                                                            ]);
                                                      });
                                                },
                                                icon:
                                                    Icon(Icons.edit, size: 18)),
                                            IconButton(
                                                onPressed: () {
                                                  projectCRUD
                                                      .deleteAttendeeComment(
                                                          snapshot.data[index]
                                                              .toString());
                                                  setState(() {});
                                                },
                                                icon: Icon(Icons.delete,
                                                    size: 18))
                                          ],
                                        )
                                      ],
                                    );
                                  });
                            }
                            return Center(
                                child: Text("No Comment", style: textStyle));
                            ;
                          }),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              labelText: '새 댓글',
                              border: OutlineInputBorder(),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelStyle: const TextStyle(
                                fontFamily: "GmarketSansTTF",
                                fontSize: 16,
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                newComment = value as String;
                              });
                            },
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              if (newComment.length > 0) {
                                projectCRUD.addAttendeeComment(
                                    newComment, false);
                              }
                              newComment = "";
                              _controller.clear();
                              setState(() {});
                            },
                            icon: Icon(Icons.send, size: 20))
                      ],
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                  child:
                      CircularProgressIndicator(color: Colors.lightBlueAccent));
            }
          },
        ),
      );
    });
  }
}

class Contact extends StatelessWidget {
  var snapshot;
  Contact(this.snapshot);
  Widget build(BuildContext context) {
    if (snapshot.data['contact_infos'] != null) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data['contact_infos'].length,
          itemBuilder: (ctx, ind) {
            String title =
                snapshot.data['contact_infos'][ind]['title'].toString();
            String content =
                snapshot.data['contact_infos'][ind]['content'].toString();
            String prefix = "";
            bool notLinkable = false;

            if (RegExp(
                    r"^(((http(s?))\:\/\/)?)([0-9a-zA-Z\-]+\.)+[a-zA-Z]{2,6}(\:[0-9]+)?(\/\S*)?")
                .hasMatch(content)) {
              print(content);
              if (!RegExp(r"^(((http(s))\:\/\/))").hasMatch(content)) {
                print("https 달아주기");
                content = "https://" + content;
              }
              print("링크");
            } else if (RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(content)) {
              print(content);
              print("메일");
              prefix = 'mailto:';
            } else if (RegExp(r"^\d{3}-?\d{3,4}-?\d{4}$").hasMatch(content)) {
              print(content);
              print("전화");
              prefix = 'tel:';
            } else {
              notLinkable = true;
            }

            return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Chip(
                      avatar: notLinkable
                          ? CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Icon(Icons.circle_outlined,
                                  color: Colors.black87, size: 15))
                          : prefix == ""
                              ? CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: Icon(Icons.link,
                                      color: Colors.black87, size: 15))
                              : prefix == "mailto:"
                                  ? CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      child: Icon(Icons.mail,
                                          color: Colors.black87, size: 15))
                                  : CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      child: Icon(Icons.phone,
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
                      label: Container(
                          width: 35,
                          alignment: Alignment(0.0, 0.0),
                          child: Text(title))),
                  Text("      "),
                  InkWell(
                      child: Text(
                        '${snapshot.data['contact_infos'][ind]['content'].toString()}',
                        style: notLinkable
                            ? TextStyle(
                                color: Colors.black87,
                                fontFamily: "GmarketSansTTF",
                                fontSize: 16)
                            : TextStyle(
                                color: Colors.lightBlueAccent.shade700,
                                fontFamily: "GmarketSansTTF",
                                fontSize: 14,
                                decoration: TextDecoration.underline,
                              ),
                      ),
                      onTap: () async {
                        if (content != "") {
                          Uri uri = Uri.parse(prefix + content);
                          launchUrl(uri);
                        }
                      })
                ]);
          });
    } else {
      return Text(
        "아직 연락 방법 목록을 작성하지 않았습니다. ",
        style: TextStyle(
            fontFamily: "GmarketSansTTF", fontSize: 14, color: Colors.black87),
      );
    }
  }
}
