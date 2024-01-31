import 'package:mindcare_app/models/ElementModel.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PdfGenerator {
  void printElementsList(List<ElementData> elements) {
  for (var element in elements) {
    print('Name: ${element.name ?? ''}');
    print('Date: ${element.date ?? ''}');
    print('Description: ${element.description ?? ''}');
    print('-----------------------------------');
  }
}
  Future<void> uploadPDF(List<ElementData> elements) async {
    final pdf = pw.Document();

    // Añadir una nueva página con el encabezado y los elementos
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) => [
        pw.Header(
          level: 0,
          child: pw.Center(
            child: pw.Text(
              "List of Elements",
              style: pw.TextStyle(fontSize: 18),
            ),
          ),
        ),
        pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: elements.map((element) {
              return _buildElementDetails(element);
            }).toList()),
      ],
    ));

    // Guardar el PDF
    final downloadsDirectory = await getDownloadsDirectory();
    final file = File("${downloadsDirectory?.path}/elements.pdf");
    await file.writeAsBytes(await pdf.save());
    print('PDF guardado en: ${file.path}');

    // También guardar en la carpeta de documentos de la aplicación
    final appDirectory = await getApplicationDocumentsDirectory();
    final pdfFile = File("${appDirectory.path}/pdf/elements.pdf");
    await pdfFile.writeAsBytes(await pdf.save());
    print('PDF guardado en: ${pdfFile.path}');
  }

  pw.Widget _buildElementDetails(ElementData element) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Name: ${element.name ?? 'N/A'}', style: pw.TextStyle(fontSize: 12)),
        pw.Text('Date: ${element.date ?? 'N/A'}', style: pw.TextStyle(fontSize: 12)),
        pw.Text('Description: ${element.description ?? 'N/A'}', style: pw.TextStyle(fontSize: 12)),
        pw.Divider(color: PdfColors.grey),
      ],
    );
  }
}