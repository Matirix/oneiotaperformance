import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:one_iota_mobile_app/api/auth.dart';
import 'package:one_iota_mobile_app/screens/rounds_feature/advanced_round_entry.dart';
import 'package:one_iota_mobile_app/screens/rounds_feature/basic_round_entry.dart';

import '../../models/courses_model.dart';
import '../../models/event_models.dart';
import '../../models/hole_data_model.dart';
import '../../models/round_model.dart';
import '../../api/one_iota_api.dart';
import '../../api/persistent_data.dart';

class AddRound extends StatefulWidget {
  const AddRound({super.key});

  @override
  State<AddRound> createState() => AddRoundState();
}

class AddRoundState extends State<AddRound> {
  TextEditingController _commentTextController =
      TextEditingController(text: '');
  TextEditingController _temperatureTextController =
      TextEditingController(text: '');
  int? roundId;
  List<HoleData>? holeData;
  bool advancedMode = false;
  DateTime? _selectedDate = DateTime.now();
  DateTime _selectedTime = DateTime.now();
  Course? _selectedCourse;
  int _startingHole = 1;
  String _roundType = "Practice";
  String _wind = "Not Set";
  String _weather = "Not Set";
  int? _temperature;
  Event? _event;
  int _roundMaxNumber = 0;
  int? _roundNumber;
  String? _comment;
  Future<List<Course>>? _futureCourses;
  Future<List<Event>>? _futureEvents;
  Color reqTextColour = const Color(0xff155B94);
  final Set<Course> _courseOptions = {};
  final Set<Event> _eventOptions = {Event(name: "Not Set")};

