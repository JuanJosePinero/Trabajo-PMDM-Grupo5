import 'package:flutter/material.dart';
import 'package:mindcare_app/screens/admin/graph.dart';

class CustomAppBar {
  AppBar adminAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.deepPurple,
      centerTitle: true,
      title: const Text(
        'Admin Settings',
        style:
            TextStyle(fontSize: 17, color: Colors.white, letterSpacing: 0.53),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.auto_graph_outlined),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Graph()),
            );
          },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(110.0),
        child: Container(
          padding: const EdgeInsets.only(left: 30, bottom: 20),
          child: Row(
            children: [
              const Stack(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person_outline_rounded),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Admin',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                    Text(
                      'admin@gmail.com',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'only the admin can watch this page',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  AppBar changePasswordAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.deepPurple,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: const Text(
        'Change Password',
        style:
            TextStyle(fontSize: 17, color: Colors.white, letterSpacing: 0.53),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(),
      ),
    );
  }

  AppBar changeRegisterAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.deepPurple,
      centerTitle: true,
      title: const Text(
        'Register',
        style:
            TextStyle(fontSize: 17, color: Colors.white, letterSpacing: 0.53),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(),
      ),
    );
  }
}

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton({
    Key? key,
    required this.onPressed,
    required this.tooltip,
    required this.heroTag,
    required this.icon,
    required this.label,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String tooltip;
  final Object? heroTag;
  final Icon icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FloatingActionButton(
          onPressed: onPressed,
          tooltip: tooltip,
          heroTag: heroTag,
          child: icon,
        ),
        const SizedBox(height: 1),
        Text(
          label,
          style: const TextStyle(
              fontSize:
                  12), // Ajusta el tamaño del texto según tus preferencias
        ),
      ],
    );
  }
}
