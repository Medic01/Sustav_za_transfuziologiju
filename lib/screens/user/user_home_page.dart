import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sustav_za_transfuziologiju/main.dart';
import 'package:sustav_za_transfuziologiju/screens/user/blood_donation_reservation_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserHomePage extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const UserHomePage({Key? key, this.userData}) : super(key: key);

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  String _selectedList = 'accepted';

  @override
  Widget build(BuildContext context) {
    final String userEmail =
        widget.userData != null ? widget.userData!['email'] ?? '' : '';
    final String userId =
        widget.userData != null ? widget.userData!['user_id'] ?? '' : '';
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    bool _isLoggedIn = false;
    final Logger logger = Logger('UserHomePage');

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.homePageTitle),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${AppLocalizations.of(context)!.welcome} , ${widget.userData != null ? widget.userData!['name'] ?? 'Unknown' : 'Unknown'}!',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${AppLocalizations.of(context)!.emailTxt} $userEmail',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Center(
            child: DropdownButton<String>(
              value: _selectedList,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedList = newValue!;
                });
              },
              items: <String>['accepted', 'rejected']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _selectedList == 'accepted'
                  ? FirebaseFirestore.instance
                      .collection('accepted')
                      .where('user_id', isEqualTo: userId)
                      .snapshots()
                  : FirebaseFirestore.instance
                      .collection('rejected')
                      .where('user_id', isEqualTo: userId)
                      .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text(
                      '${AppLocalizations.of(context)!.genericErrMsg} ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.docs.isEmpty) {
                  return Center(
                      child: Text(AppLocalizations.of(context)!.noData));
                }

                final dataList = snapshot.data!.docs
                    .map((doc) => doc.data() as Map<String, dynamic>)
                    .toList();

                return ListView.builder(
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    final entry = dataList[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: entry.entries
                          .map((entry) => ListTile(
                                title: Text(entry.key),
                                subtitle: Text(entry.value.toString()),
                              ))
                          .toList(),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.home),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const BloodDonationReservationPage()),
                );
              },
              icon: const Icon(Icons.calendar_today),
            ),
            IconButton(
              onPressed: () async {
                try {
                  await _googleSignIn.signOut();

                  await _googleSignIn.disconnect();

                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();

                  setState(() {
                    _isLoggedIn = false;
                  });
                } catch (error) {
                  logger.severe(
                      '${AppLocalizations.of(context)!.oauthErrorSignOut} $error');
                }
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              icon: const Icon(Icons.logout_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
