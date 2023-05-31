/// Model for the EventCourse class
class EventCourse {
  int? id;
  String? name;
  String? roundNumber;

  EventCourse({
    this.id,
    this.name,
    this.roundNumber,
  });

  factory EventCourse.fromJson(Map<String, dynamic> json) {
    return EventCourse(
      id: json['id'],
      name: json['name'],
      roundNumber: json['roundNumber'],
    );
  }
}

/// Model for the Event class
class Event {
  int? eventId;
  String? ownerId;
  String? name;
  bool? teamEvent;
  String? teamName;
  String? startDate;
  String? endDate;
  bool? multipleCourses;
  List<EventCourse>? courses; // courses.id, courses.name, courses.roundNumber
  int? numRounds;
  String? type;
  String? state;

  Event(
      {this.eventId,
      this.ownerId,
      this.name,
      this.teamEvent,
      this.teamName,
      this.startDate,
      this.endDate,
      this.multipleCourses,
      this.courses,
      this.numRounds,
      this.type,
      this.state});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventId: json['eventId'],
      ownerId: json['ownerId'],
      name: json['name'],
      teamEvent: json['teamEvent'],
      teamName: json['teamName'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      multipleCourses: json['multipleCourses'],
      courses: json['courses']
          .map((data) => EventCourse.fromJson(data))
          .toList()
          .cast<EventCourse>(),
      numRounds: json['numRounds'],
      type: json['type'],
      state: json['state'],
    );
  }

  // overriding boolean equals operator to allow if two events are equal.
  // used in initial value setting of AddRound page.
  @override
  bool operator ==(Object other) {
    return other is Event && (eventId == other.eventId);
  }

  // this override is necessary for the boolean override
  @override
  int get hashCode => eventId.hashCode;
}
