import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_flutter/locator.dart';
import 'package:web_flutter/routing/route_names.dart';
import 'package:web_flutter/services/navigation_service.dart';

class LogoutView extends StatelessWidget {
  const LogoutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.remove('isAuthorized');
      prefs.remove('userId');
      locator<NavigationService>().navigateTo(LoginRoute);
    });
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
