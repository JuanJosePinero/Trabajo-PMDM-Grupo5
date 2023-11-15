import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mindcare_app/screens/admin/customAppBar.dart';
import 'package:mindcare_app/themes/themeColors.dart';
import 'package:mindcare_app/services/UserService.dart';
import 'package:mindcare_app/models/UserModel.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  AdminScreenState createState() => AdminScreenState();
}

class AdminScreenState extends State<AdminScreen> {
  final UserService _userService = UserService();
  // ignore: unused_field
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

  Widget buildListTileSubtitle(int? actived) {
    if (actived == 1) {
      return const Text('Account activated');
    } else {
      return const Text('Account deactivated');
    }
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
                                SnackBar(
                                  content: Row(
                                    children: [
                                      const Icon(Icons.check,
                                          color: Colors.green),
                                      const SizedBox(width: 8),
                                      Text(
                                          '${user.name ?? "User"} has been deleted!'),
                                    ],
                                  ),
                                ),
                              );
                              _userService.postDelete(user.id.toString());
                            },
                          ),
                          SlidableAction(
                            backgroundColor:
                                const Color.fromARGB(255, 33, 151, 202),
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: 'Edit',
                            onPressed: (BuildContext context) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      const Icon(Icons.check,
                                          color: Colors.green),
                                      const SizedBox(width: 8),
                                      Text(
                                          '${user.name ?? "User"} has been edited!'),
                                    ],
                                  ),
                                ),
                              );
                              _userService.postUpdate(
                                  user.id.toString(), user.name.toString());
                            },
                          ),
                        ],
                      ),
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          if (user.actived == 1)
                            SlidableAction(
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 165, 80),
                              foregroundColor: Colors.white,
                              icon: Icons.not_interested_outlined,
                              label: 'Desactivate',
                              onPressed: (BuildContext context) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        const Icon(Icons.check,
                                            color: Colors.green),
                                        const SizedBox(width: 8),
                                        Text(
                                            '${user.name ?? "User"} has been desactivated!'),
                                      ],
                                    ),
                                  ),
                                );
                                _userService.postDeactivate(user.id.toString());
                              },
                            ),
                          if (user.actived == 0)
                            SlidableAction(
                              flex: 2,
                              backgroundColor: const Color(0xFF7BC043),
                              foregroundColor: Colors.white,
                              icon: Icons.verified_outlined,
                              label: 'Activate',
                              onPressed: (BuildContext context) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        const Icon(Icons.check,
                                            color: Colors.green),
                                        const SizedBox(width: 8),
                                        Text(
                                            '${user.name ?? "User"} has been activated!'),
                                      ],
                                    ),
                                  ),
                                );
                                _userService.postActivate(user.id.toString());
                              },
                            ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(user.name ?? 'Unknown'),
                        subtitle: buildListTileSubtitle(user.actived),
                      ));
                },
              );
            }
          },
        ),
      ),
    );
  }
}
