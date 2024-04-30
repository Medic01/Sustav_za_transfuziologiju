import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sustav_za_transfuziologiju/screens/enums/donation_status.dart';
import 'package:sustav_za_transfuziologiju/screens/utils/blood_type_assets.dart';
import 'package:sustav_za_transfuziologiju/screens/widgets/blood_drop_loading_widget/blood_drop_loading_widget.dart';
import 'package:sustav_za_transfuziologiju/services/donation_service.dart';
import 'admin_welcome_page_styles.dart';

class AdminWelcomePage extends StatefulWidget {
  @override
  _AdminWelcomePageState createState() => _AdminWelcomePageState();
}

class _AdminWelcomePageState extends State<AdminWelcomePage> {
  DonationStatus _selectedFilter = DonationStatus.ACCEPTED;
  final DonationService _donationService = DonationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.homePageTitle,
          style: appBarTextStyle,
        ),
        backgroundColor: headerBackgroundColor,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: sizedBoxHeight),
            Container(
              margin: dropDownMargin,
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                border: Border.all(
                  color: _selectedFilter == DonationStatus.ACCEPTED ? acceptedBorderColor : rejectedBorderColor,
                  width: filterBorderWidth,
                ),
              ),
              child: Padding(
                padding: dropDownPadding,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<DonationStatus>(
                    value: _selectedFilter,
                    onChanged: (DonationStatus? newValue) {
                      setState(() {
                        _selectedFilter = newValue!;
                      });
                    },
                    style: dropdownTextStyle,
                    icon: dropdownIcon,
                    underline: Container(),
                    elevation: dropDownElevation,
                    dropdownColor: dropDownColor,
                    items: [
                      DropdownMenuItem(
                        value: DonationStatus.ACCEPTED,
                        child: Text(
                          AppLocalizations.of(context)!.acceptedFilter,
                          style: dropdownTextStyle,
                        ),
                      ),
                      DropdownMenuItem(
                        value: DonationStatus.REJECTED,
                        child: Text(
                          AppLocalizations.of(context)!.rejectedFilter,
                          style: dropdownTextStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: sizedBoxHeight),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _donationService.getBloodDonationStream(_selectedFilter),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(
                      '${AppLocalizations.of(context)!.genericErrMsg} ${snapshot.error}',
                      style: rejectionReasonColor,
                    );
                  }
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return BloodDropLoadingWidget();
                    default:
                      return SingleChildScrollView(
                        primary: false,
                        child: Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot document = snapshot.data!.docs[index];
                                String donorName = document['donor_name'];
                                String bloodType = document['blood_type'];
                                String svgAssetPath = BloodTypeAssets.bloodTypeAssetPaths[bloodType] ?? '';
                                String rejectionReason = '';

                                if (_selectedFilter == DonationStatus.REJECTED) {
                                  rejectionReason = document['rejection_reason'] ?? '';
                                }

                                return Card(
                                  color: cardColor,
                                  elevation: listItemElevation,
                                  margin: listItemMargin,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: borderRadius,
                                    side: BorderSide(
                                      color: _selectedFilter == DonationStatus.ACCEPTED ? acceptedBorderColor : rejectedBorderColor,
                                      width: listItemBorderWidth,
                                    ),
                                  ),
                                  child: ListTile(
                                    title: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${AppLocalizations.of(context)!.donorName} $donorName',
                                                style: const TextStyle(fontWeight: cardTextStyle),
                                              ),
                                              if (_selectedFilter == DonationStatus.REJECTED)
                                                Text('${AppLocalizations.of(context)!.rejectionReason} $rejectionReason'),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: sizedBoxWidth),
                                        SvgPicture.asset(
                                          svgAssetPath,
                                          height: svgHeight,
                                          width: svgWidth,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}