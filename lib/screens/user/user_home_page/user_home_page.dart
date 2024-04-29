import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sustav_za_transfuziologiju/main/main.dart';
import 'package:sustav_za_transfuziologiju/screens/user/blood_donation_reservation_page/blood_donation_reservation_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sustav_za_transfuziologiju/screens/user/user_home_page/user_home_page_styles.dart';
import 'package:sustav_za_transfuziologiju/screens/user/user_home_page/user_key.dart';
import 'package:sustav_za_transfuziologiju/services/donation_service.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserHomePage extends StatefulWidget {
  final Map<String, dynamic>? userData;

  const UserHomePage({Key? key, this.userData}) : super(key: key);

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class MySvgWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/nema-donacija.svg',
      semanticsLabel: 'My SVG Image',
    );
  }
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
    final DonationService _donationService = DonationService();
    final Logger logger = Logger('UserHomePage');

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          AppLocalizations.of(context)!.homePageTitle,
          style: appBarTitleStyle,
        ),
        centerTitle: true,
        backgroundColor: appBarBackgroundColor,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: sizedBoxHeight),
          Center(
            child: Text(
                '${AppLocalizations.of(context)!.welcome} , ${widget.userData != null ? widget.userData!['name'] ?? 'Unknown' : 'Unknown'}!',
                style: welcomeTextStyle),
          ),
          SizedBox(height: sizedBoxHeightSmall),
          Center(
            child: Text('${AppLocalizations.of(context)!.emailTxt} $userEmail',
                style: emailTextStyle),
          ),
          SizedBox(height: sizedBoxHeight),
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
                  child: Row(
                    children: <Widget>[
                      testTubeSvg(),
                      Text(value),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _donationService.getUserBloodDonationStream(
                  userId, _selectedList),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text(
                      '${AppLocalizations.of(context)!.genericErrMsg} ${snapshot.error}',
                      style: errorTextStyle);
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        noDonationSvg(),
                        SizedBox(height: sizedBoxHeight),
                        Text(
                          AppLocalizations.of(context)!.noData,
                          textAlign: TextAlign.center,
                          style: noDataTextStyle,
                        ),
                      ],
                    ),
                  );
                }

                final dataList = snapshot.data!.docs
                    .map((doc) => doc.data() as Map<String, dynamic>)
                    .toList();

                return ListView.builder(
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    final entry = dataList[index];
                    return Container(
                      margin: containerMargin,
                      padding: containerPadding,
                      decoration: boxDecorationStyle,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: entry.entries
                            .where((entry) => entry.key != 'user_id')
                            .map((entry) => ListTile(
                                  title: Text(
                                    getDisplayName(entry.key),
                                    style: titleTextStyle,
                                  ),
                                  subtitle: Text(
                                    entry.key == 'blood_type'
                                        ? mapBloodType(entry.value.toString())
                                        : entry.value.toString(),
                                    style: subtitleTextStyle,
                                  ),
                                ))
                            .toList(),
                      ),
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
          mainAxisAlignment: mainAxisAlign,
          children: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.home),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BloodDonationReservationPage()),
                );
              },
              icon: Icon(Icons.calendar_today),
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
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              icon: Icon(Icons.logout_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
