import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:web_flutter/views/rates/rates_content_desktop.dart';
import 'package:web_flutter/views/rates/rates_content_mobile.dart';

class RatesView extends StatelessWidget {
  final int userId;

  const RatesView({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: RatesContentMobile(userId: userId),
      desktop: RatesContentDesktop(userId: userId),
    );
  }
}
