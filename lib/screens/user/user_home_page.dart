import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sustav_za_transfuziologiju/main.dart';
import 'package:sustav_za_transfuziologiju/screens/enums/donation_status.dart';
import 'package:sustav_za_transfuziologiju/screens/user/blood_donation_reservation_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserHomePage extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const UserHomePage({Key? key, this.userData}) : super(key: key);

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  DonationStatus _selectedStatus = DonationStatus.ACCEPTED;

  @override
  Widget build(BuildContext context) {
    final String userEmail =
    widget.userData != null ? widget.userData!['email'] ?? '' : '';
    final String userId =
    widget.userData != null ? widget.userData!['user_id'] ?? '' : '';

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
            child: DropdownButton<DonationStatus>(
              value: _selectedStatus,
              onChanged: (DonationStatus? newValue) {
                setState(() {
                  _selectedStatus = newValue!;
                });
              },
              items: <DonationStatus>[
                DonationStatus.ACCEPTED,
                DonationStatus.REJECTED
              ].map<DropdownMenuItem<DonationStatus>>((DonationStatus value) {
                return DropdownMenuItem<DonationStatus>(
                  value: value,
                  child: Text(value.toString().split('.').last),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('blood_donation')
                  .where('status', isEqualTo: _selectedStatus.toString().split('.').last.toUpperCase())
                  .where('user_id', isEqualTo: userId)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('${AppLocalizations.of(context)!.genericErrMsg} ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.docs.isEmpty) {
                  return Center(child: Text(AppLocalizations.of(context)!.noData));
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
              onPressed: () {

              },
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
              onPressed: () {
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