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
}