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

  UserData.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        name = doc.data()!['name'],
        surname = doc.data()!['surname'],
        email = doc.data()!['email'],
        uniqueCitizensId = doc.data()!['unique_citizens_id'],
        dateOfBirth = doc.data()!['date_of_birth'],
        address = doc.data()!['address'],
        city = doc.data()!['city'],
        phoneNumber = doc.data()!['phone_number'],
        bloodType = _parseBloodType(doc.data()!['blood_type']),
        gender = doc.data()!['gender'],
        isFirstLogin = doc.data()!['is_first_login'];

  static BloodTypes? _parseBloodType(String? value) {
    if (value == null) return null;
    return BloodTypes.values.firstWhere(
          (type) => type.toString().split('.').last == value,
      orElse: () => BloodTypes.A_NEGATIVE,
    );
  }

}