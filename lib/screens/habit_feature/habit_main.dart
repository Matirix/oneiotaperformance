import 'dart:math';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/habit_data_model.dart';
import '../../utils/app_colors.dart';
import '../../api/auth.dart';
import '../../utils/custom_app_bar.dart';
import 'package:intl/intl.dart';
import '../../api/one_iota_api.dart';
import '../../widgets/habit_feature_widgets/habit_list.dart';

class HabitPage extends StatefulWidget {
  const HabitPage({super.key});

  @override
  State<HabitPage> createState() => _HabitPageState();
}

class _HabitPageState extends State<HabitPage> {
  String formattedDate = DateFormat('MMM d, y').format(DateTime.now());
// Calculate the first day of the current week
  DateTime now = DateTime.now();
  Future<List<HabitData>>? _futureHabits;

  double? hoursOfSleepData = 8;

  @override
  void initState() {
    super.initState();
    // _futureHabits = OneIotaAuth().getHabits(token: Auth.idToken!);
    _futureHabits = OneIotaAuth().get7daysHabits(token: Auth.idToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(),
        body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(formattedDate,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 20,
                  ),
                  SevenWeekBox(futureHabits: _futureHabits, context: context),
                  const SizedBox(
                    height: 10,
                  ),
                  GenerateCounter(futureHabits: _futureHabits),
                  // weeklyHabitEntries(context),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Daily Habit Tracking",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w400),
                  ),
                  // From ../../widgets/habit_feature_widget/habit_list.dart
                  GenerateHabits(futureHabits: _futureHabits)
                ],
              )),
        ));
  }
}

class GenerateCounter extends StatelessWidget {
  GenerateCounter({
    super.key,
    required Future<List<HabitData>>? futureHabits,
  }) : _futureHabits = futureHabits;

  final Future<List<HabitData>>? _futureHabits;

  int? selfCareData;
  int? graititudeData;
  int? journalentryData;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureHabits,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          selfCareData = HabitData().weeklyCountMap(snapshot.data!)["thoughts"];
          graititudeData =
              HabitData().weeklyCountMap(snapshot.data!)["gratitude"];
          journalentryData =
              HabitData().weeklyCountMap(snapshot.data!)["entries"];

          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                    width: 100,
                    height: 100,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF87CA80),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${selfCareData.toString()} / 7',
                          // "fff",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF155B94),
                          ),
                        ),
                        const Text(
                          "Self Care Entries",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        )
                      ],
                    )),
                Container(
                    width: 100,
                    height: 100,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF87CA80),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${graititudeData.toString()} / 7',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF155B94),
                          ),
                        ),
                        const Text(
                          "Gratitude Entries",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        )
                      ],
                    )),
                Container(
                    width: 100,
                    height: 100,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF87CA80),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${journalentryData.toString()} / 7',
                          // "fff",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF155B94),
                          ),
                        ),
                        const Text(
                          "Journal Entries",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        )
                      ],
                    ))
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Row(
            children: [
              loadingHabit(),
              loadingHabit(),
              loadingHabit(),
            ],
          );
        }
        return const CircularProgressIndicator();
      },
    );
  }

  Container loadingHabit() {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      padding: const EdgeInsets.all(10),
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFF87CA80),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
}

class Mode {
  String? mode;
  String? text;
  Function? averageWeekFunction;
  Function? averageDailyFunction;

  Mode(this.mode, this.text, this.averageWeekFunction,
      this.averageDailyFunction);
}

class SevenWeekBox extends StatelessWidget {
  SevenWeekBox({
    super.key,
    required Future<List<HabitData>>? futureHabits,
    required this.context,
  }) : _futureHabits = futureHabits;

  final Future<List<HabitData>>? _futureHabits;
  final BuildContext context;

  final List<Mode> modes = [
    Mode(
        'sleep',
        'hours of sleep',
        HabitData().calculateAverageSleepDurationOfHabits,
        HabitData().specificDailySleepDurationLevel),
    Mode(
        'energy',
        'level of energy',
        HabitData().calculateAverageEnergyLevelOfHabits,
        HabitData().specificDailyEnergyLevel),
    Mode(
        'stress',
        'level of stress',
        HabitData().calculateAverageStressLevelOfHabits,
        HabitData().specificDailyStressLevel)
  ];

