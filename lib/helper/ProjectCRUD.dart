import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:team/helper/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:team/widget/hashtagInput.dart';

class ProjectCRUD {
  String projectID;

  ProjectCRUD(this.projectID);

  late final attendeesCollection = FirebaseFirestore.instance
      .collection("projects")
      .doc(projectID)
      .collection("attendees");
  late final studentCollection = FirebaseFirestore.instance
      .collection('students')
      .doc(FirebaseAuth.instance.currentUser!.uid);
  late final teamsCollection = FirebaseFirestore.instance
      .collection("projects")
      .doc(projectID)
      .collection("teams");
  late final attendeesHashtagsCollection = FirebaseFirestore.instance
      .collection("projects")
      .doc(projectID)
      .collection("attendees_hashtags");
  late final teamsHashtagsCollection = FirebaseFirestore.instance
      .collection("projects")
      .doc(projectID)
      .collection("teams_hashtags");

  Future getstu_id() async {
    final snapshot = await studentCollection.get();
    var data = snapshot.data() as Map<String, dynamic>;
    return data['stu_id'].toString();
  }

  Future getAttendeeInfo() async {
    final snapshot = await attendeesCollection.get();
    var stu_id = await getstu_id();
    for (var doc in snapshot.docs) {
      var dataElement = doc.data() as Map<String, dynamic>;
      if (dataElement['stu_id'].toString() == stu_id) {
        return dataElement;
      }
    }
  }

  Future getMemsInfo(List<dynamic> memIds) async {
    // print("?");
    // print(memIds);
    List<dynamic> result = [];
    final snapshot = await attendeesCollection.get();
    for (var doc in snapshot.docs) {
      var dataElement = doc.data() as Map<String, dynamic>;
      if (memIds.contains(dataElement['stu_id'])) {
        result.add(dataElement);
      }
    }
    // print(result);
    return result;
  }

  Future addAttendeeReply(String content, String comment_data) async {
    var stu_id = await getstu_id();
    final QuerySnapshot snapshot = await attendeesCollection.get();
    for (var doc in snapshot.docs) {
      var dataElement = doc.data() as Map<String, dynamic>;
      if (dataElement['stu_id'].toString() == stu_id) {
        final QuerySnapshot snapshot2 =
            await attendeesCollection.doc(doc.id).collection('comments').get();
        for (var doc2 in snapshot2.docs) {
          var dataElement2 = doc2.data().toString();
          if (dataElement2 == comment_data) {
            if (attendeesCollection
                    .doc(doc.id)
                    .collection('comments')
                    .doc(doc2.id)
                    .collection('reply')
                    .get()
                    .toString()
                    .length ==
                0) {
              final b = await attendeesCollection
                  .doc(doc.id)
                  .collection('comments')
                  .doc(doc2.id)
                  .collection('reply')
                  .add({
                'comment_id': doc2.id,
                'author_doc_id': doc.id,
                'name': dataElement['name'],
                'content': content,
                'timestamp': FieldValue.serverTimestamp()
              });
            } else {
              final a = await attendeesCollection
                  .doc(doc.id)
                  .collection('comments')
                  .doc(doc2.id)
                  .collection('reply')
                  .doc()
                  .set({
                'comment_id': doc2.id,
                'author_doc_id': doc.id,
                'name': dataElement['name'],
                'content': content,
                'timestamp': FieldValue.serverTimestamp()
              });
            }
          }
        }
      }
    }
  }

  Future updateAttendeeReply(String comment_data, String content) async {
    var stu_id = await getstu_id();
    final QuerySnapshot snapshot = await attendeesCollection.get();
    for (var doc in snapshot.docs) {
      var dataElement = doc.data() as Map<String, dynamic>;
      if (dataElement['stu_id'].toString() == stu_id) {
        final QuerySnapshot snapshot2 =
            await attendeesCollection.doc(doc.id).collection('comments').get();
        for (var doc2 in snapshot2.docs) {
          var dataElement2 = doc2.data().toString();
          final QuerySnapshot snapshot3 = await attendeesCollection
              .doc(doc.id)
              .collection('comments')
              .doc(doc2.id)
              .collection('reply')
              .get();
          for (var doc3 in snapshot3.docs) {
            var dataElement3 = doc3.data().toString();
            if (dataElement3 == comment_data) {
              attendeesCollection
                  .doc(doc.id)
                  .collection('comments')
                  .doc(doc2.id)
                  .collection('reply')
                  .doc(doc3.id)
                  .update({'content': content});
            }
          }
        }
      }
    }
  }

