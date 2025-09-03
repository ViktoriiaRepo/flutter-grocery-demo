import 'package:flutter/material.dart';

class FavouritesPage extends StatelessWidget {
  static const String path = '/favourites';
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favourite')),
      body: Center(child: Text('Favourite content here')),
    );
  }
}
