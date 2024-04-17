import 'package:flutter/material.dart';
import 'package:web_flutter/widgets/navigation_bar/navigation_bar_tablet_desktop.dart';
import 'package:web_flutter/widgets/navigation_bar/navigation_bar_mobile.dart';
import 'package:responsive_builder/responsive_builder.dart';

class MyNavigationBar extends StatelessWidget {
  const MyNavigationBar({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: NavigationBarMobile(),
      tablet: NavigationBarTabletDesktop(),
    );
  }
}
