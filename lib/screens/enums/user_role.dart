enum UserRole {
  USER,
  ADMIN;

  String get name {
    return toString().split('.').last;
  }
}