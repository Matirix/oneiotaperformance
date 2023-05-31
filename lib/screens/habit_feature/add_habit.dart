import 'package:numberpicker/numberpicker.dart';
import 'package:one_iota_mobile_app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:one_iota_mobile_app/api/one_iota_api.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../api/auth.dart';
import '../../models/habit_data_model.dart';
import '../../api/persistent_data.dart';
import '../../utils/custom_app_bar.dart';
import '../../widgets/habit_feature_widgets/loading_container_widget.dart';

class AddHabit extends StatefulWidget {
  const AddHabit({
    Key? key,
    this.qeueriedDate,
  }) : super(key: key);

  final DateTime? qeueriedDate;

  @override
  State<AddHabit> createState() => _AddHabitState();
}

final stressValues = [
  "",
  "Very Calm",
  "Calm",
  "Neutral",
  "Stressed",
  "Very Stressed"
];

class _AddHabitState extends State<AddHabit> {
  Future<HabitData?>? _futureHabit;
  late ValueNotifier<HabitData?> habitListeners;
  HabitData? previousData;

  CalendarFormat format = CalendarFormat.week;

  DateTime? _bedTime = DateTime.now();
  DateTime? _wakeUpTime = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  String formattedDate = DateFormat('MMM y').format(DateTime.now());

  bool isSaved = true;
  // Energy Controller
  TextEditingController energyAMController = TextEditingController();
  TextEditingController energyMIDController = TextEditingController();
  TextEditingController energyPMController = TextEditingController();
  int energyAM = 0;
  int energyMID = 0;
  int energyPM = 0;
  bool energyDone = false;

  // Stress
  late Map<String, double> _selectedValues = {
    'AM': 2.0,
    'MID': 2.0,
    'PM': 2.0,
  };
  // Nutrition Fields
  double _hydrationValue = 2.5;
  String _nutritionValue = "Awful";
  String _activeRecoveryValue = "Good";

  // Text Areasc
  TextEditingController gratitudeController = TextEditingController();
  TextEditingController journalController = TextEditingController();
  int charsTyped = 0;
  final int saveAtNum = 15;

