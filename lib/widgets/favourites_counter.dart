import 'package:first_app/pages/favourites_page/cubit/favourites_cubit.dart';
import 'package:first_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavouritesCounterBadge extends StatelessWidget {
  const FavouritesCounterBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<FavouritesCubit, FavouritesState, int>(
      selector: (s) => s.totalCount,
      builder: (context, count) {
        if (count <= 0) return const SizedBox.shrink();
        return Container(
          width: 16,
          height: 16,
          decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Text('$count',
              style: const TextStyle(color: AppColor.white, fontSize: 10, height: 1)),
        );
      },
    );
  }
}
