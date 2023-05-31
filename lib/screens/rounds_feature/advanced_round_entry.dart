import 'package:one_iota_mobile_app/screens/rounds_feature/add_round_page.dart';
import 'package:one_iota_mobile_app/screens/rounds_feature/summary_page.dart';
export 'package:one_iota_mobile_app/screens/rounds_feature/advanced_round_entry.dart'
    show RadioGroup, PuttCounterWidget, ScoreWidget;
import 'package:flutter/material.dart';

import '../../models/courses_model.dart';
import '../../models/hole_data_model.dart';
import '../../models/round_model.dart';
import '../../api/persistent_data.dart';
import '../../widgets/rounds_widgets/putt_counter_widget.dart';
import '../../widgets/rounds_widgets/radio_buttons.dart';
import '../../widgets/rounds_widgets/score_widget.dart';

class AdvancedRoundEntry extends StatefulWidget {
  final int? startingHole;
  const AdvancedRoundEntry({super.key, required this.startingHole});

  @override
  State<AdvancedRoundEntry> createState() => AdvancedRoundEntryState();
}

class AdvancedRoundEntryState extends State<AdvancedRoundEntry> {
  late final PageController _pageController;
  List<int> pageNumbers = List.generate(18, (index) => index + 1);
  late int _pages;
  int _currentPage = 0;
  List<bool> isCheckedList = [];
  final fairwayItems = [
    RadioItem(icon: Icons.arrow_back, label: 'Left'),
    RadioItem(icon: Icons.arrow_upward, label: 'Hit'),
    RadioItem(icon: Icons.arrow_forward, label: 'Right'),
    RadioItem(icon: Icons.forest, label: 'No Shot'),
    RadioItem(icon: Icons.water_drop, label: 'Hazard'),
    RadioItem(icon: Icons.dangerous_outlined, label: 'Lost'),
  ];
  final lieItems = [
    RadioItem(icon: Icons.sports_golf, label: 'Tee'),
    RadioItem(icon: Icons.check, label: 'Fway'),
    RadioItem(icon: Icons.landscape, label: 'Rough'),
    RadioItem(icon: Icons.nature, label: 'Sand'),
  ];
  final resultItems = [
    RadioItem(icon: Icons.check, label: 'Hit'),
    RadioItem(icon: Icons.arrow_back, label: 'Left'),
    RadioItem(icon: Icons.arrow_forward, label: 'Right'),
    RadioItem(icon: Icons.arrow_downward, label: 'Short'),
    RadioItem(icon: Icons.arrow_upward, label: 'Long'),
    RadioItem(icon: Icons.dangerous_outlined, label: 'None'),
  ];
  final chipResultItems = [
    RadioItem(icon: Icons.check, label: 'Hit'),
    RadioItem(icon: Icons.close, label: 'Miss'),
    RadioItem(icon: Icons.remove, label: 'None'),
  ];
  final sandResultItems = [
    RadioItem(icon: Icons.check, label: 'Hit'),
    RadioItem(icon: Icons.close, label: 'Miss'),
    RadioItem(icon: Icons.remove, label: 'None'),
  ];

  late TextEditingController _distanceTextController;

  List<RadioItem?> selectedFairways = List.filled(18, null);
  List<RadioItem?> selectedLies = List.filled(18, null);
  List<RadioItem?> selectedResults = List.filled(18, null);
  List<RadioItem?> selectedChipResults = List.filled(18, null);
  List<RadioItem?> selectedSandResults = List.filled(18, null);
  List<int?> distances = List.filled(18, null);
  List<int?> scores = List.filled(18, null);
  List<int?> numOfPuttList = List.filled(18, null);
  List<List<int?>> puttInputList = List.filled(18, List.filled(3, null));
  bool _fairwayDone = false;
  bool _liesDone = false;
  bool _resultsDone = false;
  bool _chipDone = false;
  bool _sandDone = false;
  bool _puttsDone = false;
  bool _scoresDone = false;

  @override
  void initState() {
    _distanceTextController = TextEditingController();
    super.initState();
    _pages = pageNumbers.length;
    isCheckedList = List.filled(_pages, true);
    _pageController = PageController(initialPage: widget.startingHole! - 1);
    if (widget.startingHole != null && widget.startingHole! >= 2) {
      for (int i = 0; i < widget.startingHole! - 1; i++) {
        isCheckedList[i] = false;
      }
      _currentPage = widget.startingHole! - 1;
    }
    loadDistanceData();
  }

