import 'package:flutter/material.dart';
import 'package:first_app/utils/colors.dart';

class LoginForm extends StatefulWidget {
  final Function(String, String) onLogin;

  const LoginForm({super.key, required this.onLogin});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  GlobalKey<FormState> form = GlobalKey();
  TextEditingController login = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    login.dispose();
    password.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Form(
      key: form,
      child: Column(
        children: [
          TextFormField(
            controller: login,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Email",
              label: Text("Email"),
            )
          ),
          const SizedBox(height: 30,),
          TextFormField(
            controller: password,
            obscureText: true,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: "Password",
              label: Text("Password"),
            ),
          ),
          const SizedBox(height: 30,),
          SizedBox(
            width: double.infinity,
            height: 67,
            child: FilledButton(
              onPressed: _onClick,
              style: FilledButton.styleFrom(
                backgroundColor: AppColor.accentColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),
                ),
              ),
                child: Text("Log In"),


            )
          )
        ]
      )
    );
  }
  _onClick(){
    widget.onLogin(
      login.text.trim(),
      password.text.trim(),
    );
  }
}
