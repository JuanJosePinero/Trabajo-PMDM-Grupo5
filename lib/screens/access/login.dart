// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:mindcare_app/screens/access/forget_password.dart';
import 'package:mindcare_app/screens/admin/admin_screen.dart';
import 'package:mindcare_app/screens/main/main_screen.dart';
import 'package:mindcare_app/screens/main/notActived.dart';
import 'package:mindcare_app/screens/main/notVerified.dart';
import 'package:mindcare_app/themes/themeColors.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mindcare_app/services/UserService.dart';
import 'package:mindcare_app/models/UserModel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void click() {}
  bool _obscureText = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final UserService _userService = UserService();

  void login() async {
    String email = emailController.text;
    String password = passwordController.text;

    _userService.login(email, password).then((value) {

    if (value == 'success') {
      if (UserService.userType == 'a') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdminScreen()),
        );
      } else if (UserService.userType == 'u') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()),
            );
          } 
    }else if(value == 'Email not confimed') {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => notVerified()),
        );
    } else if(value == 'User not activated') {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => notActived()),
        );
    } else {
      // Mostrar mensaje de error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Login failed!'),
            content: const Text('Invalid credentials'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(gradient: ThemeColors.getGradient()),
          height: height,
          child: Stack(
            children: <Widget>[
              // Positioned(
              // top: -height * .15,
              // right: -MediaQuery.of(context).size.width * .4,
              // child: BezierContainer(),
              // ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * 0.1),
                      RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          text: 'M',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: Colors.lightBlue,
                          ),
                          children: [
                            TextSpan(
                              text: 'ind',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                              ),
                            ),
                            TextSpan(
                              text: 'C',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 30,
                              ),
                            ),
                            TextSpan(
                              text: 'ar',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                              ),
                            ),
                            TextSpan(
                              text: 'e',
                              style: TextStyle(
                                color: Colors.lightBlue,
                                fontSize: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        height: 100,
                        width: 100,
                        child: Image.asset('assets/screen_images/heart.gif'),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              12), // Cambia el valor para redondear las esquinas
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey
                                  .withOpacity(0.5), // Color de la sombra
                              spreadRadius: 5, // Radio de propagación
                              blurRadius: 7, // Radio de desenfoque
                              offset:
                                  Offset(0, 3), // Desplazamiento de la sombra
                            ),
                          ],
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: const [
                              Color.fromARGB(255, 255, 255, 255),
                              Color.fromARGB(255, 235, 246, 255),
                              Color.fromARGB(255, 199, 228, 252),
                              Color.fromARGB(255, 178, 218, 251),
                            ],
                          ),
                        ),
                        child: loginBox(context),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 0,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                            left: 0,
                            top: 10,
                            bottom: 10,
                          ),
                          child: Icon(
                            Icons.keyboard_arrow_left,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Back',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column loginBox(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 30,
        ),
        const Text(
          "Hello!",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          "Please Login to Your Account",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 15,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Container(
          width: 260,
          height: 60,
          child: TextField(
            controller:
                emailController, // Asociar el controlador de texto del email
            decoration: InputDecoration(
              suffixIcon: Icon(
                Icons.email,
                color: Colors.black54,
              ),
              labelText: "Email Address",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Container(
          width: 260,
          height: 60,
          child: TextField(
            controller:
                passwordController, // Asociar el controlador de texto de la contraseña
            obscureText: _obscureText,
            decoration: InputDecoration(
              labelText: "Password",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 30, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgetPassword(),
                    ),
                  );
                },
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(color: Colors.deepOrange),
                ),
              )
            ],
          ),
        ),
        GestureDetector(
          onTap: login,
          child: Container(
            alignment: Alignment.center,
            width: 250,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [
                      Color.fromARGB(255, 119, 194, 255),
                      Color.fromARGB(255, 21, 118, 255),
                    ])),
            child: InkWell(
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Login',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 17,
        ),
        Container(
          margin: EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Row(
            children: const <Widget>[
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Divider(
                    thickness: 1,
                  ),
                ),
              ),
              Text(
                'or login using',
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Divider(
                    thickness: 2,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: click,
                icon:
                    const Icon(FontAwesomeIcons.facebook, color: Colors.blue)),
            IconButton(
                onPressed: click,
                icon: const Icon(
                  FontAwesomeIcons.google,
                  color: Colors.redAccent,
                )),
            IconButton(
                onPressed: click,
                icon: const Icon(
                  FontAwesomeIcons.twitter,
                  color: Colors.orangeAccent,
                )),
            IconButton(
                onPressed: click,
                icon: const Icon(
                  FontAwesomeIcons.linkedinIn,
                  color: Colors.green,
                ))
          ],
        ),
      ],
    );
  }
}