  Future deleteAttendeeReply(String comment_data) async {
    var stu_id = await getstu_id();
    var timeZoneOffset = DateTime.now().timeZoneOffset.inMilliseconds;
    final QuerySnapshot snapshot = await attendeesCollection.get();
    for (var doc in snapshot.docs) {
      var dataElement = doc.data() as Map<String, dynamic>;
      if (dataElement['stu_id'].toString() == stu_id) {
        final QuerySnapshot snapshot2 =
            await attendeesCollection.doc(doc.id).collection('comments').get();
        for (var doc2 in snapshot2.docs) {
          var dataElement2 = doc2.data().toString();
          final QuerySnapshot snapshot3 = await attendeesCollection
              .doc(doc.id)
              .collection('comments')
              .doc(doc2.id)
              .collection('reply')
              .get();
          for (var doc3 in snapshot3.docs) {
            var dataElement3 = doc3.data().toString();
            if (dataElement3 == comment_data) {
              attendeesCollection
                  .doc(doc.id)
                  .collection('comments')
                  .doc(doc2.id)
                  .collection('reply')
                  .doc(doc3.id)
                  .delete();
            }
          }
        }
      }
    }
  }

  Future getAttendeeReply(String comment_data) async {
    var stu_id = await getstu_id();
    var data = [];
    var attendee_id = await getAttendeeID();

    final QuerySnapshot snapshot = await attendeesCollection.get();
    for (var doc in snapshot.docs) {
      var dataElement = doc.data() as Map<String, dynamic>;
      if (dataElement['stu_id'].toString() == stu_id) {
        final QuerySnapshot snapshot2 =
            await attendeesCollection.doc(doc.id).collection('comments').get();
        for (var doc2 in snapshot2.docs) {
          var dataElement2 = doc2.data().toString();
          if (dataElement2 == comment_data) {
            QuerySnapshot snapshot3 = await attendeesCollection
                .doc(doc.id)
                .collection('comments')
                .doc(doc2.id)
                .collection('reply')
                .get();
            for (var doc3 in snapshot3.docs) {
              data.add(doc3.data());
            }
          }
        }
      }
    }
    return data;
  }

  Future addTeamReply(String content, String comment_data) async {
    var stu_id = await getstu_id();
    var attendee = await getAttendeeInfo() as Map<String, dynamic>;
    var attendeeId = await getAttendeeID();
    final QuerySnapshot snapshot = await teamsCollection.get();
    for (var doc in snapshot.docs) {
      var mapp = doc.data() as Map<String, dynamic>;
      var dataElement = mapp['members'];
      for (int i = 0; i < dataElement.length; i++) {
        if (dataElement[i].toString() == stu_id) {
          final QuerySnapshot snapshot2 =
              await teamsCollection.doc(doc.id).collection('comments').get();
          for (var doc2 in snapshot2.docs) {
            var dataElement2 = doc2.data().toString();
            if (dataElement2 == comment_data) {
              if (teamsCollection
                      .doc(doc.id)
                      .collection('comments')
                      .doc(doc2.id)
                      .collection('reply')
                      .get()
                      .toString()
                      .length ==
                  0) {
                final b = await teamsCollection
                    .doc(doc.id)
                    .collection('comments')
                    .doc(doc2.id)
                    .collection('reply')
                    .add({
                  'comment_id': doc2.id,
                  'author_doc_id': attendeeId,
                  'name': attendee["name"],
                  'content': content,
                  'timestamp': FieldValue.serverTimestamp()
                });
              } else {
                final a = await teamsCollection
                    .doc(doc.id)
                    .collection('comments')
                    .doc(doc2.id)
                    .collection('reply')
                    .doc()
                    .set({
                  'comment_id': doc2.id,
                  'author_doc_id': attendeeId,
                  'name': attendee["name"],
                  'content': content,
                  'timestamp': FieldValue.serverTimestamp()
                });
              }
            }
          }
        }
      }
    }
  }

