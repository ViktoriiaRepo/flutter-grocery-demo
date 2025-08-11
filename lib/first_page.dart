import 'package:flutter/material.dart';

import 'state_full.dart';

class FirstPage extends StatelessWidget {

  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: double.infinity,
        color: Colors.amberAccent,
        child: FirstStateFull(startCount: 0)
      ),

    );
  }
}
