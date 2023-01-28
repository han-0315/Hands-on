import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team/Project/widget/student_tile_with_btn.dart';
import 'package:team/helper/DatabaseService.dart';
import 'package:team/helper/ProjectCRUD.dart';

class Candidate extends StatefulWidget {
  final String projectId;
  final String projectname;
  List<dynamic> stuIds = [];

  Candidate({
    Key? key,
    required this.projectId,
    required this.projectname,
    required this.stuIds,
  }) : super(key: key);
  @override
  _CandidateState createState() => _CandidateState();
}

class _CandidateState extends State<Candidate> {
  Stream<QuerySnapshot>? stulist;
  String projectid = "";
  String stuId = "";

  String teamid = "";
  List<String> stuidlist = [];
  @override
  void initState() {
    gettingstuData();
    super.initState();
  }

  gettingstuData() async {
    DatabaseService().getstulist(widget.projectId).then((snapshot) {
      setState(() {
        stulist = snapshot;
      });
    });
    await ProjectCRUD(widget.projectId).getTeamID().then((value) {
      teamid = value;
    });
    await DatabaseService()
        .getteamcandidatelist(widget.projectId, teamid)
        .then((value) {
      stuidlist = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        gettingstuData();
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
              "신청자 목록 (${stuidlist.length})",
              style: TextStyle(
                  color: Colors.black87,
                  fontFamily: "GmarketSansTTF",
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          body: attendees());
    });
  }

  attendees() {
    return StreamBuilder(
      stream: stulist,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData && !snapshot.hasError
            ? stuidlist.length != 0
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      // print(snapshot.data.docs[index]['stu_id']);
                      // print(widget.stuIds);
                      if (stuidlist.contains(
                          snapshot.data.docs[index]['stu_id'].toString())) {
                        return Student_tile_with_btn(
                          name: snapshot.data.docs[index]['name'],
                          info: snapshot.data.docs[index]['introduction'],
                          id: snapshot.data.docs[index]['stu_id'].toString(),
                          projectid: widget.projectId,
                          projectname: widget.projectname,
                          isMine: false,
                        );
                      } else {
                        return Container();
                      }
                    },
                    //controller: unitcontroller,
                  )
                : nostudWidget()
            : const Center(
                child:
                    CircularProgressIndicator(color: Colors.lightBlueAccent));
      },
    );
  }

  nostudWidget() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "참여를 희망하는 학생이 없습니다.",
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