  Future getTeamReply(String comment_data) async {
    var stu_id = await getstu_id();
    List data = [];
    var attendee = await getAttendeeInfo() as Map<String, dynamic>;
    var attendeeId = await getAttendeeID();
    final QuerySnapshot snapshot = await teamsCollection.get();
    for (var doc in snapshot.docs) {
      var mapp = doc.data() as Map<String, dynamic>;
      var dataElement = mapp['members'];
      for (int i = 0; i < dataElement.length; i++) {
        if (dataElement[i].toString() == stu_id) {
          final QuerySnapshot snapshot2 =
              await teamsCollection.doc(doc.id).collection('comments').get();
          for (var doc2 in snapshot2.docs) {
            var dataElement2 = doc2.data().toString();
            if (dataElement2 == comment_data) {
              QuerySnapshot snapshot3 = await teamsCollection
                  .doc(doc.id)
                  .collection('comments')
                  .doc(doc2.id)
                  .collection('reply')
                  .get();
              for (var doc3 in snapshot3.docs) {
                data.add(doc3.data());
              }
            }
          }
        }
      }
      return data;
    }
  }

  Future updateTeamReply(String comment_data, String content) async {
    var stu_id = await getstu_id();
    final QuerySnapshot snapshot = await teamsCollection.get();
    for (var doc in snapshot.docs) {
      var mapp = doc.data() as Map<String, dynamic>;
      var dataElement = mapp['members'];
      for (int i = 0; i < dataElement.length; i++) {
        if (dataElement[i].toString() == stu_id) {
          final QuerySnapshot snapshot2 =
              await teamsCollection.doc(doc.id).collection('comments').get();
          for (var doc2 in snapshot2.docs) {
            var dataElement2 = doc2.data().toString();
            final QuerySnapshot snapshot3 = await teamsCollection
                .doc(doc.id)
                .collection('comments')
                .doc(doc2.id)
                .collection('reply')
                .get();
            for (var doc3 in snapshot3.docs) {
              var dataElement3 = doc3.data().toString();
              if (dataElement3 == comment_data) {
                teamsCollection
                    .doc(doc.id)
                    .collection('comments')
                    .doc(doc2.id)
                    .collection('reply')
                    .doc(doc3.id)
                    .update({'content': content});
              }
            }
          }
        }
      }
    }
  }

  Future deleteTeamReply(String comment_data) async {
    var stu_id = await getstu_id();
    var attendee = await getAttendeeInfo() as Map<String, dynamic>;
    var attendeeId = await getAttendeeID();
    final QuerySnapshot snapshot = await teamsCollection.get();
    for (var doc in snapshot.docs) {
      var mapp = doc.data() as Map<String, dynamic>;
      var dataElement = mapp['members'];
      for (int i = 0; i < dataElement.length; i++) {
        if (dataElement[i].toString() == stu_id) {
          final QuerySnapshot snapshot2 =
              await teamsCollection.doc(doc.id).collection('comments').get();
          for (var doc2 in snapshot2.docs) {
            var dataElement2 = doc2.data().toString();
            final QuerySnapshot snapshot3 = await teamsCollection
                .doc(doc.id)
                .collection('comments')
                .doc(doc2.id)
                .collection('reply')
                .get();
            for (var doc3 in snapshot3.docs) {
              var dataElement3 = doc3.data().toString();
              if (dataElement3 == comment_data) {
                teamsCollection
                    .doc(doc.id)
                    .collection('comments')
                    .doc(doc2.id)
                    .collection('reply')
                    .doc(doc3.id)
                    .delete();
              }
            }
          }
        }
      }
    }
  }

  Future addAttendeeComment(String content, bool isSecret) async {
    var stu_id = await getstu_id();
    final QuerySnapshot snapshot = await attendeesCollection.get();
    for (var doc in snapshot.docs) {
      var dataElement = doc.data() as Map<String, dynamic>;
      if (dataElement['stu_id'].toString() == stu_id) {
        if (attendeesCollection
                .doc(doc.id)
                .collection('comments')
                .get()
                .toString()
                .length ==
            0) {
          final b =
              await attendeesCollection.doc(doc.id).collection('comments').add({
            'author_doc_id': doc.id,
            'name': dataElement['name'],
            'isSecret': isSecret,
            'content': content,
            'timestamp': FieldValue.serverTimestamp()
          });
        } else {
          final a = await attendeesCollection
              .doc(doc.id)
              .collection('comments')
              .doc()
              .set({
            'author_doc_id': doc.id,
            'name': dataElement['name'],
            'isSecret': isSecret,
            'content': content,
            'timestamp': FieldValue.serverTimestamp()
          });
        }
      }
    }
  }

  Future getStudentCommentDocRef() async {
    var stu_id = await getstu_id();
    final QuerySnapshot snapshot = await attendeesCollection.get();
    for (var doc in snapshot.docs) {
      var dataElement = doc.data() as Map<String, dynamic>;
      if (dataElement['stu_id'].toString() == stu_id) {
        return attendeesCollection
            .doc(doc.id)
            .collection('comments')
            .snapshots()
            .listen((event) => {print("rarara")});
      }
    }
  }

