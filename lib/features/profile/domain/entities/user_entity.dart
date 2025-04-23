/* p step 1 */
class UserEntity {
  final String uid;
  final String email;
  final String? name;
  final String? companyId;
  final String? department;
  final String? position;
  final String role;
  final String? joinDate;
  final String? lastCheckIn;

  const UserEntity({
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
}
