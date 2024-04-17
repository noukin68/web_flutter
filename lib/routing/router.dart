import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:web_flutter/logout_view.dart';
import 'package:web_flutter/routing/route_names.dart';
import 'package:web_flutter/views/connectDevices/connectDevices_view.dart';
import 'package:web_flutter/views/home/home_view.dart';
import 'package:web_flutter/views/login/login_view.dart';
import 'package:web_flutter/views/profile/profile_view.dart';
import 'package:web_flutter/views/rates/rates_view.dart';
import 'package:web_flutter/views/register/register_view.dart';
import 'package:web_flutter/views/renewRates/renewRates_view.dart';

Route<dynamic> generateRoute(RouteSettings settings, {int? userId}) {
  final String? routeName = settings.name;

  switch (routeName) {
    case HomeRoute:
      final int homeUserId = userId ?? settings.arguments as int? ?? 0;
      return _getPageRoute(HomeView(userId: homeUserId), routeName!);
    case RatesRoute:
      final int ratesUserId = userId ?? settings.arguments as int? ?? 0;
      return _getPageRoute(RatesView(userId: ratesUserId), routeName!);
    case ConnectDevicesRoute:
      final int connectDevicesUserId =
          userId ?? settings.arguments as int? ?? 0;
      return _getPageRoute(
          ConnectDevicesView(userId: connectDevicesUserId), routeName!);
    case RenewRatesRoute:
      final int renewRatesUserId = userId ?? settings.arguments as int? ?? 0;
      return _getPageRoute(
          RenewRatesView(userId: renewRatesUserId), routeName!);
    case LoginRoute:
      return _getPageRoute(LoginView(), routeName!);
    case RegisterRoute:
      return _getPageRoute(RegisterView(), routeName!);
    case ProfileRoute:
      final int? profileUserId = userId ?? settings.arguments as int?;
      if (profileUserId == null) {
        throw ArgumentError('userId cannot be null');
      }
      return _getPageRoute(ProfileView(userId: profileUserId), routeName!);
    case LogoutRoute:
      return MaterialPageRoute(builder: (_) => LogoutView());
    default:
      throw ArgumentError('Unknown route: $routeName');
  }
}

PageRoute _getPageRoute(Widget child, String routeName) {
  return _FadeRoute(child: child, routeName: routeName);
}

class _FadeRoute extends PageRouteBuilder {
  final Widget child;
  final String routeName;
  _FadeRoute({required this.child, required this.routeName})
      : super(
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) =>
                child,
            settings: RouteSettings(name: routeName),
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) =>
                FadeTransition(
                  opacity: animation,
                  child: child,
                ));
}
