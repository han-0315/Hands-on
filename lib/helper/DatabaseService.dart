import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team/helper/ProjectCRUD.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // reference for our collections
  final CollectionReference studentCollection =
      FirebaseFirestore.instance.collection("students");

  final CollectionReference professorCollection =
      FirebaseFirestore.instance.collection("professors");

  final CollectionReference teamCollection =
      FirebaseFirestore.instance.collection("projects");

  // saving the userdata
  Future savingstuData(String userName, String email, String stuid) async {
    return await studentCollection.doc(uid).set({
      "username": userName,
      "email": email,
      "projects": [],
      "uid": uid,
      "stu_id": stuid,
    });
  }

  Future savingproData(String userName, String email) async {
    return await professorCollection.doc(uid).set({
      "username": userName,
      "email": email,
      "projects": [],
      "uid": uid,
    });
  }

  Future<bool>? checkALLAttendeetag(String projectid, List<String> tags) async {
    late final attendeesCollection = FirebaseFirestore.instance
        .collection("projects")
        .doc(projectid)
        .collection("attendees");

    final QuerySnapshot snapshot = await attendeesCollection.get();
    for (var doc in snapshot.docs) {
      var dataElement = doc.get("hashtags");
      for (var data in dataElement) {
        if (tags.contains(data)) {
          return true;
        }
      }
    }
    return false;
  }

  Future<bool>? checkALLteamtag(String projectid, List<String> tags) async {
    late final attendeesCollection = FirebaseFirestore.instance
        .collection("projects")
        .doc(projectid)
        .collection("teams");

    final QuerySnapshot snapshot = await attendeesCollection.get();
    for (var doc in snapshot.docs) {
      var dataElement = doc.get("hashtags");
      for (var data in dataElement) {
        if (tags.contains(data)) {
          return true;
        }
      }
    }
    return false;
  }

  Future<bool>? checkwthisteamhashtags(
      String projectid, String tid, String tags) async {
    late final attendeesCollection = FirebaseFirestore.instance
        .collection("projects")
        .doc(projectid)
        .collection("teams")
        .doc(tid);

    DocumentSnapshot<Map<String, dynamic>>? teamsnapshot;
    await attendeesCollection.get().then((value) {
      teamsnapshot = value;
    });

    final data = teamsnapshot!.data();
    final stulist =
        List<String>.from(data?['hashtags'] == null ? [] : data?['hashtags']);

    if (!stulist.contains(tags)) {
      return true;
    }
    return false;
  }

  removeteamhashtags(
      String projectid, String teamuid, List<String> tags) async {
    bool flag = false;

    await checkALLteamtag(projectid, tags)?.then((value) {
      flag = value;
    });
    if (flag) {
      await teamCollection
          .doc(projectid)
          .collection("teams_hashtags")
          .doc("Tags")
          .update({
        "hashtags": FieldValue.arrayRemove([tags])
      });
    }
  }

  addteamhashtags(String projectid, String teamuid, List<String> tags) async {
    bool flag = true;
    if (true) {
      await teamCollection
          .doc(projectid)
          .collection("teams_hashtags")
          .doc("Tags")
          .update({"hashtags": FieldValue.arrayUnion(tags)});

      await teamCollection
          .doc(projectid)
          .collection("teams")
          .doc(teamuid)
          .set({"hashtags": FieldValue.arrayUnion(tags)});
    }
  }

  removestuhashtags(String projectid, List<String> tags) async {
    bool flag = false;
    await checkALLAttendeetag(projectid, tags)?.then((value) {
      flag = value;
    });
    if (true) {
      await teamCollection
          .doc(projectid)
          .collection("attendees_hashtags")
          .doc("Tags")
          .update({"hashtags": tags});
    }
  }

  addstuhashtags(String projectid, String attdocid, List<String> tags) async {
    bool flag = true;
    // await checkALLAttendeetag(projectid, tags)?.then((value) {
    //   flag = value;
    // });

    if (true) {
      await teamCollection
          .doc(projectid)
          .collection("attendees_hashtags")
          .doc("Tags")
          .set({"hashtags": FieldValue.arrayUnion(tags)});

      await teamCollection
          .doc(projectid)
          .collection("attendees")
          .doc(attdocid)
          .update({"hashtags": FieldValue.arrayUnion(tags)});
    }
  }

  // getting user data
  Future gettingstuData(String email) async {
    QuerySnapshot snapshot =
        await studentCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  Future gettingproData(String email) async {
    QuerySnapshot snapshot =
        await professorCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  Future getTeamlist(String projectId) async {
    return teamCollection.doc(projectId).collection("teams").snapshots();
  }

  Future getstulist(String projectId) async {
    return teamCollection.doc(projectId).collection("attendees").snapshots();
  }

  getteamhashtags(String projectId) async {
    return teamCollection
        .doc(projectId)
        .collection("teams_hashtags")
        .doc("Tags")
        .get();
  }

  List<dynamic> getReqToTeam(String projectid, List<dynamic> stuids) {
    // 학번으로 데이터 가져오기
    late final attendeesCollection = FirebaseFirestore.instance
        .collection("projects")
        .doc(projectid)
        .collection("attendees");
    QuerySnapshot<Map<String, dynamic>>? stusnapshot;
    attendeesCollection.get().then((value) {
      stusnapshot = value;
    });

    final result = [];
    final docs = stusnapshot!.docs;
    docs.forEach((doc) {
      final data = doc.data() as Map<String, dynamic>;
      if (stuids.contains(data['stu_id'])) {
        final temp = data;
        result.add(temp);
      }
    });

    return result;
  }

  Future<bool?> requseteamTostu(String projectid, String attendeesuid,
      String teamuid, String teamname) async {
    late final attendeesCollection = FirebaseFirestore.instance
        .collection("projects")
        .doc(projectid)
        .collection("attendees")
        .doc(attendeesuid);
    DocumentSnapshot<Map<String, dynamic>>? stusnapshot;
    await attendeesCollection.get().then((value) {
      stusnapshot = value;
    });

    final data = stusnapshot!.data();
    final teamlist =
        List<String>.from(data?['후보팀'] == null ? [] : data?['후보팀']);
    if (!teamlist.contains(teamuid + "_" + teamname)) {
      await attendeesCollection.update({
        "후보팀": FieldValue.arrayUnion(["${teamuid}_$teamname"])
      });
      return true;
    }
    return false;
  }

  Future<bool?> requsestuToteam(
      String projectid, String teamuid, String stuid) async {
    final teamsCollection = FirebaseFirestore.instance
        .collection("projects")
        .doc(projectid)
        .collection("teams")
        .doc(teamuid);
    DocumentSnapshot<Map<String, dynamic>>? teamsnapshot;
    await teamsCollection.get().then((value) {
      teamsnapshot = value;
    });

    final data = teamsnapshot!.data();
    final stulist =
        List<String>.from(data?['후보학생'] == null ? [] : data?['후보학생']);

    if (!stulist.contains(stuid)) {
      await teamsCollection.update({
        "후보학생": FieldValue.arrayUnion([stuid])
      });
      return true;
    }
    return false;
  }

  Future<List<String>> getattendcandidatelist(
      String projectid, String attendeesuid) async {
    late final attendeesCollection = FirebaseFirestore.instance
        .collection("projects")
        .doc(projectid)
        .collection("attendees")
        .doc(attendeesuid);
    DocumentSnapshot<Map<String, dynamic>>? stusnapshot;
    await attendeesCollection.get().then((value) {
      stusnapshot = value;
    });
    final data = stusnapshot!.data();
    List<String> teamlist =
        List<String>.from(data?['후보팀'] == null ? [] : data?['후보팀']);
    return teamlist;
  }

  Future<List<String>> getteamcandidatelist(
      String projectid, String teamid) async {
    late final attendeesCollection = FirebaseFirestore.instance
        .collection("projects")
        .doc(projectid)
        .collection("teams")
        .doc(teamid);
    DocumentSnapshot<Map<String, dynamic>>? teamsnapshot;
    await attendeesCollection.get().then((value) {
      teamsnapshot = value;
    });
    final data = teamsnapshot!.data();
    List<String> stulist =
        List<String>.from(data?['후보학생'] == null ? [] : data?['후보학생']);
    return stulist;
  }

  Future<bool?> responsestu(String projectid, String attendeesuid,
      String teamuid, String teamname, bool accept, String stuid) async {
    late final attendeesCollection = FirebaseFirestore.instance
        .collection("projects")
        .doc(projectid)
        .collection("attendees")
        .doc(attendeesuid);
    DocumentSnapshot<Map<String, dynamic>>? stusnapshot;
    await attendeesCollection.get().then((value) {
      stusnapshot = value;
    });

    final data = stusnapshot!.data();
    final teamlist =
        List<String>.from(data?['후보팀'] == null ? [] : data?['후보팀']);
    if (teamlist.contains(teamuid + '_' + teamname)) {
      await attendeesCollection.update({
        "후보팀": FieldValue.arrayRemove(["${teamuid}_$teamname"])
      });
      if (!accept) return true;
      if (accept) {
        final teamsCollection = FirebaseFirestore.instance
            .collection("projects")
            .doc(projectid)
            .collection("teams")
            .doc(teamuid);
        DocumentSnapshot<Map<String, dynamic>>? teamsnapshot;
        await teamsCollection.get().then((value) {
          teamsnapshot = value;
        });

        final data = teamsnapshot!.data();
        final stulist =
            List<String>.from(data?['members'] == null ? [] : data?['members']);
        if (!stulist.contains(stuid)) {
          await teamsCollection.update({
            "members": FieldValue.arrayUnion([stuid])
          });
          return true;
        }
      }
    }
    return false;
  }

  Future<bool?> responseteam(String projectid, String attendeesuid,
      String teamuid, String teamname, bool accept, String stuid) async {
    final teamsCollection = FirebaseFirestore.instance
        .collection("projects")
        .doc(projectid)
        .collection("teams")
        .doc(teamuid);

    DocumentSnapshot<Map<String, dynamic>>? teamsnapshot;
    await teamsCollection.get().then((value) {
      teamsnapshot = value;
    });

    final data = teamsnapshot!.data();
    final stulist =
        List<String>.from(data?['후보학생'] == null ? [] : data?['후보학생']);
    if (stulist.contains(stuid)) {
      await teamsCollection.update({
        "후보학생": FieldValue.arrayRemove([stuid])
      });
      if (!accept) return true;

      final stulist =
          List<String>.from(data?['members'] == null ? [] : data?['members']);
      if (!stulist.contains(stuid)) {
        await teamsCollection.update({
          "members": FieldValue.arrayUnion([stuid])
        });
        return true;
      }
    }
    return false;
  }

  getstuhashtags(String projectId) async {
    return teamCollection
        .doc(projectId)
        .collection("attendees_hashtags")
        .doc("Tags")
        .get();
  }

  getmaxteam(String projectId) async {
    return teamCollection.doc(projectId).get();
  }

  getUserName() async {
    return studentCollection.doc(uid).get();
  }

  getStuID() async {
    return studentCollection.doc(uid).get();
  }

  getprofprojects() async {
    return professorCollection.doc(uid).snapshots();
  }

  getstuprojects() async {
    return studentCollection.doc(uid).snapshots();
  }
}
