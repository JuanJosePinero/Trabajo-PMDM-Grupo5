import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:mindcare_app/screens/admin/customAppBar.dart';
import 'package:mindcare_app/themes/themeColors.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({Key? key}) : super(key: key);

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
                  'If you want to change your password,\nplease write your email here to send \n you a new password code.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            sizedBoxSpace,
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  filled: true,
                  icon: Icon(Icons.email),
                  hintText: 'example@gmail.com',
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: _validateMail,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Agregar lógica para enviar el código aquí

                // Muestra el Snackbar
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.check,
                            color:
                                Colors.green), 
                        SizedBox(width: 8), 
                        Text(
                            'Code sent correctly to email'), 
                      ],
                    ),
                  ),
                );
              },
              child: const Text('Send Password Code'),
            ),
          ],
        ),
      ),
    );
  }

  String? _validateMail(String? value) {
    if (value == null || value.isEmpty) {
      return 'It can not be empty';
    }
    if (!EmailValidator.validate(value)) {
      return 'Invalid email';
    }
    return null;
  }
}
