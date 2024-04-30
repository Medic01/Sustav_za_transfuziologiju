import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';
import 'package:sustav_za_transfuziologiju/screens/donation/blood_donation_form/blood_donation_form.dart';
import 'package:sustav_za_transfuziologiju/screens/enums/donation_status.dart';
import 'package:sustav_za_transfuziologiju/screens/widgets/blood_drop_loading_widget/blood_drop_loading_widget.dart';
import 'package:sustav_za_transfuziologiju/screens/widgets/success_dialog/success_dialog.dart';
import 'package:sustav_za_transfuziologiju/services/donation_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sustav_za_transfuziologiju/screens/utils/blood_type_assets.dart';
import 'reservation_styles.dart';

class Reservations extends StatelessWidget {
  final DonationService _donationService = DonationService();
  final Logger logger = Logger("Reservations");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.reservationTitle,
          style: const TextStyle(fontWeight: headerTitleFontWeight, color: headerTitleTextColor),
        ),
        backgroundColor: headerBackgroundColor,
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder(
        stream: _donationService.getPendingBloodDonationStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('${AppLocalizations.of(context)!.genericErrMsg} ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: BloodDropLoadingWidget(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return const SizedBox(height: 16.0);
              } else {
                DocumentSnapshot document = snapshot.data!.docs[index - 1];
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                if (data['status'] == DonationStatus.PENDING.toString().split('.').last) {
                  String bloodType = data['blood_type'];
                  String svgAssetPath = BloodTypeAssets.bloodTypeAssetPaths[bloodType] ?? '';

                  return Card(
                    elevation: cardElevation,
                    margin: cardMargin,
                    shape:cardShape,
                    child: Column(
                      crossAxisAlignment: crossAxisAlignment,
                      children: [
                        Container(
                          padding: containerPadding,
                          decoration: containerDecoration,
                          child: Column(
                            crossAxisAlignment: crossAxisAlignment,
                            children: [
                              Row(
                                mainAxisAlignment: mainAxisAlignment,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: crossAxisAlignment,
                                      children: [
                                        Text(
                                          '${AppLocalizations.of(context)!.donorName} ${data['donor_name']}',
                                          style: const TextStyle(fontWeight: donorNameFontWeight),
                                        ),
                                        Text('${AppLocalizations.of(context)!.emailTxt} ${data['email']}'),
                                        Text('${AppLocalizations.of(context)!.donationDate} ${data['date']}'),
                                      ],
                                    ),
                                  ),
                                  SvgPicture.asset(
                                    svgAssetPath,
                                    height: svgHeight,
                                    width: svgWidth,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: containerPadding,
                          color: containerColor,
                          child: ButtonBar(
                            alignment: buttonBarAlignment,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  _handleAccept(context, document, data);
                                },
                                style: acceptButtonStyle,
                                child: Text(
                                    AppLocalizations.of(context)!.acceptBtn,
                                    style: const TextStyle(color: acceptButtonTextColor)
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  _handleReject(context, document);
                                },
                                style: rejectButtonStyle,
                                child: Text(
                                  AppLocalizations.of(context)!.rejectBtn,
                                  style: const TextStyle(color: rejectButtonTextColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              }
            },
          );
        },
      ),
    );
  }

  void _handleAccept(BuildContext context, DocumentSnapshot document, Map<String, dynamic> data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BloodDonationForm(
          date: data['date'],
          donorName: data['donor_name'],
          bloodType: data['blood_type'],
          userId: data['user_id'],
          documentId: document.id,
        ),
      ),
    );
  }
  void _handleReject(BuildContext context, DocumentSnapshot document) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String rejectionReason = '';
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.rejection),
          content: TextField(
            onChanged: (value) {
              rejectionReason = value;
            },
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.rejectionReason,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                _donationService.rejectDonation(document.id, rejectionReason).then((_) {
                  logger.info('Document successfully rejected after reservation');
                }).catchError((error) {
                  logger.severe('Error rejecting document after reservation: $error');
                });
                Navigator.of(context).pop();
                SuccessDialog.show(context);
              },
              child: Text(AppLocalizations.of(context)!.submitBtn),
            ),
          ],
        );
      },
    );
  }
}