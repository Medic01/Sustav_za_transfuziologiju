import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

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
    ..subject = accepted ? 'Prihvaćena donacija krvi' : 'Odbijena donacija krvi'
    ..text = accepted
        ? 'Vaša donacija krvi je uspješno prihvaćena. Hvala vam što ste donirali.'
        : 'Nažalost, vaša donacija krvi nije prihvaćena.';

  try {
    final sendReport = await send(message, smtpServer);

    if (sendReport != null) {
      print('Email poslan: ${sendReport.toString()}');

      await Future.delayed(const Duration(minutes: 2));

      final additionalMessage = Message()
        ..from = const Address(username, 'Transfuzija Krvi')
        ..recipients.add(recipientEmail)
        ..subject = 'Dodatna poruka'
        ..text = 'Evo me nakon 2 minute.';

      final additionalSendReport = await send(additionalMessage, smtpServer);

      if (additionalSendReport != null) {
        print('Dodatni email poslan: ${additionalSendReport.toString()}');
      } else {
        print('Dodatni email nije uspješno poslan');
      }
    } else {
      print('Email nije uspješno poslan');
    }
  } on MailerException catch (e) {
    print('Greška pri slanju emaila: ${e.message}');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  } catch (e) {
    print('Nepoznata greška: $e');
  }
}
