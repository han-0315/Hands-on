import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'widget/memNumPicker.dart';
import 'widget/datePicker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'dart:io';
import '../functions/projects.dart';

class ProjectAddPage extends StatefulWidget {
  const ProjectAddPage({Key? key}) : super(key: key);

  @override
  State<ProjectAddPage> createState() => ProjectAddPageState();
}

class ProjectAddPageState extends State<ProjectAddPage> {
  final _formKey = GlobalKey<FormState>();

  final textStyle = const TextStyle(
      fontFamily: "GmarketSansTTF", fontSize: 12, color: Colors.black54);

  String name = '';
  String fileName = '아직 파일이 선택되지 않았습니다. ';
  int minTeamMem = 1;
  int maxTeamMem = 1;
  int totalStuNum = 0;
  DateTime deadline = DateTime.now();
  bool numErr = false, fileErr = false;
  bool isNowLoading = false;

  final attendeeData = [];

  bool _tryValidation() {
    bool isNameValid = _formKey.currentState!.validate();
    bool isNumValid = minTeamMem <= maxTeamMem;
    if (!isNumValid) {
      setState(() {
        numErr = true;
      });
    } else {
      setState(() {
        numErr = false;
      });
    }
    bool isFileValid = !(fileName == '아직 파일이 선택되지 않았습니다. ');
    if (!isFileValid) {
      setState(() {
        fileErr = true;
      });
    } else {
      setState(() {
        fileErr = false;
      });
    }

    if (isNameValid && isNumValid && isFileValid) {
      _formKey.currentState!.save();
      return true;
    }

    return false;
  }

  void _setMinNum(int selected) {
    setState(() {
      minTeamMem = selected;
    });
    print(minTeamMem);
  }

  void _setMaxNum(int selected) {
    setState(() {
      maxTeamMem = selected;
    });
    print(maxTeamMem);
  }

  void _setDeadline(DateTime selected) {
    setState(() {
      deadline = selected;
    });
    print(deadline);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black87),
          title: Text(
            "수업 생성",
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
                    // 수업 이름
                    const SizedBox(height: 20),
                    TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        validator: ((value) {
                          if (value!.isEmpty) {
                            return "수업 이름을 입력해주세요.";
                          }
                          return null;
                        }),
                        onSaved: ((value) {
                          name = value!.trim();
                        }),
                        onChanged: (value) {
                          name = value.trim();
                        },
                        decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: "수업명",
                            labelStyle: const TextStyle(
                              fontFamily: "GmarketSansTTF",
                              fontSize: 16,
                            ))),

                    // 팀인원수
                    const SizedBox(height: 40),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        '팀 인원수',
                        style: textStyle,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        // 최소
                        Row(
                          children: <Widget>[
                            Text('최소  ', style: textStyle),
                            MemCntPicker(data: minTeamMem, setter: _setMinNum),
                          ],
                        ),
                        Text('        ~        ', style: textStyle),
                        // 최대
                        Row(
                          children: <Widget>[
                            Text('최대  ', style: textStyle),
                            MemCntPicker(data: maxTeamMem, setter: _setMaxNum)
                          ],
                        ),
                      ],
                    ),
                    if (numErr)
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '최소 인원은 최대 인원보다 작거나 같아야 합니다.',
                          style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFFD32F2F),
                              height: 1.7),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    // const Divider(
                    //   color: Colors.black45,
                    //   thickness: 1,
                    //   endIndent: 0,
                    // ),

                    // 기한
                    const SizedBox(height: 40),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        '마감 기한',
                        style: textStyle,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    DatePicker(data: deadline, setter: _setDeadline),

                    // 엑셀 첨부
                    const SizedBox(height: 40),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        '수강생 엑셀 파일 선택',
                        style: textStyle,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            fileName,
                            style: textStyle,
                          ),
                          TextButton(
                            child: const Text(
                              '+  파일 선택',
                              style: TextStyle(
                                fontFamily: "GmarketSansTTF",
                                fontSize: 14,
                              ),
                            ),
                            onPressed: () async {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: ['xlsx']);

                              if (result != null) {
                                String? nullableString =
                                    result.files.single.path;

                                if (nullableString != null) {
                                  var bytes =
                                      File(nullableString).readAsBytesSync();
                                  var excel = Excel.decodeBytes(bytes);

                                  setState(() {
                                    fileName = result.files.first.name;
                                  });

                                  for (var table in excel.tables.keys) {
                                    // print(table);
                                    // print(excel.tables[table]?.maxCols);
                                    // print(excel.tables[table]?.maxRows);
                                    int? nullableInt =
                                        excel.tables[table]?.maxRows;

                                    if (nullableInt != null) {
                                      int row;
                                      for (row = 0; row < nullableInt; row++) {
                                        // 한 학생에 대한 정보
                                        List<String> temp = [];
                                        if (row == 0) continue;
                                        final rowData =
                                            excel.tables[table]?.rows[row];
                                        attendeeData.add({
                                          "name": rowData?.elementAt(0)?.value,
                                          "stu_id": rowData
                                              ?.elementAt(1)
                                              ?.value
                                              .toString(),
                                          "introduction": "",
                                          "finding_team_info": "",
                                          "contacts": {
                                            // "email": "",
                                            // "phone": "",
                                            // "url1": "",
                                            // "url2": "",
                                            // "url3": ""
                                          },
                                          "hashtags": [],
                                        });
                                      }

                                      setState(() {
                                        totalStuNum = row - 1;
                                      });
                                    }
                                  }
                                }
                              }
                            },
                          )
                        ]),
                    if (fileErr)
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '수강생 엑셀 파일을 선택해주세요.',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFD32F2F),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),

                    // 생성
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
                                "수업 생성",
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
                                if (!_tryValidation()) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      "수업 정보를 다시 한 번 확인해주세요. ",
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
                                  return;
                                }
                                try {
                                  // // 추가
                                  // deadline = DateTime(deadline.year, deadline.month,
                                  //     deadline.day, 23, 59, 59, 999, 999);
                                  final projectData = {
                                    "name": name,
                                    "prof_uid":
                                        FirebaseAuth.instance.currentUser?.uid,
                                    "max_team_mem": maxTeamMem,
                                    "min_team_mem": minTeamMem,
                                    "total_stu_num": totalStuNum,
                                    "deadline": deadline,
                                  };
                                  print(attendeeData);
                                  await addProject(projectData, attendeeData);
                                  // *TODO : 생성된 project 화면으로 이동
                                } catch (e) {
                                  print(e);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      "수업 생성을 실패했습니다. 다시 시도해주세요",
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
                            : null)
                  ],
                ),
              ),
            )),
          ),
        ));
  }
}
