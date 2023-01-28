import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team/Project/widget/team_tile_with_btn.dart';
import 'package:team/helper/DatabaseService.dart';
import '../../student/team/AddNewTeam.dart';
import 'package:team/helper/ProjectCRUD.dart';

class Candidate extends StatefulWidget {
  final String projectId;
  final String projectname;
  final List<String> docIds;
  final List<String> teamnames;
  Candidate(
      {Key? key,
      required this.projectId,
      required this.projectname,
      required this.docIds,
      required this.teamnames})
      : super(key: key);
  @override
  _Candidatestate createState() => _Candidatestate();
}

class _Candidatestate extends State<Candidate> {
  Stream<QuerySnapshot>? teams;
  String projectid = "";
  String stuId = "";
  String attendid = "";
  List<String> teamsid = [];
  @override
  void initState() {
    gettingteamData();
    super.initState();
  }

  gettingteamData() async {
    // getting the list of snapshots in our stream
    DatabaseService().getTeamlist(widget.projectId).then((snapshot) {
      setState(() {
        teams = snapshot;
      });
    });
    await ProjectCRUD(projectid).getstu_id().then((value) {
      stuId = value;
    });

    await ProjectCRUD(projectid).getAttendeeIDhdm(stuId).then((value) {
      attendid = value;
    });
    await DatabaseService()
        .getattendcandidatelist(widget.projectId, attendid)
        .then((value) {
      teamsid = value;
    });
    for (int i = 0; i < teamsid.length; i++) {
      teamsid[i] = teamsid[i].substring(0, teamsid[i].indexOf('_'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        gettingteamData();
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
            "초대받은 팀 목록 (${teamsid.length})",
            style: TextStyle(
                color: Colors.black87,
                fontFamily: "GmarketSansTTF",
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: teamList(),
      );
    });
  }

  teamList() {
    return StreamBuilder(
      stream: teams,
      builder: (context, AsyncSnapshot snapshot) {
        // print("???");
        // print(snapshot.data.docs.length);
        return snapshot.hasData && !snapshot.hasError
            ? snapshot.data.docs.length != 0
                ? ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      if (widget.docIds
                          .contains(snapshot.data.docs[index].id)) {
                        return Teamtile_with_btn(
                            teamName: snapshot.data.docs[index]['name'],
                            teaminfo: snapshot.data.docs[index]
                                ['finding_member_info'],
                            projectid: widget.projectId,
                            projectname: widget.projectname,
                            isfinished:
                                snapshot.data.docs[index]['isFinished'] != null
                                    ? snapshot.data.docs[index]['isFinished']
                                    : false,
                            memNum: snapshot.data.docs[index]['members'] != null
                                ? snapshot.data.docs[index]['members'].length
                                : 0,
                            isMyTeam:
                                snapshot.data.docs[index]['members'] != null &&
                                    snapshot.data.docs[index]['members']
                                        .contains(stuId));
                      } else {
                        return Container();
                      }
                    },
                    //controller: unitcontroller,
                  )
                : noteamWidget()
            : const Center(
                child:
                    CircularProgressIndicator(color: Colors.lightBlueAccent));
      },
    );
  }

  noteamWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "초대받은 팀이 없습니다.",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: "GmarketSansTTF",
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
