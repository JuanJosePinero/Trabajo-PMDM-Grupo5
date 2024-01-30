import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mindcare_app/models/ElementModel.dart';
import 'package:mindcare_app/screens/user/pdf.dart';
import 'package:mindcare_app/services/ElementService.dart';
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
                            width: 50,
                          ),
                          Text(
                            formattedStartDate,
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(
                            height: 8.0,
                            width: 50,
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
                                  elementService.obtenerElementos(startDate, finalDate, isMoodsChecked, isEventsChecked, isEmotionsChecked);
                                  final pdfGenerator = PdfGenerator();
                                  await pdfGenerator.uploadPDF(elementService.elementsList);
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                ),
                                child: const Text('Upload PDF'),
                              ),
                              const SizedBox(width: 16.0),
                              ElevatedButton(
                                onPressed: () {
                                  // Lógica para la acción de "Send PDF"
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

  // final elementService = ElementService();
  // List<ElementData> moodElements = [];
  // List<ElementData> eventElements = [];
  // List<ElementData> emotionElements = [];
  // List<ElementData> elementsList = [];

  // void obtenerElementos() async {
  //   try {
  //     ElementResponse response = await elementService.getElements();

  //     if (response.success == true) {
  //       // print('Elementos obtenidos correctamente:');
  //       response.data?.forEach((element) {
  //         // print('Nombre: ${element.name}, Fecha: ${element.date}');

  //         if (element.type == 'mood') {
  //           moodElements.add(element);
  //         } else if (element.type == 'event') {
  //           eventElements.add(element);
  //         } else if (element.type == 'emotion') {
  //           emotionElements.add(element);
  //         }
  //       });

  //       // Paso 3: Aplicar filtro por rango de fechas
  //       moodElements = moodElements.where((element) {
  //         DateTime elementDate = DateTime.parse(element.date!);
  //         return elementDate.isAfter(startDate) &&
  //             elementDate.isBefore(finalDate);
  //       }).toList();

  //       eventElements = eventElements.where((element) {
  //         DateTime elementDate = DateTime.parse(element.date!);
  //         return elementDate.isAfter(startDate) &&
  //             elementDate.isBefore(finalDate);
  //       }).toList();

  //       emotionElements = emotionElements.where((element) {
  //         DateTime elementDate = DateTime.parse(element.date!);
  //         return elementDate.isAfter(startDate) &&
  //             elementDate.isBefore(finalDate);
  //       }).toList();

  //       // Paso 4: Aplicar filtros de checkboxes
  //       if (!isMoodsChecked) {
  //         moodElements.clear();
  //       }

  //       if (!isEventsChecked) {
  //         eventElements.clear();
  //       }

  //       if (!isEmotionsChecked) {
  //         emotionElements.clear();
  //       }

  //       // Combinar los elementos filtrados en una lista
  //       elementsList.clear();
  //       elementsList.addAll(moodElements);
  //       elementsList.addAll(eventElements);
  //       elementsList.addAll(emotionElements);

  //       // Paso 5: Mostrar resultados en la consola
  //       print('Elementos filtrados por fechas y checkboxes:');
  //       elementsList.forEach((element) {
  //         print('Nombre: ${element.name}, Fecha: ${element.date}');
  //       });
  //     } else {
  //       print('Error al obtener elementos: ${response.message}');
  //     }
  //   } catch (error) {
  //     print('Error al obtener elementos: $error');
  //   }
  // }

}
