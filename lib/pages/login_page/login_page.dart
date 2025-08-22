import 'package:first_app/api/server_api.dart';
import 'package:first_app/utils/app_settings.dart';
import 'package:first_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../widgets/login_form.dart';
import 'package:go_router/go_router.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static String path = "/LoginPage";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  String? error;

  ServerApi api = ServerApi();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                const SizedBox(height: 40),

                Align(
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    'assets/carrot.svg',
                    width: 48,
                  ),
                ),

                const SizedBox(height: 100),

                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 26,
                    color: AppColor.textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  'Enter your emails and password',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColor.descColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 40),

                LoginForm(
                  onLogin: _onLogin,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don’t have an account? ",
                      style: TextStyle(color: AppColor.descColor),
                    ),
                    GestureDetector(
                      onTap: () => context.go('/signup'),
                      child: Text(
                        'Signup',
                        style: TextStyle(
                          color: AppColor.accentColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  _onLogin(String login, String password) async {
    try {
      final value = await api.login(login: login, password: password);

      if (value.isSuccess) {
        final settings = AppSettings.getInstance();
        settings.saveToken(value.token);
        settings.saveUserEmail(value.userEmail);
        settings.saveUserName(value.userDisplayName);

        if (!mounted) return;
        context.go('/account');
      } else {
        if (!mounted) return;
        setState(() {
          error = value.message;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = 'Login error: $e';
      });
    }
  }

}
