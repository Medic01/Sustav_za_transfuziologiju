import '../enums/blood_types.dart';

class BloodTypeAssets {
  static Map<String, String> bloodTypeAssetPaths = {
    BloodTypes.A_POSITIVE.toString().split('.').last: 'assets/a-positive-blood-type.svg',
    BloodTypes.B_POSITIVE.toString().split('.').last: 'assets/b-positive-blood-type.svg',
    BloodTypes.A_NEGATIVE.toString().split('.').last: 'assets/a-negative-blood-type.svg',
    BloodTypes.B_NEGATIVE.toString().split('.').last: 'assets/b-negative-blood-type.svg',
    BloodTypes.AB_POSITIVE.toString().split('.').last: 'assets/ab-positive-blood-type.svg',
    BloodTypes.AB_NEGATIVE.toString().split('.').last: 'assets/ab-negative-blood-type.svg',
    BloodTypes.O_NEGATIVE.toString().split('.').last: 'assets/o-negative-blood-type.svg',
    BloodTypes.O_POSITIVE.toString().split('.').last: 'assets/o-positive-blood-type.svg',
  };
}