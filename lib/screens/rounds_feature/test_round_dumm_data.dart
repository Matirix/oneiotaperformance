import '../../models/round_model.dart';

Round testRound = Round.fromJson({
  "Id": 4614,
  "Date":
      "2023-05-02T15:30:00", // "YYYY-MM-DDTHH:MM:SS" (Time of 00:00:00 indicates the time is not set)
  "StartingHole": 1,
  "Type": "Practice", // Practice, Qualfying, Competition, Tournament
  "Wind": "Not Set", // Not Set, No Wind, 10, 20, 30, 40. 50+
  "Weather": "Not Set", // Not Set, Sunny, Light Rain, Heavy Rain, Overcast
  "Temperature": 100, // Number between -10 and 50
  "CourseId": null,
  "Comment": null, // string comment (max length 500)
  "Event": null, // eventId
  "EventRound": null, // number between 1 and 6
  "EntryType": "Mobile", // "Category", "AllStats" (web only),
  "DetailLevel": "Advanced", // "Basic",
  "InProgress": true, // Indicates if this is an attempt to finalize the round
  "PreNotable": null, // Notable object or null
  "PostNotable": null, // Notable object or null
  "HoleData": [
    {
      'holeNum': 1,
      "played": true, // true, false,
      "par": 4,
      "length": 387,
      "fairway":
          "No Shot", // Hit, Left, Right, No Shot, Hazard, Lost Ball, Miss, Penalty OR null (null is for par 3s)
      "approachDistance": 123, // null if no value
      "approachResult":
          "Hit", // Hit, Left, Right, Short, Long, No Shot OR null (null is for no entry or basic entry)
      "approachLie":
          "Fway", // Fway, Tee, Rough, Sand OR null (null is for no entry or basic entry)
      "GIR": true, // true or false when basic entry (always null for advanced)
      "chipResult": null, // null, Hit, Miss (null for basic entry or no chip)
      "sandResult": null, // null, Hit, Miss (null for basic entry or no sand)
      "chipSand":
          true, // true, false when basic entry (always null for advanced)
      "numOfPutts": 1, // 0, 1, 2, 3, 4, 5 OR null (null for no entry)
      "putt1": 18, // OR null (null for no entry or basic entry)
      "putt2": 2, // OR null (null for no entry or basic entry)
      "putt3": null, // OR a number (null for no entry or basic entry)
      "score": 10, // OR null (null for no entry)
      "notable": {
        "note": "test note",
        "impact": "Good",
        "category": "Other"
      } // Notable object or null
    },
    {
      'holeNum': 2,
      "played": true, // true, false,
      "par": 5,
      "length": 567,
      "fairway":
          "Hit", // Hit, Left, Right, No Shot, Hazard, Lost Ball, Miss, Penalty OR null (null is for par 3s)
      "approachDistance": null, // null if no value
      "approachResult":
          null, // Hit, Left, Right, Short, Long, No Shot OR null (null is for no entry or basic entry)
      "approachLie":
          null, // Fway, Tee, Rough, Sand OR null (null is for no entry or basic entry)
      "GIR": null, // true or false when basic entry (always null for advanced)
      "chipResult": 'Hit', // null, Hit, Miss (null for basic entry or no chip)
      "sandResult": null, // null, Hit, Miss (null for basic entry or no sand)
      "chipSand":
          true, // true, false when basic entry (always null for advanced)
      "numOfPutts": 0, // 0, 1, 2, 3, 4, 5 OR null (null for no entry)
      "putt1": null, // OR null (null for no entry or basic entry)
      "putt2": null, // OR null (null for no entry or basic entry)
      "putt3": null, // OR a number (null for no entry or basic entry)
      "score": 4, // OR null (null for no entry)
      "notable": null // Notable object or null
    },
    {
      'holeNum': 3,
      "played": true, // true, false,
      "par": 4,
      "length": 465,
      "fairway":
          "Left", // Hit, Left, Right, No Shot, Hazard, Lost Ball, Miss, Penalty OR null (null is for par 3s)
      "approachDistance": null, // null if no value
      "approachResult":
          null, // Hit, Left, Right, Short, Long, No Shot OR null (null is for no entry or basic entry)
      "approachLie":
          'Tee', // Fway, Tee, Rough, Sand OR null (null is for no entry or basic entry)
      "GIR": null, // true or false when basic entry (always null for advanced)
      "chipResult": null, // null, Hit, Miss (null for basic entry or no chip)
      "sandResult": 'Hit', // null, Hit, Miss (null for basic entry or no sand)
      "chipSand":
          null, // true, false when basic entry (always null for advanced)
      "numOfPutts": 4, // 0, 1, 2, 3, 4, 5 OR null (null for no entry)
      "putt1": 15, // OR null (null for no entry or basic entry)
      "putt2": 20, // OR null (null for no entry or basic entry)
      "putt3": null, // OR a number (null for no entry or basic entry)
      "score": 3, // OR null (null for no entry)
      "notable": null // Notable object or null
    },
    {
      'holeNum': 4,
      "played": false, // true, false,
      "par": 3,
      "length": 167,
      "fairway":
          "No Shot", // Hit, Left, Right, No Shot, Hazard, Lost Ball, Miss, Penalty OR null (null is for par 3s)
      "approachDistance": null, // null if no value
      "approachResult":
          null, // Hit, Left, Right, Short, Long, No Shot OR null (null is for no entry or basic entry)
      "approachLie":
          null, // Fway, Tee, Rough, Sand OR null (null is for no entry or basic entry)
      "GIR": null, // true or false when basic entry (always null for advanced)
      "chipResult": null, // null, Hit, Miss (null for basic entry or no chip)
      "sandResult": null, // null, Hit, Miss (null for basic entry or no sand)
      "chipSand":
          null, // true, false when basic entry (always null for advanced)
      "numOfPutts": 2, // 0, 1, 2, 3, 4, 5 OR null (null for no entry)
      "putt1": null, // OR null (null for no entry or basic entry)
      "putt2": null, // OR null (null for no entry or basic entry)
      "putt3": null, // OR a number (null for no entry or basic entry)
      "score": 1, // OR null (null for no entry)
      "notable": null // Notable object or null
    },
    {
      'holeNum': 5,
      "played": false, // true, false,
      "par": 4,
      "length": 378,
      "fairway":
          "No Shot", // Hit, Left, Right, No Shot, Hazard, Lost Ball, Miss, Penalty OR null (null is for par 3s)
      "approachDistance": null, // null if no value
      "approachResult":
          null, // Hit, Left, Right, Short, Long, No Shot OR null (null is for no entry or basic entry)
      "approachLie":
          null, // Fway, Tee, Rough, Sand OR null (null is for no entry or basic entry)
      "GIR": null, // true or false when basic entry (always null for advanced)
      "chipResult": null, // null, Hit, Miss (null for basic entry or no chip)
      "sandResult": null, // null, Hit, Miss (null for basic entry or no sand)
      "chipSand":
          null, // true, false when basic entry (always null for advanced)
      "numOfPutts": 3, // 0, 1, 2, 3, 4, 5 OR null (null for no entry)
      "putt1": null, // OR null (null for no entry or basic entry)
      "putt2": null, // OR null (null for no entry or basic entry)
      "putt3": null, // OR a number (null for no entry or basic entry)
      "score": 2, // OR null (null for no entry)
      "notable": null // Notable object or null
    },
    {
      'holeNum': 6,
      "played": true, // true, false,
      "par": 4,
      "length": 410,
      "fairway":
          "Hit", // Hit, Left, Right, No Shot, Hazard, Lost Ball, Miss, Penalty OR null (null is for par 3s)
      "approachDistance": null, // null if no value
      "approachResult":
          null, // Hit, Left, Right, Short, Long, No Shot OR null (null is for no entry or basic entry)
      "approachLie":
          null, // Fway, Tee, Rough, Sand OR null (null is for no entry or basic entry)
      "GIR": null, // true or false when basic entry (always null for advanced)
      "chipResult": null, // null, Hit, Miss (null for basic entry or no chip)
      "sandResult": null, // null, Hit, Miss (null for basic entry or no sand)
      "chipSand":
          null, // true, false when basic entry (always null for advanced)
      "numOfPutts": 1, // 0, 1, 2, 3, 4, 5 OR null (null for no entry)
      "putt1": 10, // OR null (null for no entry or basic entry)
      "putt2": null, // OR null (null for no entry or basic entry)
      "putt3": null, // OR a number (null for no entry or basic entry)
      "score": 3, // OR null (null for no entry)
      "notable": null // Notable object or null
    },
    {
      'holeNum': 7,
      "played": true, // true, false,
      "par": 3,
      "length": 221,
      "fairway":
          "Hit", // Hit, Left, Right, No Shot, Hazard, Lost Ball, Miss, Penalty OR null (null is for par 3s)
      "approachDistance": null, // null if no value
      "approachResult":
          null, // Hit, Left, Right, Short, Long, No Shot OR null (null is for no entry or basic entry)
      "approachLie":
          null, // Fway, Tee, Rough, Sand OR null (null is for no entry or basic entry)
      "GIR": null, // true or false when basic entry (always null for advanced)
      "chipResult": null, // null, Hit, Miss (null for basic entry or no chip)
      "sandResult": null, // null, Hit, Miss (null for basic entry or no sand)
      "chipSand":
          null, // true, false when basic entry (always null for advanced)
      "numOfPutts": 5, // 0, 1, 2, 3, 4, 5 OR null (null for no entry)
      "putt1": 20, // OR null (null for no entry or basic entry)
      "putt2": 40, // OR null (null for no entry or basic entry)
      "putt3": 60, // OR a number (null for no entry or basic entry)
      "score": 2, // OR null (null for no entry)
      "notable": null // Notable object or null
    },
    {
      'holeNum': 8,
      "played": true, // true, false,
      "par": 5,
      "length": 554,
      "fairway":
          "Hit", // Hit, Left, Right, No Shot, Hazard, Lost Ball, Miss, Penalty OR null (null is for par 3s)
      "approachDistance": null, // null if no value
      "approachResult":
          null, // Hit, Left, Right, Short, Long, No Shot OR null (null is for no entry or basic entry)
      "approachLie":
          null, // Fway, Tee, Rough, Sand OR null (null is for no entry or basic entry)
      "GIR": null, // true or false when basic entry (always null for advanced)
      "chipResult": null, // null, Hit, Miss (null for basic entry or no chip)
      "sandResult": null, // null, Hit, Miss (null for basic entry or no sand)
      "chipSand":
          null, // true, false when basic entry (always null for advanced)
      "numOfPutts": 1, // 0, 1, 2, 3, 4, 5 OR null (null for no entry)
      "putt1": 80, // OR null (null for no entry or basic entry)
      "putt2": null, // OR null (null for no entry or basic entry)
      "putt3": null, // OR a number (null for no entry or basic entry)
      "score": 5, // OR null (null for no entry)
      "notable": null // Notable object or null
    },
    {
      'holeNum': 9,
      "played": true, // true, false,
      "par": 4,
      "length": 434,
      "fairway":
          "Hit", // Hit, Left, Right, No Shot, Hazard, Lost Ball, Miss, Penalty OR null (null is for par 3s)
      "approachDistance": null, // null if no value
      "approachResult":
          null, // Hit, Left, Right, Short, Long, No Shot OR null (null is for no entry or basic entry)
      "approachLie":
          null, // Fway, Tee, Rough, Sand OR null (null is for no entry or basic entry)
      "GIR": null, // true or false when basic entry (always null for advanced)
      "chipResult": null, // null, Hit, Miss (null for basic entry or no chip)
      "sandResult": null, // null, Hit, Miss (null for basic entry or no sand)
      "chipSand":
          null, // true, false when basic entry (always null for advanced)
      "numOfPutts": 2, // 0, 1, 2, 3, 4, 5 OR null (null for no entry)
      "putt1": 55, // OR null (null for no entry or basic entry)
      "putt2": 65, // OR null (null for no entry or basic entry)
      "putt3": null, // OR a number (null for no entry or basic entry)
      "score": 2, // OR null (null for no entry)
      "notable": null // Notable object or null
    },
    {
      'holeNum': 10,
      "played": true, // true, false,
      "par": 4,
      "length": 334,
      "fairway":
          "Hit", // Hit, Left, Right, No Shot, Hazard, Lost Ball, Miss, Penalty OR null (null is for par 3s)
      "approachDistance": null, // null if no value
      "approachResult":
          null, // Hit, Left, Right, Short, Long, No Shot OR null (null is for no entry or basic entry)
      "approachLie":
          null, // Fway, Tee, Rough, Sand OR null (null is for no entry or basic entry)
      "GIR": null, // true or false when basic entry (always null for advanced)
      "chipResult": 'Miss', // null, Hit, Miss (null for basic entry or no chip)
      "sandResult": 'Miss', // null, Hit, Miss (null for basic entry or no sand)
      "chipSand":
          null, // true, false when basic entry (always null for advanced)
      "numOfPutts": 1, // 0, 1, 2, 3, 4, 5 OR null (null for no entry)
      "putt1": 20, // OR null (null for no entry or basic entry)
      "putt2": null, // OR null (null for no entry or basic entry)
      "putt3": null, // OR a number (null for no entry or basic entry)
      "score": 3, // OR null (null for no entry)
      "notable": null // Notable object or null
    },
    {
      'holeNum': 11,
      "played": true, // true, false,
      "par": 4,
      "length": 536,
      "fairway":
          "Hit", // Hit, Left, Right, No Shot, Hazard, Lost Ball, Miss, Penalty OR null (null is for par 3s)
      "approachDistance": null, // null if no value
      "approachResult":
          "Hit", // Hit, Left, Right, Short, Long, No Shot OR null (null is for no entry or basic entry)
      "approachLie":
          null, // Fway, Tee, Rough, Sand OR null (null is for no entry or basic entry)
      "GIR": null, // true or false when basic entry (always null for advanced)
      "chipResult": null, // null, Hit, Miss (null for basic entry or no chip)
      "sandResult": null, // null, Hit, Miss (null for basic entry or no sand)
      "chipSand":
          null, // true, false when basic entry (always null for advanced)
      "numOfPutts": 0, // 0, 1, 2, 3, 4, 5 OR null (null for no entry)
      "putt1": null, // OR null (null for no entry or basic entry)
      "putt2": null, // OR null (null for no entry or basic entry)
      "putt3": null, // OR a number (null for no entry or basic entry)
      "score": 3, // OR null (null for no entry)
      "notable": null // Notable object or null
    },
    {
      'holeNum': 12,
      "played": true, // true, false,
      "par": 4,
      "length": 458,
      "fairway":
          "Hit", // Hit, Left, Right, No Shot, Hazard, Lost Ball, Miss, Penalty OR null (null is for par 3s)
      "approachDistance": null, // null if no value
      "approachResult":
          null, // Hit, Left, Right, Short, Long, No Shot OR null (null is for no entry or basic entry)
      "approachLie":
          null, // Fway, Tee, Rough, Sand OR null (null is for no entry or basic entry)
      "GIR": null, // true or false when basic entry (always null for advanced)
      "chipResult": null, // null, Hit, Miss (null for basic entry or no chip)
      "sandResult": null, // null, Hit, Miss (null for basic entry or no sand)
      "chipSand":
          null, // true, false when basic entry (always null for advanced)
      "numOfPutts": 2, // 0, 1, 2, 3, 4, 5 OR null (null for no entry)
      "putt1": 70, // OR null (null for no entry or basic entry)
      "putt2": 35, // OR null (null for no entry or basic entry)
      "putt3": null, // OR a number (null for no entry or basic entry)
      "score": 2, // OR null (null for no entry)
      "notable": null // Notable object or null
    },
    {
      'holeNum': 13,
      "played": true, // true, false,
      "par": 3,
      "length": 194,
      "fairway":
          "Hit", // Hit, Left, Right, No Shot, Hazard, Lost Ball, Miss, Penalty OR null (null is for par 3s)
      "approachDistance": null, // null if no value
      "approachResult":
          null, // Hit, Left, Right, Short, Long, No Shot OR null (null is for no entry or basic entry)
      "approachLie":
          null, // Fway, Tee, Rough, Sand OR null (null is for no entry or basic entry)
      "GIR": null, // true or false when basic entry (always null for advanced)
      "chipResult": null, // null, Hit, Miss (null for basic entry or no chip)
      "sandResult": null, // null, Hit, Miss (null for basic entry or no sand)
      "chipSand":
          null, // true, false when basic entry (always null for advanced)
      "numOfPutts": 1, // 0, 1, 2, 3, 4, 5 OR null (null for no entry)
      "putt1": 77, // OR null (null for no entry or basic entry)
      "putt2": null, // OR null (null for no entry or basic entry)
      "putt3": null, // OR a number (null for no entry or basic entry)
      "score": 7, // OR null (null for no entry)
      "notable": null // Notable object or null
    },
    {
      'holeNum': 14,
      "played": true, // true, false,
      "par": 4,
      "length": 368,
      "fairway":
          "Left", // Hit, Left, Right, No Shot, Hazard, Lost Ball, Miss, Penalty OR null (null is for par 3s)
      "approachDistance": null, // null if no value
      "approachResult":
          "Long", // Hit, Left, Right, Short, Long, No Shot OR null (null is for no entry or basic entry)
      "approachLie":
          "Fway", // Fway, Tee, Rough, Sand OR null (null is for no entry or basic entry)
      "GIR": null, // true or false when basic entry (always null for advanced)
      "chipResult": null, // null, Hit, Miss (null for basic entry or no chip)
      "sandResult": null, // null, Hit, Miss (null for basic entry or no sand)
      "chipSand":
          null, // true, false when basic entry (always null for advanced)
      "numOfPutts": 1, // 0, 1, 2, 3, 4, 5 OR null (null for no entry)
      "putt1": 50, // OR null (null for no entry or basic entry)
      "putt2": null, // OR null (null for no entry or basic entry)
      "putt3": null, // OR a number (null for no entry or basic entry)
      "score": 2, // OR null (null for no entry)
      "notable": null // Notable object or null
    },
    {
      'holeNum': 15,
      "played": true, // true, false,
      "par": 4,
      "length": 440,
      "fairway":
          "Hit", // Hit, Left, Right, No Shot, Hazard, Lost Ball, Miss, Penalty OR null (null is for par 3s)
      "approachDistance": null, // null if no value
      "approachResult":
          null, // Hit, Left, Right, Short, Long, No Shot OR null (null is for no entry or basic entry)
      "approachLie":
          null, // Fway, Tee, Rough, Sand OR null (null is for no entry or basic entry)
      "GIR": null, // true or false when basic entry (always null for advanced)
      "chipResult": null, // null, Hit, Miss (null for basic entry or no chip)
      "sandResult": null, // null, Hit, Miss (null for basic entry or no sand)
      "chipSand":
          null, // true, false when basic entry (always null for advanced)
      "numOfPutts": 2, // 0, 1, 2, 3, 4, 5 OR null (null for no entry)
      "putt1": 68, // OR null (null for no entry or basic entry)
      "putt2": 47, // OR null (null for no entry or basic entry)
      "putt3": null, // OR a number (null for no entry or basic entry)
      "score": 3, // OR null (null for no entry)
      "notable": null // Notable object or null
    },
    {
      'holeNum': 16,
      "played": true, // true, false,
      "par": 4,
      "length": 452,
      "fairway":
          "Hit", // Hit, Left, Right, No Shot, Hazard, Lost Ball, Miss, Penalty OR null (null is for par 3s)
      "approachDistance": null, // null if no value
      "approachResult":
          null, // Hit, Left, Right, Short, Long, No Shot OR null (null is for no entry or basic entry)
      "approachLie":
          null, // Fway, Tee, Rough, Sand OR null (null is for no entry or basic entry)
      "GIR": null, // true or false when basic entry (always null for advanced)
      "chipResult": null, // null, Hit, Miss (null for basic entry or no chip)
      "sandResult": null, // null, Hit, Miss (null for basic entry or no sand)
      "chipSand":
          null, // true, false when basic entry (always null for advanced)
      "numOfPutts": 3, // 0, 1, 2, 3, 4, 5 OR null (null for no entry)
      "putt1": null, // OR null (null for no entry or basic entry)
      "putt2": null, // OR null (null for no entry or basic entry)
      "putt3": null, // OR a number (null for no entry or basic entry)
      "score": 1, // OR null (null for no entry)
      "notable": null // Notable object or null
    },
    {
      'holeNum': 17,
      "played": true, // true, false,
      "par": 3,
      "length": 234,
      "fairway":
          "Hit", // Hit, Left, Right, No Shot, Hazard, Lost Ball, Miss, Penalty OR null (null is for par 3s)
      "approachDistance": null, // null if no value
      "approachResult":
          null, // Hit, Left, Right, Short, Long, No Shot OR null (null is for no entry or basic entry)
      "approachLie":
          null, // Fway, Tee, Rough, Sand OR null (null is for no entry or basic entry)
      "GIR": null, // true or false when basic entry (always null for advanced)
      "chipResult": null, // null, Hit, Miss (null for basic entry or no chip)
      "sandResult": null, // null, Hit, Miss (null for basic entry or no sand)
      "chipSand":
          null, // true, false when basic entry (always null for advanced)
      "numOfPutts": 1, // 0, 1, 2, 3, 4, 5 OR null (null for no entry)
      "putt1": 88, // OR null (null for no entry or basic entry)
      "putt2": null, // OR null (null for no entry or basic entry)
      "putt3": null, // OR a number (null for no entry or basic entry)
      "score": 4, // OR null (null for no entry)
      "notable": null // Notable object or null
    },
    {
      'holeNum': 18,
      "played": true, // true, false,
      "par": 5,
      "length": 549,
      "fairway":
          "Hit", // Hit, Left, Right, No Shot, Hazard, Lost Ball, Miss, Penalty OR null (null is for par 3s)
      "approachDistance": null, // null if no value
      "approachResult":
          null, // Hit, Left, Right, Short, Long, No Shot OR null (null is for no entry or basic entry)
      "approachLie":
          null, // Fway, Tee, Rough, Sand OR null (null is for no entry or basic entry)
      "GIR": null, // true or false when basic entry (always null for advanced)
      "chipResult": null, // null, Hit, Miss (null for basic entry or no chip)
      "sandResult": null, // null, Hit, Miss (null for basic entry or no sand)
      "chipSand":
          null, // true, false when basic entry (always null for advanced)
      "numOfPutts": 0, // 0, 1, 2, 3, 4, 5 OR null (null for no entry)
      "putt1": null, // OR null (null for no entry or basic entry)
      "putt2": null, // OR null (null for no entry or basic entry)
      "putt3": null, // OR a number (null for no entry or basic entry)
      "score": null, // OR null (null for no entry)
      "notable": null // Notable object or null
    }
  ]
});
