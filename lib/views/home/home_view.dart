import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:web_flutter/views/home/home_content_desktop.dart';
import 'package:web_flutter/views/home/home_content_mobile.dart';

class HomeView extends StatelessWidget {
  final int userId;
  const HomeView({key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: HomeContentMobile(userId: userId),
      desktop: HomeContentDesktop(userId: userId),
    );
  }
}