  final List<int> _startingHoleOptions = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
  ];
  final List<String> _roundTypeOptions = [
    "Practice",
    "Qualifying",
    "Competition",
    "Tournament",
  ];
  final List<String> _windOptions = [
    "Not Set",
    "50+ km/h",
    "40 km/h",
    "30 km/h",
    "20 km/h",
    "10 km/h",
    "No Wind",
  ];
  final List<String> _weatherOptions = [
    "Not Set",
    "Sunny",
    "Light Rain",
    "Heavy Rain",
    "Overcast",
  ];

  final List<String> _roundNumberOptions = [
    "Round 1",
    "Round 2",
    "Round 3",
    "Round 4",
    "Round 5",
    "Round 6",
  ];

  @override
  void initState() {
    loadCourseNames();
    loadEventNames();
    loadCurrentEditRound();
    super.initState();
  }

  Future<void> _errorDialog(String msg) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding: const EdgeInsets.all(30.0),
          backgroundColor: Colors.white,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  msg,
                  style: const TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _deleteDialog(BuildContext outerContext) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding: const EdgeInsets.all(20.0),
          backgroundColor: Colors.white,
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure you want to delete this round?',
                    style: TextStyle(
                      color: Colors.red,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    )),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Delete  ',
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: Colors.black,
                  )),
              onPressed: () {
                OneIotaAuth().deleteRound(
                    token: Auth.idToken!,
                    roundId: PersistentData.currentRoundEdit!.roundId!);
                Navigator.of(context).pop();
                Navigator.pop(outerContext, '/rounds_main');
              },
            ),
          ],
        );
      },
    );
  }

  void loadCurrentEditRound() async {
    if (PersistentData.currentRoundEdit != null) {
      // get all hole data for this round
      if (PersistentData.currentRoundEdit!.roundId != null) {
        roundId = PersistentData.currentRoundEdit!.roundId;
        PersistentData.currentRoundEdit = await OneIotaAuth().getRound(
            roundId: PersistentData.currentRoundEdit!.roundId!,
            token: Auth.idToken!);
      }

      Round currentRound = PersistentData.currentRoundEdit!;
      if (currentRound.courseId != null && currentRound.courseId != -1) {
        _selectedCourse = await PersistentData.getCourseData();
      }
      if (currentRound.holeData != null && currentRound.holeData!.isNotEmpty) {
        holeData = currentRound.holeData;

        // this will ensure there is valid par data for each hole, even if unplayed
        if (_selectedCourse != null) {
          for (int i = 0; i < holeData!.length; i++) {
            holeData![i].par = _selectedCourse!.holes?[i].par;
            holeData![i].length = _selectedCourse!.holes?[i].length;
          }
        } else {
          for (int i = 0; i < holeData!.length; i++) {
            holeData![i].par = 4;
            holeData![i].length = 400;
          }
        }
        // holeNumber isn't part of the database response, so we will create it here
        // To be used in Summary page.
        int holeNumber = 1;
        for (var element in holeData!) {
          element.holeNumber = holeNumber++;
        }
      }

      advancedMode = (currentRound.detailLevel == "Advanced") ? true : false;
      late String formattedDate;
      try {
        formattedDate = currentRound.date!.split('T').first;
      } on StateError catch (_) {
        formattedDate = currentRound.date!;
      }

      String formattedTime = "00:00:00";
      if (currentRound.time != null) {
        DateFormat formatter = DateFormat('HH:mm:ss');
        formattedTime = formatter.format(
            DateFormat('h:mma').parse(currentRound.time!.toUpperCase()));
      }
      formattedDate = "${formattedDate}T$formattedTime";
      _selectedTime = DateTime.parse(formattedDate);
      _selectedDate = DateTime.parse(currentRound.date!);
      if (currentRound.eventId != null) {
        _event = _eventOptions
            .where((event) => event.eventId == currentRound.eventId)
            .first;
      }
      _startingHole = currentRound.startingHole;
      _roundType = currentRound.roundType;

      String formattedWind = currentRound.wind;
      if (currentRound.wind.length <= 3) {
        formattedWind = "$formattedWind km/h";
      }
      _wind = formattedWind;
      _weather = currentRound.weather;

      if (currentRound.temperature != null) {
        _temperature = currentRound.temperature;
        _temperatureTextController =
            TextEditingController(text: currentRound.temperature.toString());
      }
      // _roundNumber = currentRound.eventRound;
      _comment = currentRound.comment;
      _commentTextController =
          TextEditingController(text: currentRound.comment);
    } else {
      // ensures that chosenCourse data doesn't get leaked to an empty course
      PersistentData.chosenCourse = null;
    }
    // refresh page when done
    setState(() {});
  }

  Future<void> loadCourseNames() async {
    _futureCourses = OneIotaAuth().getCourses(token: Auth.idToken!);
  }

  Future<void> loadEventNames() async {
    _futureEvents = OneIotaAuth().getEvents(token: Auth.idToken!);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xff2C6E2E),
            dialogBackgroundColor: Colors.white,
            colorScheme: const ColorScheme.light(
              primary: Color(0xff2C6E2E),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ).copyWith(secondary: const Color(0xff2C6E2E)),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedTime),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xff2C6E2E),
            dialogBackgroundColor: Colors.white,
            colorScheme: const ColorScheme.light(
              primary: Color(0xff2C6E2E),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ).copyWith(secondary: const Color(0xff2C6E2E)),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = DateTime(
          _selectedTime.year,
          _selectedTime.month,
          _selectedTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    }
  }

  FutureBuilder<List<Course>> futureCourseDropdownMenu() {
    return FutureBuilder<List<Course>>(
        future: _futureCourses,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            snapshot.data?.forEach((element) {
              _courseOptions.add(element);
            });
            return DropdownButtonFormField<Course>(
              isExpanded: true,
              decoration: InputDecoration(
                labelText: "Select course name",
                labelStyle: const TextStyle(
                  color: Colors.grey,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                border: InputBorder.none,
                fillColor: Colors.white,
                filled: true,
                contentPadding: const EdgeInsets.only(
                  top: -15,
                  left: 10,
                  right: 10,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10), // Set border radius
                  borderSide: const BorderSide(
                    color: Color(0xfff1f1f1), // Customize border color
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10), // Set border radius
                  borderSide: const BorderSide(
                    color: Color(0xfff1f1f1), // Customize focused border color
                  ),
                ),
              ),
              value: _selectedCourse,
              onChanged: (newValue) {
                setState(() {
                  _selectedCourse = newValue!;
                });
              },
              items: _courseOptions.map((option) {
                return DropdownMenuItem<Course>(
                  value: option,
                  child: Text('${option.name!} - ${option.tee}',
                      style: const TextStyle(
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      )),
                );
              }).toList(),
            );
          } else if (snapshot.hasError) {
            return const Text(
                'Could not connect to the API, please try again later');
          }
          return const Text('Loading course names..',
              style: TextStyle(
                color: Colors.grey,
                fontFamily: "Inter",
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ));
        });
  }

  FutureBuilder<List<Event>> futureEventDropdownMenu() {
    return FutureBuilder<List<Event>>(
        future: _futureEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            snapshot.data?.forEach((element) {
              _eventOptions.add(element);
            });
            return SizedBox(
              width: 193,
              child: DropdownButtonFormField<Event>(
                decoration: InputDecoration(
                  labelText: "None",
                  labelStyle: const TextStyle(
                    color: Colors.grey,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: InputBorder.none,
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.only(
                    top: -15,
                    left: 10,
                    right: 10,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(10), // Set border radius
                    borderSide: const BorderSide(
                      color: Color(0xfff1f1f1), // Customize border color
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(10), // Set border radius
                    borderSide: const BorderSide(
                      color:
                          Color(0xfff1f1f1), // Customize focused border color
                    ),
                  ),
                ),
                value: _event,
                onChanged: (newValue) {
                  setState(() {
                    if (newValue!.name != "Not Set") {
                      _event = newValue;
                      _roundMaxNumber = newValue.numRounds!;
                    } else {
                      _roundMaxNumber = 0;
                      _event = null;
                      _roundNumber = null;
                    }
                  });
                },
                items: _eventOptions.map((option) {
                  return DropdownMenuItem<Event>(
                    value: option,
                    child: Text(option.name!,
                        style: const TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        )),
                  );
                }).toList(),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 160),
                    child: const Text(
                      'Could not connect to the API, please try again later.',
                      textAlign: TextAlign.center,
                      softWrap: true,
                      style: TextStyle(fontSize: 9),
                    ),
                  ),
                ),
              ),
            );
          }
          return const Text('Loading event names..',
              style: TextStyle(
                color: Colors.grey,
                fontFamily: "Inter",
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ));
        });
  }

  void saveRound() async {
    DateFormat formatter = DateFormat("yyyy-MM-dd");
    DateFormat timeFormatter = DateFormat("HH:mm:ss");
    String? formattedDate = formatter.format(_selectedDate!);
    String formattedTime = timeFormatter.format(_selectedTime);

    advancedMode
        ? formattedDate = '${formattedDate}T$formattedTime'
        : formattedDate = '${formattedDate}T00:00:00';

    // if wind is set to a number, then extract the number that appears first
    String formattedWind = _wind;
    if (!(formattedWind == "Not Set" || formattedWind == "No Wind")) {
      formattedWind = formattedWind.split(' ')[0];
    }

    // check if holeData already exists in PersistentData, if so, load it.
    // this case is more likely if you enter press back button.
    if (PersistentData.currentRoundEdit?.holeData != null &&
        PersistentData.currentRoundEdit!.holeData!.isNotEmpty) {
      holeData = PersistentData.currentRoundEdit?.holeData;
    }

    Round newRound = Round(
      holeData: holeData ??
          List.generate(18, (int index) => HoleData(holeNumber: index + 1)),
      roundId: roundId,
      detailLevel: advancedMode ? 'Advanced' : 'Basic',
      date: formattedDate,
      courseId: _selectedCourse?.id,
      startingHole: _startingHole,
      roundType: _roundType,
      wind: formattedWind,
      weather: _weather,
      temperature: _temperature,
      eventName: _event?.name == "Not Set" ? null : _event?.name,
      eventId: _event?.name == "Not Set" ? null : _event?.eventId,
      eventRound: _roundNumber,
      comment: _comment,
    );
    PersistentData.currentRoundEdit = newRound;
    if (_selectedCourse != null) {
      PersistentData.chosenCourse = await OneIotaAuth()
          .getCourse(token: Auth.idToken!, courseId: _selectedCourse!.id!);
      // print('courseId: ${_selectedCourse!.id}');
    }

    if (newRound.roundId == null) {
      // int newId = await OneIotaAuth()
      //     .addRound(token: Auth.idToken!, newRound: newRound);
      // PersistentData.currentRoundEdit?.roundId = newId;
    } else {
      // await OneIotaAuth()
      //     .updateRound(token: Auth.idToken!, updateRound: newRound);
    }
  }

  void _changeReqTextColour(Color newColour) {
    reqTextColour = newColour;
    setState(() {});
  }

