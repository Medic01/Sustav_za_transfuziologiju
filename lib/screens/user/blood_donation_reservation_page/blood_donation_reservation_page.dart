import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:sustav_za_transfuziologiju/screens/user/blood_donation_reservation_page/blood_donation_reservation_page_styles.dart';
import 'package:sustav_za_transfuziologiju/screens/utils/session_manager.dart';
import 'package:sustav_za_transfuziologiju/services/donation_service.dart';
import '../../enums/blood_types.dart';
import '../../widgets/blood_type_dropdown_widget/blood_type_dropdown_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BloodDonationReservationPage extends StatefulWidget {
  const BloodDonationReservationPage({Key? key});

  @override
  _BloodDonationReservationPageState createState() =>
      _BloodDonationReservationPageState();
}

class _BloodDonationReservationPageState
    extends State<BloodDonationReservationPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dateController = TextEditingController();
  final DonationService _donationService = DonationService();
  String? _selectedBloodType;
  late MaskTextInputFormatter _dateMaskFormatter;
  String? _userId;
  final _emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  SessionManager sessionManager = SessionManager();
  late final AnimationController _bloodDropController = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _bloodDropAnimation = CurvedAnimation(
    parent: _bloodDropController,
    curve: Curves.easeIn,
  );

  @override
  void initState() {
    super.initState();
    sessionManager.getUserId().then((value) {
      setState(() {
        _userId = value;
      });
      _loadUserData();
    });
    _dateMaskFormatter = MaskTextInputFormatter(
      mask: '##/##/####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy,
    );
  }

  void _loadUserData() async {
    if (_userId != null) {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .get();

      setState(() {
        final name = userData['name'];
        final surname = userData['surname'];
        _nameController.text = '$name $surname';
        _emailController.text = userData['email'];
        _selectedBloodType = userData['blood_type'];
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedBloodType != null) {
      await _donationService.bookBloodDonationAppointment(
        donorName: _nameController.text,
        email: _emailController.text,
        date: _dateController.text,
        bloodType: _selectedBloodType!,
        userId: _userId!,
      );

      _nameController.clear();
      _emailController.clear();
      _dateController.clear();
      setState(() {
        _selectedBloodType = null;
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              successIcon,
              sizedBoxWidth10,
              Expanded(child: Text(AppLocalizations.of(context)!.success)),
            ],
          ),
          content: Text(AppLocalizations.of(context)!.reservationSuccessText),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.ok),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _bloodDropController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.donationDateReservation,
          style: appBarTextStyle,
        ),
        backgroundColor: appBarBackgroundColor,
        iconTheme: appBarIconTheme,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: SingleChildScrollViewPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: AppLocalizations.of(context)!.fullNameLabel,
                    labelStyle: labelTextStyle,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.fullNameTxt;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: sizedBoxHeight),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: AppLocalizations.of(context)!.emailTxt,
                    labelStyle: labelTextStyle,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.emailReminder;
                    }
                    if (!_emailRegExp.hasMatch(value)) {
                      return AppLocalizations.of(context)!.emailErrorMessage;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: sizedBoxHeight),
                TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: AppLocalizations.of(context)!.date,
                    labelStyle: labelTextStyle,
                  ),
                  inputFormatters: [_dateMaskFormatter],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.enterDonationDate;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: sizedBoxHeight),
                BloodTypeDropdownWidget(
                  onChanged: (value) {
                    setState(() {
                      _selectedBloodType = value.toString().split('.').last;
                    });
                  },
                  value: _selectedBloodType != null
                      ? BloodTypes.values.firstWhere((element) =>
                          element.toString().split('.').last ==
                          _selectedBloodType)
                      : null,
                ),
                const SizedBox(height: sizedBoxHeight),
                ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(AppLocalizations.of(context)!.submitBtn),
                    style: elevatedButtonStylee),
                Center(
                  child: FadeTransition(
                    opacity: _bloodDropAnimation,
                    child: Icon(
                      Icons.bloodtype,
                      size: bloodTypeIconSize,
                      color: bloodTypeIconColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
