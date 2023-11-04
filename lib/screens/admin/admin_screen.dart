import 'package:flutter/material.dart';
import 'package:mindcare_app/screens/admin/customAppBar.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar().buildAppBar(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 236, 197, 252),
              Color.fromARGB(255, 225, 207, 255),
              Color.fromARGB(255, 169, 198, 255),
              Color.fromARGB(255, 114, 191, 255),
            ],
          ),
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
                dataRowHeight: 50,
                headingRowColor: MaterialStateProperty.all(
                  const Color.fromARGB(255, 79, 144, 255),
                ),
                sortColumnIndex: 2,
                sortAscending: false,
                columns: const [
                  DataColumn(label: Text("Nombre")),
                  DataColumn(label: Text("Email")),
                  DataColumn(label: Text("Verificado")),
                  DataColumn(label: Text("Activado")),
                  DataColumn(label: Text("Editar")),
                  DataColumn(label: Text("Borrar")),
                ],
                rows: const [
                  DataRow(cells: [
                    DataCell(Text("Andres")),
                    DataCell(Text("andres@gmail.com")),
                    DataCell(Icon(Icons.check), showEditIcon: true),
                    DataCell(Icon(Icons.check), showEditIcon: true),
                    DataCell(Icon(Icons.edit)),
                    DataCell(Icon(Icons.delete)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text("Ramos")),
                    DataCell(Text("ramos@gmail.com")),
                    DataCell(Icon(Icons.check), showEditIcon: true),
                    DataCell(Icon(Icons.check_box), showEditIcon: true),
                    DataCell(Icon(Icons.edit_square)),
                    DataCell(Icon(Icons.delete)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text("Ramos")),
                    DataCell(Text("ramos@gmail.com")),
                    DataCell(Icon(Icons.check), showEditIcon: true),
                    DataCell(Icon(Icons.check_box), showEditIcon: true),
                    DataCell(Icon(Icons.edit_square)),
                    DataCell(Icon(Icons.delete)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text("Ramos")),
                    DataCell(Text("ramos@gmail.com")),
                    DataCell(Icon(Icons.check), showEditIcon: true),
                    DataCell(Icon(Icons.check_box), showEditIcon: true),
                    DataCell(Icon(Icons.edit_square)),
                    DataCell(Icon(Icons.delete)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text("Ramos")),
                    DataCell(Text("ramos@gmail.com")),
                    DataCell(Icon(Icons.check), showEditIcon: true),
                    DataCell(Icon(Icons.check_box), showEditIcon: true),
                    DataCell(Icon(Icons.edit_square)),
                    DataCell(Icon(Icons.delete)),
                  ]),
                  
                  DataRow(cells: [
                    DataCell(Text("Ramos")),
                    DataCell(Text("ramos@gmail.com")),
                    DataCell(Icon(Icons.check), showEditIcon: true),
                    DataCell(Icon(Icons.check), showEditIcon: true),
                    DataCell(Icon(Icons.edit_note)),
                    DataCell(Icon(Icons.delete)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text("Ramos")),
                    DataCell(Text("ramos@gmail.com")),
                    DataCell(Icon(Icons.check), showEditIcon: true),
                    DataCell(Icon(Icons.close), showEditIcon: true),
                    DataCell(Icon(Icons.edit)),
                    DataCell(Icon(Icons.delete_forever_outlined)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text("Ramos")),
                    DataCell(Text("ramos@gmail.com")),
                    DataCell(Icon(Icons.check_circle), showEditIcon: true),
                    DataCell(Icon(Icons.check), showEditIcon: true),
                    DataCell(Icon(Icons.edit)),
                    DataCell(Icon(Icons.delete_forever)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text("Ramos")),
                    DataCell(Text("ramos@gmail.com")),
                    DataCell(Icon(Icons.disabled_by_default_outlined),
                        showEditIcon: true),
                    DataCell(Icon(Icons.check), showEditIcon: true),
                    DataCell(Icon(Icons.edit)),
                    DataCell(Icon(Icons.delete)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text("Ramos")),
                    DataCell(Text("ramos@gmail.com")),
                    DataCell(Icon(Icons.check), showEditIcon: true),
                    DataCell(Icon(Icons.disabled_by_default), showEditIcon: true),
                    DataCell(Icon(Icons.edit)),
                    DataCell(Icon(Icons.delete)),
                  ]),
                  DataRow(cells: [
                    DataCell(Text("Juan")),
                    DataCell(Text("Juan@gmail.com")),
                    DataCell(Icon(Icons.check_box_outline_blank),
                        showEditIcon: true),
                    DataCell(Icon(Icons.check), showEditIcon: true),
                    DataCell(Icon(Icons.edit)),
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
