class AdminUserModel {
  final String uid;
  final String email;
  final String? name;

  AdminUserModel({required this.uid, required this.email, this.name});

  factory AdminUserModel.fromJson(String uid, Map<String, dynamic> json) {
    return AdminUserModel(
      uid: uid,
      email: json['email'],
      name: json['name'],
    );
  }
}
