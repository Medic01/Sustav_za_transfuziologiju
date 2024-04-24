import 'dart:html';
import 'dart:io';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:url_launcher/url_launcher.dart';
import 'package:window_to_front/window_to_front.dart';
import 'package:window_to_front/window_to_front.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../services/oauth_constants.dart';

class AuthManager {
  HttpServer? redirectServer;
  final BuildContext context;

  AuthManager({required this.context});

  String authApi = Constants.googleAuthApi;
  String tokenApi = Constants.googleTokenApi;
  String scope = Constants.emailScope;
  String url = Constants.redirectURL;

  Future<oauth2.Credentials> login() async {
    await redirectServer?.close();

    redirectServer = await HttpServer.bind('localhost', 0);
    final redirectUrl = url + redirectServer!.port.toString();

    oauth2.Client authenticatedHttpClient =
        await _getOauthClient(Uri.parse(redirectUrl));
    return authenticatedHttpClient.credentials;
  }

  Future<oauth2.Client> _getOauthClient(Uri redirectUrl) async {
    var grant = oauth2.AuthorizationCodeGrant(
      dotenv.env['OAUTH_CLIENTID']!,
      Uri.parse(Constants.googleAuthApi),
      Uri.parse(tokenApi),
      httpClient: JsonAcceptingHttpClient(),
      secret: dotenv.env['OAUTH_SECRETID'],
    );

    var authorizationUrl =
        grant.getAuthorizationUrl(redirectUrl, scopes: [scope]);
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
      throw Exception(
          '${AppLocalizations.of(context)!.oauthErrorLaunch} URL: $authorizationUri');
    }
  }

  Future<Map<String, String>> listen() async {
    var request = await redirectServer!.first;
    var params = request.uri.queryParameters;
    await WindowToFront.activate();

    request.response.statusCode = 200;
    request.response.headers.set(
        AppLocalizations.of(context as BuildContext)!.oauthContent,
        AppLocalizations.of(context as BuildContext)!.oauthTextPlain);
    request.response
        .writeln(AppLocalizations.of(context as BuildContext)!.oauthCloseTab);

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
