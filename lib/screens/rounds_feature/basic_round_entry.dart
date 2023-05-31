import 'package:one_iota_mobile_app/screens/rounds_feature/add_round_page.dart';
import 'package:one_iota_mobile_app/screens/rounds_feature/summary_page.dart';
import 'package:flutter/material.dart';

import '../../models/courses_model.dart';
import '../../models/hole_data_model.dart';
import '../../models/round_model.dart';
import '../../api/persistent_data.dart';
import '../../widgets/rounds_widgets/radio_buttons.dart';
import '../../widgets/rounds_widgets/score_widget.dart';

class BasicRoundEntry extends StatefulWidget {
  final int? startingHole;
  const BasicRoundEntry({super.key, required this.startingHole});

  @override
  State<BasicRoundEntry> createState() => BasicRoundEntryState();
}

class BasicRoundEntryState extends State<BasicRoundEntry> {
  late final PageController _pageController;
  // Used to generate numbers dynamically for PageView.builder
  List<int> pageNumbers = List.generate(18, (index) => index + 1);
  late int _pages;
  int _currentPage = 0;
  List<bool> isCheckedList = [];

  /// For Basic Round Entry
  List<RadioItem?> selectedFairways = List.filled(18, null);
  List<RadioItem?> selectedGreens = List.filled(18, null);
  List<RadioItem?> selectedChipSandShots = List.filled(18, null);

  final fairwayItems = [
    RadioItem(icon: Icons.arrow_upward, label: 'Hit'),
    RadioItem(icon: Icons.close, label: 'Miss'),
    RadioItem(icon: Icons.remove, label: 'Penalty'),
  ];

  final yesNoItems = [
    RadioItem(icon: Icons.check, label: 'Yes'),
    RadioItem(icon: Icons.close, label: 'No'),
  ];

  final List<int?> _putts = List.filled(18, null);
  final List<int?> _scores = List.filled(18, null);
  bool _fairwayDone = false;
  bool _girDone = false;
  bool _chipSandDone = false;
  bool _puttsDone = false;
  bool _scoresDone = false;

  @override
  void initState() {
    super.initState();
    _pages = pageNumbers.length;
    isCheckedList = List.filled(_pages, true);
    _pageController = PageController(initialPage: widget.startingHole! - 1);
    if (widget.startingHole != null && widget.startingHole! >= 2) {
      for (int i = 0; i < widget.startingHole! - 1; i++) {
        isCheckedList[i] = false;
      }
    }
  }

  // This method is responsible for saving holeData to the currently-editted round
  // on pageChange.
  void saveBasicHole(int pageNumber) async {
    bool isChecked = isCheckedList[pageNumber];
    int? par = 4;
    int? length = 400;
    if (PersistentData.chosenCourse != null) {
      par = PersistentData.getCurrentCourseHoleData()[pageNumber].par;
      length = PersistentData.getCurrentCourseHoleData()[pageNumber].length;
    }

    HoleData newHole = HoleData(
      holeNumber: pageNumber + 1,
      par: par,
      length: length,
      played: isChecked,
      fairway: selectedFairways[pageNumber]?.label,
      gir: selectedGreens[pageNumber]?.label == "Yes" ? true : false,
      chipSand:
          selectedChipSandShots[pageNumber]?.label == "Yes" ? true : false,
      numOfPutts: _putts[pageNumber] ?? 0,
      score: _scores[pageNumber] == 0 ? null : _scores[pageNumber],
    );

    PersistentData.currentRoundEdit!.addHoleData(_currentPage, newHole);
  }

