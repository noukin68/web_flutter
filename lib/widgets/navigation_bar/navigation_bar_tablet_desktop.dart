import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_flutter/routing/route_names.dart';
import 'navbar_item.dart';
import 'navbar_logo.dart';

class NavigationBarTabletDesktop extends StatefulWidget {
  const NavigationBarTabletDesktop({Key? key}) : super(key: key);

  @override
  _NavigationBarTabletDesktopState createState() =>
      _NavigationBarTabletDesktopState();
}

class _NavigationBarTabletDesktopState
    extends State<NavigationBarTabletDesktop> {
  bool _isAuthorized = false;
  bool _hasLicense = false;

  @override
  void initState() {
    super.initState();
    _checkAuthorizationAndLicense();
  }

  Future<void> _checkAuthorizationAndLicense() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAuthorized = prefs.getBool('isAuthorized') ?? false;
      _hasLicense = prefs.getBool('hasLicense') ?? false;
    });
    print('_isAuthorized: $_isAuthorized');
    print('_hasLicense: $_hasLicense');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      color: const Color.fromRGBO(53, 50, 50, 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const NavBarLogo(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _isAuthorized && _hasLicense
                  ? NavBarItem('Мой аккаунт', ProfileRoute)
                  : NavBarItem('О нас', HomeRoute),
              const SizedBox(width: 60),
              _isAuthorized && _hasLicense
                  ? NavBarItem('Подключение устройств', ConnectDevicesRoute)
                  : NavBarItem('Тарифы', RatesRoute),
              const SizedBox(width: 60),
              _isAuthorized
                  ? Padding(
                      padding: const EdgeInsets.only(right: 60),
                      child: NavBarItem('Выход', LogoutRoute),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(right: 60),
                      child: NavBarItem('Авторизация', LoginRoute),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
