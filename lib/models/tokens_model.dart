/// This class is responsible for holding the custom token response from
/// 1io API.
class CustomToken {
  final String id;
  const CustomToken({required this.id});

  factory CustomToken.fromJson(Map<String, dynamic> json) {
    return CustomToken(id: json['idToken']);
  }
}

/// This class is responsible for holding the ID token response from
/// 1io API.
class IdToken {
  final String id;
  final String refreshToken;

  const IdToken({
    required this.id,
    required this.refreshToken,
  });

  factory IdToken.fromJson(Map<String, dynamic> json) {
    return IdToken(
      id: json['idToken'],
      refreshToken: json['refreshToken'],
    );
  }
}