  Future getTeamhdm() async {
    final snapshot = await teamsCollection.get();
    var stu_id = await getstu_id();
    for (var doc in snapshot.docs) {
      var dataElement = doc.get('members') as List;
      for (int i = 0; i < dataElement.length; i++) {
        if (dataElement[i].toString() == stu_id) {
          return doc.id;
        }
      }
    }
  }

  Future getTeamname() async {
    String teamid = "";
    await getTeamhdm().then((value) {
      teamid = value!;
    });
    final myteamsCollectionawait = teamsCollection.doc(teamid);
    DocumentSnapshot<Map<String, dynamic>>? teamsnapshot;
    await myteamsCollectionawait.get().then((value) {
      teamsnapshot = value;
    });

    final data = teamsnapshot!.data();
    return data?["name"];
  }

  Future getTeamID() async {
    var stu_id = await getstu_id();
    final QuerySnapshot snapshot = await teamsCollection.get();
    for (var doc in snapshot.docs) {
      var mapp = doc.data() as Map<String, dynamic>;
      var dataElement = mapp['members'];
      for (int i = 0; i < dataElement.length; i++) {
        if (dataElement[i].toString() == stu_id) {
          return doc.id;
        }
      }
    }
  }

  Future getTeamIDHDM(String teamname) async {
    final QuerySnapshot snapshot = await teamsCollection.get();
    for (var doc in snapshot.docs) {
      var mapp = doc.data() as Map<String, dynamic>;
      var dataElement = mapp['name'];

      //print(doc.id);
      if (dataElement == teamname) return doc.id;
    }
  }

  Future getOthersAttendeeInfo(String stu_id) async {
    final snapshot = await attendeesCollection.get();
    for (var doc in snapshot.docs) {
      var dataElement = doc.data() as Map<String, dynamic>;
      if (dataElement['stu_id'].toString() == stu_id) {
        return dataElement;
      }
    }
  }

  Future getOthersTeamInfo(String teamName) async {
    final snapshot = await teamsCollection.get();
    for (var doc in snapshot.docs) {
      var dataElement = doc.data() as Map<String, dynamic>;
      for (int i = 0; i < dataElement.length; i++) {
        if (dataElement['name'].toString() == teamName) {
          return doc.data() as Map<String, dynamic>;
        }
      }
    }
  }

  Future getAttendeeID() async {
    var stu_id = await getstu_id();
    final QuerySnapshot snapshot = await attendeesCollection.get();
    for (var doc in snapshot.docs) {
      var dataElement = doc.get("stu_id");
      if (dataElement == stu_id) {
        return doc.id;
      }
    }
  }

  Future addTeamComment(String content, bool isSecret) async {
    print("oinkoink");
    var stu_id = await getstu_id();
    var attendee = await getAttendeeInfo() as Map<String, dynamic>;
    var attendeeId = await getAttendeeID();
    final QuerySnapshot snapshot = await teamsCollection.get();
    for (var doc in snapshot.docs) {
      var mapp = doc.data() as Map<String, dynamic>;
      var dataElement = mapp['members'];
      for (int i = 0; i < dataElement.length; i++) {
        if (dataElement[i].toString() == stu_id) {
          if (teamsCollection
                  .doc(doc.id)
                  .collection('comments')
                  .get()
                  .toString()
                  .length ==
              0) {
            final b =
                await teamsCollection.doc(doc.id).collection('comments').add({
              'author_doc_id': attendeeId,
              'name': attendee["name"],
              'isSecret': isSecret,
              'content': content,
              'timestamp': FieldValue.serverTimestamp()
            });
          } else {
            final a = await teamsCollection
                .doc(doc.id)
                .collection('comments')
                .doc()
                .set({
              'author_doc_id': attendeeId,
              'name': attendee["name"],
              'isSecret': isSecret,
              'content': content,
              'timestamp': FieldValue.serverTimestamp()
            });
          }
        }
      }
    }
  }