  @override
  void initState() {
    _selectedDay = widget.qeueriedDate ?? DateTime.now();
    gratitudeController.addListener(_autosaveListener);
    journalController.addListener(_autosaveListener);
    loadFutureHabit();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// On initialized, it loads the current date and the data related to it.
  Future<void> loadFutureHabit() async {
    _futureHabit = null;
    _futureHabit = OneIotaAuth()
        .getSpecificHabit(token: Auth.idToken!, date: _selectedDay);
  }

  /// When the user presses the calendar button on the top row, it will show a calendar
  Future<void> _showDatePicker(BuildContext context) async {
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

    if (pickedDate != null && pickedDate != _selectedDay) {
      setState(() {
        _selectedDay = pickedDate;
      });
    }
  }

  ///  Loads the associated data related to the date pressed
  /// [date] is the date that is pressed on the calendar
  void _loadSpecificDate(DateTime date) async {
    energyDone = false;
    charsTyped = 0;
    // empty Fields so it doesn't carry on to a day that hasn't been filled out
    _selectedValues = {
      'AM': 1.0,
      'MID': 1.0,
      'PM': 1.0,
    };
    _hydrationValue = 2.5;
    _nutritionValue = "Awful";
    _activeRecoveryValue = "Good";
    gratitudeController.text = "";
    journalController.text = "";
    // energyAMController.text = "";
    // energyMIDController.text = "";
    // energyPMController.text = "";
    energyAM = 0;
    energyMID = 0;
    energyPM = 0;

    _bedTime = DateTime.now();
    _wakeUpTime = DateTime.now();

    _futureHabit =
        OneIotaAuth().getSpecificHabit(token: Auth.idToken!, date: date);
    _futureHabit!.then((value) => setState(() {}));
  }

  /// Saves journal and gratitude entries after a specific number of typed
  /// characters
  void _autosaveListener() {
    print('chars typed: $charsTyped');
    charsTyped++;
    if (charsTyped >= saveAtNum) {
      charsTyped = 0;
      try {
        print('saving');
        saveHabitData();
      } catch (e) {
        print(e);
      }
    }
  }

  /// Calls the update habit API call. So far this only implemented in the Sleep
  /// Container, Self-care, and Journal/Gratitude. Caution on implementing this
  /// on the Stress and Energy box as they are sliders and may cause an issue
  /// with the amount of API calls.
  void saveHabitData() async {
    DateTime now = _selectedDay;
    String weekDayToday = DateFormat('EEEE').format(now);
    String isoDate = '${DateFormat('yyyy-MM-dd').format(now)}T07:00:00.000Z';
    Map<String, String> stress =
        HabitData().convertMapValuesToString(_selectedValues);
    String uid = await PersistentData.id;
    HabitData habit = HabitData(
      userId: uid,
      date: isoDate,
      dayOfWeek: weekDayToday,
      sleepStart: _bedTime!.toIso8601String(),
      sleepEnd: _wakeUpTime!.toIso8601String(),
      stressAM: stress['AM'],
      stressMid: stress['MID'],
      stressPM: stress['PM'],
      energyAM: energyAM,
      energyMid: energyMID,
      energyPM: energyPM,
      nutrition: _nutritionValue,
      hydration: _hydrationValue,
      activeRecovery: _activeRecoveryValue,
      gratitude: gratitudeController.text,
      thoughts: journalController.text,
      userEntry: 1,
    );
    print("habit: ${habit.toJson()}");
    setState(() {
      isSaved = false;
    });
    try {
      // Uncomment this to update the habit data.
      // await OneIotaAuth().updateHabit(token: Auth.idToken!, updateHabit: habit);
      setState(() {
        isSaved = true;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MMM y').format(_selectedDay);

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _calendarBar(formattedDate, context),
              _calendar(),
              const SizedBox(
                height: 20,
              ),
              generateSleep(),
              const SizedBox(
                height: 20,
              ),
              generateEnergy(),
              const SizedBox(
                height: 20,
              ),
              generateStress(),
              const SizedBox(
                height: 20,
              ),
              generateSelfCare(),
              const SizedBox(
                height: 20,
              ),
              generateJournal(),
              generateGratitude(),
            ],
          ),
        ),
      ),
    );
  }

  TableCalendar<dynamic> _calendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: _selectedDay,
      calendarFormat: format,
      availableCalendarFormats: const {
        CalendarFormat.week: 'Week',
        CalendarFormat.month: 'Month',
      },
      availableGestures: AvailableGestures.none,
      headerVisible: false,
      headerStyle: const HeaderStyle(
        titleCentered: true,
        headerMargin: EdgeInsets.only(bottom: 10),
        formatButtonTextStyle: TextStyle(
          color: Colors.green,
        ),
        leftChevronIcon: Icon(Icons.arrow_back_ios, color: Colors.green),
        rightChevronIcon: Icon(Icons.arrow_forward_ios, color: Colors.green),
        titleTextStyle: TextStyle(
          color: Colors.green, // change title text color to green
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      onFormatChanged: (newFormat) {
        setState(() {
          format = newFormat;
        });
      },
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _loadSpecificDate(_selectedDay);
        });
      },
      calendarStyle: CalendarStyle(
        todayDecoration: const BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: AppColors.lightGreen,
          shape: BoxShape.circle,
        ),
        todayTextStyle: TextStyle(
          color: AppColors.lightGreen,
        ),
      ),
    );
  }

  /// Builds the header for the calendar.
  /// [formattedDate] is the formatted date to be displayed.
  Row _calendarBar(String formattedDate, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          formattedDate,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        IconButton(
            onPressed: () {
              _showDatePicker(context);
              _loadSpecificDate(_selectedDay);
            },
            icon: const Icon(Icons.calendar_month)),
        TextButton(
            onPressed: () {
              setState(() {
                _selectedDay = DateTime.now();
                _loadSpecificDate(_selectedDay);
              });
            },
            child: const Text(
              "Go to Today",
              style: TextStyle(
                  color: Colors.black, decoration: TextDecoration.underline),
            )),
        IsSavedWidget(isSaved: isSaved), // For checking saving progress
      ],
    );
  }

  /// Builds the Future for the Self Care Widget
  FutureBuilder<HabitData?> generateSelfCare() {
    return FutureBuilder<HabitData?>(
      future: _futureHabit,
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          final habitData = snapshot.data;
          final nutritionValue = habitData?.nutrition ?? _nutritionValue;
          final hydrationValue = habitData?.hydration ?? _hydrationValue;
          final activeRecoveryValue =
              habitData?.activeRecovery ?? _activeRecoveryValue;

          return SelfCareWidget(
            nutritionValue: nutritionValue,
            nutritionOnChanged: (value) {
              setState(() {
                _nutritionValue = value;
              });
              saveHabitData();
            },
            hydrationValue: hydrationValue,
            hydrationOnChanged: (value) {
              setState(() {
                _hydrationValue = value;
              });
              saveHabitData();
            },
            activeRecoveryValue: activeRecoveryValue,
            activeRecoveryOnChanged: (value) {
              setState(() {
                _activeRecoveryValue = value;
              });
              saveHabitData();
            },
          );
        } else if (snapshot.hasError) {
          return const SizedBox(
            width: 0.0,
            height: 0.0,
          );
        } else if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.waiting) {
          return LoadingContainer(
            height: 200,
            color: AppColors.darkBlue,
          );
        } else {
          return SelfCareWidget(
            nutritionValue: _nutritionValue,
            nutritionOnChanged: (value) {
              setState(() {
                _nutritionValue = value;
              });
            },
            hydrationValue: _hydrationValue,
            hydrationOnChanged: (value) {
              setState(() {
                _hydrationValue = value;
              });
            },
            activeRecoveryValue: _activeRecoveryValue,
            activeRecoveryOnChanged: (value) {
              setState(() {
                _activeRecoveryValue = value;
              });
            },
          );
        }
      },
    );
  }

  FutureBuilder<HabitData?> generateEnergy() {
    return FutureBuilder<HabitData?>(
      future: _futureHabit,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          // check if data already exists; if it does not, grab new data
          // prevents overwriting
          if (energyDone) {
            final habitData = snapshot.data;
            energyAM = habitData?.energyAM ?? 0;
            energyMID = habitData?.energyMid ?? 0;
            energyPM = habitData?.energyPM ?? 0;
            energyDone = true;
          }

          return EnergyContainer(
              energyAM: energyAM,
              energyOnChangedAM: (value) {
                setState(() {
                  energyAM = value;
                });
                // debugPrint("412 = $energyAM, $energyMID, $energyPM");
              },
              energyMID: energyMID,
              energyOnChangedMID: (value) {
                setState(() {
                  energyMID = value;
                });
                // debugPrint("413 = $energyAM, $energyMID, $energyPM");
              },
              energyPM: energyPM,
              energyOnChangedPM: (value) {
                setState(() {
                  energyPM = value;
                });
              },
              context: context);
        } else if (snapshot.hasError) {
          return const Text(
            'Could not retrieve information, please check your internet connection',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return LoadingContainer(height: 200, color: AppColors.darkBlue);
        } else {
          return EnergyContainer(
              energyAM: energyAM,
              energyOnChangedAM: (value) {
                setState(() {
                  energyAM = value;
                });
              },
              energyMID: energyMID,
              energyOnChangedMID: (value) {
                setState(() {
                  energyMID = value;
                });
              },
              energyPM: energyPM,
              energyOnChangedPM: (value) {
                setState(() {
                  energyPM = value;
                });
              },
              context: context);
        }
      },
    );
  }

  /// Builds the Future for the Sleep Widget
  FutureBuilder<HabitData?> generateSleep() {
    return FutureBuilder<HabitData?>(
      future: _futureHabit,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          final habitData = snapshot.data;
          _bedTime = HabitData()
              .convertSleepTimeFromJsonToDateTime(habitData?.sleepStart);
          _wakeUpTime = HabitData()
              .convertSleepTimeFromJsonToDateTime(habitData?.sleepEnd);
          return SleepContainer(
            context: context,
            date: habitData?.date,
            bedTime: _bedTime ?? DateTime.now(),
            wakeUpTime: _wakeUpTime ?? DateTime.now(),
            onBedTimeSelected: (value) {
              setState(() {
                _bedTime = value;
              });
            },
            onWakeUpTimeSelected: (value) {
              setState(() {
                _wakeUpTime = value;
              });
            },
          );
        } else if (snapshot.hasError) {
          return const SizedBox(
            width: 0.0,
            height: 0.0,
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF87CA80),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child:
                  CircularProgressIndicator(), // Add CircularProgressIndicator here
            ),
          );
        } else {
          // return const CircularProgressIndicator();
          // print("Gets run here");
          return SleepContainer(
            context: context,
            date: null,
            bedTime: _bedTime ?? DateTime.now(),
            wakeUpTime: _wakeUpTime ?? DateTime.now(),
            onBedTimeSelected: (value) {
              setState(() {
                _bedTime = value;
                saveHabitData();
              });
            },
            onWakeUpTimeSelected: (value) {
              setState(() {
                _wakeUpTime = value;
                saveHabitData();
              });
            },
          );
        }
      },
    );
  }

  /// Builds the Future for the Stress Widget
  FutureBuilder<HabitData?> generateStress() {
    return FutureBuilder(
        future: _futureHabit,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final habitData = snapshot.data;
            if (previousData != habitData) {
              _selectedValues = HabitData().convertMapValuesFromJson(
                  habitData?.stressAM,
                  habitData?.stressMid,
                  habitData?.stressPM);
              previousData = habitData;
            }

            return StressWidget(
              selectedValues: _selectedValues,
              date: habitData?.date,
              updateSelectedValues: (value) {
                setState(() {
                  _selectedValues = value;
                });
              },
            );
          } else if (snapshot.hasError) {
            return const SizedBox(
              width: 0.0,
              height: 0.0,
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingContainer(
              height: 410,
              color: AppColors.lightGreen,
            );
          } else {
            // return const CircularProgressIndicato/r();
            return StressWidget(
              selectedValues: _selectedValues,
              date: null,
              updateSelectedValues: (value) {
                setState(() {
                  _selectedValues = value;
                });
              },
            );
          }
        });
  }

  /// Builds the Future for the Thoughts Widget
  FutureBuilder<HabitData?> generateJournal() {
    return FutureBuilder<HabitData?>(
      future: _futureHabit,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // this part prevents the case where new data gets overwritten by old
          if (journalController.text == '' &&
              journalController.text != snapshot.data?.thoughts) {
            journalController.text = snapshot.data?.thoughts ?? "";
          }

          return TextAreaWidget(
              context: context,
              title: "Journal",
              controller: journalController,
              hintText: "Enter notes from today...",
              onChangeText: (value) => setState(() {
                    journalController.text = value;
                  }),
              maxLines: 13);
        } else if (snapshot.hasError) {
          return const SizedBox(
            width: 0.0,
            height: 0.0,
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          return TextAreaWidget(
            context: context,
            title: "Journal",
            controller: journalController,
            hintText: "Enter notes from today...",
            maxLines: 13,
            onChangeText: (value) {
              setState(() {
                journalController.text = value;
              });
            },
          );
        }
      },
    );
  }

  /// Builds the Future for the Thoughts Widget
  FutureBuilder<HabitData?> generateGratitude() {
    return FutureBuilder<HabitData?>(
      future: _futureHabit,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // this part prevents the case where new data gets overwritten by old
          if (gratitudeController.text == '' &&
              gratitudeController.text != snapshot.data?.gratitude) {
            gratitudeController.text = snapshot.data?.gratitude ?? "";
          }
          return TextAreaWidget(
              context: context,
              title: "Gratitude",
              controller: gratitudeController,
              promptText: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "What are 3 things you are ",
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                    ),
                    TextSpan(
                      text: "GRATEFUL",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0,
                          color: Colors.black),
                    ),
                    TextSpan(
                      text: " for / ",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                        text: "APPRECIATE",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                            color: Colors.black)),
                    TextSpan(
                      text: " from today?",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              hintText: "I am grateful for...",
              onChangeText: (value) => setState(() {
                    gratitudeController.text = value;
                  }),
              maxLines: 6);
        } else if (snapshot.hasError) {
          return const SizedBox(
            width: 0.0,
            height: 0.0,
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          return TextAreaWidget(
              context: context,
              title: "Gratitude",
              controller: gratitudeController,
              promptText: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "What are 3 things you are ",
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                    ),
                    TextSpan(
                      text: "GRATEFUL",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0,
                          color: Colors.black),
                    ),
                    TextSpan(
                      text: " for / ",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                        text: "APPRECIATE",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                            color: Colors.black)),
                    TextSpan(
                      text: " from today?",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              hintText: "I am grateful for...",
              onChangeText: (value) => setState(() {
                    gratitudeController.text = value;
                  }),
              maxLines: 6);
        }
      },
    );
  }
}

