/* p step 2 */

import 'package:cicoattendance/features/profile/domain/entities/user_entity.dart';

class UserModel {
  final String uid;
  final String email;
  final String? name;
  final String? companyId;
  final String? department;
  final String? position;
  final String role;
  final String? joinDate;
  final String? lastCheckIn;

  const UserModel({
    required this.uid,
    required this.email,
    this.name,
    this.companyId,
    this.department,
    this.position,
    required this.role,
    this.joinDate,
    this.lastCheckIn,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String uid) {
    return UserModel(
      uid: uid,
      email: json['email'] ?? '',
      name: json['name'],
      companyId: json['company_id'],
      department: json['department'],
      position: json['position'],
      role: json['role'] ?? 'user',
      joinDate: json['join_date'],
      lastCheckIn: json['last_check_in'],
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      email: email,
      name: name,
      companyId: companyId,
      department: department,
      position: position,
      role: role,
      joinDate: joinDate,
      lastCheckIn: lastCheckIn,
    );
  }
}
