import 'package:flutter/material.dart';
import 'package:one_iota_mobile_app/screens/rounds_feature/round_complete.dart';
import '../../api/auth.dart';
import '../../models/round_model.dart';
import '../../api/one_iota_api.dart';
import '../../api/persistent_data.dart';

class SummaryPage extends StatefulWidget {
  final bool isBasicRound;

  const SummaryPage({Key? key, required this.isBasicRound}) : super(key: key);

  @override
  State<SummaryPage> createState() => SummaryPageState();
}

class SummaryPageState extends State<SummaryPage> {
  late bool isBasicRound;
  late TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    isBasicRound = widget.isBasicRound;
    textEditingController = TextEditingController();
    gettingPuttScoreDetails();
    gettingOverviewDetails();
    checkForErrors();
    numOfErrors();
  }

  void checkForErrors() {
    if (PersistentData.currentRoundEdit != null) {
      Round thisRound = PersistentData.currentRoundEdit!;
      // Round thisRound = testRound;

      //Error - Invalid temparature
      var temperature = thisRound.temperature;
      if (temperature != null) {
        if (temperature.isNaN || temperature < -10 || temperature > 50) {
          errorCards.add(ErrorCard(
            type: "Error",
            title: "Temparature",
            suggestion:
                "The temperature provided is not valid. You can leave the temperature blank or provide the temperature in degree celsius. The temperature can be any number between -10 and 50 degrees",
          ));
        }
      }

      //Looping through all holes
      for (var i = 0; i < thisRound.holeData!.length; i++) {
        var element = thisRound.holeData![i];
        //Error - Invalid tee shot result
        if (element.played == true) {
          if (element.par != 3 && element.fairway == null) {
            errorCards.add(ErrorCard(
              type: "Error",
              title: "Fairway",
              holeNumber: element.holeNumber,
              suggestion:
                  "You set the tee shot result for a par 4 or par 5 to no shot. This is not possible.",
            ));
          }
          // ERROR - Make sure there is an approach distance if they said there should be
          if (element.approachResult != null &&
              element.approachResult != "None" &&
              element.approachDistance != null &&
              (element.approachDistance!.isNaN ||
                  element.approachDistance! < 30)) {
            errorCards.add(ErrorCard(
              type: "Error",
              title: "Approach Distance",
              holeNumber: element.holeNumber,
              suggestion:
                  "You didn't provide a valid approach distance but didn't specify there was no approach shot. Make sure the approach length is greater than 30 yards or specify there was no approach shot",
            ));
          }
          // ERROR - Number of putts is greater than or equal to the score
          if (element.numOfPutts != null &&
              element.score != null &&
              element.numOfPutts! >= element.score!) {
            errorCards.add(ErrorCard(
              type: "Error",
              title: "Number Of Putts",
              holeNumber: element.holeNumber,
              suggestion:
                  "The number of putts for the hole cannot be the same as or greater than the score on the hole. Please review this.",
            ));
          }
          // ERROR - number of putts field is empty
          if (element.numOfPutts == null ||
              element.numOfPutts != null && element.numOfPutts!.isNaN ||
              element.numOfPutts != null && element.numOfPutts! < 0) {
            errorCards.add(ErrorCard(
                type: "Error",
                title: "Number Of Putts",
                holeNumber: element.holeNumber,
                suggestion:
                    "You have to enter the number of putts for a hole. If you didn't have any putts, enter 0"));
          } else if (element.numOfPutts != null && element.numOfPutts! >= 1) {
            if (element.putt1 == null ||
                element.putt1 != null && element.putt1!.isNaN) {
              errorCards.add(ErrorCard(
                  type: "Error",
                  title: "Putt 1",
                  holeNumber: element.holeNumber,
                  suggestion:
                      "You specified you had ${element.numOfPutts} putts but didn't specify a length for putt 1"));
            }
            if (element.numOfPutts! >= 2 && element.putt2 == null ||
                element.putt2 != null && element.putt2!.isNaN) {
              errorCards.add(ErrorCard(
                  type: "Error",
                  title: "Putt 2",
                  holeNumber: element.holeNumber,
                  suggestion:
                      "You specified you had ${element.numOfPutts} putts but didn't specify a length for putt 2"));
            }
            if (element.numOfPutts! >= 3 && element.putt3 == null ||
                element.putt3 != null && element.putt3!.isNaN) {
              errorCards.add(ErrorCard(
                  type: "Error",
                  title: "Putt 3",
                  holeNumber: element.holeNumber,
                  suggestion:
                      "You specified you had ${element.numOfPutts} putts but didn't specify a length for putt 3"));
            }
          }
          // ERROR - no score provided
          if (element.score == null ||
              element.score != null && element.score!.isNaN) {
            errorCards.add(ErrorCard(
                type: "Error",
                title: "Score",
                holeNumber: element.holeNumber,
                suggestion:
                    "You did not specify the score on this hole. You can select that you didn't play this hole if you don't have a score"));
          }
          // ERROR - Tee shot in play, Approach hit the green, putts are 0 and score is not 2 / 3 on par 4 or 5
          if ((element.fairway == "Hit" ||
                  element.fairway == "Left" ||
                  element.fairway == "Right") &&
              element.approachResult == "Hit" &&
              element.numOfPutts == 0 &&
              (element.score! > (element.par! - 2))) {
            errorCards.add(ErrorCard(
                type: "Error",
                title: "Shot Squence",
                holeNumber: element.holeNumber,
                suggestion:
                    "You specified a tee shot in play, holed approach shot and score that was not an eagle. Please review your hole entries to resolve this issue."));
          }
          // ERROR - Approach shot on par 3 is not from tee box
          if (element.par == 3 &&
              element.approachLie != null &&
              element.approachLie! != "Tee") {
            errorCards.add(ErrorCard(
                type: "Error",
                title: "Approach Lie",
                holeNumber: element.holeNumber,
                suggestion:
                    "You specifed your approach shot was not from the tee on a par 3."));
          }
          // //WARN - fway missed, approach from fairway, green hit, not a par 5
          if (element.par != 5 &&
              element.fairway != "Hit" &&
              element.approachResult != "None" &&
              element.approachLie == "Fway" &&
              (element.score! - element.numOfPutts!) <= (element.par! - 2)) {
            errorCards.add(ErrorCard(
                type: "Warning",
                title: "Approach Lie OR Tee Shot",
                holeNumber: element.holeNumber,
                suggestion:
                    "You specifed you hit the green on your approach shot from the fairway while missing the fairway off the tee on a par 4. We wanted to make sure this wasn't a mistake"));
          }
          //WARN - missed chip or sand, non par 5 greater than 350 yards
          if (element.par != 5 &&
              (element.chipResult == "Miss" || element.sandResult == "Miss") &&
              (element.score! - element.numOfPutts!) <= (element.par! - 2)) {
            errorCards.add(ErrorCard(
                type: "Warning",
                title: "Short Game",
                holeNumber: element.holeNumber,
                suggestion:
                    "You specifed you hit the green on a par 3 or 4 while also missing the green from green side. Specifying a short game shot as missed means it did not finish on the green. Are you sure this is correct?"));
          }
          //WARN - on par 3, hole length and approach are off my more than 40 yards
          if (element.par == 3 &&
              element.approachDistance != null &&
              ((element.length! - element.approachDistance!).abs() > 40)) {
            errorCards.add(ErrorCard(
                type: "Warning",
                title: "Approach Distance",
                holeNumber: element.holeNumber,
                suggestion:
                    "You specifed your approach shot was from ${element.approachDistance} but the normal hole length is ${element.length}. We wanted to make sure this wasn't an error."));
          }
        }
      }
    }
  }

  void gettingPuttScoreDetails() {
    if (PersistentData.currentRoundEdit != null) {
      Round thisRound = PersistentData.currentRoundEdit!;
      // Round thisRound = testRound;
      for (var i = 0; i < thisRound.holeData!.length; i++) {
        var element = thisRound.holeData![i];
        parList.add(element.par!);
        scoreList.add(element.score);
        holeList.add(element.holeNumber);

        if (i >= 0 && i <= 8) {
          puttOut += element.numOfPutts ?? 0;
          scoreOut += element.score ?? 0;
        }
        if (i >= 9 && i <= 17) {
          puttIn += element.numOfPutts ?? 0;
          scoreIn += element.score ?? 0;
        }
        puttTotal += element.numOfPutts ?? 0;
        scoreTotal += element.score ?? 0;
      }

      for (int i = 0; i < parList.length; i++) {
        List<String> row = [
          holeList[i].toString(),
          parList[i].toString(),
          scoreList[i]?.toString() ?? '-',
        ];
        rowData.add(row);

        if (scoreList[i] == null) {
          scoreIndicator.add(null);
        } else if (scoreList[i] == parList[i]) {
          scoreIndicator.add(null);
        } else if (scoreList[i] == (parList[i] - 1)) {
          scoreIndicator.add(birdie);
        } else if (scoreList[i]! <= (parList[i] - 2)) {
          scoreIndicator.add(eagle);
        } else if (scoreList[i] == (parList[i] + 1)) {
          scoreIndicator.add(bogey);
        } else if (scoreList[i]! >= (parList[i] + 2)) {
          scoreIndicator.add(doubleBogey);
        }
      }
    }
  }

  void gettingOverviewDetails() {
    if (PersistentData.currentRoundEdit != null) {
      Round thisRound = PersistentData.currentRoundEdit!;
      // Round thisRound = testRound;
      for (var element in thisRound.holeData!) {
        if ((element.par == 4 || element.par == 5) &&
            element.fairway == "Hit") {
          fairways += 1;
        }
        if (element.par != 3) {
          fairwayTotal += 1;
        }
        if (element.gir != null && element.gir!) {
          greens += 1;
        } else if (element.score != null &&
            element.numOfPutts != null &&
            element.par != null &&
            (element.score! - element.numOfPutts!) <= (element.par! - 2)) {
          greens += 1;
        } // needs rework
        if (element.played != null && element.played!) {
          greensTotal += 1;
        }
        if (element.chipResult == "Hit" && element.numOfPutts! <= 1) {
          chipping += 1;
        }
        if (element.chipResult == "Hit" || element.chipResult == "Miss") {
          chippingTotal += 1;
        }
        if (element.sandResult == "Hit" && element.numOfPutts! <= 1) {
          sand += 1;
        }
        if (element.sandResult == "Hit" || element.sandResult == "Miss") {
          sandTotal += 1;
        }
        if (element.chipSand != null &&
            element.chipSand! &&
            element.numOfPutts! <= 1) {
          chipSand += 1;
        }
        if (element.chipSand != null) {
          chipSandTotal += 1;
        }
      }
    }
  }

  List<int?> holeList = [];
  List<int> parList = [];
  List<int?> scoreList = [];
  List<List<String>> rowData = [];
  List<String?> scoreIndicator = [null];
  int puttOut = 0;
  int puttIn = 0;
  int puttTotal = 0;
  int scoreOut = 0;
  int scoreIn = 0;
  int scoreTotal = 0;
  String birdie = 'assets/circle.png';
  String eagle = 'assets/doublecircle.png';
  String bogey = 'assets/square.png';
  String doubleBogey = 'assets/doublesquare.png';

  List<TextStyle> rowTextStyles = List.generate(
    19,
    (index) => index == 0
        ? const TextStyle(fontWeight: FontWeight.w700, color: Colors.white)
        : const TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
  );

  List<Color> rowBackgroundColors = List.generate(
    19,
    (index) => index == 0 ? const Color(0xff155B94) : Colors.white,
  );

  List<bool> hasBorders = List.filled(19, true);

  int errors = 0;
  int fairways = 0;
  int fairwayTotal = 0;
  int greens = 0;
  int greensTotal = 0;
  int chipping = 0;
  int chippingTotal = 0;
  int chipSand = 0;
  int chipSandTotal = 0;
  int sand = 0;
  int sandTotal = 0;

  List<ErrorCard> errorCards = [];

  void numOfErrors() {
    for (int i = 0; i < errorCards.length; i++) {
      if (errorCards[i].type == "Error") {
        errors += 1;
      }
    }
  }

  void _updateRoundData(BuildContext context) async {
    if (errors == 0) {
      PersistentData.currentRoundEdit!.inProgress = false;
      await OneIotaAuth().updateRound(
          token: Auth.idToken, updateRound: PersistentData.currentRoundEdit!);
      print('nice');
    } else {
      await OneIotaAuth().updateRound(
          token: Auth.idToken, updateRound: PersistentData.currentRoundEdit!);
      print('not nice');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2C6E2E),
      body: Center(
        child: Container(
          width: 350,
          height: 620,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          decoration: BoxDecoration(
            color: const Color(0xfff1f1f1),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 70,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        "Summary",
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          color: Color(0xff155B94),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Errors + Warnings ($errors)",
                              style: const TextStyle(
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            if (errors == 0)
                              const Text(
                                "There is no error. Your round is complete.",
                                style: TextStyle(
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: Colors.black,
                                ),
                              ),
                            if (errors < 0)
                              Text(
                                "Your round has $errors. You must resolve these errors before saving your round.",
                                style: const TextStyle(
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: Colors.black,
                                ),
                              ),
                            ErrorCardsWidget(errorCards: errorCards),
                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                              "Overview",
                              style: TextStyle(
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            StatusBarWidget(
                              fairway: fairways,
                              fairwayTotalEntries: fairwayTotal,
                              green: greens,
                              greenTotalEntries: greensTotal,
                              chipSand: chipSand,
                              chipSandTotalEntries: chipSandTotal,
                              chipping: chipping,
                              chippingTotalEntries: chippingTotal,
                              sand: sand,
                              sandTotalEntries: sandTotal,
                              isBasicRound: isBasicRound,
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 35.0,
                                    right: 20,
                                  ),
                                  child: Column(
                                    children: const [
                                      Text(
                                        "Putts",
                                        style: TextStyle(
                                          fontFamily: "Inter",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          color: Color(0xff155B94),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "Score",
                                        style: TextStyle(
                                          fontFamily: "Inter",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          color: Color(0xff155B94),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                CustomTable(
                                  data: [
                                    const ['Out', 'In', 'Total'],
                                    [
                                      puttOut.toString(),
                                      puttIn.toString(),
                                      puttTotal.toString()
                                    ],
                                    [
                                      scoreOut.toString(),
                                      scoreIn.toString(),
                                      scoreTotal.toString()
                                    ],
                                  ],
                                  rowTextStyles: const [
                                    TextStyle(fontWeight: FontWeight.w700),
                                    TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xff87CA80)),
                                    TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xff87CA80)),
                                  ],
                                  rowBackgroundColors: const [
                                    Color(0xfff1f1f1),
                                    Color(0xfff1f1f1),
                                    Color(0xfff1f1f1),
                                  ],
                                  hasBorders: const [false, false, false],
                                  cellTextStyle: const TextStyle(fontSize: 13),
                                  cellPadding: 8.0,
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              "Scorecard",
                              style: TextStyle(
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Center(
                              child: SizedBox(
                                width: 300,
                                height: 640,
                                child: CustomTable(
                                  data: [
                                    const ['Hole', 'Par', 'Score'],
                                    ...rowData,
                                  ],
                                  rowTextStyles: rowTextStyles,
                                  rowBackgroundColors: rowBackgroundColors,
                                  hasBorders: hasBorders,
                                  cellTextStyle: const TextStyle(fontSize: 13),
                                  cellPadding: 8.0,
                                  scoreIndicator: scoreIndicator,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Container(
                      alignment: Alignment.center,
                      width: 150,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xff87CA80),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          _updateRoundData(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RoundComplete()),
                          );
                        },
                        child: const Center(
                          child: Text(
                            'Save',
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: Color(0xff155B94),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ErrorCard {
  final String type;
  final String title;
  final int? holeNumber;
  final String suggestion;

  ErrorCard({
    required this.type,
    required this.title,
    this.holeNumber,
    required this.suggestion,
  });
}

class ErrorCardsWidget extends StatelessWidget {
  final List<ErrorCard> errorCards;

  const ErrorCardsWidget({super.key, required this.errorCards});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: errorCards.map((errorCard) {
          Color cardColor;
          // Set the card color based on the error type
          if (errorCard.type == 'Error') {
            cardColor = const Color(0xffC14E4E);
          } else if (errorCard.type == 'Warning') {
            cardColor = const Color(0xfff8c418);
          } else {
            cardColor =
                Colors.grey; // Default color if the type is not recognized
          }
          return Card(
            color: cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              width: 150,
              height: 202,
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    errorCard.type,
                    style: const TextStyle(
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    errorCard.title,
                    style: const TextStyle(
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Hole ${errorCard.holeNumber}",
                    style: const TextStyle(
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    errorCard.suggestion,
                    style: const TextStyle(
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w400,
                      fontSize: 11,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class StatusBarWidget extends StatelessWidget {
  final int fairway;
  final int fairwayTotalEntries;
  final int green;
  final int greenTotalEntries;
  final int? chipSand;
  final int? chipSandTotalEntries;
  final int? chipping;
  final int? chippingTotalEntries;
  final int? sand;
  final int? sandTotalEntries;
  final bool isBasicRound;

  const StatusBarWidget({
    Key? key,
    required this.fairway,
    required this.fairwayTotalEntries,
    required this.green,
    required this.greenTotalEntries,
    this.chipSand,
    this.chipSandTotalEntries,
    this.chipping,
    this.chippingTotalEntries,
    this.sand,
    this.sandTotalEntries,
    required this.isBasicRound,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildStatusBar(
            'Fairways', fairway, fairwayTotalEntries, const Color(0xff87CA80)),
        _buildStatusBar(
            'Greens', green, greenTotalEntries, const Color(0xff87CA80)),
        if (isBasicRound)
          _buildStatusBar('Chip/Sand', chipSand!, chipSandTotalEntries!,
              const Color(0xff87CA80)),
        if (!isBasicRound)
          Column(
            children: [
              _buildStatusBar('Chipping', chipping!, chippingTotalEntries!,
                  const Color(0xff87CA80)),
              _buildStatusBar(
                  'Sand', sand!, sandTotalEntries!, const Color(0xff87CA80)),
            ],
          )
      ],
    );
  }

  Widget _buildStatusBar(
      String label, int count, int totalEntries, Color color) {
    double percentage = count / totalEntries;
    if (totalEntries == 0) {
      percentage = 0;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          SizedBox(
            width: 75,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: "Inter",
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Color(0xff155B94),
              ),
            ),
          ),
          SizedBox(
            height: 10,
            width: 170,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: const Color(0xffd9d9d9),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Text(
            "$count / $totalEntries",
            style: const TextStyle(
              fontFamily: "Inter",
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: Color(0xff155B94),
            ),
          )
        ],
      ),
    );
  }
}

class CustomTable extends StatelessWidget {
  final List<List<String>> data;
  final List<TextStyle> rowTextStyles;
  final List<Color> rowBackgroundColors;
  final TextStyle cellTextStyle;
  final double cellPadding;
  final List<bool> hasBorders;
  final List<String?>? scoreIndicator;

  const CustomTable({
    Key? key,
    required this.data,
    required this.rowTextStyles,
    required this.rowBackgroundColors,
    this.cellTextStyle = const TextStyle(fontSize: 13),
    this.cellPadding = 8.0,
    required this.hasBorders,
    this.scoreIndicator,
  })  : assert(data.length == rowTextStyles.length &&
            data.length == rowBackgroundColors.length &&
            data.length == hasBorders.length),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: List.generate(data.length, (index) {
          final rowData = data[index];
          final rowTextStyle = rowTextStyles[index];
          final rowBackgroundColor = rowBackgroundColors[index];
          final rowHasBorders = hasBorders[index];

          return buildRow(
            rowData,
            rowTextStyle,
            rowBackgroundColor,
            rowHasBorders,
            index,
          );
        }),
      ),
    );
  }

  Widget buildRow(List<String> rowData, TextStyle rowTextStyle,
      Color rowBackgroundColor, bool rowHasBorders, int rowIndex) {
    return Row(
      children: List.generate(rowData.length, (index) {
        final cellData = rowData[index];
        final cellHasBorder = rowHasBorders && index < rowData.length;
        final imagePath = index == 2 &&
                scoreIndicator != null &&
                rowIndex < scoreIndicator!.length
            ? scoreIndicator![rowIndex]
            : null;
        return buildCell(cellData, rowTextStyle, rowBackgroundColor,
            cellHasBorder, imagePath);
      }),
    );
  }

  Widget buildCell(String cellData, TextStyle rowTextStyle,
      Color rowBackgroundColor, bool cellHasBorder, String? imagePath) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(cellPadding),
        decoration: BoxDecoration(
          color: rowBackgroundColor,
          border: cellHasBorder
              ? Border.all(
                  color: const Color(0xffb9b9b9),
                  width: 0.5,
                )
              : null,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (imagePath != null)
              Positioned.fill(
                child: Transform.scale(
                  scale: 1.5,
                  child: Image.asset(imagePath, fit: BoxFit.fitHeight),
                ),
              ),
            Text(
              cellData,
              textAlign: TextAlign.center,
              style: cellTextStyle.merge(rowTextStyle),
            ),
          ],
        ),
      ),
    );
  }
}
