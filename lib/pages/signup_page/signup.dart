import 'package:first_app/api/server_api.dart';
import 'package:first_app/utils/app_settings.dart';
import 'package:first_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'bloc/sign_up_cubit.dart';
import 'widgets/sign_up_form.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});
  static String path = "/signup";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignUpCubit(
        api: ServerApi(),
        settings: AppSettings.getInstance(),
      ),
      child: const _SignUpView(),
    );
  }
}

class _SignUpView extends StatelessWidget {
  const _SignUpView({super.key});

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
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 26,
                    color: AppColor.textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  'Enter your email and password',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColor.descColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 40),

                BlocConsumer<SignUpCubit, SignUpState>(
                  listener: (context, state) {
                    if (state.status == SignUpStatus.success) {
                      context.go('/'); // як у LoginPage
                    }
                    if (state.status == SignUpStatus.failure &&
                        state.errorMessage != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.errorMessage!)),
                      );
                    }
                  },
                  builder: (context, state) {
                    final loading = state.status == SignUpStatus.loading;
                    return Column(
                      children: [
                        SignUpForm(
                          isLoading: loading,
                          onSignUp: (username, email, pass) =>
                              context.read<SignUpCubit>()
                                  .submit(username, email, pass),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already have an account? ",
                                style: TextStyle(color: AppColor.descColor)),
                            GestureDetector(
                              onTap: () => context.goNamed('login'),
                              child: Text(
                                'Login',
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
