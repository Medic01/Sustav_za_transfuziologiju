import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';
import 'package:sustav_za_transfuziologiju/models/donation.dart';

class DonationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Logger logger = Logger('DonationService');

  Future<void> saveBloodDonationData({
    required String donorName,
    required String email,
    required String date,
    required String bloodType,
    required String userId,
  }) async {
    try {
      await _db.collection('donation_date').add({
        'donor_name': donorName,
        'email': email,
        'date': date,
        'blood_type': bloodType,
        'user_id': userId,
      });
      logger.info('Blood donation data successfully saved to Firestore!');
    } catch (e) {
      logger.severe('Error while saving blood donation data: $e');
      throw e;
    }
  }

  Future<void> saveDonationData(Donation data) async {
    try {
      await _db.collection('blood_donation').add({
        'location': data.place,
        'date': data.date,
        'blood_pressure': data.bloodPressure,
        'hemoglobin': data.hemoglobin,
        'doctor_name': data.doctorName,
        'technician_name': data.technicianName,
        'blood_type': data.bloodType != null
            ? data.bloodType.toString().split('.').last
            : null,
        'donor_name': data.donorName,
        'user_id': data.userId,
      });

      logger.info('Data successfuly saved to firestore!');
    } catch (e) {
      logger.severe("Error $e while saving data!");
      throw e;
    }
  }

  Future<void> acceptDonation(
      String documentId, Map<String, dynamic> data) async {
    try {
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
    } catch (e) {
      logger.severe('Error $e has occured!');
      throw e;
    }
  }

  Future<void> rejectDonation(String documentId, Map<String, dynamic> data,
      String rejectionReason) async {
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
      logger.severe('Error $e has occurred!');
      throw e;
    }
  }

  Future<void> acceptDonationAfterReservation(
      String documentId, Map<String, dynamic> data) async {
    try {
      CollectionReference donationRef = _db.collection('donation_date');
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

      await donationRef.doc(documentId).delete();
    } catch (e) {
      logger.severe('Error $e has occured!');
      throw e;
    }
  }

  Future<void> rejectDonationAfterReservation(String documentId,
      Map<String, dynamic> data, String rejectionReason) async {
    try {
      CollectionReference donationRef = _db.collection('donation_date');
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

      await donationRef.doc(documentId).delete();
    } catch (e) {
      logger.severe('Error $e has occurred!');
      throw e;
    }
  }

  Stream<List<Donation>> getAcceptedDonations(String? selectedBloodType) {
    Query collectionRef = _db.collection('accepted');

    if (selectedBloodType != null && selectedBloodType != 'All') {
      collectionRef =
          collectionRef.where('blood_type', isEqualTo: selectedBloodType);
    }

    return collectionRef.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Donation.fromFirestore(doc)).toList());
  }

  Future<void> markDoseProcessed(String donationId) async {
    try {
      await _db.collection('accepted').doc(donationId).update({
        'dose_processed': true,
      });

      logger.info("Dose marked as processed!");
    } catch (e) {
      logger
          .severe("Error occurred while trying to mark dose as processed: $e");
    }
  }

  Future<void> markDoseUsed(String donationId) async {
    try {
      await _db.collection('accepted').doc(donationId).update({
        'dose_used': true,
      });
      logger.info('Dose marked as used');
    } catch (e) {
      logger.severe('Error occurred while marking dose as used: $e');
      throw e;
    }
  }

  Future<void> updateDonatedDose(String donationId, int newQuantity) async {
    try {
      await _db.collection('accepted').doc(donationId).update({
        'donated_dose': newQuantity,
      });
      logger.info('Donated dose quantity updated');
    } catch (e) {
      logger.severe('Error occurred while updating donated dose quantity: $e');
      throw e;
    }
  }
}
