import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:web_flutter/locator.dart';
import 'package:web_flutter/routing/route_names.dart';
import 'package:web_flutter/routing/router.dart';
import 'package:web_flutter/services/navigation_service.dart';
import 'package:web_flutter/widgets/navigation_bar/navigation_bar.dart';
import 'package:web_flutter/widgets/navigation_drawer/navigation_drawer.dart';

class LayoutTemplate extends StatelessWidget {
  const LayoutTemplate({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) => Scaffold(
        drawer: sizingInformation.deviceScreenType == DeviceScreenType.mobile
            ? MyNavigationDrawer()
            : null,
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment:
              CrossAxisAlignment.stretch, // Растянуть по всей ширине
          children: <Widget>[
            MyNavigationBar(),
            Expanded(
              child: Navigator(
                key: locator<NavigationService>().navigatorKey,
                onGenerateRoute: generateRoute,
                initialRoute: HomeRoute,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
