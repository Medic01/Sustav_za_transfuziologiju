import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sustav_za_transfuziologiju/models/user_data.dart';
import 'package:sustav_za_transfuziologiju/screens/enums/user_role.dart';

class UserDataService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> updateUser(UserData userData) async {
    try {
      final userSnapshot = await _db
          .collection('users')
          .where('email', isEqualTo: userData.email)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        final userId = userSnapshot.docs.first.id;

        await _db.collection('users').doc(userId).update(userData.toMap());
      }

      print('Data successfully saved to Firestore!');
    } catch (e) {
      print('Error $e while saving data!');
    }
  }

  Future<void> registerUser({
    required String email,
    required String password,
  }) async {

    final userId = generateTimeStampId();
    final passwordHash = sha256.convert(utf8.encode(password)).toString();

    try {

      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'user_id': userId,
        'email': email,
        'password': passwordHash,
        'role': UserRole.USER.toString().split('.').last,
        'is_first_login': true,
      });

    } catch (e) {
      print("An error $e has occured!");
    }

  }

  String generateTimeStampId() {
    DateTime now = DateTime.now();
    String timestampId = now.microsecondsSinceEpoch.toString();
    return timestampId;
  }
}