/// Sleep Container
class SleepContainer extends StatefulWidget {
  const SleepContainer({
    Key? key,
    required this.context,
    required this.date,
    required this.bedTime,
    required this.wakeUpTime,
    required this.onBedTimeSelected,
    required this.onWakeUpTimeSelected,
  }) : super(key: key);

  final BuildContext context;
  final DateTime bedTime;
  final String? date;
  final DateTime wakeUpTime;
  final void Function(DateTime) onBedTimeSelected;
  final void Function(DateTime) onWakeUpTimeSelected;

  @override
  State<SleepContainer> createState() => _SleepContainerState();
}

class _SleepContainerState extends State<SleepContainer> {
  late DateTime bedTime;
  late DateTime wakeUpTime;
  String? date;

  @override
  void initState() {
    super.initState();
    bedTime = widget.bedTime;
    wakeUpTime = widget.wakeUpTime;
    date = widget.date;
  }

  // When the Widget rebuilds, it'll check if the date changed and update
  // accordingly. If the user clicks on a date without an entry, it will not
  // update the UI.
  @override
  void didUpdateWidget(SleepContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    date = oldWidget.date;
    if (widget.date != date) {
      bedTime = widget.bedTime;
      wakeUpTime = widget.wakeUpTime;
    }
  }

