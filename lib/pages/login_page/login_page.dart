import 'package:first_app/api/server_api.dart';
import 'package:first_app/utils/app_settings.dart';
import 'package:first_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'widgets/login_form.dart';
import 'bloc/login_cubit.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  static String path = "/LoginPage";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(
        api: ServerApi(),
        settings: AppSettings.getInstance(),
      ),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView({super.key});

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
                  child: SvgPicture.asset('assets/carrot.svg', width: 48),
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

                BlocConsumer<LoginCubit, LoginState>(
                  listener: (context, state) {
                    if (state.status == LoginStatus.success) {
                      context.go('/account');
                    }
                    if (state.status == LoginStatus.failure &&
                        state.errorMessage != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.errorMessage!)),
                      );
                    }
                  },
                  builder: (context, state) {
                    final loading = state.status == LoginStatus.loading;
                    return Column(
                      children: [
                        LoginForm(
                          isLoading: loading,
                          onLogin: (email, pass) =>
                              context.read<LoginCubit>().submit(email, pass),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don’t have an account? ",
                                style: TextStyle(color: AppColor.descColor)),
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
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
