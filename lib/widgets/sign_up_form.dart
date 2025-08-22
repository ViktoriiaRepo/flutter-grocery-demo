import 'package:flutter/material.dart';
import 'package:first_app/utils/colors.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    super.key,
    required this.onSubmit,
    this.loading = false,
    this.error,
  });

  final Future<void> Function({
  required String username,
  required String email,
  required String password,
  }) onSubmit;

  final bool loading;
  final String? error;

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameC  = TextEditingController();
  final _emailC = TextEditingController();
  final _passC  = TextEditingController();

  bool _agree = false;
  bool _showPass = false;

  @override
  void dispose() {
    _nameC.dispose();
    _emailC.dispose();
    _passC.dispose();
    super.dispose();
  }

  void _submit() {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    if (!_agree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept Terms & Privacy')),
      );
      return;
    }

    widget.onSubmit(
      username: _nameC.text.trim(),
      email: _emailC.text.trim(),
      password: _passC.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Username
          TextFormField(
            controller: _nameC,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Username',
              border: UnderlineInputBorder(),
            ),
            validator: (v) =>
            (v == null || v.trim().isEmpty) ? 'Enter username' : null,
          ),
          const SizedBox(height: 12),

          // Email
          TextFormField(
            controller: _emailC,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: UnderlineInputBorder(),
            ),
            validator: (v) {
              final t = v?.trim() ?? '';
              if (t.isEmpty) return 'Enter email';
              final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(t);
              return ok ? null : 'Invalid email';
            },
          ),
          const SizedBox(height: 12),

          // Password + око
          TextFormField(
            controller: _passC,
            obscureText: !_showPass,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: 'Password',
              border: const UnderlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: () => setState(() => _showPass = !_showPass),
                icon: Icon(_showPass ? Icons.visibility_off : Icons.visibility),
                color: AppColor.descColor,
                tooltip: _showPass ? 'Hide password' : 'Show password',
              ),
            ),
            validator: (v) =>
            (v == null || v.length < 6) ? 'Min 6 characters' : null,
            onFieldSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Checkbox(
                value: _agree,
                activeColor: AppColor.accentColor,
                onChanged: (v) => setState(() => _agree = v ?? false),
              ),
              Flexible(
                child: Text(
                  'By continuing you agree to our Terms of Service and Privacy Policy.',
                  style: TextStyle(color: AppColor.descColor, fontSize: 12),
                ),
              ),
            ],
          ),

          if (widget.error != null) ...[
            const SizedBox(height: 8),
            Text(widget.error!, style: TextStyle(color: AppColor.errorColor)),
          ],

          const SizedBox(height: 16),

          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: widget.loading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.accentColor,
                foregroundColor: AppColor.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: AppColor.accentColor.withOpacity(.5),
              ),
              child: widget.loading
                  ? const CircularProgressIndicator()
                  : const Text('Sign Up',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
