import 'package:firebase_database/firebase_database.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

const String gmailUsername = '';
const String gmailPassword = '';

main() async {
  var options = new SmtpOptions()
    ..hostName = 'mailslurp.mx'
    ..port = 2587
    ..secured = true
    ..username = ''
    ..password = '';
  // Firebase configurationn
  final reference =
      FirebaseDatabase.instance.reference().child('blood_donation');
  // Mail configuration with app password
  final smtpServer = SmtpServer(options);
  // Listen for changes in Firebase
  reference.onChildChanged.listen((event) async {
    print('Child changed event detected');

    DataSnapshot snapshot = event.snapshot;
    Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;

    String status = data['status']?.toLowerCase() ?? '';
    if (status == 'accepted' || status == 'rejected') {
      print('Status change detected to: $status');

      String donorEmail = data['email'];

      final message = Message()
        ..from = Address(gmailUsername, 'MARKO SALJE')
        ..recipients.add(donorEmail)
        ..subject = 'Status vaše donacije je promijenjen'
        ..text = 'Vaša doza je ${status}';

      try {
        final sendReport = await send(message, smtpServer);
        print('Message sent: ' + sendReport.toString());
      } catch (error) {
        print('Error sending email: $error');
      }
    }
  });
}
