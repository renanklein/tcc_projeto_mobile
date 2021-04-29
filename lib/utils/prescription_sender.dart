
import 'dart:io';

import 'package:injector/injector.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tcc_projeto_app/login/models/user_model.dart';
import 'package:tcc_projeto_app/main.dart';
import 'package:tcc_projeto_app/med_record/models/diagnosis/complete_diagnosis_model.dart';
import 'package:tcc_projeto_app/pacient/models/pacient_model.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_email_sender/flutter_email_sender.dart';
class PrescriptionSender{
  static final user = Injector.appInstance.get<UserModel>();
  static Future<File> prescriptionToPdf(CompleteDiagnosisModel diagnosis, PacientModel pacient) async{
    var pdf = pw.Document();
    var diagnosisDate = dateFormatter.format(diagnosis.getDate);
    pdf.addPage(pw.Page(
      build: (context){
        return pw.Column(
          children: [
            pw.Center(child: pw.Text("Prescrição ${diagnosis.diagnosis.diagnosisCid}")),
            pw.Text("Paciente: ${pacient.getNome}"),
            pw.Text("Médico: ${user.name}"),
            pw.Text("Data de realização: $diagnosisDate"),
            pw.Text("Medicamento: ${diagnosis.prescription.prescriptionMedicine}"),
            pw.Text("Duração: ${diagnosis.prescription.prescriptionUsageDuration}"),
            pw.Text("Dosagem: ${diagnosis.prescription.prescriptionDosage}"),
            pw.Text("Orientação: ${diagnosis.prescription.prescriptionUsageOrientation}"),
            pw.Text("Informações: ${diagnosis.prescription.prescriptionDosageForm}")
          ],
        );
      }
    ));
    var tempDir = await getTemporaryDirectory();
    var fileName = "prescricao.pdf";
    var file = File("${tempDir.path}/$fileName");
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static Future sendEmail(List<String> recipients,String body, File attachment) async{
    var email = Email(
      body: body,
      recipients: recipients,
      attachmentPaths: [attachment.path],
      isHTML: false
    );

    await FlutterEmailSender.send(email);
  }
}