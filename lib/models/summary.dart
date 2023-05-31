class Summary {
  Analysis? analysis;

  Summary({this.analysis});

  Summary.fromJson(Map<String, dynamic> json) {
    analysis =
        json['Analysis'] != null ? Analysis.fromJson(json['Analysis']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (analysis != null) {
      data['Analysis'] = analysis!.toJson();
    }
    return data;
  }
}

class Analysis {
  Data? data;
  String? title;
  String? detailLevel;

  Analysis({this.data, this.title, this.detailLevel});

  Analysis.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    title = json['title'];
    detailLevel = json['detailLevel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['title'] = title;
    data['detailLevel'] = detailLevel;
    return data;
  }
}

class Data {
  Recommendation? recommendation;
  ScoringAverage? scoringAverage;
  ScoreType? scoreType;
  TeeInPlay? teeInPlay;
  TeeFway? teeFway;
  TeeFway? approachGir;
  TeeFway? shortGameSave;
  TeeFway? chipSaved;
  SandSaved? sandSaved;
  SandSaved? puttsRound;
  TeeFway? threePuttsRound;
  TeeFway? feetOfPutts;

  Data(
      {this.recommendation,
      this.scoringAverage,
      this.scoreType,
      this.teeInPlay,
      this.teeFway,
      this.approachGir,
      this.shortGameSave,
      this.chipSaved,
      this.sandSaved,
      this.puttsRound,
      this.threePuttsRound,
      this.feetOfPutts});

  Data.fromJson(Map<String, dynamic> json) {
    recommendation = json['Recommendation'] != null
        ? Recommendation.fromJson(json['Recommendation'])
        : null;
    scoringAverage = json['ScoringAverage'] != null
        ? ScoringAverage.fromJson(json['ScoringAverage'])
        : null;
    scoreType = json['ScoreType'] != null
        ? ScoreType.fromJson(json['ScoreType'])
        : null;
    teeInPlay = json['Tee_InPlay'] != null
        ? TeeInPlay.fromJson(json['Tee_InPlay'])
        : null;
    teeFway =
        json['Tee_Fway'] != null ? TeeFway.fromJson(json['Tee_Fway']) : null;
    approachGir = json['Approach_Gir'] != null
        ? TeeFway.fromJson(json['Approach_Gir'])
        : null;
    shortGameSave = json['ShortGameSave'] != null
        ? TeeFway.fromJson(json['ShortGameSave'])
        : null;
    chipSaved =
        json['ChipSaved'] != null ? TeeFway.fromJson(json['ChipSaved']) : null;
    sandSaved = json['SandSaved'] != null
        ? SandSaved.fromJson(json['SandSaved'])
        : null;
    puttsRound = json['PuttsRound'] != null
        ? SandSaved.fromJson(json['PuttsRound'])
        : null;
    threePuttsRound = json['ThreePuttsRound'] != null
        ? TeeFway.fromJson(json['ThreePuttsRound'])
        : null;
    feetOfPutts = json['FeetOfPutts'] != null
        ? TeeFway.fromJson(json['FeetOfPutts'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (recommendation != null) {
      data['Recommendation'] = recommendation!.toJson();
    }
    if (scoringAverage != null) {
      data['ScoringAverage'] = scoringAverage!.toJson();
    }
    if (scoreType != null) {
      data['ScoreType'] = scoreType!.toJson();
    }
    if (teeInPlay != null) {
      data['Tee_InPlay'] = teeInPlay!.toJson();
    }
    if (teeFway != null) {
      data['Tee_Fway'] = teeFway!.toJson();
    }
    if (approachGir != null) {
      data['Approach_Gir'] = approachGir!.toJson();
    }
    if (shortGameSave != null) {
      data['ShortGameSave'] = shortGameSave!.toJson();
    }
    if (chipSaved != null) {
      data['ChipSaved'] = chipSaved!.toJson();
    }
    if (sandSaved != null) {
      data['SandSaved'] = sandSaved!.toJson();
    }
    if (puttsRound != null) {
      data['PuttsRound'] = puttsRound!.toJson();
    }
    if (threePuttsRound != null) {
      data['ThreePuttsRound'] = threePuttsRound!.toJson();
    }
    if (feetOfPutts != null) {
      data['FeetOfPutts'] = feetOfPutts!.toJson();
    }
    return data;
  }
}

class Recommendation {
  Strength? strength;
  Strength? weakness;

  Recommendation({this.strength, this.weakness});

  Recommendation.fromJson(Map<String, dynamic> json) {
    strength =
        json['Strength'] != null ? Strength.fromJson(json['Strength']) : null;
    weakness =
        json['Weakness'] != null ? Strength.fromJson(json['Weakness']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (strength != null) {
      data['Strength'] = strength!.toJson();
    }
    if (weakness != null) {
      data['Weakness'] = weakness!.toJson();
    }
    return data;
  }
}

class Strength {
  String? title;
  String? score;
  String? message;

  Strength({this.title, this.score, this.message});

  Strength.fromJson(Map<String, dynamic> json) {
    title = json['Title'];
    score = json['Score'];
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Title'] = title;
    data['Score'] = score;
    data['Message'] = message;
    return data;
  }
}

class ScoringAverage {
  Total? total;
  Total? par3;
  Total? par4;
  Total? par5;

  ScoringAverage({this.total, this.par3, this.par4, this.par5});

  ScoringAverage.fromJson(Map<String, dynamic> json) {
    total = json['Total'] != null ? Total.fromJson(json['Total']) : null;
    par3 = json['Par3'] != null ? Total.fromJson(json['Par3']) : null;
    par4 = json['Par4'] != null ? Total.fromJson(json['Par4']) : null;
    par5 = json['Par5'] != null ? Total.fromJson(json['Par5']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (total != null) {
      data['Total'] = total!.toJson();
    }
    if (par3 != null) {
      data['Par3'] = par3!.toJson();
    }
    if (par4 != null) {
      data['Par4'] = par4!.toJson();
    }
    if (par5 != null) {
      data['Par5'] = par5!.toJson();
    }
    return data;
  }
}

class Total {
  double? value;
  double? toPar;

  Total({this.value, this.toPar});

  Total.fromJson(Map<String, dynamic> json) {
    value = json['value'].toDouble();
    toPar = json['toPar'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['toPar'] = toPar;
    return data;
  }
}

class ScoreType {
  int? eagle;
  double? birdie;
  double? par;
  double? bogey;
  double? sdouble;

  ScoreType({this.eagle, this.birdie, this.par, this.bogey, this.sdouble});

  ScoreType.fromJson(Map<String, dynamic> json) {
    eagle = json['Eagle'];
    birdie = json['Birdie']?.toDouble();
    par = json['Par']?.toDouble();
    bogey = json['Bogey']?.toDouble();
    sdouble = json['Double']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Eagle'] = eagle;
    data['Birdie'] = birdie;
    data['Par'] = par;
    data['Bogey'] = bogey;
    data['Double'] = sdouble;
    return data;
  }
}

class TeeInPlay {
  int? min;
  int? max;
  double? goal;
  double? value;

  TeeInPlay({this.min, this.max, this.goal, this.value});

  TeeInPlay.fromJson(Map<String, dynamic> json) {
    min = json['min'];
    max = json['max'];
    goal = json['goal'];
    value = json['value'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['min'] = min;
    data['max'] = max;
    data['goal'] = goal;
    data['value'] = value;
    return data;
  }
}

class TeeFway {
  int? min;
  int? max;
  int? goal;
  double? value;

  TeeFway({this.min, this.max, this.goal, this.value});

  TeeFway.fromJson(Map<String, dynamic> json) {
    min = json['min'];
    max = json['max'];
    goal = json['goal'];
    value = json['value'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['min'] = min;
    data['max'] = max;
    data['goal'] = goal;
    data['value'] = value;
    return data;
  }
}

class SandSaved {
  int? min;
  int? max;
  int? goal;
  int? value;

  SandSaved({this.min, this.max, this.goal, this.value});

  SandSaved.fromJson(Map<String, dynamic> json) {
    min = json['min'];
    max = json['max'];
    goal = json['goal'];
    value = json['value'].toInt();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['min'] = min;
    data['max'] = max;
    data['goal'] = goal;
    data['value'] = value;
    return data;
  }
}
