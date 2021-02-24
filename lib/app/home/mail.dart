import 'package:mailer2/mailer.dart';

class SendMail {
  SendMail();

  mail(recipients, subject, body) async {
    var options = new GmailSmtpOptions()
      ..username = 'whyghost33@gmail.com'
      ..password = 'WHYg#ost33';
    var emailTransport = new SmtpTransport(options);

    var envelope = new Envelope()
      ..from = 'whyghost133@gmail.com'
      ..recipients.addAll(recipients)
      ..subject = subject
      ..text = body;

    emailTransport
        .send(envelope)
        .then((envelope) => print('Email sent!'))
        .catchError((e) => print('Error occurred: $e'));
  }
}
