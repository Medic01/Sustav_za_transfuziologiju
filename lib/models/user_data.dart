import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/enums/blood_types.dart';

class UserData {
  final String? id;
  final String name;
  final String surname;
  final String email;
  final String uniqueCitizensId;
  final String dateOfBirth;
  final String address;
  final String city;
  final String phoneNumber;
  final BloodTypes? bloodType;
  final String gender;
  final bool isFirstLogin;

  UserData({
    this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.uniqueCitizensId,
    required this.dateOfBirth,
    required this.address,
    required this.city,
    required this.phoneNumber,
    this.bloodType,
    required this.gender,
    required this.isFirstLogin,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'surname': surname,
      'unique_citizens_id': uniqueCitizensId,
      'date_of_birth': dateOfBirth,
      'address': address,
      'city': city,
      'phone_number': phoneNumber,
      'blood_type': bloodType != null ? bloodType.toString().split('.').last : null,
      'gender': gender,
      'is_first_login': isFirstLogin,
    };
  }

  UserData.fromMap(Map<String, dynamic> data)
      : id = data['id'],
        name = data['name'],
        surname = data['surname'],
        email = data['email'],
        uniqueCitizensId = data['unique_citizens_id'],
        dateOfBirth = data['date_of_birth'],
        address = data['address'],
        city = data['city'],
        phoneNumber = data['phone_number'],
        bloodType = _parseBloodType(data['blood_type']),
        gender = data['gender'],
        isFirstLogin = data['is_first_login'];

  static BloodTypes? _parseBloodType(String? value) {
    if (value == null) return null;
    return BloodTypes.values.firstWhere(
          (type) => type.toString().split('.').last == value,
      orElse: () => BloodTypes.A_NEGATIVE,
    );
  }

}