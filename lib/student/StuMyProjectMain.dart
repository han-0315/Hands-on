import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:team/student/student_info/MyStudentInfo.dart';
import 'package:team/student/team/MyTeamInfo.dart';
import 'package:team/Project/main/teamlist.dart';
import 'package:team/Project/main/studentlist.dart';

class StuMyProjectMain extends StatefulWidget {
  String projectId = "";
  String projectName = "";
  String userName = "";
  StuMyProjectMain(this.projectId, this.projectName, this.userName);

  @override
  State<StuMyProjectMain> createState() => _StuMyProjectMainState();
}

class _StuMyProjectMainState extends State<StuMyProjectMain> {
  int _currentIndex = 0;
  List<Widget> pageList = [];

  int _selectedIndex = 0;

  @override
  void initState() {
    pageList.add(TeamListPage(
        projectId: widget.projectId, projectname: widget.projectName));
    pageList.add(StulistPage(
        projectId: widget.projectId, projectname: widget.projectName));
    pageList.add(MyTeamInfoPage(widget.projectId, widget.projectName));
    pageList.add(MyStudentInfoPage(widget.projectId, widget.projectName));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      body: pageList[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.text_snippet),
            activeIcon: Icon(Icons.text_snippet, size: 30),
            label: "팀리스트",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            activeIcon: Icon(Icons.people, size: 30),
            label: "학생리스트",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag),
            activeIcon: Icon(Icons.flag, size: 30),
            label: "내 팀 정보",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            activeIcon: Icon(Icons.person, size: 30),
            label: "내 정보",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightBlueAccent,
        selectedLabelStyle: TextStyle(
            color: Colors.lightBlueAccent,
            fontFamily: "GmarketSansTTF",
            fontSize: 12,
            fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(
          color: Colors.black38,
          fontFamily: "GmarketSansTTF",
          fontSize: 12,
        ),
        unselectedItemColor: Colors.black38,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }
}
