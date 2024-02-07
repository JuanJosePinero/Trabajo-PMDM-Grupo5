import 'package:flutter/material.dart';
import 'package:mindcare_app/themes/themeColors.dart';
import 'package:mindcare_app/services/UserService.dart';
import 'package:mindcare_app/models/UserModel.dart';

class Graph extends StatefulWidget {
  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  final UserService userService = UserService();
  late List<UserData> users = [];
  String? selectedUser;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final user = await userService.getUsers();
    setState(() {
      users = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Graph Page'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: ThemeColors.getGradient(),
        ),
        child: Column(
          children: [
            const SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedUser,
                    hint: const Text("Select User"),
                    isExpanded: true,
                    onChanged: (newValue) {
                      setState(() {
                        selectedUser = newValue;
                      });
                    },
                    items: users.map<DropdownMenuItem<String>>((UserData user) {
                      return DropdownMenuItem<String>(
                        value: user.name,
                        child: Text(
                          user.name ?? 'Unknown',
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            const Expanded(
              child: Center(
                child: Text('Esta es la página del gráfico'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
