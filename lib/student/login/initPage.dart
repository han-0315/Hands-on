import 'package:flutter/material.dart';

class loginInitPageS extends StatelessWidget {
  const loginInitPageS({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            "Team building",
            style: TextStyle(
                color: Colors.black87,
                fontFamily: "GmarketSansTTF",
                fontWeight: FontWeight.bold,
                fontSize: 26),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Center(
            child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  top: 20, bottom: 20, left: 20, right: 20),
              child: Image(image: AssetImage("assets/images/profile.jpeg")),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: RichText(
                  text: TextSpan(
                    text: "학생용",
                    style: TextStyle(
                        color: Colors.black87,
                        fontFamily: "GmarketSansTTF",
                        fontSize: 20),
                  ),
                )),
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
                        Navigator.of(context).pushNamed("/toStu_SignUpPage");
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 110, height: 1, color: Colors.grey),
                  Text(" or ",
                      style: TextStyle(
                          color: Colors.grey,
                          fontFamily: "GmarketSansTTF",
                          fontSize: 12)),
                  Container(width: 110, height: 1, color: Colors.grey),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color.fromARGB(255, 239, 239, 239)),
                  child: IconButton(
                    icon: Image.asset("assets/images/g_logo.png"),
                    onPressed: () {},
                  ),
                ),
                SizedBox(width: 30),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color.fromARGB(255, 7, 190, 52)),
                  child: IconButton(
                    icon: Image.asset("assets/images/p_logo.png"),
                    onPressed: () {},
                  ),
                ),
                SizedBox(width: 30),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color.fromARGB(255, 255, 228, 0)),
                  child: IconButton(
                    icon: Image.asset("assets/images/k_logo.png"),
                    onPressed: () {},
                  ),
                ),
              ],
            )
          ],
        )));
  }
}
