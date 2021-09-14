import 'package:groceries_shopping_app/models/models.dart';

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
  final List<UserAddress> addresses;
  final String createdAt;
  final String updatedAt;

  const User(
    this.profile, {
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
  });

  factory User.fromJsonUserData(Map<String, dynamic> json) {
    return User(
       json['profile'] as String ?? "",
      uid: json['id'] as int,
      email: json['email'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      addresses: (json['addresses'].map<UserAddress>((e) => UserAddress.fromJson(e) ).toList()) as List<UserAddress> ?? List.empty()
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
