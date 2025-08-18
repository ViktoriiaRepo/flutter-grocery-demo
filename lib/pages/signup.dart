import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/auth_header.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _name  = TextEditingController();
  final _email = TextEditingController();
  final _pass  = TextEditingController();
  bool _obscure = true;

  bool get _emailOk => RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(_email.text);

  @override
  void dispose() { _name.dispose(); _email.dispose(); _pass.dispose(); super.dispose(); }

  void _submit(){
    if (_formKey.currentState!.validate()){
      debugPrint('signup: name=${_name.text}, email=${_email.text}');
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
                Text('Sign Up', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text('Enter your credentials to continue', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54)),
                const SizedBox(height: 24),

                TextFormField(
                  controller: _name,
                  decoration: const InputDecoration(labelText: 'Username', border: UnderlineInputBorder()),
                  validator: (v)=> (v==null || v.isEmpty) ? 'Enter your name' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _email,
                  onChanged: (_) => setState((){}),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: const UnderlineInputBorder(),
                    suffixIcon: _emailOk ? const Icon(Icons.check_circle, color: green) : null,
                  ),
                  validator: (v){
                    if (v==null || v.isEmpty) return 'Enter email';
                    return _emailOk ? null : 'Wrong email';
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

                const SizedBox(height: 12),
                Text.rich(
                  TextSpan(
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black54),
                    children: [
                      const TextSpan(text: 'By continuing you agree to our '),
                      TextSpan(text: 'Terms of Service', style: const TextStyle(color: green),
                          recognizer: TapGestureRecognizer()..onTap = ()=> debugPrint('TOS')),
                      const TextSpan(text: ' and '),
                      TextSpan(text: 'Privacy Policy', style: const TextStyle(color: green),
                          recognizer: TapGestureRecognizer()..onTap = ()=> debugPrint('Privacy')),
                      const TextSpan(text: '.'),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity, height: 56,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: _submit,
                    child: const Text('Sign Up'),
                  ),
                ),

                const SizedBox(height: 16),
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black87),
                      children: [
                        const TextSpan(text: 'Already have an account? '),
                        TextSpan(
                          text: 'Sign Up',
                          style: const TextStyle(color: green, fontWeight: FontWeight.w600),
                          recognizer: TapGestureRecognizer()..onTap = ()=> context.go('/login'),
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