  /// Shows the Time picker
  /// [selectedTime] is updated.
  Future<void> _selectTime(BuildContext context, DateTime selectedTime,
      Function(DateTime) onTimeSelected) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedTime),
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
      final newTime = DateTime(
        selectedTime.year,
        selectedTime.month,
        selectedTime.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      onTimeSelected(newTime); // Call the callback to update the state
    }
  }

  /// Calculates the total hours.
  Text calculateTotalHours() {
    Duration difference = wakeUpTime.difference(bedTime);
    int totalHours = difference.inHours;
    int totalMinutes = difference.inMinutes.remainder(60);

    return Text(
      '$totalHours hrs $totalMinutes minutes',
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF87CA80),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Sleep",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextButton(
                  onPressed: () {},
                  child: Row(
                    children: const [
                      Text(
                        "Set up automatic collection",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            decoration: TextDecoration.underline),
                      ),
                      SizedBox(width: 5),
                      Icon(
                        Icons.info,
                        color: Colors.black,
                        size: 15,
                      ),
                    ],
                  )) // TODO fill later
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "To Bed:",
                style: TextStyle(
                  color: AppColors.darkBlue,
                  fontSize: 20,
                ),
              ),
              GestureDetector(
                onTap: () {
                  _selectTime(context, bedTime, (newTime) {
                    setState(() {
                      bedTime = newTime;
                    });
                    widget.onBedTimeSelected(newTime);
                  });
                },
                child: Text(
                  DateFormat.jm().format(bedTime),
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Wake",
                style: TextStyle(
                  color: AppColors.darkBlue,
                  fontSize: 20,
                ),
              ),
              GestureDetector(
                onTap: () {
                  _selectTime(context, wakeUpTime, (newTime) {
                    setState(() {
                      wakeUpTime = newTime;
                    });
                    widget.onBedTimeSelected(newTime);
                  });
                },
                child: Text(
                  DateFormat.jm().format(wakeUpTime),
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.bedtime,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Text(
                "Total: ",
                style: TextStyle(
                  color: AppColors.darkBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              calculateTotalHours(),
            ],
          )
        ],
      ),
    );
  }
}

