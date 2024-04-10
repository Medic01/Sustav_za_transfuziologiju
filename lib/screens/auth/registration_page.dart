import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:crypto/crypto.dart';
import 'package:logging/logging.dart';
import 'package:sustav_za_transfuziologiju/screens/utils/email.validator.dart';
import 'package:sustav_za_transfuziologiju/services/user_data_service.dart';
import 'dart:convert';
import '../user/data_entry_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  final UserDataService _userDataService = UserDataService();
  final Logger logger = Logger("RegistrationPage");
  bool _isPasswordValid = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isPasswordFocused = false;


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
        title: Text(AppLocalizations.of(context)!.registrationTitle),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.usernameLabel,
                  ),
                ),
                const SizedBox(height: 20.0),
                TextField(
                  focusNode: _passwordFocusNode,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.passwordLabel,
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
                      ),
                    ),
                  ),
                  obscureText: !_isPasswordVisible,
                  onTap: () {
                    setState(() {
                      _isPasswordFocused = true;
                    });
                  },
                  onChanged: (_) {
                    setState(() {
                      _isPasswordValid = false;
                    });
                  },
                ),
                const SizedBox(height: 20.0),
                if (_isPasswordFocused)
                  FlutterPwValidator(
                    controller: _passwordController,
                    minLength: 6,
                    uppercaseCharCount: 1,
                    numericCharCount: 1,
                    specialCharCount: 1,
                    normalCharCount: 3,
                    width: 200,
                    height: 100,
                    onSuccess: () {
                      if (!_isPasswordValid) {
                        setState(() {
                          _isPasswordValid = true;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppLocalizations.of(context)!.validPasswordMessage),
                          ),
                        );
                      }
                    },
                    onFail: () {
                      if (_isPasswordValid) {
                        setState(() {
                          _isPasswordValid = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppLocalizations.of(context)!.invalidPasswordMessage),
                          ),
                        );
                      }
                    },
                  ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.passwordLabel,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        });
                      },
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                  obscureText: !_isConfirmPasswordVisible,
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_usernameController.text.isEmpty ||
                        _passwordController.text.isEmpty ||
                        _confirmPasswordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppLocalizations.of(context)!.fillAllFieldsMessage),
                        ),
                      );
                      return;
                    }
                    if (EmailValidator.isValid(_usernameController.text) != true) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppLocalizations.of(context)!.emailErrorMessage),
                        ),
                      );
                      return;
                    }
                    if (_passwordController.text !=
                        _confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppLocalizations.of(context)!.passwordMismatchMessage),
                        ),
                      );
                      return;
                    }

                    try {
                      final existingUser = await FirebaseFirestore.instance
                          .collection('users')
                          .where('email', isEqualTo: _usernameController.text)
                          .get();
                      if (existingUser.docs.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppLocalizations.of(context)!.usernameAlreadyInUse),
                          ),
                        );
                        return;
                      }
                      await _userDataService.registerUser(
                          email: _usernameController.text,
                          password: _passwordController.text
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppLocalizations.of(context)!.successfulSignup),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DataEntryPage(email: _usernameController.text),
                        ),
                      );
                    } catch (e) {
                      logger.severe("Greška prilikom registracije $e");
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.registrationButton),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
