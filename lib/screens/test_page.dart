import 'dart:convert';

import 'package:one_iota_mobile_app/api/one_iota_api.dart';
import 'package:one_iota_mobile_app/screens/home_page.dart';
import 'package:flutter/material.dart';
import '../api/auth.dart';

import '../models/auth_models.dart';
import '../models/courses_model.dart';
import '../models/habit_data_model.dart';
import '../models/hole_data_model.dart';
import '../models/round_model.dart';
import '../api/persistent_data.dart';
import '../widgets/habit_feature_widgets/habit_list.dart';

class FeatureOne extends StatefulWidget {
  const FeatureOne({super.key});
  @override
  State<FeatureOne> createState() => FeatureOneState();
}

class FeatureOneState extends State<FeatureOne> {
  Future<AccountInfo>? _futureAccount;
  Future<List<Round>>? _futureRounds;
  Future<List<HabitData>>? _futureHabits;

  Round testRound = Round(
      date:
          "2023-05-02T15:30:00", // "YYYY-MM-DDTHH:MM:SS" (Time of 00:00:00 indicates the time is not set)
      startingHole: 1,
      roundType: "Practice", // Practice, Qualfying, Competition, Tournament
      wind: "Not Set", // Not Set, No Wind, 10, 20, 30, 40. 50+
      weather: "Not Set", // Not Set, Sunny, Light Rain, Heavy Rain, Overcast
      temperature: null, // Number between -10 and 50
      courseId: null,
      comment: "Test round from application", // string comment (max length 500)
      eventId: null, // eventId
      eventRound: null, // number between 1 and 6
      detailLevel: "Advanced" // "Basic"
      );
  Future<void> signOut() async {
    await Auth().signOut();
  }

  Future<void> postRound() async {
    print("adding a round");
    await OneIotaAuth().addRound(token: Auth.idToken!, newRound: testRound);
    print("done");
  }

  Future<void> getCourses() async {
    print("getting courses");
    await OneIotaAuth().getCourses(token: Auth.idToken!);
    print("done");
  }

  Future<void> getCourse() async {
    print("getting course");
    Course newCourse =
        await OneIotaAuth().getCourse(token: Auth.idToken!, courseId: 608);
    print('dones');
    for (var element in newCourse.getHoleData()) {
      print(
        'holeNum: ${element.holeNumber}, length:${element.length}',
      );
    }
  }

  Future<void> getRound() async {
    Round round =
        await OneIotaAuth().getRound(roundId: 4614, token: Auth.idToken!);
    round.holeData?.forEach((element) {
      print('Length: ${element.length}, Score: ${element.score}');
    });
  }

  void checkRound() {
    if (PersistentData.currentRoundEdit != null) {
      print("Exists: ${PersistentData.currentRoundEdit?.date}");
    }
  }

  void addHole() {
    HoleData newData = HoleData(length: 420);
    if (PersistentData.currentRoundEdit != null) {
      PersistentData.currentRoundEdit!.addHoleData(2, newData);
    }
    print(
        "Testing new added hole: ${PersistentData.currentRoundEdit!.holeData![2].length}");

    for (var element in PersistentData.currentRoundEdit!.holeData!) {
      print("hole length: ${element.length}");
    }
    print("Json encoded: ${jsonEncode(PersistentData.currentRoundEdit!)}");
  }

  void updateRound() async {
    Round testRound = Round();
    int roundId = 4614;
    print("updating hole with id $roundId");
    print(testRound.date);
    print(testRound.time);
    print('Encoded: ${jsonEncode(testRound)}');
    await OneIotaAuth()
        .updateRound(token: Auth.idToken!, updateRound: testRound);
    print('done');
  }

  void deleteRound() async {
    int roundId = 4599;
    print("deleting round with id: $roundId");
    await OneIotaAuth().deleteRound(token: Auth.idToken!, roundId: roundId);
  }