class EnergyContainer extends StatefulWidget {
  const EnergyContainer({
    Key? key,
    required this.energyAM,
    required this.energyMID,
    required this.energyPM,
    required this.context,
    required this.energyOnChangedAM,
    required this.energyOnChangedMID,
    required this.energyOnChangedPM,
  }) : super(key: key);

  final int energyAM;
  final int energyMID;
  final int energyPM;
  final Function energyOnChangedAM;
  final Function energyOnChangedMID;
  final Function energyOnChangedPM;
  final BuildContext context;

  @override
  State<EnergyContainer> createState() => _EnergyContainerState();
}

class _EnergyContainerState extends State<EnergyContainer> {
  late int energyAM;
  late int energyMID;
  late int energyPM;

  @override
  void initState() {
    super.initState();
    energyAM = widget.energyAM;
    energyMID = widget.energyMID;
    energyPM = widget.energyPM;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 250,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF155B94),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text(
          "Energy",
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                const Text("AM",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF87CA80),
                    )),
                const SizedBox(height: 10),
                Container(
                  width: 50,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: NumberPicker(
                    selectedTextStyle: TextStyle(
                      color: AppColors.darkBlue,
                    ),
                    itemHeight: 30,
                    maxValue: 10,
                    minValue: 0,
                    value: energyAM,
                    onChanged: (value) {
                      setState(() {
                        energyAM = value;
                        widget.energyOnChangedAM(value);
                      });
                      print("1060 $value energyAM: ${widget.energyAM}");
                    },
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Text("MID",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF87CA80),
                    )),
                const SizedBox(height: 10),
                Container(
                  width: 50,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: NumberPicker(
                    selectedTextStyle: TextStyle(
                      color: AppColors.darkBlue,
                    ),
                    itemHeight: 30,
                    maxValue: 10,
                    minValue: 0,
                    value: energyMID,
                    onChanged: (value) {
                      setState(() {
                        energyMID = value;
                      });
                      widget.energyOnChangedMID(value);
                    },
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Text("PM",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF87CA80),
                    )),
                const SizedBox(height: 10),
                Container(
                  width: 50,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: NumberPicker(
                    selectedTextStyle: TextStyle(
                      color: AppColors.darkBlue,
                    ),
                    itemHeight: 30,
                    maxValue: 10,
                    minValue: 0,
                    value: energyPM,
                    onChanged: (value) {
                      setState(() {
                        energyPM = value;
                      });
                      widget.energyOnChangedPM(value);
                    },
                  ),
                ),
              ],
            ),
          ],
        )
      ]),
    );
  }
}

