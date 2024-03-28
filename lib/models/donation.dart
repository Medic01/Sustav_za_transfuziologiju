import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/enums/blood_types.dart';

class Donation {
  final String userId;
  final String donorName;
  final String date;
  final String place;
  final String doctorName;
  final String technicianName;
  final String hemoglobin;
  final String bloodPressure;
  final BloodTypes? bloodType;
  final bool donationRejected;
  final String rejectionReason;

  Donation({
    required this.date,
    required this.donorName,
    required this.place,
    required this.doctorName,
    required this.technicianName,
    required this.hemoglobin,
    required this.bloodPressure,
    required this.bloodType,
    required this.userId,
    required this.donationRejected,
    required this.rejectionReason,
  });

  factory Donation.fromFirestore(DocumentSnapshot doc) {
    Map <String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Donation(
      date: data['date'],
      donorName: data['donor_name'],
      place: data['place'],
      doctorName: data['doctor_name'],
      technicianName: data['technician_name'],
      hemoglobin: data['hemoglobin'],
      bloodPressure: data['blood_pressure'],
      bloodType: data['blood_type'] != null ? BloodTypes.values.firstWhere((e) => e.toString().split('.')[1] == data['blood_type']) : null,
      userId: data['user_id'],
      donationRejected: data['donation_rejected'] ?? false,
      rejectionReason: data['rejection_reason'] ?? '',
    );
  }
}