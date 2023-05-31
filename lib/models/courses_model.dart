class CourseHoleData {
  int? courseId;
  int? holeNumber;
  int? par;
  int? length;

  CourseHoleData({
    this.courseId,
    this.holeNumber,
    this.par = 4,
    this.length = 400,
  });

  factory CourseHoleData.fromJson(Map<String, dynamic> json) {
    return CourseHoleData(
      courseId: json['CourseId'],
      holeNumber: json['HoleNumber'],
      par: json['Par'],
      length: json['Length'],
    );
  }
}

class Course {
  List<CourseHoleData>? holes;
  int? id;
  String? name;
  String? ownerId;
  String? tee;
  String? city;
  String? region;
  double? rating;
  int? slope;
  int? par;
  int? length;

  Course({
    this.holes,
    this.id,
    this.name,
    this.ownerId,
    this.tee,
    this.city,
    this.region,
    this.rating,
    this.slope,
    this.par,
    this.length,
  });

  // if holesData is null, set all par, length fields to 4, 400 respectively
  // assumes that the given course data is valid.
  List<CourseHoleData> getHoleData() {
    if (holes == null) {
      return List.filled(18, CourseHoleData());
    }
    return holes!;
  }

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['Id'],
      name: json['Name'],
      ownerId: json['OwnerId'],
      tee: json['Tee'],
      city: json['City'],
      region: json['Region'],
      rating: _ensureDouble(json['Rating']),
      slope: json['Slope'],
      par: json['Par'],
      length: json['Length'],
      holes: json['Holes']
          .map((data) => CourseHoleData.fromJson(data))
          .toList()
          .cast<CourseHoleData>(),
    );
  }

  // overriding boolean equals operator to allow if two courses are equal.
  // used in initial value setting of AddRound page.
  @override
  bool operator ==(Object other) {
    return other is Course && (id == other.id);
  }

  // this override is necessary for the boolean override
  @override
  int get hashCode => id.hashCode;
}

// Helper method to ensure numbers are received and stored as double type
double? _ensureDouble(dynamic number) {
  return number is int ? (number).toDouble() : number;
}