///  Builds a text area widget for the journal and the
class TextAreaWidget extends StatelessWidget {
  const TextAreaWidget(
      {super.key,
      required this.context,
      required this.title,
      required this.controller,
      required this.hintText,
      required this.onChangeText,
      required this.maxLines,
      this.promptText});

  final BuildContext context;
  final String title;
  final TextEditingController controller;
  final String hintText;
  final Function(String) onChangeText;
  final int maxLines;
  final RichText? promptText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 350,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          title,
          style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color(0xFF155B94)),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: promptText,
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            fillColor: Colors.grey[300],
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF155B94),
              ),
            ),
            hintText: hintText,
          ),
        ),
      ]),
    );
  }
}

/// Saved or In Progress Indicator for the API
class IsSavedWidget extends StatefulWidget {
  const IsSavedWidget({
    super.key,
    required this.isSaved,
  });

  final bool isSaved;

  @override
  State<IsSavedWidget> createState() => _IsSavedWidgetState();
}

class _IsSavedWidgetState extends State<IsSavedWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        widget.isSaved
            ? Row(
                children: const [
                  Text("Saved"),
                  SizedBox(width: 5),
                  Icon(Icons.check, size: 25, color: Colors.green),
                ],
              )
            : Row(
                children: const [
                  Text("In progress..."),
                  SizedBox(width: 5),
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(),
                  ),
                ],
              ),
      ],
    );
  }
}

