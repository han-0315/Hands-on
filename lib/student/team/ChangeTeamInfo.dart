import 'package:flutter/material.dart';
import 'package:team/helper/ProjectCRUD.dart';
import './MyTeamInfo.dart';
import '../../widget/hashtagInput.dart';
import 'package:team/helper/DatabaseService.dart';

class ChangeTeamInfo extends StatelessWidget {
  String projectID;
  ChangeTeamInfo(this.projectID);

  @override
  Widget build(BuildContext context) {
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
        title: const Text(
          "팀 정보 수정",
          style: TextStyle(
              color: Colors.black87,
              fontFamily: "GmarketSansTTF",
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: TeamInfoForm(projectID),
    );
  }
}

class TeamInfoForm extends StatefulWidget {
  String projectID;
  TeamInfoForm(this.projectID);

  @override
  State<TeamInfoForm> createState() => _TeamInfoFormState(projectID);
}

class _TeamInfoFormState extends State<TeamInfoForm> {
  final _formkey = GlobalKey<FormState>();
  String projectID;
  _TeamInfoFormState(this.projectID);
  late final ProjectCRUD projectCRUD = ProjectCRUD(projectID);

  List<dynamic> hashtags = [];

  // _navigateAndDisplaySelection(BuildContext context) async {
  //   final result = await Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => MyTeamInfoPage(projectID)),
  //   );
  // }

  void _setHashtags(List<String> tags) {
    int length = tags.length;
    setState(() {
      hashtags = [];

      tags.forEach((element) {
        hashtags.add(element);
      });
    });
  }

  dbupdate(List<String> tags) async {
    {
      String teamid = "";
      await ProjectCRUD(widget.projectID).getTeamID().then((value) {
        teamid = value;
      });
      DatabaseService().addteamhashtags(widget.projectID, teamid, tags);
    }
  }

  @override
  Widget build(BuildContext context) {
    String name = "";
    String introduction = "";
    String finding_member_info = "";

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: FutureBuilder(
          future: projectCRUD.getTeamInfo(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Form(
                key: _formkey,
                child: ListView(
                  children: [
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: " 팀 이름 ",
                          labelStyle: const TextStyle(
                            fontFamily: "GmarketSansTTF",
                            fontSize: 16,
                          )),
                      initialValue: snapshot.data['name'].toString(),
                      onSaved: (value) {
                        setState(() {
                          name = value as String;
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(width: 10, height: 1, color: Colors.grey),
                          Text(
                            "  팀장 선택  ",
                            style: const TextStyle(
                                fontFamily: "GmarketSansTTF",
                                fontSize: 11,
                                color: Colors.black54),
                            textAlign: TextAlign.left,
                          ),
                          Container(width: 280, height: 1, color: Colors.grey),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      minLines: 6,
                      maxLines: null,
                      initialValue: snapshot.data['introduction'].toString(),
                      onSaved: (value) {
                        setState(() {
                          introduction = value as String;
                        });
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: " 팀 소개",
                        labelStyle: const TextStyle(
                          fontFamily: "GmarketSansTTF",
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: " 원하는 팀원",
                        labelStyle: const TextStyle(
                          fontFamily: "GmarketSansTTF",
                          fontSize: 16,
                        ),
                      ),
                      minLines: 6,
                      maxLines: null,
                      initialValue:
                          snapshot.data['finding_member_info'].toString(),
                      onSaved: (value) {
                        setState(() {
                          finding_member_info = value as String;
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(width: 10, height: 1, color: Colors.grey),
                          Text(
                            "  해시태그  ",
                            style: const TextStyle(
                                fontFamily: "GmarketSansTTF",
                                fontSize: 11,
                                color: Colors.black54),
                            textAlign: TextAlign.left,
                          ),
                          Container(width: 280, height: 1, color: Colors.grey),
                        ],
                      ),
                    ),
                    Hashtags(
                      hashtags: snapshot.data["hashtags"] != null
                          ? snapshot.data["hashtags"]
                          : [],
                      setter: _setHashtags,
                      projectid: widget.projectID,
                      type: "team",
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor: Colors.lightBlueAccent,
                          disabledBackgroundColor:
                              Colors.lightBlueAccent.shade100,
                          minimumSize: const Size.fromHeight(40)),
                      onPressed: () async {
                        _formkey.currentState!.save();

                        try {
                          await projectCRUD.setTeamName(name);
                          await projectCRUD.setTeamIntro(introduction);
                          await projectCRUD
                              .setWantedMember(finding_member_info);
                          dbupdate(List<String>.from(hashtags));
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              "팀 정보 수정이 완료되었습니다.",
                              style: TextStyle(
                                fontFamily: "GmarketSansTTF",
                                fontSize: 14,
                              ),
                            ),
                            backgroundColor: Colors.lightBlueAccent,
                          ));

                          Navigator.pop(context);
                          // _navigateAndDisplaySelection(context);
                        } catch (e) {
                          print(e);

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              "팀 정보 수정에 실패하였습니다.",
                              style: TextStyle(
                                fontFamily: "GmarketSansTTF",
                                fontSize: 14,
                              ),
                            ),
                            backgroundColor: Colors.lightBlueAccent,
                          ));
                        }
                      },
                      child: const Text(
                        "팀 정보 수정",
                        style: TextStyle(
                          fontFamily: "GmarketSansTTF",
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                  child:
                      CircularProgressIndicator(color: Colors.lightBlueAccent));
            }
          }),
    );
  }
}
