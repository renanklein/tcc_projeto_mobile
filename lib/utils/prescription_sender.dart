import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:tcc_projeto_app/login/models/user_model.dart';
import 'package:tcc_projeto_app/main.dart';
import 'package:tcc_projeto_app/med_record/models/diagnosis/complete_diagnosis_model.dart';
import 'package:tcc_projeto_app/pacient/models/pacient_model.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:tcc_projeto_app/utils/api/google_auth_api.dart';

class PrescriptionSender {
  static final user = Injector.appInstance.get<UserModel>();

  static Future<File> prescriptionToPdf(
      CompleteDiagnosisModel diagnosis, PacientModel pacient) async {
    var pdf = pw.Document();
    var diagnosisDate = dateFormatter.format(diagnosis.getDate);
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat(
            PdfPageFormat.a4.width, PdfPageFormat.a4.height,
            marginLeft: 10.0, marginTop: 10.0),
        build: (context) {
          var diagnosisCidsAndDescriptions = [];
          for (int i = 0; i < diagnosis?.diagnosis?.diagnosisCid?.length; i++) {
            diagnosisCidsAndDescriptions.add(pw.Text(
                "Cid do diagnóstico: ${diagnosis?.diagnosis?.diagnosisCid[i]}",
                textAlign: pw.TextAlign.left));
            diagnosisCidsAndDescriptions.add(pw.Text(
                "Descrição do diagnóstico: ${diagnosis?.diagnosis?.diagnosisDescription[i]}",
                textAlign: pw.TextAlign.left));
          }
          return pw.Flex(direction: pw.Axis.horizontal, children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("Paciente: ${pacient.getNome}",
                    textAlign: pw.TextAlign.left),
                pw.Text("Médico: ${user.name}", textAlign: pw.TextAlign.left),
                pw.Text("Data de realização: $diagnosisDate",
                    textAlign: pw.TextAlign.left),
                ...diagnosisCidsAndDescriptions,
                pw.SizedBox(height: 40), 
                pw.Text("Prescrição: ${diagnosis.prescription}")
              ],
            ),
          ]);
        }));
    var tempDir = await getTemporaryDirectory();
    var fileName = "prescricao.pdf";
    var file = File("${tempDir.path}/$fileName");
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static Future sendEmail(List<String> recipients, String body, File attachment,
      String subject, BuildContext context) async {
    final user = await GoogleAuthApi.signIn();
    if (user == null) return;
    var senderEmail = user.email;
    final auth = await user.authentication;
    var token = auth.accessToken;
    final smtpServer = gmailSaslXoauth2(senderEmail, token);
    final message = Message()
      ..from = Address(emailSender, "Prescrição")
      ..attachments = <Attachment>[FileAttachment(attachment)]
      ..subject = subject
      ..text = body
      ..recipients = recipients;

    try {
     await send(message, smtpServer);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "Email enviado com sucesso",
          style: TextStyle(
              fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ));
    } catch (error, stack_trace) {
      await FirebaseCrashlytics.instance.recordError(error, stack_trace);
    } 
  }
}
