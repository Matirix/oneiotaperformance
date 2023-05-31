/// This class contains data for the holes in a Round class.
class HoleData {
  int? holeNumber;
  bool? played;
  int? par;
  int? length;
  String? fairway;
  int? approachDistance;
  String? approachLie;
  String? approachResult;
  bool? gir;
  String? chipResult;
  String? sandResult;
  bool? chipSand;
  int? numOfPutts;
  int? putt1;
  int? putt2;
  int? putt3;
  int? score;

  HoleData(
      {this.holeNumber,
      this.played = false,
      this.length = 400,
      this.par = 4,
      this.fairway = 'Hit',
      this.approachDistance,
      this.approachLie,
      this.approachResult,
      this.gir,
      this.chipResult,
      this.sandResult,
      this.chipSand,
      this.numOfPutts,
      this.putt1,
      this.putt2,
      this.putt3,
      this.score});

  factory HoleData.fromJson(Map<String, dynamic> json) {
    // the responses for gir had key value in capital or lowercase;
    // this is to catch both cases
    bool? girValue = json['GIR'];
    girValue ??= json['gir'];

    int? score = json['score'];
    if (score != null && score == -1) {
      score = null;
    }
    return HoleData(
        holeNumber: json['holeNum'],
        played: json['played'],
        par: json['par'],
        length: json['length'],
        fairway: json['fairway'] ?? "Hit",
        approachDistance: json['approachDistance'],
        approachLie: json['approachLie'],
        approachResult: json['approachResult'],
        gir: girValue,
        chipResult: json['chipResult'],
        chipSand: json['chipSand'],
        sandResult: json['sandResult'],
        numOfPutts: json['numOfPutts'],
        putt1: json['putt1'],
        putt2: json['putt2'],
        putt3: json['putt3'],
        score: score);
  }

  // using jsonEncode on this object will properly format a string in JSON
  // used in UpdateRound
  Map toJson() => {
        'played': played,
        'length': length,
        'par': par,
        'fairway': fairway,
        'approachDistance': approachDistance,
        'approachLie': approachLie,
        'approachResult': approachResult,
        'GIR': gir,
        'chipResult': chipResult,
        'chipSand': chipSand,
        'sandResult': sandResult,
        'numOfPutts': numOfPutts,
        'putt1': putt1,
        'putt2': putt2,
        'putt3': putt3,
        'score': score,
      };
}
