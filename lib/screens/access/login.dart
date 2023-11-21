import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:mindcare_app/screens/access/forget_password.dart';
import 'package:mindcare_app/screens/admin/admin_screen.dart';
import 'package:mindcare_app/screens/user/main_screen.dart';
import 'package:mindcare_app/themes/themeColors.dart';
import 'package:mindcare_app/services/UserService.dart';

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
    print(email + password);

    _userService.login(email, password).then((value) {
      if (value == 'success') {
        if (UserService.userType == 'a') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdminScreen()),
          );
        } else if (UserService.userType == 'u') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        }
      } else if (value == 'Email not confimed') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Email not confirmed! \nCheck your email to verify your account.'),
            backgroundColor: Colors.red,
          ),
        );
      } else if (value == 'User not activated') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('User not activated! \nAdmin must activate your account.'),
            backgroundColor: Colors.red,
          ),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                      const SizedBox(height: 20),
                      SizedBox(
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
                              offset: const Offset(
                                  0, 3), // Desplazamiento de la sombra
                            ),
                          ],
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color.fromARGB(255, 255, 255, 255),
                              Color.fromARGB(255, 235, 246, 255),
                              Color.fromARGB(255, 199, 228, 252),
                              Color.fromARGB(255, 178, 218, 251),
                            ],
                          ),
                        ),
                        child: loginBox(context),
                      ),
                      const SizedBox(
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(
                            left: 0,
                            top: 10,
                            bottom: 10,
                          ),
                          child: const Icon(
                            Icons.keyboard_arrow_left,
                            color: Colors.black,
                          ),
                        ),
                        const Text(
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
        SizedBox(
          width: 260,
          height: 60,
          child: TextField(
            controller:
                emailController, // Asociar el controlador de texto del email
            decoration: const InputDecoration(
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
        SizedBox(
          width: 260,
          height: 60,
          child: TextField(
            controller:
                passwordController, // Asociar el controlador de texto de la contraseña
            obscureText: _obscureText,
            decoration: InputDecoration(
              labelText: "Password",
              border: const OutlineInputBorder(
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
            child: const InkWell(
              child: Padding(
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
          margin: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: const Row(
            children: <Widget>[
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
