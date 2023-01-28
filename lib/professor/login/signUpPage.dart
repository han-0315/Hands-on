import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team/helper/DatabaseService.dart';
import 'package:team/helper/helper_function.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPageP extends StatefulWidget {
  const SignUpPageP({Key? key}) : super(key: key);

  @override
  State<SignUpPageP> createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPageP> {
  final _formKey = GlobalKey<FormState>();
  final _authentication = FirebaseAuth.instance;
  String username = '';
  String userEmail = '';
  String userPassword = '';
  bool isNowLoading = false;

  void _tryValidation() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black87),
          title: Text(
            "교수님 회원가입",
            style: TextStyle(
                color: Colors.black87,
                fontFamily: "GmarketSansTTF",
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: (() {
            FocusScope.of(context).unfocus();
          }),
          child: SingleChildScrollView(
            child: Center(
                child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    TextFormField(
                        validator: ((value) {
                          if (value!.isEmpty) {
                            return "이름을 입력하세요";
                          }
                          return null;
                        }),
                        onSaved: ((value) {
                          username = value!;
                        }),
                        onChanged: (value) {
                          username = value;
                        },
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: "이름",
                          labelStyle: TextStyle(
                            fontFamily: "GmarketSansTTF",
                            fontSize: 16,
                          ),
                        )),
                    SizedBox(height: 20),
                    TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        onSaved: ((value) {
                          userEmail = value!;
                        }),
                        onChanged: (value) {
                          userEmail = value;
                        },
                        validator: ((value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return "이메일 형식이 아닙니다.";
                          }
                          return null;
                        }),
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: "학교 이메일",
                          labelStyle: TextStyle(
                            fontFamily: "GmarketSansTTF",
                            fontSize: 16,
                          ),
                        )),
                    SizedBox(height: 20),
                    TextFormField(
                        obscureText: true,
                        validator: ((value) {
                          if (value!.isEmpty) {
                            return "비밀번호를 입력하세요.";
                          }
                          return null;
                        }),
                        onSaved: ((value) {
                          userPassword = value!;
                        }),
                        onChanged: (value) {
                          userPassword = value;
                        },
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: "비밀번호",
                          labelStyle: TextStyle(
                            fontFamily: "GmarketSansTTF",
                            fontSize: 16,
                          ),
                        )),
                    SizedBox(height: 20),
                    TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: "비밀번호 재확인",
                          labelStyle: TextStyle(
                            fontFamily: "GmarketSansTTF",
                            fontSize: 16,
                          ),
                        )),
                    SizedBox(height: 40),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            backgroundColor: Colors.lightBlueAccent,
                            disabledBackgroundColor:
                                Colors.lightBlueAccent.shade100,
                            minimumSize: const Size.fromHeight(40)),
                        child: !isNowLoading
                            ? Text(
                                "가입하기",
                                style: TextStyle(
                                  fontFamily: "GmarketSansTTF",
                                  fontSize: 14,
                                ),
                              )
                            : Container(
                                width: 20,
                                height: 20,
                                padding: const EdgeInsets.all(2.0),
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                        onPressed: !isNowLoading
                            ? () async {
                                setState(() {
                                  isNowLoading = true;
                                });
                                _tryValidation();

                                try {
                                  final newUser = await _authentication
                                      .createUserWithEmailAndPassword(
                                          email: userEmail,
                                          password: userPassword);

                                  if (newUser.user != null) {
                                    await DatabaseService(
                                            uid: newUser.user!.uid)
                                        .savingproData(username, userEmail);

                                    await HelperFunctions
                                        .saveUserLoggedInStatus(true);
                                    SharedPreferences sf =
                                        await SharedPreferences.getInstance();
                                    await sf.setInt("TYPE", 1);
                                    await HelperFunctions.saveUserIDSF(
                                        FirebaseAuth.instance.currentUser!.uid);
                                    await HelperFunctions.saveUserNameSF(
                                        username);
                                    await HelperFunctions.saveUserEmailSF(
                                        userEmail);
                                    await HelperFunctions.saveUsertypeSF(1);
                                    Navigator.of(context)
                                        .pushNamed("/toProfProjectlistPage");
                                    setState(() {
                                      isNowLoading = false;
                                    });
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      "잘못된 이메일 혹은 비밀번호입니다.",
                                      style: TextStyle(
                                        fontFamily: "GmarketSansTTF",
                                        fontSize: 14,
                                      ),
                                    ),
                                    backgroundColor: Colors.lightBlueAccent,
                                  ));
                                  setState(() {
                                    isNowLoading = false;
                                  });
                                }
                              }
                            : null)
                  ],
                ),
              ),
            )),
          ),
        ));
  }
}
