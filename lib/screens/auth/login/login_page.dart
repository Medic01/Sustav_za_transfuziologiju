import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:logging/logging.dart';
import 'dart:convert';
import 'package:sustav_za_transfuziologiju/screens/admin/admin_footer.dart';
import 'package:sustav_za_transfuziologiju/screens/auth/login/login_page_styles.dart';
import 'package:sustav_za_transfuziologiju/screens/enums/user_role.dart';
import 'package:sustav_za_transfuziologiju/screens/user/data_entry_page/data_entry_page.dart';
import 'package:sustav_za_transfuziologiju/screens/user/user_footer/user_footer.dart';
import 'package:sustav_za_transfuziologiju/screens/user/user_home_page/user_home_page.dart';
import 'package:sustav_za_transfuziologiju/screens/utils/session_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Logger logger = Logger("LoginPage");
  SessionManager sessionManager = SessionManager();

  bool _isPasswordVisible = false;
  Map<String, dynamic>? _loggedInUserData;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text(
          AppLocalizations.of(context)!.loginTitle,
          style: appBarTextStyle,
        ),
        iconTheme: appBarIconTheme,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(allSidesPadding),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: columnMainAxisAlignment,
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: AppLocalizations.of(context)!.usernameLabel,
                    labelStyle: passwordLabelStyle,
                  ),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return AppLocalizations.of(context)!.emailReminder;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: standardPadding),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: AppLocalizations.of(context)!.passwordLabel,
                    suffixIcon: IconButton(
                      icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: visibilityIconColor),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    labelStyle: passwordLabelStyle,
                  ),
                  obscureText: !_isPasswordVisible,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return AppLocalizations.of(context)!.passwordReminder;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: standardPadding),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      try {
                        final userSnapshot = await FirebaseFirestore.instance
                            .collection('users')
                            .where('email', isEqualTo: _emailController.text)
                            .get();

                        if (userSnapshot.docs.isNotEmpty) {
                          final userData = userSnapshot.docs.first.data();
                          final storedPasswordHash = userData['password'];

                          sessionManager.setUserId(userData['user_id']);

                          final passwordHash =
                              generateHash(_passwordController.text);

                          if (passwordHash == storedPasswordHash) {
                            setState(() {
                              _loggedInUserData = userData;
                            });

                            final role = userData['role'];
                            final isFirstLogin =
                                userData['is_first_login'] ?? true;

                            logger.info(isFirstLogin);

                            if (role == UserRole.ADMIN.name) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                        AppLocalizations.of(context)!.welcome),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const WelcomePage(),
                                            ),
                                          );
                                        },
                                        child: Text(
                                            AppLocalizations.of(context)!.ok),
                                      ),
                                    ],
                                  );
                                },
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AdminPage(),
                                ),
                              );
                            } else if (role == UserRole.USER.name) {
                              if (isFirstLogin) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DataEntryPage(
                                      email: _emailController.text,
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UserHomePage(
                                      userData: _loggedInUserData,
                                    ),
                                  ),
                                );
                              }
                            }
                            return;
                          }
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppLocalizations.of(context)!
                                .invalidCredentialsMessage),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                '${AppLocalizations.of(context)!.unsuccessfulLoginMessage} $e'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context)!.loginButton,
                    style: loginButtonTextStyle,
                  ),
                  style: loginButtonStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String generateHash(String input) {
  return sha256.convert(utf8.encode(input)).toString();
}
