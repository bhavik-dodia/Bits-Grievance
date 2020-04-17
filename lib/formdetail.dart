import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toast/toast.dart';
import 'package:mailer2/mailer.dart';

class FormDetail extends StatelessWidget {
  FormDetail(
      {@required this.doc,
      this.description,
      this.category,
      this.subject,
      this.email,
      this.eno});

  final doc;
  final description;
  final category;
  final subject;
  final db = Firestore.instance;
  final email;
  final eno;

  void sendMail() {
    GmailSmtpOptions options = new GmailSmtpOptions()
      ..username = 'bitsgrievance@gmail.com'
      ..password = 'gouqmopakjxjmjty';
    SmtpTransport emailTransport = new SmtpTransport(options);
    Envelope envelope = new Envelope()
      ..from = 'bitsgrievance@gmail.com'
      ..recipients.add(email)
      ..subject = 'Grievance Solved!!!'
      //..attachments.add(new Attachment(file: new File(fileName)))
      ..html =
          "<html><body><p><font size=3>Thanks for contacting us!<br>Your grievance for Form ID: <b>$doc</b> has been resolved and closed successfully!!</font></p></body></html>";
    emailTransport
        .send(envelope)
        .then((envelope) => print('Email sent!'))
        .catchError((e) => print('Error occurred: $e'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(doc),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Column(
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(padding: const EdgeInsets.only(top: 20)),
                      Text("Enrollment No: " + eno,
                          softWrap: true, textAlign: TextAlign.justify),
                      Padding(padding: const EdgeInsets.only(top: 20)),
                      Text("Email Id: " + email,
                          softWrap: true, textAlign: TextAlign.justify),
                      Padding(padding: const EdgeInsets.only(top: 20)),
                      Text("Category: " + category,
                          softWrap: true, textAlign: TextAlign.justify),
                      Padding(padding: const EdgeInsets.only(top: 20)),
                      Text("Subject: " + subject,
                          softWrap: true, textAlign: TextAlign.justify),
                      Padding(padding: const EdgeInsets.only(top: 20)),
                      Text("Description: " + description,
                          softWrap: true, textAlign: TextAlign.justify),
                      Padding(padding: const EdgeInsets.only(top: 20)),
                      Container(
                        padding:
                            const EdgeInsets.only(top: 20, left: 90, right: 90),
                        child: MaterialButton(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          child: Text('Mark Close',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          splashColor: Colors.lightBlueAccent,
                          onPressed: () {
                            db
                                .collection('Forms')
                                .document(doc)
                                .updateData({'10 Status': 'Close'});
                            sendMail();
                            Toast.show(
                                "Form " + doc + " closed successfully", context,
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.BOTTOM);
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