  Future updateTeamComment(String content, String comment_data) async {
    var stu_id = await getstu_id();
    var attendee = await getAttendeeInfo() as Map<String, dynamic>;
    var attendeeId = await getAttendeeID();
    final QuerySnapshot snapshot = await teamsCollection.get();
    for (var doc in snapshot.docs) {
      var mapp = doc.data() as Map<String, dynamic>;
      var dataElement = mapp['members'];
      for (int i = 0; i < dataElement.length; i++) {
        if (dataElement[i].toString() == stu_id) {
          final QuerySnapshot snapshot2 =
              await teamsCollection.doc(doc.id).collection('comments').get();
          for (var doc2 in snapshot2.docs) {
            var dataElement2 = doc2.data().toString();
            if (dataElement2 == comment_data) {
              teamsCollection
                  .doc(doc.id)
                  .collection('comments')
                  .doc(doc2.id)
                  .update({'content': content});
            }
          }
        }
      }
    }
  }

  Future deleteTeamComment(String comment_data) async {
    var stu_id = await getstu_id();
    var attendee = await getAttendeeInfo() as Map<String, dynamic>;
    var attendeeId = await getAttendeeID();
    final QuerySnapshot snapshot = await teamsCollection.get();
    for (var doc in snapshot.docs) {
      var mapp = doc.data() as Map<String, dynamic>;
      var dataElement = mapp['members'];
      for (int i = 0; i < dataElement.length; i++) {
        if (dataElement[i].toString() == stu_id) {
          final QuerySnapshot snapshot2 =
              await teamsCollection.doc(doc.id).collection('comments').get();
          for (var doc2 in snapshot2.docs) {
            var dataElement2 = doc2.data().toString();
            if (dataElement2 == comment_data) {
              teamsCollection
                  .doc(doc.id)
                  .collection('comments')
                  .doc(doc2.id)
                  .delete();
            }
          }
        }
      }
    }
  }

  Future updateAttendeeComment(String content, String comment_data) async {
    var stu_id = await getstu_id();
    var timeZoneOffset = DateTime.now().timeZoneOffset.inMilliseconds;
    final QuerySnapshot snapshot = await attendeesCollection.get();
    for (var doc in snapshot.docs) {
      var dataElement = doc.data() as Map<String, dynamic>;
      if (dataElement['stu_id'].toString() == stu_id) {
        final QuerySnapshot snapshot2 =
            await attendeesCollection.doc(doc.id).collection('comments').get();
        for (var doc2 in snapshot2.docs) {
          var dataElement2 = doc2.data().toString();
          if (dataElement2 == comment_data) {
            attendeesCollection
                .doc(doc.id)
                .collection('comments')
                .doc(doc2.id)
                .update({'content': content});
          }
        }
      }
    }
  }

  Future getAttendeeIDhdm(String stu_id) async {
    final QuerySnapshot snapshot = await attendeesCollection.get();
    for (var doc in snapshot.docs) {
      var dataElement = doc.get("stu_id");
      if (dataElement.toString() == stu_id) {
        return doc.id;
      }
    }
  }

  Future getAttendeeComment() async {
    var stu_id = await getstu_id();
    List data = [];
    int index = 0;
    final QuerySnapshot snapshot = await attendeesCollection.get();
    for (var doc in snapshot.docs) {
      var dataElement = doc.data() as Map<String, dynamic>;
      if (dataElement['stu_id'].toString() == stu_id) {
        QuerySnapshot snapshot2 =
            await attendeesCollection.doc(doc.id).collection('comments').get();
        for (var doc2 in snapshot2.docs) {
          data.add(doc2.data());
          QuerySnapshot snapshot3 = await attendeesCollection
              .doc(doc.id)
              .collection('comments')
              .doc(doc2.id)
              .collection('reply')
              .get();
          for (var doc3 in snapshot3.docs) {
            data.add(doc3.data());
          }
        }
      }
    }
    return data;
  }

  Future getTeamComment() async {
    var stu_id = await getstu_id();
    List data = [];
    final QuerySnapshot snapshot = await teamsCollection.get();
    for (var doc in snapshot.docs) {
      var temp = doc.data() as Map<String, dynamic>;
      List dataElement = temp['members'];
      for (int i = 0; i < dataElement.length; i++) {
        if (dataElement[i].toString() == stu_id) {
          QuerySnapshot snapshot2 =
              await teamsCollection.doc(doc.id).collection('comments').get();
          for (var doc2 in snapshot2.docs) {
            data.add(doc2.data());
            QuerySnapshot snapshot3 = await teamsCollection
                .doc(doc.id)
                .collection('comments')
                .doc(doc2.id)
                .collection('reply')
                .get();
            for (var doc3 in snapshot3.docs) {
              data.add(doc3.data());
            }
          }
        }
      }
    }
    return data;
  }

