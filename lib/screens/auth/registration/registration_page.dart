import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:logging/logging.dart';
import 'package:sustav_za_transfuziologiju/screens/auth/registration/registration_page_styles.dart';
import 'package:sustav_za_transfuziologiju/screens/utils/email.validator.dart';
import 'package:sustav_za_transfuziologiju/services/user_data_service.dart';
import '../../user/data_entry_page/data_entry_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  final UserDataService _userDataService = UserDataService();
  final Logger logger = Logger("RegistrationPage");
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isPasswordFocused = false;
  bool _isPasswordValid = false;

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _passwordFocusNode.addListener(() {
      setState(() {
        _isPasswordFocused = _passwordFocusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.registrationTitle,
          style: appBarTitleTextStyle,
        ),
        backgroundColor: appBarBackgroundColor,
        iconTheme: appBarIconTheme,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(allSidesPadding),
            child: Column(
              mainAxisAlignment: columnMainAxisAlignment,
              children: <Widget>[
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: AppLocalizations.of(context)!.usernameLabel,
                    labelStyle: labelTextStyle,
                  ),
                ),
                const SizedBox(height: standardPadding),
                TextField(
                  focusNode: _passwordFocusNode,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: AppLocalizations.of(context)!.passwordLabel,
                    labelStyle: passwordLabelStyle,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: visibilityIconColor),
                    ),
                  ),
                  obscureText: !_isPasswordVisible,
                  onTap: () {
                    setState(() {
                      _isPasswordFocused = true;
                    });
                  },
                ),
                const SizedBox(height: standardPadding),
                if (_isPasswordFocused)
                  FlutterPwValidator(
                    controller: _passwordController,
                    minLength: passwordMinLength,
                    uppercaseCharCount: passwordUppercaseCharCount,
                    numericCharCount: passwordNumericCharCount,
                    specialCharCount: passwordSpecialCharCount,
                    normalCharCount: passwordNormalCharCount,
                    width: passwordValidatorWidth,
                    height: passwordValidatorHeight,
                    onSuccess: () {
                      setState(() {
                        _isPasswordValid = true;
                      });
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                AppLocalizations.of(context)!
                                    .validPasswordMessage,
                                style: validPasswordSnackBarTextStyle),
                            backgroundColor:
                                validPasswordSnackBarBackgroundColor),
                      );
                    },
                    onFail: () {
                      setState(() {
                        _isPasswordValid = false;
                      });
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              AppLocalizations.of(context)!
                                  .invalidPasswordMessage,
                              style: invalidPasswordSnackBarTextStyle),
                          backgroundColor:
                              invalidPasswordSnackBarBackgroundColor,
                        ),
                      );
                    },
                  ),
                const SizedBox(height: standardPadding),
                TextField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: AppLocalizations.of(context)!.passwordLabel,
                    labelStyle: passwordLabelStyle,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                      icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: visibilityIconColor),
                    ),
                  ),
                  obscureText: !_isConfirmPasswordVisible,
                ),
                const SizedBox(height: standardPadding),
                ElevatedButton(
                  onPressed: () async {
                    final String username = _usernameController.text.trim();
                    final String password = _passwordController.text.trim();
                    final String confirmPassword =
                        _confirmPasswordController.text.trim();

                    if (username.isEmpty ||
                        password.isEmpty ||
                        confirmPassword.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!.fillAllFieldsMessage,
                            style: fillAllFieldsSnackBarTextStyle,
                          ),
                          backgroundColor: fillAllFieldsSnackBarBackgroundColor,
                        ),
                      );
                      return;
                    }
                    if (!EmailValidator.isValid(username)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!.emailErrorMessage,
                            style: emailErrorSnackBarTextStyle,
                          ),
                          backgroundColor: emailErrorSnackBarBackgroundColor,
                        ),
                      );
                      return;
                    }
                    if (password != confirmPassword) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!
                                .passwordMismatchMessage,
                            style: passwordMismatchSnackBarTextStyle,
                          ),
                          backgroundColor:
                              passwordMismatchSnackBarBackgroundColor,
                        ),
                      );
                      return;
                    }
                    if (!_isPasswordValid) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!
                                .invalidPasswordMessage,
                            style: invalidPasswordSnackBarTextStyle,
                          ),
                          backgroundColor:
                              invalidPasswordSnackBarBackgroundColor,
                        ),
                      );
                      return;
                    }
                    try {
                      final existingUser = await FirebaseFirestore.instance
                          .collection('users')
                          .where('email', isEqualTo: username)
                          .get();
                      if (existingUser.docs.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(context)!
                                  .usernameAlreadyInUse,
                              style: usernameSnackBarTextStyle,
                            ),
                            backgroundColor: usernameSnackBarBackgroundColor,
                          ),
                        );
                        return;
                      }
                      await _userDataService.registerUser(
                        email: username,
                        password: password,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context)!.successfulSignup,
                            style: snackBarTextStyle,
                          ),
                          backgroundColor: snackBarBackgroundColor,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DataEntryPage(email: username),
                        ),
                      );
                    } catch (e) {
                      logger.severe("Error during registration: $e");
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context)!.registrationButton,
                    style: registrationButtonTextStyle,
                  ),
                  style: registrationButtonStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
