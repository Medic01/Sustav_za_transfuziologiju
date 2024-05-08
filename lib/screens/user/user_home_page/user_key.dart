String getDisplayName(String key) {
  switch (key) {
    case 'date':
      return 'Datum';
    case 'donor_name':
      return 'Ime donora';
    case 'blood_type':
      return 'Krvna grupa';
    case 'dose_used':
      return 'Doza iskorištena';
    case 'blood_pressure':
      return 'Krvni tlak';
    case 'hemoglobin':
      return 'Hemoglobin';
    case 'donated_dose':
      return 'Donirana doza';
    case 'dose_processed':
      return 'Doza obrađena';
    case 'location':
      return 'Lokacija';
    case 'doctor_name':
      return 'Ime doktora';
    case 'email':
      return 'Email';
    case 'technician_name':
      return 'Ime tehničara';
    case 'status':
      return 'Status';
    case 'rejection_reason':
      return 'Razlog odbijanja';
    default:
      return key;
  }
}

String mapBloodType(String bloodType) {
  switch (bloodType) {
    case 'A_NEGATIVE':
      return 'A-';
    case 'A_POSITIVE':
      return 'A+';
    case 'B_NEGATIVE':
      return 'B-';
    case 'B_POSITIVE':
      return 'B+';
    case 'AB_NEGATIVE':
      return 'AB-';
    case 'AB_POSITIVE':
      return 'AB+';
    case 'O_NEGATIVE':
      return 'O-';
    case 'O_POSITIVE':
      return 'O+';
    default:
      return bloodType;
  }
}
