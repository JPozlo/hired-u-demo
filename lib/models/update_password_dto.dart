class UpdatePasswordDTO {
  UpdatePasswordDTO({this.password, this.newPassword});
  final String password;
  final String newPassword;

  Map<String, dynamic> toJson() => {'password': password, 'new_password': newPassword};
}
