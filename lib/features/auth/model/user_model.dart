class UserModel {
  final String name;
  final String password;
  final String email;
  final String phone;
  final String role;
  final String onesignalId;
  final bool whatsappUpdations;

  UserModel(
      {required this.email,
      required this.name,
      required this.onesignalId,
      required this.password,
      required this.phone,
      required this.role,
      required this.whatsappUpdations});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        email: json["email"],
        name: json["name"],
        onesignalId: json["onesignal_id"],
        password: json["password"],
        phone: json["phone"],
        role: json["role"],
        whatsappUpdations: json["whatsapp_updations"]);
  }
}
