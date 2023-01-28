import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team/helper/DatabaseService.dart';
import 'package:team/helper/helper_function.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInPageS extends StatefulWidget {
  const SignInPageS({Key? key}) : super(key: key);

  @override
  State<SignInPageS> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPageS> {
  final _formKey = GlobalKey<FormState>();
  final _authentication = FirebaseAuth.instance;
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
            "학생 로그인",
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
                        keyboardType: TextInputType.emailAddress,
                        validator: ((value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return "이메일 형식이 아닙니다.";
                          }
                          return null;
                        }),
                        onSaved: ((value) {
                          userEmail = value!;
                        }),
                        onChanged: (value) {
                          userEmail = value;
                        },
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
                            return "Type in password";
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
                              "로그인",
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
                                    .signInWithEmailAndPassword(
                                        email: userEmail,
                                        password: userPassword);

                                if (newUser.user != null) {
                                  QuerySnapshot snapshot =
                                      await DatabaseService(
                                              uid: FirebaseAuth
                                                  .instance.currentUser!.uid)
                                          .gettingstuData(userEmail);
                                  await HelperFunctions.saveUserLoggedInStatus(
                                      true);
                                  SharedPreferences sf =
                                      await SharedPreferences.getInstance();
                                  await sf.setInt("TYPE", 0);
                                  await HelperFunctions.saveUsertypeSF(0);
                                  await HelperFunctions.saveUserIDSF(
                                      FirebaseAuth.instance.currentUser!.uid);
                                  await HelperFunctions.saveUserNameSF(
                                      snapshot.docs[0]['username']);
                                  await HelperFunctions.saveUserEmailSF(
                                      userEmail);
                                  await HelperFunctions.saveUserstuIDSF(
                                      snapshot.docs[0]['stu_id']);
                                  Navigator.of(context)
                                      .pushNamed("/toStuProjectlistPage");
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
                              }
                              setState(() {
                                isNowLoading = false;
                              });
                            }
                          : null,
                    )
                  ],
                ),
              ),
            )),
          ),
        ));
  }
}