  /// This widget is responsible creating the radio button group for Fairway,
  /// loading initial data if it exists
  FutureBuilder<RadioItem?> futureFairwayRadioBuilder() {
    return FutureBuilder<RadioItem?>(
        future: loadFairways(_currentPage),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return RadioGroup(
              items: fairwayItems,
              defaultSelection: snapshot.data,
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

  /// This widget is responsible creating the radio button group for Greens,
  /// loading initial data if it exists
  FutureBuilder<RadioItem?> futureGreensRadioBuilder() {
    return FutureBuilder<RadioItem?>(
        future: loadGIR(_currentPage),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return RadioGroup(
              items: yesNoItems,
              defaultSelection: snapshot.data,
              onChanged: (item) {
                setState(() {
                  selectedGreens[_currentPage] = item;
                });
              },
            );
          } else if (snapshot.hasError) {
            return RadioGroup(
              items: yesNoItems,
              onChanged: (item) {
                setState(() {
                  selectedGreens[_currentPage] = item;
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

  /// This widget is responsible creating the radio button group for ChipSandResult,
  /// loading initial data if it exists
  FutureBuilder<RadioItem?> futureChipSandRadioBuilder() {
    return FutureBuilder<RadioItem?>(
        future: loadChipSandShot(_currentPage),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return RadioGroup(
              items: yesNoItems,
              defaultSelection: snapshot.data,
              onChanged: (item) {
                setState(() {
                  selectedChipSandShots[_currentPage] = item;
                });
              },
            );
          } else if (snapshot.hasError) {
            return RadioGroup(
              items: yesNoItems,
              onChanged: (item) {
                setState(() {
                  selectedChipSandShots[_currentPage] = item;
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

  /// This widget is responsible creating the Putts counter,
  /// loading initial data if it exists
  FutureBuilder<int> futurePuttsBuilder() {
    return FutureBuilder<int>(
        initialData: 0,
        future: loadPuttData(_currentPage),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return ScoreWidget(
              labelText: 'Putts',
              initialValue: snapshot.data!,
              onChanged: (putts) {
                _putts[_currentPage] = putts;
              },
              maxScoreCount: 6,
            );
          } else if (snapshot.hasError) {
            return ScoreWidget(
              labelText: 'Putts',
              initialValue: 0,
              onChanged: (putts) {
                _putts[_currentPage] = putts;
              },
              maxScoreCount: 6,
            );
          } else if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            return Container();
          }
        });
  }

  /// This widget is responsible creating the Score counter,
  /// loading initial data if it exists
  FutureBuilder<int> futureScoreBuilder() {
    return FutureBuilder<int>(
        initialData: 0,
        future: loadScore(_currentPage),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return ScoreWidget(
              labelText: 'Score',
              initialValue: snapshot.data!,
              onChanged: (score) {
                _scores[_currentPage] = score;
              },
              maxScoreCount: 20,
            );
          } else if (snapshot.hasError) {
            return ScoreWidget(
              labelText: 'Score',
              initialValue: 0,
              onChanged: (score) {
                _scores[_currentPage] = score;
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
  Future<RadioItem?> loadFairways(int index) async {
    if (_fairwayDone) {
      return selectedFairways[index];
    }
    Round data = PersistentData.currentRoundEdit!;
    for (int i = 0; i < data.holeData!.length; i++) {
      if (data.holeData![i].fairway != null) {
        String dataLabel = data.holeData![i].fairway!;
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
    return selectedFairways[index];
  }

  /// This method is responsible for loading initial data if it exists upon
  /// first creation of the page, otherwise returns the current GIR data
  Future<RadioItem?> loadGIR(int index) async {
    if (_girDone) {
      return selectedGreens[index];
    }
    Round data = PersistentData.currentRoundEdit!;
    for (int i = 0; i < data.holeData!.length; i++) {
      if (data.holeData![i].gir != null) {
        String dataLabel = data.holeData![i].gir! ? 'Yes' : 'No';
        try {
          selectedGreens[i] = yesNoItems
              .where(
                (element) => element.label == dataLabel,
              )
              .first;
        } on StateError catch (_) {
          selectedGreens[i] = null;
        }
      }
    }
    _girDone = true;
    return selectedGreens[index];
  }

  /// This method is responsible for loading initial data if it exists upon
  /// first creation of the page, otherwise returns the current ChipSand data
  Future<RadioItem?> loadChipSandShot(int index) async {
    if (_chipSandDone) {
      return selectedChipSandShots[index];
    }
    Round data = PersistentData.currentRoundEdit!;
    for (int i = 0; i < data.holeData!.length; i++) {
      if (data.holeData![i].chipSand != null) {
        String dataLabel = data.holeData![i].chipSand! ? 'Yes' : 'No';
        try {
          selectedChipSandShots[i] = yesNoItems
              .where(
                (element) => element.label == dataLabel,
              )
              .first;
        } on StateError catch (_) {
          selectedChipSandShots[i] = null;
        }
      }
    }
    _chipSandDone = true;
    return selectedChipSandShots[index];
  }

  /// This method is responsible for loading initial data if it exists upon
  /// first creation of the page, otherwise returns the current putt data
  Future<int> loadPuttData(int index) async {
    if (_puttsDone) {
      return _putts[index] ?? 0;
    }
    if (_putts[index] == null && PersistentData.currentRoundEdit != null) {
      Round data = PersistentData.currentRoundEdit!;
      for (int i = 0; i < data.holeData!.length; i++) {
        _putts[i] = data.holeData![i].numOfPutts;
      }
    }
    _puttsDone = true;
    return _putts[index] ?? 0;
  }

  /// This method is responsible for loading initial data if it exists upon
  /// first creation of the page, otherwise returns the current score data
  Future<int> loadScore(int index) async {
    // this part ensures data is not null or -1
    if (_scoresDone) {
      return (_scores[index] ?? -1) == -1 ? 0 : _scores[index]!;
    }
    if (_scores[index] == null && PersistentData.currentRoundEdit != null) {
      Round data = PersistentData.currentRoundEdit!;
      for (int i = 0; i < data.holeData!.length; i++) {
        _scores[i] = data.holeData![i].score;
        if (_scores[i] == -1) {
          _scores[i] = 0;
        }
      }
    }
    _scoresDone = true;
    return (_scores[index] ?? -1) == -1 ? 0 : _scores[index]!;
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
                                    const SizedBox(
                                      height: 20,
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
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "Green in Regulation:",
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
                                                    futureGreensRadioBuilder(),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                "Chip / Sand Shot",
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
                                                    futureChipSandRadioBuilder(),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 30,
                                          ),
                                          futurePuttsBuilder(),
                                          const SizedBox(
                                            height: 30,
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
                                if (index == 0)
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
                                if (index != 0)
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
                                            saveBasicHole(_currentPage);
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
                                if (index == 17)
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
                                      child: jumpToButton()),
                                ),
                                if (index != 17)
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
                                if (index == 17)
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
                                                saveBasicHole(_currentPage);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const SummaryPage(
                                                      isBasicRound: true,
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
                saveBasicHole(_currentPage);
                setState(() {
                  _currentPage = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  ///This widget can be used to jump to different pages on the screen
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
        saveBasicHole(_currentPage);
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
