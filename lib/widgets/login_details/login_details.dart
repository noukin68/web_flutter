import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_flutter/locator.dart';
import 'package:web_flutter/routing/route_names.dart';
import 'package:web_flutter/services/navigation_service.dart';
import 'package:web_flutter/views/profile/profile_view.dart';
import 'package:web_flutter/views/register/register_view.dart';
import 'package:web_flutter/widgets/navigation_bar/navigation_bar_tablet_desktop.dart';

class LoginDetails extends StatelessWidget {
  const LoginDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFAA00FF),
            Color.fromARGB(255, 135, 90, 86),
            Color.fromARGB(255, 229, 255, 0),
          ],
        ),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 950) {
            return DesktopView();
          } else {
            return MobileView();
          }
        },
      ),
    );
  }
}

class DesktopView extends StatefulWidget {
  DesktopView({Key? key}) : super(key: key);

  @override
  State<DesktopView> createState() => _DesktopViewState();
}

class _DesktopViewState extends State<DesktopView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  int userId = 0;

  bool _isAuthorized = false;
  bool _hasLicense = false;

  void showErrorMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ошибка'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> checkLicenseStatus(int userId) async {
    try {
      var response = await http.get(
        Uri.parse('http://62.217.182.138:3000/licenseStatus/${userId}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        var licenseStatus = json.decode(response.body);
        if (licenseStatus['active'] == true) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('hasLicense', true);
          setState(() {
            _hasLicense = true;
          });
          locator<NavigationService>()
              .navigateTo(ProfileRoute, arguments: userId);
        } else {
          locator<NavigationService>()
              .navigateTo(RatesRoute, arguments: userId);
        }
      } else if (response.statusCode == 404) {
        locator<NavigationService>().navigateTo(RatesRoute, arguments: userId);
      } else {
        showErrorMessage(context, 'Ошибка при проверке статуса лицензии');
      }
    } catch (e) {
      showErrorMessage(context, 'Ошибка при проверке статуса лицензии: $e');
    }
  }

  Future<void> loginUser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showErrorMessage(context, 'Введите email и пароль');
      return;
    }

    try {
      var requestBody = jsonEncode({
        'email': email,
        'password': password,
      });

      var response = await http.post(
        Uri.parse('http://62.217.182.138:3000/userlogin'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', email);
        prefs.setBool('isAuthorized', true);
        setState(() {
          _isAuthorized = true;
        });

        prefs.setBool('hasLicense', true);
        setState(() {
          _hasLicense = true;
        });

        var responseData = json.decode(response.body);
        int userId = responseData['userId'];

        prefs.setInt('userId', userId);

        await checkLicenseStatus(userId);
      } else {
        showErrorMessage(context, 'Неверный email или пароль');
      }
    } catch (e) {
      showErrorMessage(context, 'Ошибка аутентификации: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFAA00FF),
            Color.fromARGB(255, 135, 90, 86),
            Color.fromARGB(255, 229, 255, 0),
          ],
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 60,
          ),
          Text(
            'Авторизация',
            style: TextStyle(
              color: Colors.white,
              fontSize: 100,
              fontWeight: FontWeight.bold,
              fontFamily: 'Jura',
            ),
          ),
          Expanded(
            child: Center(
              child: Wrap(
                children: [
                  LoginCard(
                    emailController: emailController,
                    passwordController: passwordController,
                    loginUser: loginUser,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MobileView extends StatefulWidget {
  MobileView({Key? key}) : super(key: key);

  @override
  State<MobileView> createState() => _MobileViewState();
}

class _MobileViewState extends State<MobileView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  int userId = 0;
  bool _isAuthorized = false;
  bool _hasLicense = false;

  void showErrorMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ошибка'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> checkLicenseStatus(int userId) async {
    try {
      var response = await http.get(
        Uri.parse('http://62.217.182.138:3000/licenseStatus/${userId}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        var licenseStatus = json.decode(response.body);
        if (licenseStatus['active'] == true) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('hasLicense', true);
          setState(() {
            _hasLicense = true;
          });
          locator<NavigationService>()
              .navigateTo(ProfileRoute, arguments: userId);
        } else {
          locator<NavigationService>()
              .navigateTo(RatesRoute, arguments: userId);
        }
      } else if (response.statusCode == 404) {
        locator<NavigationService>().navigateTo(RatesRoute, arguments: userId);
      } else {
        showErrorMessage(context, 'Ошибка при проверке статуса лицензии');
      }
    } catch (e) {
      showErrorMessage(context, 'Ошибка при проверке статуса лицензии: $e');
    }
  }

  Future<void> loginUser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showErrorMessage(context, 'Введите email и пароль');
      return;
    }

    try {
      var requestBody = jsonEncode({
        'email': email,
        'password': password,
      });

      var response = await http.post(
        Uri.parse('http://62.217.182.138:3000/userlogin'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', email);
        prefs.setBool('isAuthorized', true);
        setState(() {
          _isAuthorized = true;
        });

        prefs.setBool('hasLicense', true);
        setState(() {
          _hasLicense = true;
        });

        var responseData = json.decode(response.body);
        int userId = responseData['userId'];

        prefs.setInt('userId', userId);

        await checkLicenseStatus(userId);
      } else {
        showErrorMessage(context, 'Неверный email или пароль');
      }
    } catch (e) {
      showErrorMessage(context, 'Ошибка аутентификации: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFAA00FF),
              Color.fromARGB(255, 135, 90, 86),
              Color.fromARGB(255, 229, 255, 0),
            ],
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 60,
              ),
              Text(
                'Авторизация',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Jura',
                ),
              ),
              Center(
                child: Wrap(
                  children: [
                    LoginCard(
                      emailController: emailController,
                      passwordController: passwordController,
                      loginUser: loginUser,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginCard extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback loginUser;

  const LoginCard({
    required this.emailController,
    required this.passwordController,
    required this.loginUser,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromRGBO(53, 50, 50, 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Container(
        width: 957,
        height: 544,
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 557,
              height: 85,
              child: TextFormField(
                cursorColor: Colors.white,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                    color: Colors.white, fontSize: 48, fontFamily: 'Jura'),
                decoration: InputDecoration(
                  hintText: 'E-mail',
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(216, 216, 216, 1),
                    fontSize: 48,
                    fontFamily: 'Jura',
                  ),
                  filled: true,
                  fillColor: Color.fromRGBO(100, 100, 100, 1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            Container(
              width: 557,
              height: 85,
              child: TextFormField(
                cursorColor: Colors.white,
                controller: passwordController,
                obscureText: true,
                style: TextStyle(
                    color: Colors.white, fontSize: 48, fontFamily: 'Jura'),
                decoration: InputDecoration(
                  hintText: 'Пароль',
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(216, 216, 216, 1),
                    fontSize: 48,
                    fontFamily: 'Jura',
                  ),
                  filled: true,
                  fillColor: Color.fromRGBO(100, 100, 100, 1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            Text(
              'Нет аккаунта?',
              style: TextStyle(
                color: Color.fromRGBO(216, 216, 216, 1),
                fontSize: 32,
                fontFamily: 'Jura',
              ),
            ),
            Text.rich(
              TextSpan(
                text: 'Зарегистрироваться',
                style: TextStyle(
                  color: Color.fromRGBO(136, 51, 166, 1),
                  fontSize: 25,
                  fontFamily: 'Jura',
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    locator<NavigationService>().navigateTo(RegisterRoute);
                  },
              ),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                loginUser();
              },
              child: const Text(
                'Войти',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 64,
                  fontFamily: 'Jura',
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: Color.fromRGBO(216, 216, 216, 1),
                backgroundColor: Color.fromRGBO(100, 100, 100, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35),
                ),
                minimumSize: const Size(302, 74),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(53, 50, 50, 1),
      height: 70,
      width: double.infinity,
      child: Center(
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'ооо ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontFamily: 'Jura',
                ),
              ),
              TextSpan(
                text: '"ФТ-Групп"',
                style: TextStyle(
                  color: Color.fromRGBO(142, 51, 174, 1),
                  fontSize: 35,
                  fontFamily: 'Jura',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
