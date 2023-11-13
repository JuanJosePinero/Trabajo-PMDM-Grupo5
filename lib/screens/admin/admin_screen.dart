import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
        child: FutureBuilder<List<UserData>>(
          future: _userService.getUsers(), // Llamada a getUsers
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error fetching data'));
            } else {
              List<UserData> users = snapshot.data ?? [];

              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  UserData user = users[index];
                  return Slidable(
                    key: ValueKey(index),
                    startActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      dismissible: DismissiblePane(onDismissed: () {}),
                      children: [
                        SlidableAction(
                          backgroundColor: const Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                          onPressed: (BuildContext context) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Hello from Delete!')),
                            );
                            _userService.postDelete(user.id.toString());
                          },
                        ),
                        SlidableAction(
                          backgroundColor: const Color(0xFF21B7CA),
                          foregroundColor: Colors.white,
                          icon: Icons.share,
                          label: 'Share',
                          onPressed: (BuildContext context) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Hello from Share!')),
                            );
                          },
                        ),
                      ],
                    ),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          flex: 2,
                          backgroundColor: const Color(0xFF7BC043),
                          foregroundColor: Colors.white,
                          icon: Icons.archive,
                          label: 'Archive',
                          onPressed: (BuildContext context) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Hello from Archive!')),
                            );
                          },
                        ),
                        SlidableAction(
                          backgroundColor: const Color(0xFF0392CF),
                          foregroundColor: Colors.white,
                          icon: Icons.save,
                          label: 'Save',
                          onPressed: (BuildContext context) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Hello from Save!')),
                            );
                          },
                        ),
                      ],
                    ),
                    child: ListTile(title: Text(user.name ?? 'Unknown')),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
