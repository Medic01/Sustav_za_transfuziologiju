import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sustav_za_transfuziologiju/firebase_options.dart';
import 'prijava.dart';
import 'registracija.dart';
import 'pocetna.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then(
    (FirebaseApp value) => Get.put(AuthenticationRepository()),
  );

  runApp(MyApp());
}

class AuthenticationRepository {}

class Get {
  static put(AuthenticationRepository authenticationRepository) {}
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zavod za Zdravstvo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dobrodošli u Zavod za Zdravstvo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Dobrodošli!',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrijavaPage()),
                );
              },
              child: Text('Prijavite se'),
            ),
            SizedBox(height: 10.0),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistracijaPage()),
                );
              },
              child: Text('Registrirajte se'),
            ),
          ],
        ),
      ),
    );
  }
}