// Widget to create the delete button if a user enters this screen
// with a pre-existing round.
  Widget deleteButtonWidget(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: const Size(200, 35),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: const Color(0xFFC14E4E)),
        onPressed: () {
          _deleteDialog(context);
        },
        child: const Text(
          "Delete Round",
          style: TextStyle(
            fontFamily: "Inter",
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2C6E2E),
      // appBar: CustomAppBar(title: "Feature 2"),
      body: Center(
        child: Container(
          width: 350,
          height: 620,
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (PersistentData.currentRoundEdit == null)
                                ? "Add New Round"
                                : "Round Information",
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Advanced Mode:",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff155B94),
                                ),
                              ),
                              Transform.scale(
                                scale: 1.5,
                                child: Switch(
                                  value: advancedMode,
                                  onChanged: (value) {
                                    setState(() {
                                      advancedMode = value;
                                    });
                                  },
                                  activeColor: const Color(0xff87CA80),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "*Date:",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w700,
                                  color: reqTextColour,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              GestureDetector(
                                onTap: () {
                                  _selectDate(context);
                                },
                                child: AbsorbPointer(
                                  child: TextFormField(
                                      decoration: InputDecoration(
                                        labelText: 'Select Date',
                                        labelStyle: const TextStyle(
                                          color: Colors.grey,
                                          fontFamily: "Inter",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15,
                                        ),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never,
                                        border: InputBorder.none,
                                        fillColor: Colors.white,
                                        filled: true,
                                        contentPadding: const EdgeInsets.only(
                                          top: -15,
                                          left: 10,
                                          right: 10,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              10), // Set border radius
                                          borderSide: const BorderSide(
                                            color: Color(
                                                0xfff1f1f1), // Customize border color
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              10), // Set border radius
                                          borderSide: const BorderSide(
                                            color: Color(
                                                0xfff1f1f1), // Customize focused border color
                                          ),
                                        ),
                                      ),
                                      controller: TextEditingController(
                                        text: _selectedDate != null
                                            ? DateFormat('yyyy-MM-dd')
                                                .format(_selectedDate!)
                                            : '',
                                      ),
                                      style: const TextStyle(
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                      )),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              if (advancedMode)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Tee Time:",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xff155B94),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _selectTime(context);
                                      },
                                      child: AbsorbPointer(
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            labelText: "Select Time",
                                            labelStyle: const TextStyle(
                                              color: Colors.grey,
                                              fontFamily: "Inter",
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                            ),
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.never,
                                            border: InputBorder.none,
                                            fillColor: Colors.white,
                                            filled: true,
                                            contentPadding:
                                                const EdgeInsets.only(
                                              top: -15,
                                              left: 10,
                                              right: 10,
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10), // Set border radius
                                              borderSide: const BorderSide(
                                                color: Color(
                                                    0xfff1f1f1), // Customize border color
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      10), // Set border radius
                                              borderSide: const BorderSide(
                                                color: Color(
                                                    0xfff1f1f1), // Customize focused border color
                                              ),
                                            ),
                                          ),
                                          controller: TextEditingController(
                                            text: DateFormat.jm()
                                                .format(_selectedTime),
                                          ),
                                          style: const TextStyle(
                                            fontFamily: "Inter",
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              Text(
                                "*Course: ",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w700,
                                  color: reqTextColour,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              (_futureCourses == null)
                                  ? const Text("Loading courses.",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                      ))
                                  : futureCourseDropdownMenu(),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text(
                                "Starting Hole:",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff155B94),
                                ),
                              ),
                              SizedBox(
                                width: 60,
                              ),
                              Text(
                                "Round Type:",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff155B94),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 140,
                                child: DropdownButtonFormField<int>(
                                  decoration: InputDecoration(
                                    labelText: "None",
                                    labelStyle: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                    border: InputBorder.none,
                                    fillColor: Colors.white,
                                    filled: true,
                                    contentPadding: const EdgeInsets.only(
                                      top: -15,
                                      left: 10,
                                      right: 10,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          10), // Set border radius
                                      borderSide: const BorderSide(
                                        color: Color(
                                            0xfff1f1f1), // Customize border color
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          10), // Set border radius
                                      borderSide: const BorderSide(
                                        color: Color(
                                            0xfff1f1f1), // Customize focused border color
                                      ),
                                    ),
                                  ),
                                  value: _startingHole,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _startingHole = newValue!;
                                    });
                                  },
                                  items: _startingHoleOptions.map((option) {
                                    return DropdownMenuItem<int>(
                                      value: option,
                                      child: Text(option.toString()),
                                    );
                                  }).toList(),
                                ),
                              ),
                              const SizedBox(
                                width: 40,
                              ),
                              SizedBox(
                                width: 140,
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    labelText: "None",
                                    labelStyle: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                    border: InputBorder.none,
                                    fillColor: Colors.white,
                                    filled: true,
                                    contentPadding: const EdgeInsets.only(
                                      top: -15,
                                      left: 10,
                                      right: 10,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          10), // Set border radius
                                      borderSide: const BorderSide(
                                        color: Color(
                                            0xfff1f1f1), // Customize border color
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                          10), // Set border radius
                                      borderSide: const BorderSide(
                                        color: Color(
                                            0xfff1f1f1), // Customize focused border color
                                      ),
                                    ),
                                  ),
                                  value: _roundType,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _roundType = newValue!;
                                    });
                                  },
                                  items: _roundTypeOptions.map((option) {
                                    return DropdownMenuItem<String>(
                                      value: option,
                                      child: Text(option),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          if (advancedMode)
                            Column(
                              children: [
                                Container(
                                  width: 350,
                                  height: 205,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xff87CA80),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Conditions",
                                        style: TextStyle(
                                          fontFamily: "Inter",
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            "Wind:",
                                            style: TextStyle(
                                              fontFamily: "Inter",
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 85,
                                          ),
                                          SizedBox(
                                            width: 153,
                                            child:
                                                DropdownButtonFormField<String>(
                                              decoration: InputDecoration(
                                                labelText: "Current Wind speed",
                                                labelStyle: const TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: "Inter",
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                ),
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior.never,
                                                border: InputBorder.none,
                                                fillColor: Colors.white,
                                                filled: true,
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                  top: -15,
                                                  left: 10,
                                                  right: 10,
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10), // Set border radius
                                                  borderSide: const BorderSide(
                                                    color: Color(
                                                        0xfff1f1f1), // Customize border color
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10), // Set border radius
                                                  borderSide: const BorderSide(
                                                    color: Color(
                                                        0xfff1f1f1), // Customize focused border color
                                                  ),
                                                ),
                                              ),
                                              value: _wind,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  _wind = newValue!;
                                                });
                                              },
                                              items: _windOptions.map((option) {
                                                return DropdownMenuItem<String>(
                                                  value: option,
                                                  child: Text(
                                                    option,
                                                    style: const TextStyle(
                                                      fontFamily: "Inter",
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            "Weather:",
                                            style: TextStyle(
                                              fontFamily: "Inter",
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 55,
                                          ),
                                          SizedBox(
                                            width: 154,
                                            child:
                                                DropdownButtonFormField<String>(
                                              decoration: InputDecoration(
                                                labelText: "Current Weather",
                                                labelStyle: const TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: "Inter",
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                ),
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior.never,
                                                border: InputBorder.none,
                                                fillColor: Colors.white,
                                                filled: true,
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                  top: -15,
                                                  left: 10,
                                                  right: 10,
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10), // Set border radius
                                                  borderSide: const BorderSide(
                                                    color: Color(
                                                        0xfff1f1f1), // Customize border color
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10), // Set border radius
                                                  borderSide: const BorderSide(
                                                    color: Color(
                                                        0xfff1f1f1), // Customize focused border color
                                                  ),
                                                ),
                                              ),
                                              value: _weather,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  _weather = newValue!;
                                                });
                                              },
                                              items:
                                                  _weatherOptions.map((option) {
                                                return DropdownMenuItem<String>(
                                                  value: option,
                                                  child: Text(option,
                                                      style: const TextStyle(
                                                        fontFamily: "Inter",
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 15,
                                                      )),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            "Temperature:",
                                            style: TextStyle(
                                              fontFamily: "Inter",
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 17,
                                          ),
                                          SizedBox(
                                            width: 154,
                                            child: TextField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller:
                                                  _temperatureTextController,
                                              decoration: InputDecoration(
                                                labelText: 'Optional',
                                                labelStyle: const TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: "Inter",
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                ),
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior.never,
                                                border: InputBorder.none,
                                                fillColor: Colors.white,
                                                filled: true,
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                  top: -15,
                                                  left: 10,
                                                  right: 10,
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10), // Set border radius
                                                  borderSide: const BorderSide(
                                                    color: Color(
                                                        0xfff1f1f1), // Customize border color
                                                  ),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10), // Set border radius
                                                  borderSide: const BorderSide(
                                                    color: Color(
                                                        0xfff1f1f1), // Customize focused border color
                                                  ),
                                                ),
                                              ),
                                              onChanged: (value) {
                                                int asInt = int.parse(value);
                                                if (asInt > 60) {
                                                  _temperature = 60;
                                                  _temperatureTextController
                                                      .text = '60';
                                                } else if (asInt < -10) {
                                                  _temperature = -10;
                                                  _temperatureTextController
                                                      .text = '-10';
                                                } else {
                                                  _temperature = asInt;
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          Container(
                            width: 350,
                            height: 155,
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 15,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xff87CA80),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Link to Event",
                                  style: TextStyle(
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Event:",
                                      style: TextStyle(
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 41,
                                    ),
                                    (_futureEvents == null)
                                        ? const Text("Loading events.",
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontFamily: "Inter",
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                            ))
                                        : futureEventDropdownMenu(),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Round #:",
                                      style: TextStyle(
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 19,
                                    ),
                                    SizedBox(
                                      width: 193,
                                      child: DropdownButtonFormField<int>(
                                        decoration: InputDecoration(
                                          labelText: "None",
                                          labelStyle: const TextStyle(
                                            color: Colors.grey,
                                            fontFamily: "Inter",
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                          ),
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.never,
                                          border: InputBorder.none,
                                          fillColor: Colors.white,
                                          filled: true,
                                          contentPadding: const EdgeInsets.only(
                                            top: -15,
                                            left: 10,
                                            right: 10,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                10), // Set border radius
                                            borderSide: const BorderSide(
                                              color: Color(
                                                  0xfff1f1f1), // Customize border color
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                                10), // Set border radius
                                            borderSide: const BorderSide(
                                              color: Color(
                                                  0xfff1f1f1), // Customize focused border color
                                            ),
                                          ),
                                        ),
                                        value: _roundNumber,
                                        onChanged: (newValue) {
                                          setState(() {
                                            _roundNumber = newValue!;
                                          });
                                        },
                                        // only show rounds up to the first
                                        items: _roundNumberOptions
                                            .sublist(0, _roundMaxNumber)
                                            .map((option) {
                                          return DropdownMenuItem<int>(
                                            value: int.parse(
                                                (option.split(' ').last)),
                                            child: Text(
                                              option,
                                              style: const TextStyle(
                                                fontFamily: "Inter",
                                                fontWeight: FontWeight.w500,
                                                fontSize: 15,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "Round Comment:",
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: Color(0xff155B94),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          TextField(
                            controller: _commentTextController,
                            decoration: InputDecoration(
                              labelText: 'Optional',
                              labelStyle: const TextStyle(
                                color: Colors.grey,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              border: InputBorder.none,
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: const EdgeInsets.only(
                                top: -15,
                                left: 10,
                                right: 10,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    10), // Set border radius
                                borderSide: const BorderSide(
                                  color: Color(
                                      0xfff1f1f1), // Customize border color
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    10), // Set border radius
                                borderSide: const BorderSide(
                                  color: Color(
                                      0xfff1f1f1), // Customize focused border color
                                ),
                              ),
                            ),
                            maxLines: null,
                            maxLength: 500,
                            onChanged: (value) {
                              _comment = value;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          (PersistentData.currentRoundEdit != null)
                              ? deleteButtonWidget(context)
                              : const Text('')
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
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(110, 35),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: const Color(0xff87CA80),
                    ),
                    onPressed: () {
                      if (_selectedDate != null &&
                          _selectedDate!.isAfter(DateTime.now())) {
                        _changeReqTextColour(const Color(0xffff0000));
                        _errorDialog(
                            "Error: selected date must not be in the future");
                      } else if (_selectedDate != null &&
                          _selectedCourse != null) {
                        saveRound();
                        if (advancedMode) {
                          PersistentData.currentRoundEdit?.detailLevel =
                              'Advanced';
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdvancedRoundEntry(
                                  startingHole: _startingHole),
                            ),
                          );
                        } else {
                          PersistentData.currentRoundEdit?.detailLevel =
                              'Basic';
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BasicRoundEntry(startingHole: _startingHole),
                            ),
                          );
                        }
                      } else {
                        _changeReqTextColour(const Color(0xffff0000));
                        _errorDialog("Please enter a date and course.");
                      }
                    },
                    child: (PersistentData.currentRoundEdit != null)
                        ? const Text(
                            "View/Edit",
                            style: TextStyle(
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: Color(0xff155B94),
                            ),
                          )
                        : const Text(
                            "Begin",
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
            ],
          ),
        ),
      ),
    );
  }
}
