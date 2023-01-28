import 'package:cloud_firestore/cloud_firestore.dart';
// projects 관련 CRUD func

Future addProject(final projectData, final attendeeDataList) async {
  final db = FirebaseFirestore.instance;
  final batch = db.batch();
  List<String> empty = [];
  // 1. projects 문서 추가
  final projectDoc = await db.collection('projects').add(projectData);

  // 2. professors 컬렉션 문서에 projects 목록 추가
  final professorsRef = db.collection('professors');
  batch.update(professorsRef.doc(projectData["prof_uid"]), {
    "projects": FieldValue.arrayUnion([
      {
        "doc_id": projectDoc.id,
        "name": projectData["name"],
        "isFinished": false,
        "deadline": projectData["deadline"]
      }
    ])
  });

  // 3. attendees 추가 및 students 업데이트
  final studentsRef = db.collection('students');
  final attendeesRef = db.collection('projects/${projectDoc.id}/attendees');
  db
      .collection('projects/${projectDoc.id}/teams_hashtags')
      .doc("Tags")
      .set({"hashtags": empty});
  db
      .collection('projects/${projectDoc.id}/attendees_hashtags')
      .doc("Tags")
      .set({"hashtags": empty});

  final stus = await studentsRef.get();
  final stuMap = stus.docs
      .map((stu) =>
          {"stu_doc_id": stu.id, "stu_id": stu["stu_id"], "uid": stu["uid"]})
      .toList();
  List<String> stuIdMap =
      stuMap.map((stu) => stu["stu_id"].toString()).toList();
  // print(stuMap);
  // print(stuIdMap);

  attendeeDataList.forEach((attendee) {
    int ind = stuIdMap.indexOf(attendee["stu_id"].toString());
    if (ind != -1) {
      // 이미 회원가입한 학생의 경우
      print("이미 회원가입한 학생 : " + attendee["name"].toString());
      attendee["stu_doc_id"] = stuMap.elementAt(ind)["stu_doc_id"].toString();
      attendee["uid"] = stuMap.elementAt(ind)["uid"].toString();

      // students에 새 플젝 정보 추가해주기
      batch.update(studentsRef.doc(attendee["stu_doc_id"]), {
        "projects": FieldValue.arrayUnion([
          {
            "doc_id": projectDoc.id,
            "name": projectData["name"],
            "isFinished": false,
            "deadline": projectData["deadline"]
          }
        ])
      });
    }

    batch.set(attendeesRef.doc(), attendee);
  });

  await batch.commit();
  print("생성 완료");
}
