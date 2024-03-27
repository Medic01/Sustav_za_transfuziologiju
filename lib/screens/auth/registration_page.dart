import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:crypto/crypto.dart';
import 'package:sustav_za_transfuziologiju/services/user_data_service.dart';
import 'dart:convert';
import '../user/data_entry_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isPasswordValid = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isPasswordFocused = false;
  final FocusNode _passwordFocusNode = FocusNode();

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

  String generateTimestampId() {
    DateTime now = DateTime.now();
    String timestampId = now.microsecondsSinceEpoch.toString();
    return timestampId;
  }

  @override
  Widget build(BuildContext context) {
    String? validateEmail(String? value) {
      const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
          r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
          r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
          r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
          r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
          r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
          r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
      final regex = RegExp(pattern);
      return value!.isEmpty || !regex.hasMatch(value)
          ? 'Unesite ispravan email'
          : null;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registracija'),
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
                  decoration: const InputDecoration(
                    labelText: 'Korisničko ime (Email)',
                  ),
                ),
                const SizedBox(height: 20.0),
                TextField(
                  focusNode: _passwordFocusNode,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Lozinka',
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
                          const SnackBar(
                            content: Text('Lozinka je valjana!'),
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
                          const SnackBar(
                            content: Text('Lozinka nije valjana!'),
                          ),
                        );
                      }
                    },
                  ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Ponovite lozinku',
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
                        const SnackBar(
                          content: Text('Popunite sva polja!'),
                        ),
                      );
                      return;
                    }
                    if (validateEmail(_usernameController.text) != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Unesite ispravan email!'),
                        ),
                      );
                      return;
                    }
                    if (_passwordController.text !=
                        _confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Lozinke se ne podudaraju!'),
                        ),
                      );
                      return;
                    }
                    final passwordHash = sha256
                        .convert(utf8.encode(_passwordController.text))
                        .toString();
                    try {
                      final existingUser = await FirebaseFirestore.instance
                          .collection('users')
                          .where('email', isEqualTo: _usernameController.text)
                          .get();
                      if (existingUser.docs.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Korisničko ime već postoji!'),
                          ),
                        );
                        return;
                      }

                      try {
                        await UserDataService().registerUser(
                            email: _usernameController.text,
                            password: _passwordController.text,
                        );
                      } catch (e) {
                        print('Error $e has occured!');
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Uspješno ste se registrirali!'),
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
                      print("Greška prilikom registracije $e");
                    }
                  },
                  child: const Text('Registrirajte se'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}