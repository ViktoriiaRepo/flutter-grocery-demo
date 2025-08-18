import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/auth_header.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass  = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      debugPrint('login: ${_email.text}');
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF53B175);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AuthHeader(),
                const SizedBox(height: 16),
                Text(
                    'Log In',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text('Enter your emails and password', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54)),
                const SizedBox(height: 24),

                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: UnderlineInputBorder(),
                  ),
                  validator: (v){
                    if (v==null || v.isEmpty) return 'Enter email';
                    final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(v);
                    return ok ? null : 'Wrong email';
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _pass,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const UnderlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                      onPressed: ()=> setState(()=> _obscure = !_obscure),
                    ),
                  ),
                  validator: (v){
                    if (v==null || v.isEmpty) return 'Enter password';
                    if (v.length < 6) return 'Min 6 symbols';
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => debugPrint('Forgot password tapped'),
                    child: const Text('Forgot Password?'),
                  ),
                ),
                const SizedBox(height: 8),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: _submit,
                    child: const Text('Log In'),
                  ),
                ),

                const SizedBox(height: 16),
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black87),
                      children: [
                        const TextSpan(text: "Don't have an account? "),
                        TextSpan(
                          text: 'Signup',
                          style: const TextStyle(color: green, fontWeight: FontWeight.w600),
                          recognizer: TapGestureRecognizer()..onTap = ()=> context.go('/signup'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

