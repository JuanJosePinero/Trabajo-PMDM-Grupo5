import 'package:flutter/material.dart';
import 'package:mindcare_app/screens/admin/customAppBar.dart';
import 'package:mindcare_app/themes/themeColors.dart';
import 'package:mindcare_app/services/UserService.dart';
import 'package:mindcare_app/models/UserModel.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final UserService _userService = UserService();
  late List<UserData> _users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final users = await _userService.getUsers();
    setState(() {
      _users = users;
    });
  }

  String? _truncateName(String? name) {
    if (name != null && name.length > 12) {
      return '${name.substring(0, 12)}...';
    }
    return name;
  }

  void _activateUser(int? id) {
    // Lógica para activar el usuario
  }

  void _editUser(int? id) {
    // Lógica para editar el usuario
  }

  void _deleteUser(int? id) {
    // Lógica para eliminar el usuario
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar().adminAppBar(),
      body: Container(
        decoration: BoxDecoration(
          gradient: ThemeColors.getGradient(),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
              maxWidth: double.infinity,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                dataRowHeight: 50,
                headingRowColor: MaterialStateProperty.all(
                  const Color.fromARGB(255, 79, 144, 255),
                ),
                sortColumnIndex: 0,
                sortAscending: true,
                columns: const [
                  DataColumn(label: Text("Name")),
                  DataColumn(label: Text("Activate")),
                  DataColumn(label: Text("Edit")),
                  DataColumn(label: Text("Delete")),
                ],
                rows: _users.map((user) {
                  return DataRow(cells: [
                    DataCell(
                      Container(
                        constraints: const BoxConstraints(maxWidth: 200),
                        child: Tooltip(
                          message: user.name ?? 'Unknown',
                          child: Text(
                            _truncateName(user.name) ?? 'Unknown',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    DataCell(IconButton(
                      iconSize: 30,
                      icon: const Icon(Icons.check),
                      onPressed: () {
                        _activateUser(user.id);
                      },
                    )),
                    DataCell(IconButton(
                      iconSize: 30,
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _editUser(user.id);
                      },
                    )),
                    DataCell(IconButton(
                      iconSize: 30,
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _deleteUser(user.id);
                      },
                    )),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