/// Builds a widget for the self care section
class SelfCareWidget extends StatefulWidget {
  final String nutritionValue;
  final double hydrationValue;
  final String activeRecoveryValue;
  final Function nutritionOnChanged;
  final Function hydrationOnChanged;
  final Function activeRecoveryOnChanged;

  const SelfCareWidget({
    required this.nutritionValue,
    required this.hydrationValue,
    required this.activeRecoveryValue,
    required this.nutritionOnChanged,
    required this.hydrationOnChanged,
    required this.activeRecoveryOnChanged,
    Key? key,
  }) : super(key: key);

  @override
  State<SelfCareWidget> createState() => _SelfCareWidgetState();
}

class _SelfCareWidgetState extends State<SelfCareWidget> {
  final dropDownValues = ["Awful", "Poor", "Good", "Perfect"];

  late String nutritionValue;
  late double hydrationValue;
  late String activeRecoveryValue;

  @override
  void initState() {
    super.initState();
    nutritionValue = widget.nutritionValue;
    hydrationValue = widget.hydrationValue;
    activeRecoveryValue = widget.activeRecoveryValue;

    // print("553 + $activeRecoveryValue");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF155B94),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text(
          "Self Care",
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Hydration',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Color(0xFF87CA80),
              ),
            ),
            SizedBox(
                height: 25,
                width: 150,
                // child: _buildSlider(hydrationValue),
                child: NumberInputWidget(
                    hydrationValue: hydrationValue,
                    hydrationOnChanged: (value) {
                      widget.hydrationOnChanged(value);
                    })),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Nutrition',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Color(0xFF87CA80),
              ),
            ),
            Container(
              width: 100,
              height: 25,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                // border: Border.all(color: const Color(0xFF87CA80)),
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButton<String>(
                value: nutritionValue,
                icon: const Icon(Icons.chevron_right, color: Colors.black),
                iconSize: 20,
                hint: const Text("Select"),
                elevation: 16,
                underline: Container(
                  height: 0,
                  color: Colors.white,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    nutritionValue = newValue!;
                  });
                  widget.nutritionOnChanged(newValue);
                },
                items: dropDownValues
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Active Recovery',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Color(0xFF87CA80),
              ),
            ),
            Container(
              height: 25,
              width: 100,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButton<String>(
                value: activeRecoveryValue,
                hint: const Text("Select"),
                icon: const Icon(Icons.chevron_right, color: Colors.black),
                iconSize: 20,
                elevation: 0,
                underline: Container(
                  height: 0,
                  color: Colors.white,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    activeRecoveryValue = newValue!;
                  });
                  widget.activeRecoveryOnChanged(newValue);
                },
                items: dropDownValues
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ],
        )
      ]),
    );
  }
}

