import 'package:first_app/api/server_api.dart';
import 'package:first_app/utils/app_settings.dart';
import 'package:first_app/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/login_form.dart';



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
              ],
            ),
          ),
        ),
      ),
    );
  }
  _onLogin(String login, String password){
   api.login(login: login, password: password)
       .then((value) {
         if(value.isSuccess) {
           AppSettings.getInstance().saveToken(value.token);
           // print("Success ${value.data}");
         } else {
           setState(() {
             error = value.message;
           });
           // print("Error ${value.message} ${value.data}");
         }
   });


  }
}