  @override
  void dispose() {
    _distanceTextController.dispose();
    super.dispose();
  }

  /// This method will be used to define the functionality of the putt counter
  void _updateNumberOfPutts(int value) {
    setState(() {
      numOfPuttList[_currentPage] = value;
    });
  }

  /// This method will be used to define the functionality of the putt counter
  void _updatePuttInputValues(List<int> values) {
    setState(() {
      puttInputList[_currentPage] = values;
    });
  }

  /// This method ensures the text for distance is the proper number
  void _updateDistance() {
    String distText = distances[_currentPage].toString();
    if (distText != 'null') {
      _distanceTextController.text = distances[_currentPage].toString();
    } else {
      _distanceTextController.clear();
    }
  }

  /// This widget is responsible creating the radio button group for Fairways,
  /// loading initial data if it exists
  FutureBuilder<List<RadioItem?>> futureFairwayRadioBuilder() {
    return FutureBuilder<List<RadioItem?>>(
        future: loadFairways(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return RadioGroup(
              items: fairwayItems,
              defaultSelection: snapshot.data![_currentPage],
              onChanged: (item) {
                setState(() {
                  selectedFairways[_currentPage] = item;
                });
              },
            );
          } else if (snapshot.hasError) {
            return RadioGroup(
              items: fairwayItems,
              onChanged: (item) {
                setState(() {
                  selectedFairways[_currentPage] = item;
                });
              },
            );
          } else if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            return Container();
          }
        });
  }

  /// This widget is responsible creating the radio button group for Lie,
  /// loading initial data if it exists
  FutureBuilder<List<RadioItem?>> futureLieRadioBuilder() {
    return FutureBuilder<List<RadioItem?>>(
        initialData: List.filled(18, null),
        future: loadLies(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return RadioGroup(
              items: lieItems,
              defaultSelection: snapshot.data![_currentPage],
              onChanged: (item) {
                setState(() {
                  selectedLies[_currentPage] = item;
                });
              },
            );
          } else if (snapshot.hasError) {
            return RadioGroup(
              items: lieItems,
              onChanged: (item) {
                setState(() {
                  selectedLies[_currentPage] = item;
                });
              },
            );
          } else if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            return Container();
          }
        });
  }

  /// This widget is responsible creating the radio button group for ApproachResult,
  /// loading initial data if it exists
  FutureBuilder<List<RadioItem?>> futureResultRadioBuilder() {
    return FutureBuilder<List<RadioItem?>>(
        initialData: List.filled(18, null),
        future: loadResults(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return RadioGroup(
              items: resultItems,
              defaultSelection: snapshot.data![_currentPage],
              onChanged: (item) {
                setState(() {
                  selectedResults[_currentPage] = item;
                });
              },
            );
          } else if (snapshot.hasError) {
            return RadioGroup(
              items: resultItems,
              onChanged: (item) {
                setState(() {
                  selectedResults[_currentPage] = item;
                });
              },
            );
          } else if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            return Container();
          }
        });
  }

  /// This widget is responsible creating the radio button group for ChipResult,
  /// loading initial data if it exists
  FutureBuilder<List<RadioItem?>> futureChipResultRadioBuilder() {
    return FutureBuilder<List<RadioItem?>>(
        initialData: List.filled(18, null),
        future: loadChipResults(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return RadioGroup(
              items: chipResultItems,
              defaultSelection: snapshot.data![_currentPage],
              onChanged: (item) {
                setState(() {
                  selectedChipResults[_currentPage] = item;
                });
              },
            );
          } else if (snapshot.hasError) {
            return RadioGroup(
              items: chipResultItems,
              onChanged: (item) {
                setState(() {
                  selectedChipResults[_currentPage] = item;
                });
              },
            );
          } else if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            return Container();
          }
        });
  }

  /// This widget is responsible creating the radio button group for SandResult,
  /// loading initial data if it exists
  FutureBuilder<List<RadioItem?>> futureSandResultRadioBuilder() {
    return FutureBuilder<List<RadioItem?>>(
        initialData: List.filled(18, null),
        future: loadSandResults(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return RadioGroup(
              items: sandResultItems,
              defaultSelection: snapshot.data![_currentPage],
              onChanged: (item) {
                setState(() {
                  selectedSandResults[_currentPage] = item;
                });
              },
            );
          } else if (snapshot.hasError) {
            return RadioGroup(
              items: sandResultItems,
              onChanged: (item) {
                setState(() {
                  selectedSandResults[_currentPage] = item;
                });
              },
            );
          } else if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            return Container();
          }
        });
  }

  /// This widget is responsible creating the putt counter button and creating additional fields,
  /// loading initial data if it exists
  FutureBuilder<int> futureNumPuttBuilder() {
    return FutureBuilder<int>(
        initialData: 0,
        future: loadPuttData(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return PuttCounterWidget(
              initialValue: snapshot.data,
              initialPutts: puttInputList[_currentPage],
              onNumberOfPuttsChanged: _updateNumberOfPutts,
              onPuttInputValuesChanged: _updatePuttInputValues,
            );
          } else if (snapshot.hasError) {
            return PuttCounterWidget(
              onNumberOfPuttsChanged: _updateNumberOfPutts,
              onPuttInputValuesChanged: _updatePuttInputValues,
            );
          } else if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            return Container();
          }
        });
  }

  /// This widget is responsible creating the score counter button ,
  /// loading initial data if it exists
  FutureBuilder<int> futureScoreBuilder() {
    return FutureBuilder<int>(
        initialData: 0,
        future: loadScore(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return ScoreWidget(
              labelText: "Score",
              initialValue: snapshot.data!,
              onChanged: (score) {
                scores[_currentPage] = score;
              },
              maxScoreCount: 20,
            );
          } else if (snapshot.hasError) {
            return ScoreWidget(
              labelText: "Score",
              initialValue: 0,
              onChanged: (score) {
                scores[_currentPage] = score;
              },
              maxScoreCount: 20,
            );
          } else if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            return Container();
          }
        });
  }

  /// This method is responsible for loading initial data if it exists upon
  /// first creation of the page, otherwise returns the current Fairway data
  Future<List<RadioItem?>> loadFairways() async {
    if (_fairwayDone) {
      return selectedFairways;
    }
    Round data = PersistentData.currentRoundEdit!;
    for (int i = 0; i < data.holeData!.length; i++) {
      if (data.holeData![i].fairway != null) {
        String dataLabel = data.holeData![i].fairway!;
        if (dataLabel == "Lost Ball") {
          dataLabel = "Lost";
        }
        try {
          selectedFairways[i] = fairwayItems
              .where(
                (element) => element.label == dataLabel,
              )
              .first;
        } on StateError catch (_) {
          selectedFairways[i] = null;
        }
      }
    }
    _fairwayDone = true;
    return selectedFairways;
  }

  /// This method is responsible for loading initial data if it exists upon
  /// first creation of the page, otherwise returns the current Lie data
  Future<List<RadioItem?>> loadLies() async {
    if (_liesDone) {
      return selectedLies;
    }

    Round data = PersistentData.currentRoundEdit!;
    for (int i = 0; i < data.holeData!.length; i++) {
      if (data.holeData![i].approachLie != null) {
        try {
          selectedLies[i] = lieItems
              .where(
                (element) => element.label == data.holeData![i].approachLie,
              )
              .first;
        } on StateError catch (_) {
          selectedLies[i] = null;
        }
      }
    }
    _liesDone = true;
    return selectedLies;
  }

  /// This method is responsible for loading initial data if it exists upon
  /// first creation of the page, otherwise returns the current ApproachResults data
  Future<List<RadioItem?>> loadResults() async {
    if (_resultsDone) {
      return selectedResults;
    }
    Round data = PersistentData.currentRoundEdit!;
    for (int i = 0; i < data.holeData!.length; i++) {
      if (data.holeData![i].approachResult != null &&
          data.holeData![i].approachResult != "No Shot") {
        try {
          selectedResults[i] = resultItems
              .where(
                (element) => element.label == data.holeData![i].approachResult,
              )
              .first;
        } on StateError catch (_) {
          selectedResults[i] = null;
        }
      }
    }
    _resultsDone = true;
    return selectedResults;
  }

  /// This method is responsible for loading initial data if it exists upon
  /// first creation of the page, otherwise returns the current SandResult data
  Future<List<RadioItem?>> loadSandResults() async {
    if (_sandDone) {
      return selectedSandResults;
    }
    Round data = PersistentData.currentRoundEdit!;
    for (int i = 0; i < data.holeData!.length; i++) {
      if (data.holeData![i].sandResult != null) {
        try {
          selectedSandResults[i] = sandResultItems
              .where(
                (element) => element.label == data.holeData![i].sandResult,
              )
              .first;
        } on StateError catch (_) {
          selectedSandResults[i] = null;
        }
      }
    }
    _sandDone = true;
    return selectedSandResults;
  }

  /// This method is responsible for loading initial data if it exists upon
  /// first creation of the page, otherwise returns the current ChipResult data
  Future<List<RadioItem?>> loadChipResults() async {
    if (_chipDone) {
      return selectedChipResults;
    }
    Round data = PersistentData.currentRoundEdit!;
    for (int i = 0; i < data.holeData!.length; i++) {
      if (data.holeData![i].chipResult != null) {
        try {
          selectedChipResults[i] = chipResultItems
              .where(
                (element) => element.label == data.holeData![i].chipResult,
              )
              .first;
        } on StateError catch (_) {
          selectedChipResults[i] = null;
        }
      }
    }
    _chipDone = true;
    return selectedChipResults;
  }

  /// This method is responsible for loading initial data if it exists upon
  /// first creation of the page, otherwise returns the current putt data
  Future<int> loadPuttData() async {
    if (_puttsDone) {
      return numOfPuttList[_currentPage] ?? 0;
    }
    if (numOfPuttList[_currentPage] == null &&
        PersistentData.currentRoundEdit != null) {
      Round data = PersistentData.currentRoundEdit!;
      for (int i = 0; i < data.holeData!.length; i++) {
        numOfPuttList[i] = data.holeData![i].numOfPutts;
        List<int?> initPuttList = [
          data.holeData![i].putt1,
          data.holeData![i].putt2,
          data.holeData![i].putt3
        ];
        puttInputList[i] = initPuttList;
      }
    }
    _puttsDone = true;
    return numOfPuttList[_currentPage] ?? 0;
  }

  /// This method is responsible for loading initial data if it exists upon
  /// first creation of the page, otherwise returns the current score data
  Future<int> loadScore() async {
    if (_scoresDone) {
      return (scores[_currentPage] ?? -1) == -1 ? 0 : scores[_currentPage]!;
    }
    if (scores[_currentPage] == null &&
        PersistentData.currentRoundEdit != null) {
      Round data = PersistentData.currentRoundEdit!;
      for (int i = 0; i < data.holeData!.length; i++) {
        scores[i] = data.holeData![i].score;
        if (scores[i] == -1) {
          scores[i] = 0;
        }
      }
    }
    _scoresDone = true;
    return (scores[_currentPage] ?? -1) == -1 ? 0 : scores[_currentPage]!;
  }

  /// This method is responsible for miscellaneous data;
  /// since this is a simple TextField, future object is not required.
  void loadDistanceData() {
    if (PersistentData.currentRoundEdit != null &&
        PersistentData.currentRoundEdit!.holeData != null) {
      Round data = PersistentData.currentRoundEdit!;
      for (int i = 0; i < data.holeData!.length; i++) {
        distances[i] = data.holeData![i].approachDistance;
      }
      _updateDistance();
      setState(() {});
    }
  }

  void saveAdvancedHole(int pageNumber) async {
    int currentHole = pageNumber;
    bool isChecked = isCheckedList[currentHole];
    int? par = 4;
    int? length = 400;
    if (PersistentData.chosenCourse != null) {
      par = PersistentData.getCurrentCourseHoleData()[currentHole].par;
      length = PersistentData.getCurrentCourseHoleData()[currentHole].length;
    }

    HoleData newHole = HoleData(
      holeNumber: pageNumber + 1,
      par: par,
      length: length,
      played: isChecked,
      fairway: selectedFairways[currentHole]?.label == 'Lost'
          ? 'Lost Ball'
          : selectedFairways[currentHole]?.label,
      approachDistance: distances[currentHole],
      approachLie: selectedLies[currentHole]?.label,
      approachResult: selectedResults[currentHole]?.label,
      chipResult: selectedChipResults[currentHole]?.label,
      sandResult: selectedSandResults[currentHole]?.label,
      numOfPutts: numOfPuttList[currentHole],
      putt1: puttInputList[currentHole].isNotEmpty
          ? puttInputList[currentHole][0]
          : null,
      putt2: puttInputList[currentHole].length >= 2
          ? puttInputList[currentHole][1]
          : null,
      putt3: puttInputList[currentHole].length >= 3
          ? puttInputList[currentHole][2]
          : null,
      score: scores[currentHole] == 0 ? null : scores[currentHole],
    );

    PersistentData.currentRoundEdit!.addHoleData(currentHole, newHole);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2C6E2E),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages,
              itemBuilder: (BuildContext context, int index) {
                bool isChecked = isCheckedList[index];
                CourseHoleData courseHoleData =
                    PersistentData.getCurrentCourseHoleData()[index];
                int? par = courseHoleData.par;
                int? length = courseHoleData.length;
                return Center(
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
                          child: ListView(
                            children: [
                              Center(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 90,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Hole ${index + 1}',
                                              style: const TextStyle(
                                                fontSize: 24,
                                                fontFamily: "Inter",
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xff155b94),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.edit,
                                                  size: 20,
                                                  color: Color(0xff155B94),
                                                ),
                                                Text(
                                                  "$length yds | par $par",
                                                  style: const TextStyle(
                                                    fontFamily: "Inter",
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15,
                                                    color: Color(0xff155b94),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 35,
                                        ),
                                        Column(
                                          children: [
                                            Checkbox(
                                              value: isChecked,
                                              activeColor:
                                                  const Color(0xff155B84),
                                              onChanged: (value) {
                                                setState(() {
                                                  isCheckedList[index] = value!;
                                                  if (value = true) {
                                                    _pageController.nextPage(
                                                      duration: const Duration(
                                                          milliseconds: 400),
                                                      curve: Curves.easeInOut,
                                                    );
                                                  }
                                                });
                                              },
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              visualDensity:
                                                  const VisualDensity(
                                                      vertical: -4.0),
                                            ),
                                            const Text(
                                              "Played",
                                              style: TextStyle(
                                                fontFamily: "Inter",
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15,
                                                color: Color(0xff155b94),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "Fairway",
                                                style: TextStyle(
                                                  fontFamily: "Inter",
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15,
                                                  color: Color(0xff155b94),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 5,
                                                ),
                                                child:
                                                    futureFairwayRadioBuilder(),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Divider(
                                            color: Colors.grey,
                                            height: 20,
                                            thickness: 1,
                                            indent: 2,
                                            endIndent: 2,
                                          ),
                                          const Text(
                                            "Approach",
                                            style: TextStyle(
                                              fontFamily: "Inter",
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
                                              color: Color(0xff155b94),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "Distance:",
                                                style: TextStyle(
                                                  fontFamily: "Inter",
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15,
                                                  color: Color(0xff155b94),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 130,
                                                height: 30,
                                                child: TextFormField(
                                                  controller:
                                                      _distanceTextController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    counterText: "",
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10), // Set border radius
                                                      borderSide:
                                                          const BorderSide(
                                                        color: Color(
                                                            0xfff1f1f1), // Customize border color
                                                      ),
                                                    ),
                                                  ),
                                                  maxLines: 1,
                                                  maxLength: 5,
                                                  onChanged: (value) {
                                                    distances[_currentPage] =
                                                        int.tryParse(value);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "Lie:",
                                                style: TextStyle(
                                                  fontFamily: "Inter",
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15,
                                                  color: Color(0xff155b94),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 5,
                                                ),
                                                child: futureLieRadioBuilder(),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "Result:",
                                                style: TextStyle(
                                                  fontFamily: "Inter",
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15,
                                                  color: Color(0xff155b94),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 5,
                                                ),
                                                child:
                                                    futureResultRadioBuilder(),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Divider(
                                            color: Colors.grey,
                                            height: 20,
                                            thickness: 1,
                                            indent: 2,
                                            endIndent: 2,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "Chip Result:",
                                                style: TextStyle(
                                                  fontFamily: "Inter",
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15,
                                                  color: Color(0xff155b94),
                                                ),
                                              ),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 5,
                                                  ),
                                                  child:
                                                      futureChipResultRadioBuilder()),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "Sand Result:",
                                                style: TextStyle(
                                                  fontFamily: "Inter",
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 15,
                                                  color: Color(0xff155b94),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  top: 5,
                                                ),
                                                child:
                                                    futureSandResultRadioBuilder(),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Divider(
                                            color: Colors.grey,
                                            height: 20,
                                            thickness: 1,
                                            indent: 2,
                                            endIndent: 2,
                                          ),
                                          futureNumPuttBuilder(),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          futureScoreBuilder(),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (_currentPage == 0)
                                  Column(
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xff87CA80),
                                        ),
                                        child: IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const AddRound(),
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.arrow_back_ios,
                                            color: Color(0xff155b94),
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        'Info',
                                        style: TextStyle(
                                          fontFamily: "Inter",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                if (_currentPage != 0)
                                  Column(
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xff87CA80),
                                        ),
                                        child: IconButton(
                                          onPressed: () {
                                            _pageController.previousPage(
                                              duration: const Duration(
                                                  milliseconds: 400),
                                              curve: Curves.easeInOut,
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.arrow_back_ios,
                                            color: Color(0xff155b94),
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Hole $index',
                                        style: const TextStyle(
                                          fontFamily: "Inter",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                if (_currentPage == 17)
                                  const SizedBox(
                                    width: 15,
                                  ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 150,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color(0xff87CA80),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: jumpToButton(),
                                  ),
                                ),
                                if (_currentPage != 17)
                                  Column(
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xff87CA80),
                                        ),
                                        child: IconButton(
                                          onPressed: () {
                                            _pageController.nextPage(
                                              duration: const Duration(
                                                  milliseconds: 400),
                                              curve: Curves.easeInOut,
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.arrow_forward_ios,
                                            color: Color(0xff155b94),
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Hole ${index + 2}',
                                        style: const TextStyle(
                                          fontFamily: "Inter",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                if (_currentPage == 17)
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: FractionalTranslation(
                                      translation: const Offset(0.15, 0.0),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 32,
                                            height: 32,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xff87CA80),
                                            ),
                                            child: IconButton(
                                              onPressed: () {
                                                saveAdvancedHole(_currentPage);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const SummaryPage(
                                                      isBasicRound: false,
                                                    ),
                                                  ),
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.arrow_forward_ios,
                                                color: Color(0xff155b94),
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                          const Text(
                                            'Summary',
                                            style: TextStyle(
                                              fontFamily: "Inter",
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              onPageChanged: (int index) {
                saveAdvancedHole(_currentPage);
                setState(() {
                  _currentPage = index;
                  _updateDistance();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  DropdownButton<int> jumpToButton() {
    return DropdownButton(
      value: pageNumbers[_currentPage],
      items: [
        DropdownMenuItem<int>(
          value: -1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Information',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Color(0xff155B94),
                ),
              ),
            ],
          ),
        ),
        ...pageNumbers.map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Hole $value',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Color(0xff155B94),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        DropdownMenuItem<int>(
          value: pageNumbers.length + 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Summary',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Color(0xff155B94),
                ),
              ),
            ],
          ),
        ),
      ],
      onChanged: (int? newValue) {
        saveAdvancedHole(_currentPage);
        setState(() {
          if (newValue == -1) {
            // Navigate to the information page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddRound()),
            );
          } else if (newValue == pageNumbers.length + 1) {
            // Navigate to the summary page
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SummaryPage(isBasicRound: false)),
            );
          } else {
            // Navigate to the corresponding hole entry page
            _currentPage = newValue! - 1;
            _pageController.animateToPage(
              _currentPage,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          }
        });
      },
      icon: const Icon(Icons.arrow_drop_down),
      iconEnabledColor: const Color(0xff155B94),
      underline: Container(),
      elevation: 0,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w700,
        fontSize: 18,
        color: Color(0xff155B94),
      ),
      selectedItemBuilder: (BuildContext context) {
        // this part creates one more "Jump to" button for hole 18
        List<int> mapping = [];
        mapping.addAll(pageNumbers);
        mapping.add(19);

        return mapping.map((int value) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Jump to',
                style: TextStyle(
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Color(0xff155B94),
                ),
              ),
            ],
          );
        }).toList();
      },
    );
  }
}
