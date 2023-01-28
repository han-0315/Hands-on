import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './widget/controlBtn.dart';

// 가장 먼저 실행되는 페이지입니다
class InitPage extends StatefulWidget {
  const InitPage({Key? key}) : super(key: key);

  @override
  State<InitPage> createState() => InitPageState();
}

class InitPageState extends State<InitPage> {
  bool isUserProf = false;

  void _setIsUserProf() {
    setState(() {
      isUserProf = !isUserProf;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   elevation: 0,
        //   title: const Text(
        //     "Team building",
        //     style: TextStyle(
        //         color: Colors.black87,
        //         fontFamily: "GmarketSansTTF",
        //         fontWeight: FontWeight.bold,
        //         fontSize: 26),
        //   ),
        //   backgroundColor: Colors.white,
        //   centerTitle: true,
        // ),
        backgroundColor: Colors.white,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  top: 0, bottom: 20, left: 20, right: 20),
              child: Image(
                image: AssetImage("assets/images/title.png"),
                width: 230,
                height: 230,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 35, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 80, height: 1, color: Colors.grey),
                  Text(" 사용자 유형 선택 ",
                      style: TextStyle(
                          color: Colors.grey,
                          fontFamily: "GmarketSansTTF",
                          fontSize: 12)),
                  Container(width: 80, height: 1, color: Colors.grey),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: ControlBtn(data: isUserProf, setter: _setIsUserProf),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 105, height: 1, color: Colors.grey),
                  Text(" 시작 ",
                      style: TextStyle(
                          color: Colors.grey,
                          fontFamily: "GmarketSansTTF",
                          fontSize: 12)),
                  Container(width: 105, height: 1, color: Colors.grey),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 60, right: 60, bottom: 30),
              child: Column(
                children: [
                  ButtonTheme(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor: Colors.lightBlueAccent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text("로그인",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "GmarketSansTTF",
                                fontSize: 14,
                              )),
                        ],
                      ),
                      onPressed: () {
                        if (isUserProf)
                          Navigator.of(context).pushNamed("/toPro_SignInPage");
                        else
                          Navigator.of(context).pushNamed("/toStu_SignInPage");
                      },
                    ),
                  ),
                  ButtonTheme(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        backgroundColor: Colors.white70,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text("회원가입",
                              style: TextStyle(
                                color: Colors.black87,
                                fontFamily: "GmarketSansTTF",
                                fontSize: 14,
                              )),
                        ],
                      ),
                      onPressed: () {
                        if (isUserProf)
                          Navigator.of(context).pushNamed("/toPro_SignUpPage");
                        else
                          Navigator.of(context).pushNamed("/toStu_SignUpPage");
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        )));
  }
}
