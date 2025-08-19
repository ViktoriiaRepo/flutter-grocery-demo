import 'package:flutter/material.dart';
import 'router.dart';
import 'package:first_app/utils/app_settings.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSettings.getInstance().init();
  runApp(const GroceryApp ());
}

class GroceryApp  extends StatelessWidget {
  const GroceryApp ({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Grocery Demo',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto'
      ),
      routerConfig: router,
    );
  }
}

