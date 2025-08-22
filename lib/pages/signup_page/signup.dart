// lib/pages/auth/sign_up_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:first_app/api/server_api.dart';
import 'package:first_app/utils/app_settings.dart';
import 'package:first_app/utils/colors.dart';
import '../../widgets/sign_up_form.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  static const path = '/signup';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _api = ServerApi();
  bool _loading = false;
  String? _error;

  Future<void> _onSignUp({
    required String username,
    required String email,
    required String password,
  }) async {
    setState(() { _loading = true; _error = null; });

    final res = await _api.register(username: username, email: email, password: password);

      if (res.isSuccess) {
        final s = AppSettings.getInstance();
        s.saveToken(res.token);
        s.saveUserEmail(res.userEmail);
        s.saveUserName(res.userDisplayName);

        if (!mounted) return;
        FocusScope.of(context).unfocus();
        context.go('/account');
      } else {
        if (!mounted) return;
        setState(() => _error = res.message);
      }

      if (mounted) setState(() => _loading = false);

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColor.white,
        body: Container(
          height: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/login_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Align(
                    alignment: Alignment.center,
                    child: SvgPicture.asset('assets/carrot.svg', width: 48),
                  ),
                  const SizedBox(height: 48),

                  Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 26,
                      color: AppColor.textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter your credentials to continue',
                    style: TextStyle(fontSize: 14, color: AppColor.descColor),
                  ),
                  const SizedBox(height: 24),


                  SignUpForm(
                    loading: _loading,
                    error: _error,
                    onSubmit: _onSignUp,
                  ),

                  const SizedBox(height: 16),

                  // "Already have an account? Login"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already have an account? ',
                          style: TextStyle(color: AppColor.descColor)),
                      GestureDetector(
                        onTap: () => context.go('/login'),
                        child: Text('Login',
                            style: TextStyle(
                                color: AppColor.accentColor,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
