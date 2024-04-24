import 'package:sustav_za_transfuziologiju/screens/enums/blood_types.dart';

String getBloodTypeDisplayName(BloodTypes type) {
  return type
      .toString()
      .split('.')
      .last
      .replaceAll('_POSITIVE', '+')
      .replaceAll('_NEGATIVE', '-');
}
