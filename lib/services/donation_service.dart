import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sustav_za_transfuziologiju/models/donation.dart';

class DonationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveDonationData(Donation data) async {
    try {
      await _db.collection('blood_donation').add({
        'location': data.place,
        'date': data.date,
        'blood_pressure': data.bloodPressure,
        'hemoglobin': data.hemoglobin,
        'doctor_name': data.doctorName,
        'technician_name': data.technicianName,
        'blood_type': data.bloodType != null ? data.bloodType.toString().split('.').last : null,
        'donor_name': data.donorName,
        'user_id': data.userId,
      });

      print('Data successfuly saved to firestore!');
    } catch (e) {
      print("Error $e while saving data!");
      throw e;
    }
  }

  Future<void> acceptDonation(String documentId, Map<String, dynamic> data) async {
    try{
      CollectionReference bloodDonationRef = _db.collection('blood_donation');
      CollectionReference acceptedRef = _db.collection('accepted');

      await acceptedRef.add({
        'location': data['location'],
        'date': data['date'],
        'blood_pressure': data['blood_pressure'],
        'hemoglobin': data['hemoglobin'],
        'doctor_name': data['doctor_name'],
        'blood_type': data['blood_type'],
        'user_id': data['user_id'],
        'donor_name': data['donor_name'],
      });

      await bloodDonationRef.doc(documentId).delete();
      } catch(e) {
        print('Error $e has occured!');
        throw e;
    }
  }

  Future<void> rejectDonation(String documentId, Map<String, dynamic> data, String rejectionReason) async {
    try {
      CollectionReference donationRef = _db.collection('blood_donation');
      CollectionReference rejectedRef = _db.collection('rejected');

      await rejectedRef.add({
        'location': data['location'],
        'date': data['date'],
        'blood_pressure': data['blood_pressure'],
        'hemoglobin': data['hemoglobin'],
        'doctor_name': data['doctor_name'],
        'blood_type': data['blood_type'],
        'user_id': data['user_id'],
        'donor_name': data['donor_name'],
        'reason_for_rejection': rejectionReason,
      });

      await donationRef.doc(documentId).update({
        'donation_rejected': true,
        'reason_for_rejection': rejectionReason,
      });
    } catch (e) {
      print('Error $e has occurred!');
      throw e;
    }
  }

}