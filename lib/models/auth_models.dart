/// This class models the object returned by the fetchAccountInfo method.
class AccountInfo {
  String id;
  String name;
  String userType;
  String accountType;
  dynamic config;
  String? photoUrl;

  AccountInfo(
      {required this.id,
      required this.name,
      required this.userType,
      required this.accountType,
      required this.config,
      required this.photoUrl});

  factory AccountInfo.fromJson(Map<String, dynamic> json) {
    return AccountInfo(
      id: json['Id'],
      name: json['Name'],
      userType: json['UserType'],
      accountType: json['AccountType'],
      config: json['Configs'],
      photoUrl: json['PhotoUrl'],
    );
  }
  Map toJson() => {
        'Id': id,
        'Name': name,
        'UserType': userType,
        'AccountType': accountType,
        'Configs': config,
        'PhotoUrl': photoUrl,
      };
}
