import 'package:flutter/material.dart';
import 'package:mindcare_app/screens/admin/customAppBar.dart';
import 'package:mindcare_app/themes/themeColors.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar().adminAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: ThemeColors.getGradient()
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical, // Scroll vertical
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
              maxWidth: double.infinity,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Scroll horizontal
              child: DataTable(
                // ignore: deprecated_member_use
                dataRowHeight: 50,
                headingRowColor: MaterialStateProperty.all(
                  const Color.fromARGB(255, 79, 144, 255),
                ),
                sortColumnIndex: 2,
                sortAscending: false,
                columns: const [
                  DataColumn(label: Text("Name")),
                  DataColumn(label: Text("Email")),
                  DataColumn(label: Text("Verified")),
                  DataColumn(label: Text("Activated")),
                  DataColumn(label: Text("Delete")),
                ],
                rows: const [
                  DataRow(cells: [
                    DataCell(Text("Andres")),
                    DataCell(Text("andres@gmail.com")),
                    DataCell(Icon(Icons.check), showEditIcon: true),
                    DataCell(Icon(Icons.check), showEditIcon: true),
                    DataCell(Icon(Icons.delete)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text("Ramos")),
                    DataCell(Text("ramos@gmail.com")),
                    DataCell(Icon(Icons.check), showEditIcon: true),
                    DataCell(Icon(Icons.check_box), showEditIcon: true),
                    DataCell(Icon(Icons.delete)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text("Ramos")),
                    DataCell(Text("ramos@gmail.com")),
                    DataCell(Icon(Icons.check), showEditIcon: true),
                    DataCell(Icon(Icons.check_box), showEditIcon: true),
                    DataCell(Icon(Icons.delete)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text("Ramos")),
                    DataCell(Text("ramos@gmail.com")),
                    DataCell(Icon(Icons.check), showEditIcon: true),
                    DataCell(Icon(Icons.check_box), showEditIcon: true),
                    DataCell(Icon(Icons.delete)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text("Ramos")),
                    DataCell(Text("ramos@gmail.com")),
                    DataCell(Icon(Icons.check), showEditIcon: true),
                    DataCell(Icon(Icons.check_box), showEditIcon: true),
                    DataCell(Icon(Icons.delete)),
                  ]),
                  
                  DataRow(cells: [
                    DataCell(Text("Ramos")),
                    DataCell(Text("ramos@gmail.com")),
                    DataCell(Icon(Icons.check), showEditIcon: true),
                    DataCell(Icon(Icons.check), showEditIcon: true),
                    DataCell(Icon(Icons.delete)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text("Ramos")),
                    DataCell(Text("ramos@gmail.com")),
                    DataCell(Icon(Icons.check), showEditIcon: true),
                    DataCell(Icon(Icons.close), showEditIcon: true),
                    DataCell(Icon(Icons.delete_forever_outlined)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text("Ramos")),
                    DataCell(Text("ramos@gmail.com")),
                    DataCell(Icon(Icons.check_circle), showEditIcon: true),
                    DataCell(Icon(Icons.check), showEditIcon: true),
                    DataCell(Icon(Icons.delete_forever)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text("Ramos")),
                    DataCell(Text("ramos@gmail.com")),
                    DataCell(Icon(Icons.disabled_by_default_outlined),
                        showEditIcon: true),
                    DataCell(Icon(Icons.check), showEditIcon: true),
                    DataCell(Icon(Icons.delete)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text("Ramos")),
                    DataCell(Text("ramos@gmail.com")),
                    DataCell(Icon(Icons.check), showEditIcon: true),
                    DataCell(Icon(Icons.disabled_by_default), showEditIcon: true),
                    DataCell(Icon(Icons.delete)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text("Juan")),
                    DataCell(Text("Juan@gmail.com")),
                    DataCell(Icon(Icons.check_box_outline_blank),
                        showEditIcon: true),
                    DataCell(Icon(Icons.check), showEditIcon: true),
                    DataCell(Icon(Icons.delete)),
                  ]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
