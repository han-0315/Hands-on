import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team/helper/DatabaseService.dart';
import 'package:team/Project/widget/team_tile.dart';
import '../../student/team/AddNewTeam.dart';
import 'package:team/helper/ProjectCRUD.dart';

class TeamListPage extends StatefulWidget {
  final String projectId;
  final String projectname;
  TeamListPage({
    Key? key,
    required this.projectId,
    required this.projectname,
  }) : super(key: key);
  @override
  _TeamListstate createState() => _TeamListstate();
}

class _TeamListstate extends State<TeamListPage> {
  Stream<QuerySnapshot>? teams;
  String projectid = "";
  String stuId = "";
  DocumentSnapshot<Map<String, dynamic>>? tagsnapshot;
  List<String> _tagChoices = []; // 해당 변수로 출력관리.
  List<String> tags = [];

  late ProjectCRUD projectCRUD = ProjectCRUD(widget.projectId);

  @override
  void initState() {
    gettingteamData();
    super.initState();
  }

  gettingteamData() {
    // getting the list of snapshots in our stream
    DatabaseService().getTeamlist(widget.projectId).then((snapshot) {
      setState(() {
        teams = snapshot;
      });
    });
    DatabaseService().getteamhashtags(widget.projectId).then((snapshot) {
      setState(() {
        tagsnapshot = snapshot;
      });

      tagupdate();
    });
    projectCRUD.getstu_id().then((id) {
      setState(() {
        stuId = id;
      });
    });
  }

  tagupdate() {
    final data = tagsnapshot!.data();
    tags =
        List<String>.from(data?['hashtags'] == null ? [] : data?['hashtags']);
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
          title: const Text(
            "팀 목록",
            style: TextStyle(
                color: Colors.black87,
                fontFamily: "GmarketSansTTF",
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 14, right: 14),
              child: Wrap(
                direction: Axis.horizontal, // 정렬 방향
                alignment: WrapAlignment.start,
                spacing: 6, // 상하(좌우) 공간
                children: _buildChoiceList(), //타입 1: food, 2: place, 3: pref
              ),
            ),
            Expanded(
              child: Stack(
                children: <Widget>[
                  teamList(),
                  Container(
                    padding: EdgeInsets.all(8),
                    width: MediaQuery.of(context).size.width,
                  )
                ],
              ),
            )
          ],
        ),
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
                      //**해당 부분에 tag 관련!**
                      final List<dynamic> taglist =
                          snapshot.data.docs[index]['hashtags'];
                      bool tagcheck = false;
                      if (_tagChoices.isEmpty) tagcheck = true;
                      _tagChoices.forEach((element) {
                        if (taglist.contains(element)) {
                          tagcheck = true;
                        }
                      });

                      if (tagcheck) {
                        return Teamtile(
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
                        // false); // test
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
            "팀이 없습니다.",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: "GmarketSansTTF",
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          TextButton(
              child: const Text(
                '+  새 팀 생성',
                style: TextStyle(fontFamily: "GmarketSansTTF", fontSize: 16),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddNewTeam(widget.projectId)));
              })
        ],
      ),
    );
  }

  _buildChoiceList() {
    List<Widget> choices = [];
    tags.forEach((element) {
      choices.add(
        ChoiceChip(
          selectedColor: Colors.lightBlueAccent,
          disabledColor: Colors.grey.shade300,
          label: Text("# " + element),
          visualDensity: VisualDensity(horizontal: -1, vertical: -3.5),
          labelStyle: _tagChoices.contains(element)
              ? TextStyle(
                  fontFamily: "GmarketSansTTF",
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold)
              : TextStyle(
                  fontFamily: "GmarketSansTTF",
                  color: Colors.black87,
                  fontSize: 12),
          selected: _tagChoices.contains(element),
          onSelected: (selected) {
            setState(() {
              _tagChoices.contains(element)
                  ? _tagChoices.remove(element)
                  : _tagChoices.add(element);
            });
          },
        ),
      );
    });
    return choices;
  }
}
