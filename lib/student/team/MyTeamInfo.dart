import 'package:flutter/material.dart';
import 'package:team/helper/DatabaseService.dart';
import 'package:team/helper/ProjectCRUD.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'AddNewTeam.dart';
import 'ChangeTeamInfo.dart';
import 'Candidate.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../Project/widget/student_tile_small.dart';

class MyTeamInfoPage extends StatefulWidget {
  String projectId = "";
  String projectname = "";
  MyTeamInfoPage(this.projectId, this.projectname);

  @override
  State<MyTeamInfoPage> createState() => _MyTeamInfoPageState();
}

class _MyTeamInfoPageState extends State<MyTeamInfoPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  String newComment = "";
  String stuId = "";
  final textStyle = const TextStyle(
      fontFamily: "GmarketSansTTF", fontSize: 12, color: Colors.black54);
  late ProjectCRUD projectCRUD = ProjectCRUD(widget.projectId);
  var _controller = TextEditingController();
  bool isNull = true; // for test
  int candidateNum = 0;
  List<dynamic> stuIds = [];
  List<dynamic> mems = [];
  String leaderId = "";
  String changedText = "";

  bool renderOnce = false;

  @override
  void initState() {
    projectCRUD.getstu_id().then((id) {
      setState(() {
        stuId = id;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: const Text(
              "내 팀 정보",
              style: TextStyle(
                  color: Colors.black87,
                  fontFamily: "GmarketSansTTF",
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black87,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
            backgroundColor: Colors.white,
            actions: !isNull
                ? [
                    ActionChip(
                        avatar: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Icon(Icons.person,
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
                            fontSize: 12,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold),
                        visualDensity:
                            VisualDensity(horizontal: -1, vertical: -3.5),
                        label: Text("+ " + candidateNum.toString()),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Candidate(
                                      projectId: widget.projectId,
                                      projectname: widget.projectname,
                                      stuIds: stuIds)));
                        }),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChangeTeamInfo(widget.projectId)));
                        },
                        color: Colors.black87,
                        icon: const Icon(Icons.edit_note, size: 22)),
                  ]
                : []),
        body: FutureBuilder(
            future: projectCRUD.getTeamInfo(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // print(snapshot.data["isNull"]);
                if (snapshot.data['isNull'] == null) {
                  if (renderOnce == false) {
                    renderOnce = true;
                    Future.delayed(Duration.zero, () {
                      setState(() {
                        isNull = false;

                        setState(() {
                          candidateNum = snapshot.data['후보학생'] == null
                              ? 0
                              : snapshot.data['후보학생'].length;

                          if (candidateNum != 0) stuIds = snapshot.data['후보학생'];

                          mems = snapshot.data['members'];
                          leaderId = snapshot.data["leader_id"] == null
                              ? ""
                              : snapshot.data["leader_id"];
                        });
                      });
                    });
                  }

                  return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SmartRefresher(
                          controller: _refreshController,
                          onRefresh: _onRefresh,
                          child: ListView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        width: 10,
                                        height: 1,
                                        color: Colors.grey),
                                    Text("  팀 이름  ", style: textStyle),
                                    Flexible(
                                        fit: FlexFit.loose,
                                        child: Container(
                                            height: 1, color: Colors.grey)),
                                  ],
                                ),
                              ),
                              Text(
                                snapshot.data['name'].toString(),
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontFamily: "GmarketSansTTF",
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, bottom: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        width: 10,
                                        height: 1,
                                        color: Colors.grey),
                                    Text("  팀원 정보  ", style: textStyle),
                                    Flexible(
                                        fit: FlexFit.loose,
                                        child: Container(
                                            height: 1, color: Colors.grey)),
                                  ],
                                ),
                              ),
                              members(),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 12, bottom: 7),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        width: 10,
                                        height: 1,
                                        color: Colors.grey),
                                    Text("  팀 소개  ", style: textStyle),
                                    Flexible(
                                        fit: FlexFit.loose,
                                        child: Container(
                                            height: 1, color: Colors.grey)),
                                  ],
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(bottom: 7),
                                child: Wrap(
                                  direction: Axis.horizontal, // 정렬 방향
                                  alignment: WrapAlignment.start,
                                  spacing: 6, // 상하(좌우) 공간
                                  children: _buildChipList(snapshot.data[
                                      'hashtags']), //타입 1: food, 2: place, 3: pref
                                ),
                              ),
                              Text(
                                snapshot.data['introduction'].toString() ==
                                            "" ||
                                        snapshot.data['introduction']
                                                .toString() ==
                                            "null"
                                    ? "아직 팀 소개를 작성하지 않았습니다. "
                                    : snapshot.data['introduction'].toString(),
                                style:
                                    snapshot.data['introduction'].toString() ==
                                                "" ||
                                            snapshot.data['introduction']
                                                    .toString() ==
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
                                padding:
                                    const EdgeInsets.only(top: 15, bottom: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        width: 10,
                                        height: 1,
                                        color: Colors.grey),
                                    Text("  원하는 팀원  ", style: textStyle),
                                    Flexible(
                                        fit: FlexFit.loose,
                                        child: Container(
                                            height: 1, color: Colors.grey)),
                                  ],
                                ),
                              ),
                              Text(
                                snapshot.data['finding_member_info']
                                                .toString() ==
                                            "" ||
                                        snapshot.data['finding_member_info']
                                                .toString() ==
                                            "null"
                                    ? "아직 원하는 팀원 정보를 작성하지 않았습니다. "
                                    : snapshot.data['finding_member_info']
                                        .toString(),
                                style: snapshot.data['finding_member_info']
                                                .toString() ==
                                            "" ||
                                        snapshot.data['finding_member_info']
                                                .toString() ==
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
                              // *TODO : 해쉬태그는 나중에 원하는 팀원 text 위에 다른 해쉬태그 디자인 참고해서 넣을 것
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, bottom: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        width: 10,
                                        height: 1,
                                        color: Colors.grey),
                                    Text("  댓글  ", style: textStyle),
                                    Flexible(
                                        fit: FlexFit.loose,
                                        child: Container(
                                            height: 1, color: Colors.grey)),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 150,
                                child: FutureBuilder(
                                    future: projectCRUD.getTeamComment(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        print(snapshot.data.toString());
                                        return ListView.builder(
                                            itemCount: snapshot.data.length,
                                            itemBuilder: (context, index) {
                                              TextEditingController
                                                  _textFieldController =
                                                  TextEditingController(
                                                      text: snapshot.data[index]
                                                          ['content']);
                                              TextEditingController
                                                  _textFieldController2 =
                                                  TextEditingController();
                                              return Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Comment(
                                                          snapshot.data[index]),
                                                      EditIcon(
                                                          snapshot.data[index],
                                                          projectCRUD),
                                                      IconButton(
                                                          onPressed: () {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return AlertDialog(
                                                                      title:
                                                                          Text(
                                                                        '댓글 수정',
                                                                        style:
                                                                            textStyle,
                                                                      ),
                                                                      content:
                                                                          TextField(
                                                                        onChanged:
                                                                            (value) {
                                                                          changedText =
                                                                              value;
                                                                        },
                                                                        controller:
                                                                            _textFieldController,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          hintText:
                                                                              "댓글 수정",
                                                                          border:
                                                                              OutlineInputBorder(),
                                                                          floatingLabelBehavior:
                                                                              FloatingLabelBehavior.always,
                                                                          labelStyle:
                                                                              const TextStyle(
                                                                            fontFamily:
                                                                                "GmarketSansTTF",
                                                                            fontSize:
                                                                                16,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      actions: [
                                                                        IconButton(
                                                                            onPressed:
                                                                                () {
                                                                              if (changedText.length > 0) {
                                                                                if (snapshot.data[index].containsKey('comment_id')) {
                                                                                  projectCRUD.updateTeamReply(snapshot.data[index].toString(), changedText);
                                                                                  Navigator.pop(context);
                                                                                  setState(() {});
                                                                                } else {
                                                                                  projectCRUD.updateTeamComment(changedText, snapshot.data[index].toString());
                                                                                  Navigator.pop(context);
                                                                                  setState(() {});
                                                                                }
                                                                              }
                                                                            },
                                                                            icon:
                                                                                Icon(Icons.done))
                                                                      ]);
                                                                });
                                                          },
                                                          icon:
                                                              Icon(Icons.edit)),
                                                      IconButton(
                                                          onPressed: () {
                                                            if (snapshot
                                                                .data[index]
                                                                .containsKey(
                                                                    'comment_id')) {
                                                              projectCRUD.deleteTeamReply(
                                                                  snapshot.data[
                                                                          index]
                                                                      .toString());
                                                            } else {
                                                              projectCRUD.deleteTeamComment(
                                                                  snapshot.data[
                                                                          index]
                                                                      .toString());
                                                              setState(() {});
                                                            }
                                                          },
                                                          icon: Icon(
                                                              Icons.delete))
                                                    ],
                                                  ),
                                                ],
                                              );
                                            });
                                      } else {
                                        return Center(
                                            child: Text("No Comment"));
                                      }
                                    }),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: TextField(
                                      controller: _controller,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        labelStyle: const TextStyle(
                                          fontFamily: "GmarketSansTTF",
                                          fontSize: 16,
                                        ),
                                        labelText: '새 댓글',
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
                                          projectCRUD.addTeamComment(
                                              newComment, false);
                                        }
                                        newComment = "";
                                        _controller.clear();
                                        setState(() {});
                                      },
                                      icon: Icon(Icons.send))
                                ],
                              ),
                            ],
                          )));
                } else {
                  // Future.delayed(Duration.zero, () {
                  //   setState(() {
                  //     isNull = true;
                  //   });
                  // });

                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "소속된 팀이 없습니다.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "GmarketSansTTF",
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                            child: const Text(
                              '+  새 팀 생성',
                              style: TextStyle(
                                  fontFamily: "GmarketSansTTF", fontSize: 16),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AddNewTeam(widget.projectId)));
                            })
                      ],
                    ),
                  );
                }
              } else {
                return const Center(
                    child: CircularProgressIndicator(
                        color: Colors.lightBlueAccent));
              }
            }));
  }

  members() {
    return FutureBuilder(
        future: projectCRUD.getMemsInfo(mems),
        builder: (context, snapshot) {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data == null ? 1 : snapshot.data.length,
              itemBuilder: (context, index) {
                if (snapshot.data == null) {
                  return const Center(
                      child: CircularProgressIndicator(
                          color: Colors.lightBlueAccent));
                } else {
                  return Student_tile_small(
                      name: snapshot.data[index]['name'],
                      info: snapshot.data[index]['introduction'],
                      id: snapshot.data[index]['stu_id'],
                      projectid: widget.projectId,
                      projectname: widget.projectname,
                      isMine:
                          stuId == snapshot.data[index]['stu_id'].toString(),
                      isLeader: leaderId ==
                          snapshot.data[index]['stu_id'].toString());
                }
              });
        });
  }

  _buildChipList(List<dynamic> hashtags) {
    List<Widget> chips = [];
    hashtags.forEach((element) {
      chips.add(
        Chip(
          backgroundColor: Colors.grey.shade300,
          label: Text("# " + element),
          visualDensity: VisualDensity(horizontal: -1, vertical: -3.5),
          labelStyle: TextStyle(
              fontFamily: "GmarketSansTTF",
              color: Colors.black87,
              fontSize: 12),
        ),
      );
    });
    return chips;
  }
}

