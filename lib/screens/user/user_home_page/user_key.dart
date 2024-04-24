String getDisplayName(String key) {
  switch (key) {
    case 'date':
      return 'Date';
    case 'donor_name':
      return 'Donor Name';
    case 'blood_type':
      return 'Blood Type';
    case 'dose_used':
      return 'Dose Used';
    case 'blood_pressure':
      return 'Blood Pressure';
    case 'hemoglobin':
      return 'Hemoglobin';
    case 'donated_dose':
      return 'Donated Dose';
    case 'dose_processed':
      return 'Dose Processed';
    case 'location':
      return 'Location';
    case 'doctor_name':
      return 'Doctor Name';
    case 'email':
      return 'Email';
    case 'technician_name':
      return 'Technician Name';
    case 'status':
      return 'Status';
    case 'rejection_reason':
      return 'Rejection Reason';
    default:
      return key;
  }
}
