import 'package:first_app/pages/shop_page.dart';
import 'package:first_app/utils/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  static const String path = '/splash';
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadSettings();
    });
  }

  _loadSettings() {
    String token = AppSettings.getInstance().getToken();
    if (token.isEmpty) {
      context.go('/intro');
    } else {
      context.goNamed('shop');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF53B175),
      body: Center(
        child: SvgPicture.asset(
          'assets/carrot.svg',
          width: 64,
          height: 64,
          color: Colors.white,
        ),
      ),
    );
  }
}