  Future deleteAttendeeComment(String comment_data) async {
    var stu_id = await getstu_id();
    var timeZoneOffset = DateTime.now().timeZoneOffset.inMilliseconds;
    final QuerySnapshot snapshot = await attendeesCollection.get();
    for (var doc in snapshot.docs) {
      var dataElement = doc.data() as Map<String, dynamic>;
      if (dataElement['stu_id'].toString() == stu_id) {
        final QuerySnapshot snapshot2 =
            await attendeesCollection.doc(doc.id).collection('comments').get();
        for (var doc2 in snapshot2.docs) {
          var dataElement2 = doc2.data().toString();
          if (dataElement2 == comment_data) {
            attendeesCollection
                .doc(doc.id)
                .collection('comments')
                .doc(doc2.id)
                .delete();
          }
        }
      }
    }
  }

  Future getTeamInfo() async {
    final snapshot = await teamsCollection.get();
    var stu_id = await getstu_id();
    for (var doc in snapshot.docs) {
      var dataElement = doc.get('members') as List;
      for (int i = 0; i < dataElement.length; i++) {
        if (dataElement[i].toString() == stu_id) {
          return doc.data() as Map<String, dynamic>;
        }
      }
    }

    return {"isNull": true};
  }

  Future addTeam(String teamname, String introduction,
      String finding_member_info, List members) async {
    final teamDoc = await teamsCollection.doc().set({
      'name': teamname,
      'introduction': introduction,
      'finding_member_info': finding_member_info,
      'members': members,
      'isFinished': false,
      'hashtags': [],
    });
  }

  Future setStudentIntro(String intro) async {
    var stu_id = await getstu_id();
    final QuerySnapshot snapshot = await attendeesCollection.get();
    for (var doc in snapshot.docs) {
      var dataElement = doc.data() as Map<String, dynamic>;
      if (dataElement['stu_id'].toString() == stu_id) {
        attendeesCollection.doc(doc.id).update({'introduction': intro});
      }
    }
  }

  Future setContactInfo(List<dynamic> contacts) async {
    var stu_id = await getstu_id();
    final QuerySnapshot snapshot = await attendeesCollection.get();
    for (var doc in snapshot.docs) {
      var dataElement = doc.data() as Map<String, dynamic>;
      if (dataElement['stu_id'].toString() == stu_id) {
        //print(contacts);
        attendeesCollection.doc(doc.id).update({'contact_infos': contacts});
      }
    }
  }

  Future setWantedTeam(String intro) async {
    var stu_id = await getstu_id();
    final QuerySnapshot snapshot = await attendeesCollection.get();
    for (var doc in snapshot.docs) {
      var dataElement = doc.data() as Map<String, dynamic>;
      if (dataElement['stu_id'].toString() == stu_id) {
        attendeesCollection.doc(doc.id).update({'finding_team_info': intro});
      }
    }
  }

  Future setWantedMember(String intro) async {
    final snapshot = await teamsCollection.get();
    var stu_id = await getstu_id();
    for (var doc in snapshot.docs) {
      var dataElement = doc.get('members') as List;
      for (int i = 0; i < dataElement.length; i++) {
        if (dataElement[i].toString() == stu_id) {
          teamsCollection.doc(doc.id).update({'finding_member_info': intro});
        }
      }
    }
  }

  Future setTeamIntro(String intro) async {
    final snapshot = await teamsCollection.get();
    var stu_id = await getstu_id();
    for (var doc in snapshot.docs) {
      var dataElement = doc.get('members') as List;
      for (int i = 0; i < dataElement.length; i++) {
        if (dataElement[i].toString() == stu_id) {
          teamsCollection.doc(doc.id).update({'introduction': intro});
        }
      }
    }
  }

  Future setTeamName(String intro) async {
    final snapshot = await teamsCollection.get();
    var stu_id = await getstu_id();
    for (var doc in snapshot.docs) {
      var dataElement = doc.get('members') as List;
      for (int i = 0; i < dataElement.length; i++) {
        if (dataElement[i].toString() == stu_id) {
          teamsCollection.doc(doc.id).update({'name': intro});
        }
      }
    }
  }

  Future getattendeedoc(String comment) async {
    var stu_id = await getstu_id();
    final QuerySnapshot snapshot = await attendeesCollection.get();
    for (var doc in snapshot.docs) {
      var dataElement = doc.data() as Map<String, dynamic>;
      if (dataElement['stu_id'].toString() == stu_id) {
        return doc.id;
      }
    }
  }
}
