import 'package:mindcare_app/models/ElementModel.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PdfGenerator {
  Future<void> uploadPDF(List<ElementData> elements) async {
    final pdf = pw.Document();

    // Título centrado
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Text(
            "List of elements from you",
            style: pw.TextStyle(fontSize: 18),
          ),
        ),
      ),
    );

    // Separación
    pdf.addPage(
      pw.Page(build: (pw.Context context) => pw.SizedBox(height: 10)),
    );

    // Tabla
    final tableHeaders = ['Image', 'Description', 'Date'];

    if (elements.any((element) => element.type == 'Event')) {
      pdf.addPage(pw.Page(build: (pw.Context context) {
        return pw.Column(
          children: [
            pw.Text('Events',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            _buildTable(tableHeaders,
                elements.where((element) => element.type == 'Event')),
          ],
        );
      }));
    }

    if (elements.any(
        (element) => element.type == 'Mood' || element.type == 'Emotion')) {
      pdf.addPage(pw.Page(build: (pw.Context context) {
        return pw.Column(
          children: [
            pw.Text('Moods and Emotions',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            _buildTable(
              ['Image', 'Name', 'Date'],
              elements.where((element) =>
                  element.type == 'Mood' || element.type == 'Emotion'),
            ),
          ],
        );
      }));
    }

    // Guardar el PDF en la carpeta de descargas del dispositivo
    final downloadsDirectory = await getDownloadsDirectory();
    if (downloadsDirectory != null) {
      final file = File("${downloadsDirectory.path}/prueba3.pdf");
      await file.writeAsBytes(await pdf.save());
      print('PDF guardado en: ${file.path}');
    } else {
      print('No se pudo obtener el directorio de descargas.');
    }

    // Guardar el PDF en la carpeta lib/pdf del proyecto
    final appDirectory = await getApplicationDocumentsDirectory();
    final pdfFile = File("${appDirectory.path}/pdf/prueba.pdf");
    await pdfFile.writeAsBytes(await pdf.save());
    print('PDF guardado en: ${pdfFile.path}');
  }

  pw.Widget _buildTable(List<String> headers, Iterable<ElementData> elements) {
    final List<pw.TableRow> tableRows = [];

    // Headers
    final headerRow = headers
        .map((header) => pw.Text(header,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))
        .toList();
    tableRows.add(pw.TableRow(children: headerRow));

    // Rows
    for (final element in elements) {
      final image = element.image != null
          ? pw.Image(pw.MemoryImage(File(element.image!).readAsBytesSync()),
              width: 50, height: 50)
          : pw.Text('');
      final description = pw.Text(element.type == 'Event'
          ? element.description ?? ''
          : element.name ?? '');
      final date = pw.Text(element.date ?? '');

      final rowData = [image, description, date];
      tableRows.add(pw.TableRow(children: rowData));
    }

    return pw.Table(
      border: pw.TableBorder.all(),
      children: tableRows,
    );
  }
}
