import 'dart:html';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:url_launcher/url_launcher.dart';
import 'package:window_to_front/window_to_front.dart';
import 'package:window_to_front/window_to_front.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthManager {
  HttpServer? redirectServer;

  static const String googleAuthApi =
      "https://accounts.google.com/o/oauth2/v2/auth";
  static const String googleTokenApi = "https://oauth2.googleapis.com/token";
  static const String emailScope = "email";
  static const String redirectURL = 'http://localhost:';

  Future<oauth2.Credentials> login() async {
    await redirectServer?.close();

    redirectServer = await HttpServer.bind('localhost', 0);
    final redirectUrl = redirectURL + redirectServer!.port.toString();

    oauth2.Client authenticatedHttpClient =
        await _getOauthClient(Uri.parse(redirectUrl));
    return authenticatedHttpClient.credentials;
  }

  Future<oauth2.Client> _getOauthClient(Uri redirectUrl) async {
    var grant = oauth2.AuthorizationCodeGrant(
      dotenv.env['Oauth_ClientId']!,
      Uri.parse(googleAuthApi),
      Uri.parse(googleTokenApi),
      httpClient: JsonAcceptingHttpClient(),
      secret: dotenv.env['Oauth_SecretId'],
    );

    var authorizationUrl =
        grant.getAuthorizationUrl(redirectUrl, scopes: [emailScope]);
    await redirect(authorizationUrl);
    var responseQueryParameters = await listen();
    var client =
        await grant.handleAuthorizationResponse(responseQueryParameters);
    return client;
  }

  Future<void> redirect(Uri authorizationUri) async {
    if (await canLaunchUrl(authorizationUri)) {
      await launchUrl(authorizationUri);
    } else {
      throw Exception('Can not launch $authorizationUri');
    }
  }

  Future<Map<String, String>> listen() async {
    var request = await redirectServer!.first;
    var params = request.uri.queryParameters;
    await WindowToFront.activate();

    request.response.statusCode = 200;
    request.response.headers.set('content-type', 'text/plain');
    request.response.writeln('Please close the tab');

    await request.response.close();
    await redirectServer!.close();
    redirectServer = null;

    return params;
  }

  Future<bool> canLaunchUrl(Uri uri) async {
    return await canLaunch(uri.toString());
  }

  Future<void> launchUrl(Uri uri) async {
    await launch(uri.toString());
  }
}

class JsonAcceptingHttpClient extends http.BaseClient {
  final _httpClient = http.Client();
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Accept'] = 'application/json';
    return _httpClient.send(request);
  }
}
