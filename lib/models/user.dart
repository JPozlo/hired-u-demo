class User {
  final int uid;
  final String email;
  final String name;
  final String phone;
  final String password;
  final String confirmPassword;
  final String token;
  final String deviceName;
  final String emailVerifiedAt;
  final String profile;
  final List<String> addresses;
  final String createdAt;
  final String updatedAt;

  const User({
    this.email,
    this.name,
    this.phone,
    this.uid,
    this.addresses,
    this.password,
    this.confirmPassword,
    this.deviceName,
    this.token,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.profile,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        uid: json['id'] as int,
        email: json['email'] as String,
        name: json['name'] as String,
        phone: json['phone'] as String,
        password: json['password'] as String,
        confirmPassword: json['password_confirmation'] as String,
        token: json['token'] as String,
        deviceName: json['device_name'] as String);
  }

  // factory User.fromJsonData(Map<String, dynamic> json) {
  //   return User(
  //     uid: json['id'] as int,
  //     email: json['email'] as String,
  //     name: json['name'] as String,
  //     phone: json['phone'] as String,
  //     profile: json['profile'] as String ?? "",
  //     createdAt: json['created_at'] as String,
  //     updatedAt: json['updated_at'] as String,
  //   );
  // }

  factory User.fromJsonUserData(Map<String, dynamic> json) {
    return User(
      uid: json['id'] as int,
      email: json['email'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      profile: json['profile'] as String ?? "",
      addresses: json['addresses'] as List<String> ?? List.empty(),
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
        'addresses': addresses,
        'password': password,
        'device_name': deviceName
      };

  @override
  String toString() {
    return 'User{uid: $uid, email: $email, phone: $phone, name: $name, addresses: $addresses}';
  }
}
