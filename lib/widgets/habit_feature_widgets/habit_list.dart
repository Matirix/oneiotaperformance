import 'package:flutter/material.dart';

import '../../models/habit_data_model.dart';
import '../../screens/habit_feature/add_habit.dart';

class GenerateHabits extends StatelessWidget {
  const GenerateHabits({
    super.key,
    required Future<List<HabitData>>? futureHabits,
  }) : futureHabits = futureHabits;

  final Future<List<HabitData>>? futureHabits;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<HabitData>>(
        future: futureHabits,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return HabitsSection(habits: snapshot.data!);
          }
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(
                height: 10,
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddHabit())),
                  // onTap: () => Navigator.pushNamed(context, '/add_habit'),

                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 2,
                        color: Colors.grey.withOpacity(0.5),
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff87CA80),
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 25,
                            color: Color(0xff155B94),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "Add Today's Habits",
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            color: Color(0xff155b94),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ListView.builder(
                    itemCount: 1,
                    padding: const EdgeInsets.only(
                        top: 10), // to set default padding
                    shrinkWrap: true, // To display the entire thing
                    physics:
                        const NeverScrollableScrollPhysics(), // To stop scrolling within the list
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        height: 200,
                        padding: const EdgeInsets.all(20),
                        margin: const EdgeInsets.only(top: 10),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFF155B94),
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
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      );
                    }),
              ])
            ]),
          );
        });
  }
}

class HabitsSection extends StatelessWidget {
  const HabitsSection({
    super.key,
    required this.habits,
  });

  final List<HabitData> habits;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(
          height: 10,
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          GestureDetector(
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddHabit())),
            // onTap: () => Navigator.pushNamed(context, '/add_habit'),

            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 2,
                  color: Colors.grey.withOpacity(0.5),
                  style: BorderStyle.solid,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xff87CA80),
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 25,
                      color: Color(0xff155B94),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "Add Today's Habits",
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                      color: Color(0xff155b94),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListView.builder(
              itemCount: habits.length,
              padding: const EdgeInsets.only(top: 10), // to set default padding
              shrinkWrap: true, // To display the entire thing
              physics:
                  const NeverScrollableScrollPhysics(), // To stop scrolling within the list
              itemBuilder: (BuildContext context, int index) {
                return HabitCardContainer(habit: habits[index]);
              }),
        ])
      ]),
    );
  }
}

class HabitCardContainer extends StatelessWidget {
  const HabitCardContainer({
    super.key,
    required this.habit,
  });

  final HabitData habit;

  @override
  Widget build(BuildContext context) {
    final DateTime habitDateTime =
        habit.isoDate != null ? DateTime.parse(habit.isoDate!) : DateTime.now();

    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddHabit(
                    qeueriedDate: habitDateTime,
                  ))),
      child: Container(
          height: 200,
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(top: 10),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFF155B94),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                habit.dateWithoutYear ?? " - ",
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    habit.hoursOfSleep ?? " - ",
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF87CA80)),
                  ),
                  const Text(
                    "hours of sleep",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    habit.averageEnergyLevel != null
                        ? habit.averageEnergyLevel()!.toStringAsFixed(1)
                        : " - ",
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF87CA80)),
                  ),
                  const Text(
                    "average energy level",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    habit.averageDayStressStringValue() ?? " - ",
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF87CA80)),
                  ),
                  const Text(
                    "average stress",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