/// Builds a widget for the self care section the hydration levels.
class NumberInputWidget extends StatefulWidget {
  final Function(double) hydrationOnChanged;
  final double hydrationValue;
  const NumberInputWidget(
      {Key? key,
      required this.hydrationOnChanged,
      required this.hydrationValue})
      : super(key: key);

  @override
  _NumberInputWidgetState createState() => _NumberInputWidgetState();
}

class _NumberInputWidgetState extends State<NumberInputWidget> {
  late double _number;
  @override
  void initState() {
    super.initState();
    _number = widget.hydrationValue;
  }

  void _incrementNumber() {
    if (_number == 5) {
      return;
    }
    setState(() {
      _number += 0.25;
    });
    widget.hydrationOnChanged(_number);
  }

  void _decrementNumber() {
    if (_number == 0) {
      return;
    }
    setState(() {
      _number -= 0.25;
    });
    widget.hydrationOnChanged(_number);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: _decrementNumber,
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.remove,
              ),
            ),
            SizedBox(
              width: 50,
              child: Center(child: Text(_number.toString())),
            ),
            IconButton(
              onPressed: _incrementNumber,
              icon: const Icon(Icons.add),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}

/// Builds a widget for the self care section the hydration levels.
class StressWidget extends StatefulWidget {
  final Map<String, double> selectedValues;
  final Function updateSelectedValues;
  final String? date;

  const StressWidget({
    Key? key,
    required this.selectedValues,
    required this.updateSelectedValues,
    required this.date,
  }) : super(key: key);

  @override
  _StressWidgetState createState() => _StressWidgetState();
}

class _StressWidgetState extends State<StressWidget> {
  // Define a map to store the selected values for each time slot
  late Map<String, double> selectedValues;
  String? date;

  @override
  void initState() {
    selectedValues = widget.selectedValues;
    date = widget.date;
    super.initState();
  }

  @override
  void didUpdateWidget(StressWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    date = oldWidget.date;
    if (widget.date != date) {
      selectedValues = widget.selectedValues;
    }
  }

  final List<IconData> icons = [
    Icons.sentiment_very_satisfied,
    Icons.sentiment_satisfied,
    Icons.sentiment_neutral,
    Icons.sentiment_dissatisfied,
    Icons.sentiment_very_dissatisfied
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 450,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.lightGreen,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Stress",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          _buildSlider('AM', selectedValues['AM']!),
          const SizedBox(height: 10),
          _buildSlider('MID', selectedValues['MID']!),
          const SizedBox(height: 10),
          _buildSlider('PM', selectedValues['PM']!),
        ],
      ),
    );
  }

  Widget _buildSlider(String timeSlot, double value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          timeSlot,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // const (Icons.sentiment_dissatisfied, color: Colors.white),
              const Text(
                "Calm",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              Icon(
                icons[selectedValues[timeSlot]!.toInt() - 1],
              ),
              // const Icon(Icons.sentiment_very_dissatisfied_outlined,
              //     color: Colors.white),
              const SizedBox(
                width: 75,
                child: Text(
                  "Very Stressed",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
              trackHeight: 5,
              inactiveTickMarkColor: Colors.white,
              activeTickMarkColor: Colors.white,
              activeTrackColor: AppColors.darkBlue,
              inactiveTrackColor: Colors.transparent),
          child: Slider(
            min: 1,
            max: 5,
            divisions: 4,
            value: value,
            activeColor: const Color(0xFF155B94),
            inactiveColor: Colors.white,
            onChanged: (double newValue) {
              setState(() {
                selectedValues[timeSlot] = newValue;
                widget.updateSelectedValues(selectedValues);
              });
            },
            label: stressValues[value.toInt()],
            // label: "1",
          ),
        ),
      ],
    );
  }
}
