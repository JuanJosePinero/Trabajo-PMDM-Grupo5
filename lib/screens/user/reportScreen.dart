import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mindcare_app/models/ElementModel.dart';
import 'package:mindcare_app/screens/user/pdf.dart';
import 'package:mindcare_app/services/ElementService.dart';
import 'package:mindcare_app/services/UserService.dart';
import 'package:mindcare_app/themes/themeColors.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  DateTime startDate = DateTime.now();
  DateTime finalDate = DateTime.now();
  bool isMoodsChecked = false;
  bool isEventsChecked = false;
  bool isEmotionsChecked = false;

  @override
  Widget build(BuildContext context) {
    String formattedStartDate =
        "${startDate.year}-${startDate.month}-${startDate.day}";

    String formattedFinalDate =
        "${finalDate.year}-${finalDate.month}-${finalDate.day}";

    return Scaffold(
      appBar: const CupertinoNavigationBar(
        middle: Text('Report Screen'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: ThemeColors.getGradient(),
        ),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            height: 8.0,
                            width: 50,
                          ),
                          TextButton(
                            onPressed: () {
                              _selectStartDate(context);
                            },
                            child: const Icon(Icons.edit_calendar_outlined),
                          ),
                          const SizedBox(
                            height: 8.0,
                            width: 60,
                          ),
                          TextButton(
                            onPressed: () {
                              _selectFinalDate(context);
                            },
                            child: const Icon(Icons.edit_calendar_outlined),
                          ),
                        ],
                      ),
                      const Row(
                        children: [
                          SizedBox(
                            height: 8.0,
                            width: 40,
                          ),
                          Text(
                            'Start Date:',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            height: 8.0,
                            width: 20,
                          ),
                          Text(
                            'Final Date:',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            height: 35.0,
                            width: 45,
                          ),
                          Text(
                            formattedStartDate,
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(
                            height: 8.0,
                            width: 35,
                          ),
                          Text(
                            formattedFinalDate,
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(
                            height: 50.0,
                          ),
                        ],
                      ),
                      const Divider(
                        color: Colors.black,
                        thickness: 1.0,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      const Row(
                        children: [
                          Flexible(
                            child: Wrap(
                              children: [
                                Text(
                                  'Select the elements you want to have in your report',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: isEmotionsChecked,
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    isEmotionsChecked = newValue ?? false;
                                  });
                                },
                              ),
                              const Text('Emotions'),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: isMoodsChecked,
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    isMoodsChecked = newValue ?? false;
                                  });
                                },
                              ),
                              const Text('Moods'),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: isEventsChecked,
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    isEventsChecked = newValue ?? false;
                                  });
                                },
                              ),
                              const Text('Events'),
                            ],
                          ),
                          const SizedBox(
                            height: 40.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  final elementService = ElementService();
                                  await elementService.obtenerElementos(
                                      startDate,
                                      finalDate,
                                      isMoodsChecked,
                                      isEventsChecked,
                                      isEmotionsChecked);

                                  String? fileName =
                                      await showFileNameDialog(context);

                                  if (fileName != null && fileName.isNotEmpty) {
                                    final pdfGenerator = PdfGenerator();
                                    if (elementService
                                        .elementsList.isNotEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Saving..."),
                                              CircularProgressIndicator(
                                                  color: Colors.white),
                                            ],
                                          ),
                                          duration: Duration(hours: 1),
                                          backgroundColor: Colors.blue,
                                        ),
                                      );

                                      try {
                                        List<Uint8List?> imageDatas =
                                            await pdfGenerator
                                                .loadImagesForElements(
                                                    elementService
                                                        .elementsList);

                                        await pdfGenerator.uploadPDF(
                                            elementService.elementsList,
                                            imageDatas,
                                            fileName);

                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();

                                        showSnackbarUploadPDF(
                                            context,
                                            "Pdf saved successfully!",
                                            Icons.check_circle,
                                            Colors.green);
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();

                                        showSnackbarUploadPDF(
                                            context,
                                            "Error saving pdf: $e",
                                            Icons.error,
                                            Colors.red);
                                      }
                                    } else {
                                      showSnackbarNoElements(
                                          context,
                                          "Error. There aren't elements between these dates",
                                          Icons.error,
                                          Colors.red);
                                    }
                                  } else {
                                    showSnackbarUploadPDF(
                                        context,
                                        "Error saving pdf: No file name provided",
                                        Icons.error,
                                        Colors.red);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                ),
                                child: const Text('Upload PDF'),
                              ),
                              const SizedBox(width: 16.0),
                              ElevatedButton(
   onPressed: () async {
    final elementService = ElementService();
    await elementService.obtenerElementos(startDate, finalDate, isMoodsChecked, isEventsChecked, isEmotionsChecked);
    String? fileName = await showFileNameDialog(context);

    if (fileName != null && fileName.isNotEmpty && elementService.elementsList.isNotEmpty) {
      final pdfGenerator = PdfGenerator();

      try {
        List<Uint8List?> imageDatas = await pdfGenerator.loadImagesForElements(elementService.elementsList);
        
        String recipientEmail = UserService.userEmail;
        print(recipientEmail);
        
        await pdfGenerator.sendPDF(elementService.elementsList, imageDatas, fileName, recipientEmail);
        
        showSnackbarUploadPDF(context, "PDF enviado exitosamente!", Icons.check_circle, Colors.green);
      } catch (e) {
        showSnackbarUploadPDF(context, "Error enviando el PDF: $e", Icons.error, Colors.red);
      }
    } else {
      showSnackbarUploadPDF(context, "Error: Datos insuficientes para generar o enviar el PDF.", Icons.error, Colors.red);
    }
  },
  style: ElevatedButton.styleFrom(
    primary: Colors.red,
  ),
  child: const Text('Send PDF'),
),

                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
      });
    }
  }

  Future<void> _selectFinalDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: finalDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != finalDate) {
      setState(() {
        finalDate = picked;
      });
    }
  }

  Future<String?> showFileNameDialog(BuildContext context) async {
    String? fileName;

    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Write the file name'),
          content: TextField(
            onChanged: (value) {
              fileName = value;
            },
            decoration: const InputDecoration(hintText: "Enter file name"),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(fileName);
              },
            ),
          ],
        );
      },
    );
  }

  void showSnackbarUploadPDF(
      BuildContext context, String message, IconData icon, Color color) {
    final snackBar = SnackBar(
      content: Row(
        children: <Widget>[
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Text(message),
        ],
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showSnackbarNoElements(
      BuildContext context, String message, IconData icon, Color color) {
    final snackBar = SnackBar(
      content: Row(
        children: <Widget>[
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              message,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showLoadingSnackbar(
      BuildContext context, String message, IconData icon, Color color) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(message),
              Icon(icon, color: color),
            ],
          ),
          backgroundColor: Colors.blue,
        ),
      );
  }
}
