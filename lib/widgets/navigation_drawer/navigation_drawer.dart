import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_flutter/routing/route_names.dart';
import 'package:web_flutter/widgets/navigation_drawer/drawer_item.dart';

class MyNavigationDrawer extends StatefulWidget {
  const MyNavigationDrawer({Key? key}) : super(key: key);

  @override
  _MyNavigationDrawerState createState() => _MyNavigationDrawerState();
}

class _MyNavigationDrawerState extends State<MyNavigationDrawer> {
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(53, 50, 50, 1),
      ),
      child: Column(
        children: <Widget>[
          _isAuthorized && _hasLicense
              ? DrawerItem('Мой аккаунт', Icons.account_circle, ProfileRoute,
                  Colors.white, fontFamily: 'Jura')
              : DrawerItem('О нас', Icons.home, HomeRoute, Colors.white,
                  fontFamily: 'Jura'),
          _isAuthorized && _hasLicense
              ? DrawerItem('Подключение устройств', Icons.device_hub,
                  ConnectDevicesRoute, Colors.white, fontFamily: 'Jura')
              : DrawerItem('Тарифы', Icons.shop_two, RatesRoute, Colors.white,
                  fontFamily: 'Jura'),
          if (_isAuthorized)
            DrawerItem(
              'Выход',
              Icons.logout,
              LogoutRoute,
              Colors.white,
              fontFamily: 'Jura',
            )
          else
            DrawerItem(
              'Авторизация',
              Icons.login_sharp,
              LoginRoute,
              Colors.white,
              fontFamily: 'Jura',
            ),
        ],
      ),
    );
  }
}
