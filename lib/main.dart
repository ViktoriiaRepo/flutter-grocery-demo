import 'package:flutter/material.dart';
import 'router.dart';


void main() {
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

