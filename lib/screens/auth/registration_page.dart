import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:crypto/crypto.dart';
import 'package:logging/logging.dart';
import 'package:sustav_za_transfuziologiju/screens/utils/email.validator.dart';
import 'package:sustav_za_transfuziologiju/services/user_data_service.dart';
import '../user/data_entry_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

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
                      setState(() {
                        _isPasswordValid = true;
                      });
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppLocalizations.of(context)!.validPasswordMessage),
                        ),
                      );
                    },
                    onFail: () {
                      setState(() {
                        _isPasswordValid = false;
                      });
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppLocalizations.of(context)!.invalidPasswordMessage),
                        ),
                      );
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
                    final String username = _usernameController.text.trim();
                    final String password = _passwordController.text.trim();
                    final String confirmPassword = _confirmPasswordController.text.trim();

                    if (username.isEmpty ||
                        password.isEmpty ||
                        confirmPassword.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppLocalizations.of(context)!.fillAllFieldsMessage),
                        ),
                      );
                      return;
                    }
                    if (!EmailValidator.isValid(username)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppLocalizations.of(context)!.emailErrorMessage),
                        ),
                      );
                      return;
                    }
                    if (password != confirmPassword) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppLocalizations.of(context)!.passwordMismatchMessage),
                        ),
                      );
                      return;
                    }
                    if (!_isPasswordValid) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppLocalizations.of(context)!.invalidPasswordMessage),
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
                            content: Text(AppLocalizations.of(context)!.usernameAlreadyInUse),
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
                          content: Text(AppLocalizations.of(context)!.successfulSignup),
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
