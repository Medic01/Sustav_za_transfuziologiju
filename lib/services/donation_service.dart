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
      logger.severe('Error $e has occured!');
      throw e;
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
}