  FutureBuilder<AccountInfo> testFutureBuilderName() {
    return FutureBuilder<AccountInfo>(
        future: _futureAccount,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text("Hello, ${snapshot.data!.name}!");
          } else if (snapshot.hasData) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        });
  }

  FutureBuilder<List<Round>> testFutureRounds() {
    return FutureBuilder<List<Round>>(
        future: _futureRounds,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // const Text("check terminal");
            return RoundsSection(rounds: snapshot.data!);
          } else if (snapshot.hasData) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        });
  }

  FutureBuilder<List<HabitData>> testFutureHabits() {
    return FutureBuilder<List<HabitData>>(
        future: _futureHabits,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // const Text("check terminal");
            return HabitsSection(habits: snapshot.data!);
          } else if (snapshot.hasData) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        });
  }

  //This is an example of using Future items to update widgets.
  Widget testWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
            onPressed: () {
              setState(() {
                _futureAccount =
                    OneIotaAuth().fetchAccountInfo(token: Auth.idToken!);
              });
            },
            child: Column(children: <Widget>[
              const Text('Fetch name'),
              (_futureAccount == null)
                  ? const Text("Name: None")
                  : testFutureBuilderName()
            ])),
      ],
    );
  }

  Widget testRoundsWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
            onPressed: () {
              setState(() {
                _futureRounds = OneIotaAuth().getRounds(token: Auth.idToken!);
              });
            },
            child: Column(children: <Widget>[
              const Text('Fetch rounds'),
              (_futureRounds == null)
                  ? const Text("Rounds: None",
                      style: TextStyle(fontSize: 20, color: Colors.black))
                  : testFutureRounds()
            ])),
      ],
    );
  }

  Widget testHabitsWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
            onPressed: () {
              setState(() {
                _futureHabits = OneIotaAuth().getHabits(token: Auth.idToken!);
              });
            },
            child: Column(children: <Widget>[
              const Text('Fetch Habits'),
              (_futureAccount == null)
                  ? const Text("Habits: None",
                      style: TextStyle(fontSize: 20, color: Colors.black))
                  : testFutureHabits()
            ])),
      ],
    );
  }

  Widget _postRound() {
    return ElevatedButton(
      onPressed: postRound,
      child: const Text('Post test round'),
    );
  }

  Widget _getRound() {
    return ElevatedButton(
      onPressed: getRound,
      child: const Text('Print roundID 4614'),
    );
  }

  Widget _getCourses() {
    return ElevatedButton(
      onPressed: getCourses,
      child: const Text('Print courses'),
    );
  }

  Widget _getCourse() {
    return ElevatedButton(
      onPressed: getCourse,
      child: const Text('Print single course'),
    );
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: signOut,
      child: const Text(
        "Sign Out",
        style: TextStyle(
          color: Colors.lightBlue,
        ),
      ),
    );
  }

  Widget _idText() {
    if (Auth.idToken != null) {
      return Text('$Auth.idToken.id');
    } else {
      return const Text('text');
    }
  }

  Widget _checkRound() {
    return ElevatedButton(
      onPressed: checkRound,
      child: const Text('Check if roundEdit exists'),
    );
  }

  Widget _addHoleData() {
    return ElevatedButton(
      onPressed: addHole,
      child: const Text('Add new holeData'),
    );
  }

  Widget _updateRound() {
    return ElevatedButton(
      onPressed: updateRound,
      child: const Text('Update round'),
    );
  }

  Widget _deleteRound() {
    return ElevatedButton(
      onPressed: deleteRound,
      child: const Text('Delete round'),
    );
  }

  Widget _updateProfilePicture() {
    return ElevatedButton(
      onPressed: () => OneIotaAuth()
          .updateProfilePicture(token: Auth.idToken!, imageUrl: ""),
      child: const Text('Update profile picture'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: const EdgeInsets.all(20),
      child: Column(children: [
        _signOutButton(),
        _idText(),
        testWidget(),
        // testRoundsWidget(),
        testHabitsWidget(),
        _getRound(),
        //_postRound(),
        _getCourses(),
        _checkRound(),
        _addHoleData(),
        _updateRound(),
        _getCourse(),
        _deleteRound(),
      ]),
    ));
  }
}
