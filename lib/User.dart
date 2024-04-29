class UserProfile {
  String email;
  // String username;
  // String password;
  String accountType;

  UserProfile({
    required this.email,
    // required this.username,
    // required this.password,
    required this.accountType,
  });

  // Convert User object to a Map
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      // 'username': username,
      // 'password': password,
      'accountType': accountType,
    };
  }

  // Create a User object from a Map
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    print(map['accountType']);
    print(map['email']);

    return UserProfile(
      email: map['email'],
      // username: map['username'],
      // password: map['password'],
      accountType: map['accountType'],
    );
  }
}
