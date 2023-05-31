import 'dart:async';
import 'package:one_iota_mobile_app/api/auth.dart';
import 'package:one_iota_mobile_app/utils/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:one_iota_mobile_app/api/one_iota_api.dart';
import 'package:one_iota_mobile_app/screens/rounds_feature/add_round_page.dart';

import '../models/habit_data_model.dart';
import '../models/round_model.dart';
import '../models/summary.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../api/persistent_data.dart';
import '../widgets/habit_feature_widgets/habit_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  /// Header
  String? username;
  String? team;

  String formattedDate = DateFormat('MMM d, y').format(DateTime.now());

  /// Summary Highlights
  String? strength;
  double? strengthValue;
  String? strengthDescription;
  String? weakness;
  double? weaknessValue;
  String? weaknessDescription;

  // Rounds Box snapshot
  Future<Data>? _futureAnalysisData;
  Future<List<Round>>? _futureRounds;

  // Habit Section
  Future<List<HabitData>>? _futureHabits;
  late List byTheNumbers = [];

  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  void initState() {
    // getConnectivity();
    super.initState();

    _futureAnalysisData =
        OneIotaAuth().getAnalysisSummaryData(token: Auth.idToken);
    _futureRounds = OneIotaAuth().getRounds(token: Auth.idToken);
    _futureHabits = OneIotaAuth().get7daysHabits(
      token: Auth.idToken,
    );
  }

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            // showSnackBar(context);
            // showDialogBox();
            showInternetConnectionSnackbar(context);

            setState(() => isAlertSet = true);
          }
        },
      );

  FutureBuilder<List<Round>> generateRounds() {
    return FutureBuilder<List<Round>>(
        future: _futureRounds,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RoundsSection(rounds: snapshot.data!);
          } else if (snapshot.hasData) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        });
  }

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration:
            const Duration(days: 365), // Snackbar will stay for a long time
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void showInternetConnectionSnackbar(BuildContext context) async {
    bool isDeviceConnected =
        await Connectivity().checkConnectivity() != ConnectivityResult.none;

    if (!isDeviceConnected) {
      // ignore: use_build_context_synchronously
      showSnackbar(
          context, 'No internet connection. Please check your connectivity.');
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(formattedDate,
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 15,
              ),
              // From ../../widgets/habit_feature_widget/habit_list.dart
              GenerateSummary(futureAnalysisData: _futureAnalysisData),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Rounds",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // RoundsSection(rounds: rounds) // TODO HERE
                      GenerateRounds(futureRounds: _futureRounds),
                    ]),
              ),
              const SizedBox(
                height: 10,
              ),

              const Text(
                "Recent Habits",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              // HabitsSection(habits: habits)
              GenerateHabits(futureHabits: _futureHabits)
            ]),
          ),
        ));
  }

  Container pastMonthSummary(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF155B94),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Past Month Summary",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: Color(0xFFC1E5AF),
                      size: 40,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text:
                                  '${strength ?? "N/A"} (${strengthValue ?? 0}) ',
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFFC1E5AF))),
                          TextSpan(
                              text: strengthDescription ??
                                  "- lorem ipsum , consecteturconsecteturconsecteturconsecteturconsectetur.",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              )),
                        ]),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.close_rounded,
                      color: Color(0xFFC1E5AF),
                      size: 40,
                    ),
                    const SizedBox(width: 20),
                    Flexible(
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text:
                                  '${weakness ?? "N/A"} (${weaknessValue ?? 0}) ',
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFFC1E5AF))),
                          TextSpan(
                              text: weaknessDescription ?? "- ",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              )),
                        ]),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GenerateRounds extends StatelessWidget {
  const GenerateRounds({
    super.key,
    required Future<List<Round>>? futureRounds,
  }) : _futureRounds = futureRounds;

  final Future<List<Round>>? _futureRounds;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Round>>(
        future: _futureRounds,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RoundsSection(rounds: snapshot.data!);
          } else if (snapshot.hasData) {
            return Text('${snapshot.error}');
          }
          return Container(
            height: 125,
            width: MediaQuery.of(context).size.width - 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddRound()));
                    },
                    child: Container(
                      width: 125,
                      height: 125,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 2,
                          color: Colors.grey.withOpacity(0.5),
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xff87CA80),
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 40,
                              color: Color(0xff155B94),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Add Round",
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Color(0xff155b94),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container(
                    margin: const EdgeInsets.only(left: 10),
                    padding: const EdgeInsets.all(10),
                    width: 125,
                    height: 125,
                    decoration: BoxDecoration(
                      color: const Color(0xFF87CA80),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Loading...",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          );
        });
  }
}

/// A FutureBuilder class that builds the summary portion of the page if it exists.
/// If it doesn't exist, it will tell the user to go out and play more golf.
class GenerateSummary extends StatefulWidget {
  const GenerateSummary({
    super.key,
    required Future<Data>? futureAnalysisData,
  }) : _futureAnalysisData = futureAnalysisData;

  final Future<Data>? _futureAnalysisData;

  @override
  State<GenerateSummary> createState() => _GenerateSummaryState();
}

class _GenerateSummaryState extends State<GenerateSummary> {
  final ScrollController _scrollController = ScrollController();

