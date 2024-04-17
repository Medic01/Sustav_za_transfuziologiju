import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';
import 'package:sustav_za_transfuziologiju/screens/enums/donation_status.dart';

class DonationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Logger logger = Logger("DonationService");
  Future<void> bookBloodDonationAppointment({
    required String donorName,
    required String email,
    required String date,
    required String bloodType,
    required String userId,
  }) async {
    try {
      await _db.collection('blood_donation').add({
        'donor_name': donorName,
        'email': email,
        'date': date,
        'blood_type': bloodType,
        'user_id': userId,
        'status': DonationStatus.PENDING.toString().split('.').last,
      });
      logger.info('Appointment for blood donation made');
    } catch (e) {
      logger.severe('Error while trying to make a blood donation appointment: $e');
      throw e;
    }
  }

  Future<void> updateReservationAndAccept({
    required String documentId,
    required String location,
    required String hemoglobin,
    required String bloodPressure,
    required String doctorName,
    required String technicianName,
  }) async {

    try {
      await _db.collection('blood_donation').doc(documentId).update({
        'location': location,
        'hemoglobin': hemoglobin,
        'blood_pressure': bloodPressure,
        'doctor_name': doctorName,
        'technician_name': technicianName,
        'status': DonationStatus.ACCEPTED.toString().split('.').last,
      });

      logger.info('Donation updated and accepted successfully!');
    } catch (e) {
      logger.severe('Error while updating and accepting donation: $e');
      rethrow;
    }
  }

  Future<void> rejectDonation(String documentId, String rejectionReason) async {
    print(documentId);
    try {
      await _db.collection('blood_donation').doc(documentId).update({
        'status': DonationStatus.REJECTED.toString().split('.').last,
        'rejection_reason': rejectionReason,
      });

      logger.info('Donation rejected!');
    } catch (e) {
      logger.severe('Error while rejecting donation: $e');
      rethrow;
    }
  }


  Future<void> markDoseProcessed(String donationId) async {
    try {
      await _db.collection('blood_donation').doc(donationId).update({
        'dose_processed': true,
      });

      logger.info("Dose marked as processed!");
    } catch (e) {
      logger.severe("Error occurred while trying to mark dose as processed: $e");
    }
  }

  Future<void> markDoseUsed(String donationId) async {
    try {
      await _db.collection('blood_donation').doc(donationId).update({
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
      await _db.collection('blood_donation').doc(donationId).update({
        'donated_dose': newQuantity,
      });
      logger.info('Donated dose quantity updated');
    } catch (e) {
      logger.severe('Error occurred while updating donated dose quantity: $e');
      throw e;
    }
  }

  Stream<QuerySnapshot> getBloodDonationStream(DonationStatus status, {String? selectedBloodType}) {
    Query bloodDonationQuery = _db.collection('blood_donation').where('status', isEqualTo: status.toString().split('.').last);

    if (selectedBloodType != null && selectedBloodType != 'All') {
      bloodDonationQuery = bloodDonationQuery.where('blood_type', isEqualTo: selectedBloodType);
    }

    return bloodDonationQuery.snapshots();
  }

  Stream<QuerySnapshot> getPendingBloodDonationStream() {
    return _db.collection('blood_donation')
        .where('status', isEqualTo: DonationStatus.PENDING.toString().split('.').last)
        .snapshots();
  }

  Stream<QuerySnapshot> getUserBloodDonationStream(String userId, String selectedList) {
    return _db
        .collection('blood_donation')
        .where('user_id', isEqualTo: userId)
        .where('status', isEqualTo: selectedList == 'accepted' ? 'ACCEPTED' : 'REJECTED')
        .snapshots();
  }
}