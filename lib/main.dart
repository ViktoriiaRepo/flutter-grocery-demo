import 'package:first_app/pages/cart_page/bloc/cart_bloc.dart';
import 'package:first_app/pages/favourites_page/cubit/favourites_cubit.dart';
import 'package:first_app/router/navigation.dart';
import 'package:flutter/material.dart';

import 'package:first_app/utils/app_settings.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSettings.init();
  runApp(const GroceryApp ());
}

class GroceryApp  extends StatelessWidget {
  const GroceryApp ({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => CartBloc()),                  // вже був
          BlocProvider(create: (_) => FavouritesCubit(AppSettings.getInstance())..load()),
        ],
        child: MaterialApp.router(
          title: 'Grocery Demo',
          theme: ThemeData(
              useMaterial3: true,
              scaffoldBackgroundColor: Colors.white,
              fontFamily: 'Roboto',
              appBarTheme: const AppBarTheme(
              centerTitle: true,
              backgroundColor: Colors.white,
              elevation: 0,
              scrolledUnderElevation: 0,
              surfaceTintColor: Colors.transparent,
              titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              ),
              ),
          ),
          routerConfig: AppNavigation.getRouter(),
        ),
    );

  }
}

