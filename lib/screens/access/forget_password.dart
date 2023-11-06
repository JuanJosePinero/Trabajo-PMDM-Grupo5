import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:mindcare_app/screens/admin/customAppBar.dart';
import 'package:mindcare_app/themes/themeColors.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _emailController = TextEditingController();
  String? _emailError;
  bool _showText = false;

  @override
  Widget build(BuildContext context) {
    const sizedBoxSpace = SizedBox(height: 24);
    return Scaffold(
      appBar: CustomAppBar().changePasswordAppBar(context),
      body: Container(
        decoration: BoxDecoration(
          gradient: ThemeColors.getGradient(),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            sizedBoxSpace,
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'If you want to change your password,\nplease write your email here to send\nyou a new password code.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            sizedBoxSpace,
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  filled: true,
                  icon: Icon(Icons.email),
                  hintText: 'example@gmail.com',
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  if (_emailError != null) {
                    setState(() {
                      _emailError = null;
                    });
                  }
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final email = _emailController.text;
                final emailError = _validateMail(email);

                if (emailError != null) {
                  setState(() {
                    _emailError = emailError;
                    _showText = false;
                  });
                } else {
                  // Agregar lógica para enviar el código aquí

                  // Muestra el Snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check, color: Colors.green),
                          SizedBox(width: 8),
                          Text('Code sent correctly to email'),
                        ],
                      ),
                    ),
                  );

                  // Muestra el texto después de un retraso
                  Future.delayed(const Duration(seconds: 2), () {
                    setState(() {
                      _showText = true;
                    });
                  });
                }
              },
              child: const Text('Send Password Code'),
            ),
            sizedBoxSpace,
            if (_showText)
              const Padding(
                padding: EdgeInsets.all(20.0),
                 child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Now you can check your email\n to change your password!',
                  style: TextStyle(color: Colors.black),  textAlign: TextAlign.center,
                  
                ),
              ),
              ),
            if (_emailError != null)
              Text(
                _emailError!,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  String? _validateMail(String value) {
    if (value.isEmpty) {
      return 'It cannot be empty';
    }
    if (!EmailValidator.validate(value)) {
      return 'Invalid email';
    }
    return null;
  }
}
