import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HabitData {
  String? userId;
  String? date;
  String? isoDate;
  String? dayOfWeek;
  String? sleepStart;
  String? sleepEnd;
  String? stressAM;
  String? stressMid;
  String? stressPM;
  int? energyAM;
  int? energyMid;
  int? energyPM;
  String? nutrition;
  String? activeRecovery;
  double? hydration;
  String? thoughts;
  String? gratitude;
  int? userEntry;

  HabitData(
      {this.userId,
      this.date,
      this.isoDate,
      this.dayOfWeek,
      this.sleepStart,
      this.sleepEnd,
      this.stressAM,
      this.stressMid,
      this.stressPM,
      this.energyAM,
      this.energyMid,
      this.energyPM,
      this.nutrition,
      this.activeRecovery,
      this.hydration,
      this.thoughts,
      this.gratitude,
      this.userEntry});

  factory HabitData.fromJson(Map<String, dynamic> json) {
    return HabitData(
      userId: json['userId'],
      date: json['date'],
      isoDate: json['isoDate'],
      dayOfWeek: json['dayOfWeek'],
      sleepStart: json['sleepStart'],
      sleepEnd: json['sleepEnd'],
      stressAM: json['stressAM'] ?? "Calm",
      stressMid: json['stressMid'] ?? "Calm",
      stressPM: json['stressPM'] ?? "Calm",
      energyAM: json['energyAM'] ?? 0,
      energyMid: json['energyMid'] ?? 0,
      energyPM: json['energyPM'] ?? 0,
      nutrition: json['nutrition'],
      activeRecovery: json['activeRecovery'],
      hydration: _ensureDouble(json['hydration']),
      thoughts: json['thoughts'] ?? "",
      gratitude: json['gratitude'] ?? "",
      userEntry: json['userEntry'] ?? 1,
    );
  }

  Map toJson() => {
        'userId': userId,
        'date': date,
        'isoDate': isoDate,
        'dayOfWeek': dayOfWeek,
        'sleepStart': sleepStart,
        'sleepEnd': sleepEnd,
        'stressAM': stressAM,
        'stressMid': stressMid,
        'stressPM': stressPM,
        'energyAM': energyAM,
        'energyMid': energyMid,
        'energyPM': energyPM,
        'nutrition': nutrition,
        'activeRecovery': activeRecovery,
        'hydration': hydration,
        'thoughts': thoughts,
        'gratitude': gratitude,
        'userEntry': userEntry,
      };

  Map<String, int> validStressValues = {
    'VeryCalm': 1,
    'Calm': 2,
    'Neutral': 3,
    'Stressed': 4,
    'VeryStressed': 5
  };

  Map<int, String> stressValueMapToString = {
    1: "Very Calm",
    2: "Calm",
    3: "Neutral",
    4: "Stressed",
    5: "Very Stressed"
  };

  Map<String, double> convertMapValuesFromJson(
      String? stressAM, String? stressMid, String? stressPM) {
    Map<String, double> stressMap = {
      'AM': 0,
      'MID': 0,
      'PM': 0,
    };
    if (stressAM != null) {
      stressMap['AM'] = validStressValues[stressAM]!.toDouble();
    }
    if (stressMid != null) {
      stressMap['MID'] = validStressValues[stressMid]!.toDouble();
    }
    if (stressPM != null) {
      stressMap['PM'] = validStressValues[stressPM]!.toDouble();
    }
    return stressMap;
  }

  String? get dateWithoutYear {
    if (isoDate != null) {
      DateTime date =
          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(isoDate!);
      String formattedDate = DateFormat("EEEE, MMMM d").format(date);
      return formattedDate;
    }
    return null;
  }

  double? averageEnergyLevel() {
    if (energyAM != null && energyMid != null && energyPM != null) {
      return (energyAM! + energyMid! + energyPM!) / 3;
    } else {
      return null;
    }
  }

  double? specificDailyEnergyLevel(HabitData habit) {
    if (habit.energyAM != null &&
        habit.energyMid != null &&
        habit.energyPM != null) {
      print(
          "Line 256 ${(habit.energyAM! + habit.energyMid! + habit.energyPM!) / 3}");

      return (habit.energyAM! + habit.energyMid! + habit.energyPM!) / 3;
    } else {
      return null;
    }
  }

  DateTime? convertSleepTimeFromJsonToDateTime(String? sleepTime) {
    return DateFormat('h:mma').parse(sleepTime!.toUpperCase());
  }

  /// Used to display sleep in HabitCard
  String? get hoursOfSleep {
    if (sleepStart != null && sleepEnd != null) {
      try {
        final DateTime? convertSSFromJsonToDateTime =
            convertSleepTimeFromJsonToDateTime(sleepStart!);
        // DateFormat('h:mma').parse(sleepStart!.toUpperCase());
        final DateTime? convertSEFromJsonToDateTime =
            convertSleepTimeFromJsonToDateTime(sleepEnd!);
        // DateFormat('h:mma').parse(sleepEnd!.toUpperCase());

        final Duration difference = convertSEFromJsonToDateTime!
            .difference(convertSSFromJsonToDateTime!);
        return "${difference.inHours} hrs ${difference.inMinutes.remainder(60)} m";
      } catch (e) {
        print('Error parsing sleep time: $e');
        return null;
      }
    } else {
      return null;
    }
  }

  /// Used in the HabitDetailScreen to turn the ISOdate into a DateTime object. This
  /// is used in Habits Feature for the calendar.
  DateTime get toDateTime {
    return DateTime.parse(isoDate.toString());
  }

  String? averageDayStressStringValue() {
    double avgStressLevel = averageDayStressLevel()!;
    return stressValueMapToString[avgStressLevel.toInt()];
  }

  // Used to convert to JSON for data entry
  String? convertToStressStringValue(double stressValue) {
    return stressValueMapToString[stressValue.toInt()]!.replaceAll(' ', '');
  }

  // Used to convert Map to JSON for data entry. Used in add_habits
  Map<String, String> convertMapValuesToString(
      Map<String, double> dailyStressValues) {
    Map<String, String> dailyStressValuesString = {};
    dailyStressValues.forEach((key, value) {
      dailyStressValuesString[key] = convertToStressStringValue(value)!;
    });
    return dailyStressValuesString;
  }

  // For stress Level
  double? averageDayStressLevel() {
    if (stressAM != null && stressMid != null && stressPM != null) {
      double avgStressLevel = (validStressValues[stressAM!]! +
              validStressValues[stressMid!]! +
              validStressValues[stressPM!]!) /
          3;

      return avgStressLevel;
      // return averageStress.toString();
    } else {
      return null;
    }
  }

  double? specificDailyStressLevel(HabitData habit) {
    if (habit.stressAM != null &&
        habit.stressMid != null &&
        habit.stressPM != null) {
      double avgStressLevel = (validStressValues[habit.stressAM!]! +
              validStressValues[habit.stressMid!]! +
              validStressValues[habit.stressPM!]!) /
          3;
      print(
          "line 315 AM = ${validStressValues[habit.stressAM!]} / Mid = ${validStressValues[habit.stressMid!]} / PM = ${validStressValues[habit.stressPM!]} =  $avgStressLevel");
      return avgStressLevel;
      // return averageStress.toString();
    } else {
      return null;
    }
  }

  // Used to calculate sleep in a day, used for calculating sleep in a week
  Duration? averageSleepDurationLevel() {
    if (sleepStart != null && sleepEnd != null) {
      try {
        final DateTime convertStart =
            DateFormat('h:mma').parse(sleepStart!.toUpperCase());
        DateTime convertEnd =
            DateFormat('h:mma').parse(sleepEnd!.toUpperCase());

        // print("start: $convertStart  end: $convertEnd");

        // Check if the end time is on the next day
        if (convertEnd.isBefore(convertStart)) {
          convertEnd = convertEnd.add(const Duration(days: 1));
        }

        final Duration difference = convertEnd.difference(convertStart);
        // print(difference);
        return difference;
      } catch (e) {
        print('Error parsing sleep time: $e');
      }
    }

    // Return a default value of 0 if the start or end time is null
    return null;
  }

  double? specificDailySleepDurationLevel(HabitData habit) {
    if (habit.sleepStart != null && habit.sleepEnd != null) {
      try {
        final DateTime convertStart =
            DateFormat('h:mma').parse(habit.sleepStart!.toUpperCase());
        DateTime convertEnd =
            DateFormat('h:mma').parse(habit.sleepEnd!.toUpperCase());

        // print("start: $convertStart  end: $convertEnd");

        // Check if the end time is on the next day
        if (convertEnd.isBefore(convertStart)) {
          convertEnd = convertEnd.add(const Duration(days: 1));
        }

        final Duration difference = convertEnd.difference(convertStart);
        // print(difference);
        return difference.inMinutes / 60;
      } catch (e) {
        print('Error parsing sleep time: $e');
      }
    }

    // Return a default value of 0 if the start or end time is null
    return null;
  }

  double? averageSleepDurationLevelInHours() {
    if (averageSleepDurationLevel() != null) {
      return averageSleepDurationLevel()!.inHours.toDouble();
    } else {
      return null;
    }
  }

  Color getCircleColor(String? category, double? categoryAvg) {
    if (category == "sleep") {
      if (categoryAvg! >= 7) {
        return Colors.green;
      } else {
        return Colors.red;
      }
    }
    if (category == "stress") {
      if (categoryAvg! <= 3.5) {
        return Colors.green;
      }
    } else if (categoryAvg == 4.5) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }

    if (category == "energy") {
      if (categoryAvg > 7.5) {
        return Colors.green;
      } else if (categoryAvg <= 3) {
        return Colors.red;
      } else {
        return Colors.yellow;
      }
    }

    return Colors.red;
  }

  /// For the calendar in a week
  double calculateAverageSleepDurationOfHabits(List<HabitData>? habits) {
    int totalMinutes = 0;
    int numHabits = 0;

    for (var habit in habits ?? []) {
      final sleepDuration = habit.averageSleepDurationLevel();
      if (sleepDuration != null) {
        totalMinutes += sleepDuration.inMinutes as int;
        numHabits++;
      }
    }

    return numHabits > 0 ? totalMinutes / (numHabits * 60.0) : 0.0;
  }

  double calculateAverageStressLevelOfHabits(List<HabitData>? habits) {
    double totalStressLevel = 0;
    int numHabits = 0;

    for (var habit in habits ?? []) {
      final avgStressLevel = habit.averageDayStressLevel();
      if (avgStressLevel != null) {
        totalStressLevel += avgStressLevel;
        numHabits++;
      }
    }

    return numHabits > 0 ? totalStressLevel / numHabits : 0.0;
  }

  /// Used to display the average energy level of a week
  double calculateAverageEnergyLevelOfHabits(List<HabitData>? habits) {
    double totalEnergyLevel = 0;
    int numHabits = 0;

    for (var habit in habits ?? []) {
      final avgEnergyLevel = habit.averageEnergyLevel();
      if (avgEnergyLevel != null) {
        totalEnergyLevel += avgEnergyLevel;
        numHabits++;
      }
    }

    return numHabits > 0 ? totalEnergyLevel / numHabits : 0.0;
  }

  Map<String, int> weeklyCountMap(List<HabitData> habits) {
    int thoughtCount = 0;
    int gratitudeCount = 0;
    int missingEntryCount = 0;

    // Sort the list by date in ascending order
    habits.sort((a, b) => a.isoDate!.compareTo(b.isoDate!));

    // Loop through the list and count thoughts, gratitude, and missing user entries
    for (int i = 0; i < habits.length; i++) {
      if (habits[i].thoughts != null && habits[i].thoughts!.isNotEmpty) {
        thoughtCount++;
      }
      if (habits[i].gratitude != null && habits[i].gratitude!.isNotEmpty) {
        gratitudeCount++;
      }
      if (habits[i].userEntry == null) {
        missingEntryCount++;
      }
    }
    int entries = habits.length - missingEntryCount;

    return {
      'thoughts': thoughtCount,
      'gratitude': gratitudeCount,
      'entries': entries
    };
  }
}

// Helper method to ensure numbers are received and stored as double type
double? _ensureDouble(dynamic number) {
  return number is int ? (number).toDouble() : number;
}
