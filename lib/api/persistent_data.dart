// used to store data that is used in multiple parts of the application.
// this is likely going to be a temporary class until a cache system is setup.
import 'auth.dart';
import '../models/auth_models.dart';
import '../models/courses_model.dart';
import '../models/round_model.dart';
import 'one_iota_api.dart';

class PersistentData {
  static Round? currentRoundEdit;
  static Course? chosenCourse;
  static Future<AccountInfo>? futureAccount;
  static AccountInfo? currentAccount;

  static Future<String> get id async {
    Auth.idToken ??= await Auth.futureToken;
    futureAccount ??= OneIotaAuth().fetchAccountInfo(token: Auth.idToken);
    currentAccount ??= await futureAccount;
    return currentAccount!.id;
  }

  // This method will be used in the round entry pages to fill the par and
  // length fields.
  static List<CourseHoleData> getCurrentCourseHoleData() {
    if (chosenCourse == null) {
      return List.filled(18, CourseHoleData());
    } else {
      return chosenCourse!.getHoleData();
    }
  }

  // This method will replace the round information received at the Rounds page
  // and replace it with the Round object with the full HoleData information.
  static Future<Round> getRoundData() async {
    if (currentRoundEdit != null) {
      currentRoundEdit = await OneIotaAuth()
          .getRound(roundId: currentRoundEdit!.roundId!, token: Auth.idToken);
      return currentRoundEdit!;
    } else {
      throw Exception("Status code - Error when getting current round details");
    }
  }

  // This method will be used to initially set the Course in the Rounds page
  // if it exists. Assumes that currentRoundEdit exists and has a courseId.
  static Future<Course> getCourseData() async {
    if (currentRoundEdit != null && currentRoundEdit!.courseId != null) {
      chosenCourse = await OneIotaAuth().getCourse(
          courseId: currentRoundEdit!.courseId!, token: Auth.idToken);
      return chosenCourse!;
    } else {
      throw Exception(
          "Status code - Error when getting current course details");
    }
  }
}