  Mode getRandomMode(List<Mode> modes) {
    final random = Random();
    final index = random.nextInt(modes.length);
    return modes[index];
  }

  @override
  Widget build(BuildContext context) {
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
            "Last 7 Days",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 10,
          ),
          CalendarWidget(
            futureHabits: _futureHabits,
            mode: getRandomMode(modes),
          ),
        ],
      ),
    );
  }
}

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({
    super.key,
    this.futureHabits,
    required this.mode,
  });

  final Future<List<HabitData>>? futureHabits;
  final Mode mode;

  // final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<HabitData>>(
        future: futureHabits,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TableCalendar(
                  availableGestures: AvailableGestures.none,

                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      for (HabitData habit in snapshot.data!) {
                        if (habit.toDateTime.day == day.day &&
                            habit.toDateTime.month == day.month) {
                          return Container(
                            width: 35,
                            decoration: BoxDecoration(
                              color: AppColors.darkBlue,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  width: 3,
                                  color:
                                      // habit.score > 5 ? Colors.lightGreen : Colors.red,
                                      HabitData().getCircleColor("${mode.mode}",
                                          mode.averageDailyFunction!(habit)),
                                  style: BorderStyle.solid),
                            ),
                            child: Center(
                              child: Text(
                                '${day.day}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        }
                      }
                      return null;
                    },
                  ),
                  calendarFormat: CalendarFormat.week,
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: DateTime.now(),
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(color: Colors.white),
                    weekendStyle: TextStyle(color: Colors.white),
                  ),
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: const TextStyle(color: Colors.white),
                    weekendTextStyle: const TextStyle(color: Colors.white),
                    holidayTextStyle: const TextStyle(color: Colors.white),
                    outsideTextStyle: const TextStyle(color: Colors.white),
                    outsideDaysVisible: false,
                    canMarkersOverflow: true,
                    todayDecoration: const BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: AppColors.darkBlue,
                      shape: BoxShape.circle,
                      border: Border.all(
                        // color: _getBorderColor(
                        //     habits,
                        //     habits
                        //         .map((habit) =>
                        //             DateTime.parse(habit.date.toString()))
                        //         .toList()),
                        // color: _getBorderColor(habits, _selectedDates),

                        width: 2.0,
                      ),
                    ),
                    selectedTextStyle: const TextStyle(color: Colors.white),
                    todayTextStyle: const TextStyle(color: Colors.green),
                  ),
                  headerVisible: false,
                  // selectedDayPredicate: (day) {
                  //   final habitDates = habits
                  //       .map((habit) => DateTime.parse(habit.date.toString())
                  //           .toString()
                  //           .substring(0, 10))
                  //       .toList();

                  //   // print(habitDates[4]);
                  //   // print("day =    ${day.toLocal().toString().substring(0, 10)}");
                  //   // print(habitDates
                  //   //     .contains(day.toLocal().toString().substring(0, 10)));

                  //   // return habitDates
                  //   //     .contains(day.toLocal().toString().substring(0, 10));
                  //   if (habitDates
                  //       .contains(day.toLocal().toString().substring(0, 10))) {
                  //     _selectedDates.add(day);
                  //     return true;
                  //   }

                  //   return false;
                  // }),
                ),
                const SizedBox(
                  height: 10,
                ),
                past7DayStat(snapshot)
              ],
            );
          } else if (snapshot.hasError) {
            return const Text(
              'Could not retrieve past rounds, please check your internet connection',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  Row past7DayStat(AsyncSnapshot<List<HabitData>> snapshot) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("${mode.averageWeekFunction!(snapshot.data).toStringAsFixed(1)}",
            style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold)),
        const SizedBox(
          width: 10,
        ),
        Column(
          children: [
            RichText(
              text: TextSpan(
                text: '${mode.text}',
                style: const TextStyle(color: Color(0xFF87CA80)),
                children: const <TextSpan>[
                  TextSpan(
                      text: '\nin the past 7 days',
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