class Comment extends StatelessWidget {
  Map<String, dynamic> newcolumn = {};

  Comment(this.newcolumn);

  String additional = "";

  @override
  Widget build(BuildContext context) {
    if (newcolumn.containsKey('comment_id')) {
      additional = "    ";
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(additional + newcolumn['name']),
        Text(additional + newcolumn['content']),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

class EditIcon extends StatefulWidget {
  Map<String, dynamic> newcolumn = {};
  ProjectCRUD projectCRUD;
  EditIcon(this.newcolumn, this.projectCRUD);
  @override
  State<EditIcon> createState() => _EditIconState();
}

class _EditIconState extends State<EditIcon> {
  String newComment = "";
  @override
  TextEditingController _textFieldController2 = TextEditingController();

  Widget build(BuildContext context) {
    if (!widget.newcolumn.containsKey('comment_id')) {
      return IconButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                      title: Text('대댓글 달기'),
                      content: TextField(
                        onChanged: (value) {
                          newComment = value;
                        },
                        controller: _textFieldController2,
                        decoration: InputDecoration(
                          hintText: "대댓글 달기",
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelStyle: const TextStyle(
                            fontFamily: "GmarketSansTTF",
                            fontSize: 16,
                          ),
                        ),
                      ),
                      actions: [
                        IconButton(
                            onPressed: () {
                              widget.projectCRUD.addTeamReply(
                                  newComment, widget.newcolumn.toString());
                              Navigator.pop(context);
                              setState(() {});
                            },
                            icon: Icon(Icons.done))
                      ]);
                });
          },
          icon: Icon(Icons.comment_bank));
    } else {
      return Text(" ");
    }
  }
}
