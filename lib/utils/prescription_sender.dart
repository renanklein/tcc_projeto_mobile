import 'dart:io';

import 'package:injector/injector.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:tcc_projeto_app/login/models/user_model.dart';
import 'package:tcc_projeto_app/main.dart';
import 'package:tcc_projeto_app/med_record/models/diagnosis/complete_diagnosis_model.dart';
import 'package:tcc_projeto_app/pacient/models/pacient_model.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:tcc_projeto_app/utils/layout_utils.dart';

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
          return pw.Flex(direction: pw.Axis.vertical, children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("Paciente: ${pacient.getNome}",
                    textAlign: pw.TextAlign.left),
                pw.Text("Médico: ${user.name}", textAlign: pw.TextAlign.left),
                pw.Text("Data de realização: $diagnosisDate",
                    textAlign: pw.TextAlign.left),
                ...diagnosisCidsAndDescriptions,
              ],
            ),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [pw.Text("Prescrição: ${diagnosis.prescription}")])
          ]);
        }));
    var tempDir = await getTemporaryDirectory();
    var fileName = "prescricao.pdf";
    var file = File("${tempDir.path}/$fileName");
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static Future sendEmail(List<String> recipients, String body, File attachment,
      String subject) async {
    var email = Email(
        subject: subject,
        body: body,
        recipients: recipients,
        attachmentPaths: [attachment.path],
        isHTML: false);

    await FlutterEmailSender.send(email);
  }
}
