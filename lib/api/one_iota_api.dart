import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:one_iota_mobile_app/models/summary.dart';
import 'package:one_iota_mobile_app/api/persistent_data.dart';

import 'api_key.dart';
import 'auth.dart';

import 'package:http/http.dart' as http;

import '../models/auth_models.dart';
import '../models/courses_model.dart';
import '../models/event_models.dart';
import '../models/habit_data_model.dart';
import '../models/round_model.dart';
import '../models/tokens_model.dart';

///This class has methods related to usage of the 1io API.
class OneIotaAuth {
  final String authURL = "https://staging.oneiotaperformance.com/auth";
  final String apiURL = "https://staging.oneiotaperformance.com/api/v1";
  final String fbAuthURL =
      "https://identitytoolkit.googleapis.com/v1/accounts:signInWithCustomToken?key=";

  Future<CustomToken> fetchCustomTokenWithCreds({
    required String email,
    required String password,
  }) async {
    final response = await http.post(Uri.parse('$authURL/signin'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }));
    if (response.statusCode == 200) {
      return CustomToken.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          "Status code ${response.statusCode} - Error when fetching custom token");
    }
  }

  Future<void> updateProfilePicture(
      {required IdToken token, required String imageUrl}) async {
    Map<String, String> body = {
      'photoUrl': imageUrl,
    };

    final response = await http.put(Uri.parse('$apiURL/profile/image'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token.id}',
        },
        body: jsonEncode(body));
    print(response.statusCode);
    print('response: ${response.body}');
    if (response.statusCode == 200) {
      print("Profile picture updated");
      return;
    } else {
      throw Exception(
          "Status code ${response.statusCode} - Error when updating picture");
    }
  }

  Future<IdToken> fetchIdToken({required String customToken}) async {
    final response = await http.post(Uri.parse('$fbAuthURL$fireBaseApiKey'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'token': customToken,
          'returnSecureToken': true,
        }));
    if (response.statusCode == 200) {
      return IdToken.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          "Status code ${response.statusCode} - Error when fetching ID token");
    }
  }

  Future<AccountInfo> fetchAccountInfo({required IdToken? token}) async {
    token ??= await Auth.futureToken;
    token = await refreshToken(refreshToken: token!.refreshToken);
    final response = await http.get(
      Uri.parse('$apiURL/profile'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token.id}',
      },
    );
    if (response.statusCode == 200) {
      PersistentData.currentAccount =
          AccountInfo.fromJson(jsonDecode(response.body));
      return PersistentData.currentAccount!;
    } else {
      throw Exception(
          "Status code ${response.statusCode} - Error when fetching Account Info");
    }
  }

  Future<IdToken> refreshToken({required String refreshToken}) async {
    final response = await http.post(
        Uri.parse(
            'https://securetoken.googleapis.com/v1/token?key=$fireBaseApiKey'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'grant_type': 'refresh_token',
          'refresh_token': refreshToken,
        }));
    if (response.statusCode == 200) {
      dynamic responseJson = jsonDecode(response.body);
      IdToken newToken = IdToken(
          id: responseJson['id_token'],
          refreshToken: responseJson['refresh_token']);
      return newToken;
    } else {
      throw Exception(
          "Status code ${response.statusCode} - Error when refreshing ID token");
    }
  }

  Future<List<Round>> getRounds({required IdToken? token}) async {
    token ??= await Auth.futureToken;
    token = await refreshToken(refreshToken: token!.refreshToken);
    String uid = await PersistentData.id;
    final response = await http.get(
      Uri.parse('$apiURL/golf/round?subjects=$uid&limit=14&inProgress=true'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token.id}',
      },
    );
    if (response.statusCode == 200) {
      List<Round> rounds = jsonDecode(response.body)['Rounds']
          .map((data) => Round.fromJson(data))
          .toList()
          .cast<Round>();

      // for (var element in rounds) {
      //   print("ID: ${element.roundId} Round Comment: ${element.comment}");
      // }

      return rounds;
    } else {
      throw Exception(
          "Status code ${response.statusCode} - Error when getting Rounds");
    }
  }

  Future<Analysis> getAnalysisSummary({required IdToken? token}) async {
    token ??= await Auth.futureToken;
    token = await refreshToken(refreshToken: token!.refreshToken);
    final response = await http.get(
      Uri.parse('$apiURL/dashboard/summary'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token.id}',
      },
    );
    if (response.statusCode == 200) {
      Analysis analysis =
          Analysis.fromJson(jsonDecode(response.body)['Analysis']['data']);
      return analysis;
    } else {
      throw Exception(
          "Status code ${response.statusCode} - Error when getting Analysis");
    }
  }

  Future<Data> getAnalysisSummaryData({required IdToken? token}) async {
    token ??= await Auth.futureToken;
    token = await refreshToken(refreshToken: token!.refreshToken);
    // print("Getting Analysis");
    final response = await http.get(
      Uri.parse('$apiURL/dashboard/summary'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token.id}',
      },
    );
    if (response.statusCode == 200) {
      // print("Success getting Analysis");
      Data analysisData =
          Data.fromJson(jsonDecode(response.body)['Analysis']['data']);
      return analysisData;
    } else {
      throw Exception(
          "Status code ${response.statusCode} - Error when getting Analysis");
    }
  }

  Future<List<HabitData>> getHabits({required IdToken? token}) async {
    token ??= await Auth.futureToken;
    token = await refreshToken(refreshToken: token!.refreshToken);
    // TODO Fetch the last 7 days, instead of the whole list.
    final response = await http.get(
      Uri.parse(
          '$apiURL/tracking/daily/do?startdate=2023-04-20&enddate=2023-05-02'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token.id}',
      },
    );
    if (response.statusCode == 200) {
      // print(jsonDecode(response.body)['AthleteData']);
      List<HabitData> habits = jsonDecode(response.body)['AthleteData']
          .map((data) => HabitData.fromJson(data))
          .toList()
          .cast<HabitData>();
      // print(habits);

      // for (var element in rounds) {
      //   print("Round ID: ${element.id}");
      // }

      return habits;
    } else {
      throw Exception(
          "Status code ${response.statusCode} - Error when getting Habits");
    }
  }

  /// Returns a habit for a specific date
  Future<HabitData?> getSpecificHabit(
      {required IdToken? token, DateTime? date}) async {
    token ??= await Auth.futureToken;
    token = await refreshToken(refreshToken: token!.refreshToken);
    var formatter = DateFormat('yyyy-MM-dd');
    final tomorrow = date!.add(const Duration(days: 1));

    var formattedDate = formatter.format(date);
    var formattedTomorrow = formatter.format(tomorrow);

    final response = await http.get(
      Uri.parse(
          // '$apiURL/tracking/daily/do?startdate=2023-05-022&enddate=2023-05-23'),
          '$apiURL/tracking/daily/do?startdate=$formattedDate&enddate=$formattedTomorrow'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token.id}',
      },
    );
    if (response.statusCode == 200) {
      List<HabitData> habits = jsonDecode(response.body)['AthleteData']
          .map((data) => HabitData.fromJson(data))
          .toList()
          .cast<HabitData>(); // print(habit.toString());
      // HabitData habit = jsonDecode(response.body)["AthleteData"][0];
      // print(habit);
      if (habits.isEmpty) {
        return null;
      } else {
        return habits[0];
      }
    } else {
      throw Exception(
          "Status code ${response.statusCode} - Error when getting Habits");
    }
  }

  Future<HabitData?> getHabitv2({required IdToken? token, date}) async {
    token ??= await Auth.futureToken;
    token = await refreshToken(refreshToken: token!.refreshToken);
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    final tomorrow = now.add(const Duration(days: 1));

    var formattedDate = formatter.format(now);
    var formattedTomorrow = formatter.format(tomorrow);

    final response = await http.get(
      Uri.parse(
          // '$apiURL/tracking/daily/do?startdate=2023-04-24&enddate=2023-04-25'),
          '$apiURL/tracking/daily/do?startdate=$formattedDate&enddate=$formattedTomorrow'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token.id}',
      },
    );
    if (response.statusCode == 200) {
      // // List<HabitData> habit = jsonDecode(response.body)['AthleteData']
      // //     .map((data) => HabitData.fromJson(data))
      // //     .toList()
      // //     .cast<HabitData>(); // print(habit.toString());
      // HabitData habit = jsonDecode(response.body)["AthleteData"][0];
      // // print(habit);
      // // print(habits);
      // return habit;
      var responseData = jsonDecode(response.body)["AthleteData"];
      // print(responseData);
      if (responseData.isNotEmpty) {
        print(responseData.isNotEmpty);
        HabitData habit = responseData[0];
        print(habit);
        return habit;
      } else {
        return null;
      }
    } else {
      throw Exception(
          "Status code ${response.statusCode} - Error when getting Habits");
    }
  }

  Future<void> updateHabit(
      {required IdToken? token, required HabitData updateHabit}) async {
    token ??= await Auth.futureToken;
    token = await refreshToken(refreshToken: token!.refreshToken);
    final response = await http.put(
      Uri.parse('$apiURL/tracking/daily/do'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token.id}',
      },
      body: jsonEncode(updateHabit),
    );
    if (response.statusCode == 200) {
      print("success");
      return;
    } else {
      throw Exception(
          "Status code ${response.statusCode} - Error when updating Habit");
    }
  }

  Future<Round> getRound(
      {required int roundId, required IdToken? token}) async {
    token ??= await Auth.futureToken;
    token = await refreshToken(refreshToken: token!.refreshToken);
    final response = await http.get(
      Uri.parse('$apiURL/golf/round/$roundId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token.id}',
      },
    );
    if (response.statusCode == 200) {
      return Round.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          "Status code ${response.statusCode} - Error when getting Rounds");
    }
  }

  Future<List<HabitData>> get7daysHabits({required IdToken? token}) async {
    token ??= await Auth.futureToken;
    token = await refreshToken(refreshToken: token!.refreshToken);
    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    var formattedDate = formatter.format(now);
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    final response = await http.get(
      Uri.parse(
          '$apiURL/tracking/daily/do?startdate=$sevenDaysAgo&enddate=$formattedDate'),
      // '$apiURL/api/v1/tracking/daily/do?startdate=2023-04-20&enddate=2023-05-02'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token.id}',
      },
    );
    if (response.statusCode == 200) {
      // print(jsonDecode(response.body)['AthleteData']);
      List<HabitData> habits = jsonDecode(response.body)['AthleteData']
          .map((data) => HabitData.fromJson(data))
          .toList()
          .cast<HabitData>();
      // print(habits);

      // for (var element in rounds) {
      //   print("Round ID: ${element.id}");
      // }

      return habits;
    } else {
      throw Exception(
          "Status code ${response.statusCode} - Error when getting Habits");
    }
  }

  Future<int> addRound(
      {required IdToken? token, required Round newRound}) async {
    token ??= await Auth.futureToken;
    token = await refreshToken(refreshToken: token!.refreshToken);
    final response = await http.post(
      Uri.parse('$apiURL/golf/round'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token.id}',
      },
      body: jsonEncode(newRound),
    );
    print("code: ${response.statusCode}");
    print(response.body);
    if (response.statusCode == 200) {
      print("added round");
      return jsonDecode(response.body)['Id'];
    } else {
      throw Exception(
          "Status code ${response.statusCode} - Error when adding new Round");
    }
  }

  Future<void> updateRound(
      {required IdToken? token, required Round updateRound}) async {
    token ??= await Auth.futureToken;
    token = await refreshToken(refreshToken: token!.refreshToken);
    final response = await http.put(
      Uri.parse('$apiURL/golf/round'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token.id}',
      },
      body: jsonEncode(updateRound),
    );
    print(response.statusCode);
    print('response: ${response.body}');
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception(
          "Status code ${response.statusCode} - Error when updating Round");
    }
  }

  Future<void> deleteRound(
      {required IdToken? token, required int roundId}) async {
    token ??= await Auth.futureToken;
    token = await refreshToken(refreshToken: token!.refreshToken);
    final response = await http.delete(Uri.parse('$apiURL/golf/round'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token.id}',
        },
        body: jsonEncode(<String, int>{
          'roundId': roundId,
        }));
    if (response.statusCode == 200) {
      print('deleted');
      return;
    } else {
      throw Exception(
          "Status code ${response.statusCode} - Error when deleting a Round");
    }
  }

  Future<List<Event>> getEvents({required IdToken? token}) async {
    token ??= await Auth.futureToken;
    token = await refreshToken(refreshToken: token!.refreshToken);
    final response = await http.get(
      Uri.parse('$apiURL/event'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token.id}',
      },
    );
    if (response.statusCode == 200) {
      List<Event> events = jsonDecode(response.body)['events']
          .map((data) => Event.fromJson(data))
          .toList()
          .cast<Event>();

      // for (var element in events) {
      //   print("ID: ${element.eventId} Event Name: ${element.name}");
      // }

      return events;
    } else {
      throw Exception(
          "Status code ${response.statusCode} - Error when getting Events");
    }
  }

  Future<List<Course>> getCourses({required IdToken? token}) async {
    token ??= await Auth.futureToken;
    token = await refreshToken(refreshToken: token!.refreshToken);
    final response = await http.get(
      Uri.parse('$apiURL/golf/course/all'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token.id}',
      },
    );
    if (response.statusCode == 200) {
      List<Course> events = jsonDecode(response.body)['Courses']
          .map((data) => Course.fromJson(data))
          .toList()
          .cast<Course>();

      // for (var element in events) {
      //   print("ID: ${element.id} Event Name: ${element.name}");
      // }
      return events;
    } else {
      throw Exception(
          "Status code ${response.statusCode} - Error when getting Events");
    }
  }

  Future<Course> getCourse(
      {required IdToken? token, required int courseId}) async {
    token ??= await Auth.futureToken;
    token = await refreshToken(refreshToken: token!.refreshToken);
    final response = await http.get(
      Uri.parse('$apiURL/golf/course/info?courseId=$courseId'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${token.id}',
      },
    );
    if (response.statusCode == 200) {
      return Course.fromJson(jsonDecode(response.body)['Course']);
    } else {
      throw Exception(
          "Status code ${response.statusCode} - Error when getting Events");
    }
  }
}

// Helper method to ensure numbers are received and stored as double type
double? _ensureDouble(dynamic number) {
  return number is int ? (number).toDouble() : number;
}
