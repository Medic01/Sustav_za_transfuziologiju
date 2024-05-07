import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:sustav_za_transfuziologiju/email_sender/er.dart';

Future<void> sendBloodDonationEmail(
    String recipientEmail, bool accepted) async {
  const username = 'SMTP_USERNAME';
  const password = 'SMTP_PASSWORD';

  final smtpServer = SmtpServer(
    'mailslurp.mx',
    port: 2465,
    username: username,
    password: password,
    ssl: true,
  );

  final message = Message()
    ..from = const Address(username, 'Transfuzija Krvi')
    ..recipients.add(recipientEmail)
    ..subject = accepted ? acceptedSubject : rejectedSubject
    ..text = accepted ? acceptedBloodText : rejectedBloodText;

  try {
    final sendReport = await send(message, smtpServer);

    if (sendReport != null) {
      print('$emailSent ${sendReport.toString()}');
      await Future.delayed(const Duration(minutes: 2));

      final additionalMessage = Message()
        ..from = const Address(username, 'Transfuzija Krvi')
        ..recipients.add(recipientEmail)
        ..subject = additionalMessageText
        ..text = additionaMessageanotherText;

      final additionalSendReport = await send(additionalMessage, smtpServer);

      if (additionalSendReport != null) {
        print('$additionalEmailSent ${additionalSendReport.toString()}');
      } else {
        print(additionalEmailNotSent);
      }
    } else {
      print(emailNotSent);
    }
  } on MailerException catch (e) {
    print('$emailSentError ${e.message}');
    for (var p in e.problems) {
      print('$problem ${p.code}: ${p.msg}');
    }
  } catch (e) {
    print('$unknownError $e');
  }
}
