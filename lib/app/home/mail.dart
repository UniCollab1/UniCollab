import 'package:mailer2/mailer.dart';

class SendMail {
  SendMail();

  mail(recipients, subject, body) async {
    var options = new GmailSmtpOptions()
      ..username = 'rajkalathiya143@gmail.com'
      ..password = '123456789R@j';
    var emailTransport = new SmtpTransport(options);

    var envelope = new Envelope()
      ..from = 'rajkalathiya143@gmail.com'
      ..recipients.addAll(recipients)
      ..subject = subject
      ..text = body;

    emailTransport
        .send(envelope)
        .then((envelope) => print('Email sent!'))
        .catchError((e) => print('Error occurred: $e'));
  }
}
