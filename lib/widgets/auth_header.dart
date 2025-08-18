import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    this.asset = 'assets/carrot.svg',
    this.height = 120,
    this.iconWidth = 48,
    this.iconHeight = 55,
    this.padding = const EdgeInsets.only(top: 16, bottom: 8)
  });

  final String asset;
  final double height;
  final double iconWidth;
  final double iconHeight;
  final EdgeInsets padding;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(
        height: height,
        alignment: Alignment.center,

        child: SvgPicture.asset(
          asset,
          width: iconWidth,
          height: iconHeight,
          semanticsLabel: 'Carrot',
        ),
      ),
    );
  }
}
