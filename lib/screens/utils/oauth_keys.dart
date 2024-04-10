import 'package:flutter_dotenv/flutter_dotenv.dart';

class OAuthKeys {
  static String? googleSignInClientId = dotenv.env['Oauth_ClientId'];
}