  /// TODO Slow auto scroll feature - Not working though.
  _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return FutureBuilder<Data>(
      future: widget._futureAnalysisData,
      builder: (context, snapshot) {
        //print(snapshot);
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            Data analysisData = snapshot.data!;
            Map<String, dynamic> byTheNumbers = {
              "Tee in Play": analysisData.teeInPlay,
              "Fairways": analysisData.teeFway,
              "Greens in Regulation": analysisData.approachGir,
              "Ups and Downs": analysisData.shortGameSave,
              "Chip Saves:": analysisData.chipSaved,
              "Sand Saves": analysisData.sandSaved,
              "Putts per Round": analysisData.puttsRound,
              "3 Putts per Round": analysisData.threePuttsRound,
              "Ft. of Putts per Round": analysisData.feetOfPutts
            };
            // print(byTheNumbers);
            return Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF155B94),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Past Month Summary",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Color(0xFFC1E5AF),
                              size: 40,
                            ),
                            const SizedBox(width: 20),
                            Flexible(
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: analysisData
                                            .recommendation!.strength!.title ??
                                        "N/A",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFFC1E5AF),
                                    ),
                                  ),
                                  TextSpan(
                                    text: analysisData
                                        .recommendation!.strength!.score
                                        .toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFFC1E5AF),
                                    ),
                                  ),
                                  const TextSpan(
                                    text: " - ",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFFC1E5AF),
                                    ),
                                  ),
                                  TextSpan(
                                    text: analysisData.recommendation!.strength!
                                            .message ??
                                        "-",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(
                              Icons.close_rounded,
                              color: Color(0xFFC1E5AF),
                              size: 40,
                            ),
                            const SizedBox(width: 20),
                            Flexible(
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: analysisData
                                            .recommendation!.weakness!.title ??
                                        "N/A",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFFC1E5AF),
                                    ),
                                  ),
                                  TextSpan(
                                    text: analysisData
                                        .recommendation!.weakness!.score
                                        .toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFFC1E5AF),
                                    ),
                                  ),
                                  const TextSpan(
                                    text: " - ",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFFC1E5AF),
                                    ),
                                  ),
                                  TextSpan(
                                    text: analysisData.recommendation!.weakness!
                                            .message ??
                                        "-",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  const Text(
                    "By the Numbers",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: ByTheNumbers(byTheNumbers),
                  ),
                ],
              ),
            );
          } else {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: 400,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF155B94),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Past Month Summary",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 100),
                  Center(
                    child: Text(
                      "Can't seem to find your summary, please try again later.",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center, // Center the text
                    ),
                  ),
                ],
              ),
            );
          }
        } else if (snapshot.hasError) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: 400,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF155B94),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Past Month Summary",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 100),
                Center(
                  child: Text(
                    "Error has occured, please try again later.",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          // Still loading
          return Container(
            width: MediaQuery.of(context).size.width,
            height: 400,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF155B94),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Past Month Summary",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 100),
                Center(
                  child: Text(
                    "Loading...",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Row ByTheNumbers(byTheNumbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 290,
          height: 75,
          child: ListView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            children: byTheNumbers.entries
                .map<Widget>((entry) => StatisticWidget(
                    title: entry.key,
                    value: entry.value.value,
                    goal: entry.value.goal))
                .toList(),
          ),
        ),
      ],
    );
  }
}

class RoundsSection extends StatelessWidget {
  const RoundsSection({
    super.key,
    required this.rounds,
  });

  final List<Round> rounds;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 125,
          width: MediaQuery.of(context).size.width - 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: rounds.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddRound()));
                  },
                  child: Container(
                    width: 125,
                    height: 125,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 2,
                        color: Colors.grey.withOpacity(0.5),
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff87CA80),
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 40,
                            color: Color(0xff155B94),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Add Round",
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: Color(0xff155b94),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return RoundCardContainer(rounds: rounds[index - 1]);
              }
            },
          ),
        ),
      ],
    );
  }
}

/// this is the container for each round card
class RoundCardContainer extends StatelessWidget {
  const RoundCardContainer({
    super.key,
    required this.rounds,
  });

  final Round rounds;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        PersistentData.currentRoundEdit = rounds;

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const AddRound()));
      },
      child: Container(
        margin: const EdgeInsets.only(
          left: 10,
        ),
        padding:
            const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
        width: 125,
        height: 125,
        decoration: BoxDecoration(
          color: const Color(0xFF87CA80),
          borderRadius: BorderRadius.circular(10),
        ),
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(10),
        // ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                rounds.formattedDate ?? "-",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Text(
                rounds.score.toString() ?? "-",
                style: const TextStyle(
                    fontSize: 30,
                    color: Color(0xFF155B94),
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Text(
                  rounds.courseName ?? "-",
                  // "-",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.username,
    required this.team,
  });

  final String? username;
  final String? team;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(username ?? "John Doe",
              style:
                  const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          Text(team ?? "No team",
              textAlign: TextAlign.start,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
        ],
      ),
      const Icon(
        Icons.person,
        size: 50,
      ), //TODO add image icon
    ]);
  }
}

class StatisticWidget extends StatelessWidget {
  final String title;
  final num value;
  final num goal;

  const StatisticWidget({
    super.key,
    required this.title,
    required this.value,
    required this.goal,
  });

  String convertDoubleToIntIfWhole(num number) {
    if (number % 1 == 0) {
      return number.toInt().toString();
    } else {
      return number.toStringAsFixed(
          1); // Return null if the number has a non-zero fractional part
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      // padding: const EdgeInsets.all(10),
      // width: 155,
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(
          // color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              // width: 100,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // "- ",
                      convertDoubleToIntIfWhole(value),
                      // value.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      "You",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
                const SizedBox(width: 5),
                Column(
                  children: const [
                    Text(
                      "VS",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
                const SizedBox(width: 5),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // "- ",
                      convertDoubleToIntIfWhole(goal),
                      // goal.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      "Goal",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 100,
              child: LinearProgressIndicator(
                // value: value / goal,
                value: value / goal,
                backgroundColor: Colors.white,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Colors.green,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
