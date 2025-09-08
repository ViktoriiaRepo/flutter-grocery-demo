import 'package:first_app/utils/colors.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  final Function(String, String) onLogin;
  final bool isLoading;

  const LoginForm({
    super.key,
    required this.onLogin,
    this.isLoading = false,
  });

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final form = GlobalKey<FormState>();
  final login = TextEditingController();
  final password = TextEditingController();
  bool _showPass = false;

  @override
  void dispose() {
    login.dispose();
    password.dispose();
    super.dispose();
  }

  void _onClick() {
    if (widget.isLoading) return;
    widget.onLogin(login.text.trim(), password.text.trim());
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
            decoration: const InputDecoration(
              hintText: "Email",
              label: Text("Email"),
            ),
          ),
          const SizedBox(height: 30),
          TextFormField(
            controller: password,
            obscureText: !_showPass,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: "Password",
              label: const Text("Password"),
              border: const UnderlineInputBorder(),
              suffixIcon: IconButton(
                tooltip: _showPass ? 'Hide password' : 'Show password',
                onPressed: () => setState(() => _showPass = !_showPass),
                icon: Icon(_showPass ? Icons.visibility_off : Icons.visibility),
                color: AppColor.descColor,
              ),
            ),
            onFieldSubmitted: (_) => _onClick(),
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
              onPressed: widget.isLoading ? null : _onClick,
              style: FilledButton.styleFrom(
                backgroundColor: AppColor.accentColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: widget.isLoading
                  ? const SizedBox(
                width: 22, height: 22,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
                  : const Text("Log In"),
            ),
          ),
        ],
      ),
    );
  }
}
