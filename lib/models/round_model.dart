import 'package:intl/intl.dart';

import 'hole_data_model.dart';

/// This class models the object returned by the fetchRounds method.
class Round {
  int? eventId;
  int startingHole;
  String? score;
  int? temperature;
  int? courseId;
  int? roundId;
  int? eventRound;
  String? eventName;
  String? courseName;
  String? date;
  String? time;
  String weather;
  String? detailLevel;
  String? ownerName;
  String? comment;
  String wind;
  String roundType;
  bool inProgress;
  List<HoleData>? holeData;

  Round({
    this.courseId,
    this.roundId,
    this.eventId,
    this.startingHole = 1,
    this.score,
    this.temperature,
    this.eventRound,
    this.eventName,
    this.courseName,
    this.date,
    this.time,
    this.weather = "Not Set",
    this.detailLevel,
    this.ownerName,
    this.comment,
    this.wind = "Not Set",
    this.roundType = "Practice",
    this.inProgress = true,
    this.holeData,
  });

  /// Updates the hole number in the round with new data.
  void addHoleData(int holeNumber, HoleData updatedHole) {
    holeData ??= List.filled(18, HoleData());
    holeData![holeNumber] = updatedHole;
  }

  //TODO: add any other required information into this method
  factory Round.fromJson(Map<String, dynamic> json) {
    return Round(
        roundId: json['Id'],
        courseId: json['CourseId'],
        eventId: json['EventId'],
        date: json['Date'],
        time: json['Time'],
        weather: json['Weather'],
        score: json['Score'].toString(),
        courseName: json['CourseName'],
        holeData: json['HoleData']
            .map((data) => HoleData.fromJson(data))
            .toList()
            .cast<HoleData>(),
        roundType: json['Type'],
        eventName: json['EventName'],
        eventRound: json['EventRound'],
        comment: json['Comment'],
        startingHole: json['StartingHole'],
        wind: json['Wind'],
        inProgress: json['InProgress'],
        detailLevel: json['DetailLevel']);
  }

  /// Returns a nice looking date.
  String get formattedDate {
    final DateTime parsedDate = DateTime.parse(date!);
    final DateFormat formatter = DateFormat.yMMMMd();
    return formatter.format(parsedDate);
  }

  // using jsonEncode on this object will properly format a string in JSON
  // used in AddRound and UpdateRound
  Map toJson() => {
        'roundId': roundId,
        'date': date,
        'startingHole': startingHole,
        'type': roundType,
        'wind': wind,
        'weather': weather,
        'temperature': temperature,
        'courseId': courseId,
        'comment': comment,
        'event': eventId,
        'eventRound': eventRound,
        'entryType': 'Mobile',
        'detailLevel': detailLevel,
        'inProgress': inProgress,
        'holeData': holeData!.map((data) => data.toJson()).toList(),
      };
}
