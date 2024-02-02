import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:mindcare_app/models/ElementModel.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:intl/intl.dart';

class PdfGenerator {
  void printElementsList(List<ElementData> elements) {
    for (var element in elements) {
      print('Name: ${element.name ?? ''}');
      print('Date: ${element.date ?? ''}');
      print('Description: ${element.description ?? ''}');
      print('-----------------------------------');
    }
  }

  Future<void> uploadPDF(List<ElementData> elements,
      List<Uint8List?> imageDatas, String fileName) async {
    final pdf = pw.Document();

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) => [
        pw.Header(
          level: 0,
          child: pw.Center(
            child: pw.Text(
              "List of Elements",
              style: const pw.TextStyle(fontSize: 18),
            ),
          ),
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: List.generate(elements.length * 2 - 1, (index) {
            if (index % 2 == 0) {
              return _buildElementDetails(
                  elements[index ~/ 2], imageDatas[index ~/ 2]);
            } else {
              return pw.Divider();
            }
          }),
        ),
      ],
    ));

    // Guardar el PDF
    final downloadsDirectory = await getDownloadsDirectory();
    final file = File("${downloadsDirectory?.path}/$fileName.pdf");
    await file.writeAsBytes(await pdf.save());
    print('PDF guardado en: ${file.path}');

    final appDirectory = await getApplicationDocumentsDirectory();
    final pdfFile = File("${appDirectory.path}/pdf/$fileName.pdf");
    await pdfFile.writeAsBytes(await pdf.save());
    print('PDF guardado en: ${pdfFile.path}');
  }

  pw.Widget _buildElementDetails(ElementData element, Uint8List? imageData) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        if (imageData != null)
          pw.Image(pw.MemoryImage(imageData), width: 80, height: 80),
        pw.SizedBox(width: 8),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text('Name: ${element.name ?? 'N/A'}',
                  style: const pw.TextStyle(fontSize: 12)),
              pw.Text('Date: ${element.date ?? 'N/A'}',
                  style: const pw.TextStyle(fontSize: 12)),
              pw.Text('Description: ${element.description ?? 'N/A'}',
                  style: const pw.TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }

  Future<Uint8List?> loadImageFromUrl(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        print(
            'Error loading image: Server returned status ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error loading image: $e');
      return null;
    }
  }

  Future<List<Uint8List?>> loadImagesForElements(
      List<ElementData> elements) async {
    List<Uint8List?> imageDatas = [];
    for (var element in elements) {
      if (element.image != null) {
        Uint8List? imageData = await loadImageFromUrl(element.image!);
        imageDatas.add(imageData);
      } else {
        imageDatas.add(null);
      }
    }
    return imageDatas;
  }

Future<void> sendPDF(List<ElementData> elements, List<Uint8List?> imageDatas, String fileName, String recipientEmail, DateTime startDate, DateTime endDate) async {
  final pdf = pw.Document();
  
  pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) => [
        pw.Header(
          level: 0,
          child: pw.Center(
            child: pw.Text(
              "List of Elements",
              style: const pw.TextStyle(fontSize: 18),
            ),
          ),
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: List.generate(elements.length * 2 - 1, (index) {
            if (index % 2 == 0) {
              return _buildElementDetails(
                  elements[index ~/ 2], imageDatas[index ~/ 2]);
            } else {
              return pw.Divider();
            }
          }),
        ),
      ],
    ));

  final bytes = await pdf.save();

  final tempDir = await getTemporaryDirectory();
  final tempFile = File('${tempDir.path}/$fileName.pdf');
  await tempFile.writeAsBytes(bytes);

  String username = 'raul.reyes@allsites.es';
  String password = 'wOvVm2296,@:'; 

  final smtpServer = SmtpServer('allsites-es.correoseguro.dinaserver.com',
      port: 465,
      username: username,
      password: password,
      ssl: true,
      ignoreBadCertificate: true
  );

  final dateFormat = DateFormat('dd/MM/yyyy');
  final formattedStartDate = dateFormat.format(startDate);
  final formattedEndDate = dateFormat.format(endDate);

  final message = Message()
    ..from = Address(username, "MindCare App")
    ..recipients.add(recipientEmail)
    ..subject = 'MindCare App. PDF: $fileName.pdf'
    ..text = 'Here you have the elements generated between ${formattedStartDate} and ${formattedEndDate}.'
    ..attachments.add(FileAttachment(tempFile));

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
  }

  await tempFile.delete();
}

}
