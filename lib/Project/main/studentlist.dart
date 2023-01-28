import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team/Project/widget/student_tile.dart';
import 'package:team/helper/DatabaseService.dart';
import 'package:team/helper/ProjectCRUD.dart';

class StulistPage extends StatefulWidget {
  final String projectId;
  final String projectname;

  StulistPage({
    Key? key,
    required this.projectId,
    required this.projectname,
  }) : super(key: key);
  @override
  _Stuliststate createState() => _Stuliststate();
}

class _Stuliststate extends State<StulistPage> {
  Stream<QuerySnapshot>? stulist;
  String projectid = "";
  String stuId = "";
  List<String> _tagChoices = []; // 해당 변수로 출력관리.
  List<String> tags = [];
  DocumentSnapshot<Map<String, dynamic>>? tagsnapshot;

  late ProjectCRUD projectCRUD = ProjectCRUD(widget.projectId);

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
    DatabaseService().getstuhashtags(widget.projectId).then((snapshot) {
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
        data?['hashtags'] == null ? [] : List<String>.from(data?['hashtags']);
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
          title: const Text(
            "학생 목록",
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
              // height: 50,
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
                  attendees(),
                  Container(
                    padding: EdgeInsets.all(8),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  attendees() {
    return StreamBuilder(
      stream: stulist,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData && !snapshot.hasError
            ? snapshot.data.docs.length != 0
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      //tag관련 처리
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
                        return Student_tile(
                          name: snapshot.data.docs[index]['name'],
                          info: snapshot.data.docs[index]['introduction'],
                          id: snapshot.data.docs[index]['stu_id'].toString(),
                          projectid: widget.projectId,
                          projectname: widget.projectname,
                          isMine: stuId ==
                              snapshot.data.docs[index]['stu_id'].toString(),
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
            "학생이 없습니다.",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: "GmarketSansTTF",
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          // *TODO : 교수의 학생 CRUD
          // TextButton(
          //     child: const Text(
          //       '+  새 팀 생성',
          //       style: TextStyle(fontFamily: "GmarketSansTTF", fontSize: 16),
          //     ),
          //     onPressed: () {
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //               builder: (context) => AddNewTeam(projectid)));
          //     })
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
