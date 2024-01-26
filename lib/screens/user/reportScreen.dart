import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mindcare_app/themes/themeColors.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";

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
                              _selectDate(context);
                            },
                            child: const Icon(Icons.edit_calendar_outlined),
                          ),
                          const SizedBox(
                            height: 8.0,
                            width: 60,
                          ),
                          TextButton(
                            onPressed: () {
                              _selectDate(context);
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
                            formattedDate,
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(
                            height: 8.0,
                            width: 50,
                          ),
                          Text(
                            formattedDate,
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(
                            height: 50.0,
                          ),
                        ],
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
                      Column(
  children: [
    Row(
      children: [
        Checkbox(
          value: false, // Puedes establecer el valor según tu lógica
          onChanged: (bool? newValue) {
            // Aquí puedes manejar la lógica cuando se cambia el estado del checkbox
          },
        ),
        const Text('Emotions'),
      ],
    ),
    Row(
      children: [
        Checkbox(
          value: false, // Puedes establecer el valor según tu lógica
          onChanged: (bool? newValue) {
            // Aquí puedes manejar la lógica cuando se cambia el estado del checkbox
          },
        ),
        const Text('Moods'),
      ],
    ),
    Row(
      children: [
        Checkbox(
          value: false, // Puedes establecer el valor según tu lógica
          onChanged: (bool? newValue) {
            // Aquí puedes manejar la lógica cuando se cambia el estado del checkbox
          },
        ),
        const Text('Events'),
      ],
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            // Lógica para la acción de "Upload PDF"
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
          ),
          child: const Text('Upload PDF'),
        ),
        const SizedBox(width: 16.0), // Espacio entre botones
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

                      // Agrega aquí el contenido adicional de tu pantalla de informes.
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
