import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_flutter/locator.dart';
import 'package:web_flutter/routing/route_names.dart';
import 'package:web_flutter/services/navigation_service.dart';
import 'package:web_flutter/views/profile/profile_view.dart';

class RenewRatesDetails extends StatelessWidget {
  final int userId;
  const RenewRatesDetails({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => constraints.maxWidth > 950
          ? DesktopView(userId: userId)
          : MobileView(userId: userId),
    );
  }
}

class DesktopView extends StatefulWidget {
  final int userId;
  DesktopView({Key? key, required this.userId}) : super(key: key);

  @override
  State<DesktopView> createState() => _DesktopViewState();
}

class _DesktopViewState extends State<DesktopView> {
  int selectedPlanIndex = 0;
  List<TariffPlan> tariffPlans = [
    TariffPlan('Подписка\nна 1 месяц', 30, 450),
    TariffPlan('Подписка\nна 3 месяца', 90, 1350),
    TariffPlan('Подписка\nна год', 365, 5400),
  ];

  Future<void> renewLicense(int selectedPlanIndex) async {
    // Получение количества дней лицензии в зависимости от выбранного тарифного плана
    int licenseDays = tariffPlans[selectedPlanIndex].days;

    // Формирование JSON-тела запроса
    var requestBody = {
      'userId': widget.userId,
      'selectedPlanIndex': selectedPlanIndex,
    };

    try {
      // Отправка данных на сервер
      var response = await http.post(
        Uri.parse('http://62.217.182.138:3000/renewLicense'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      // Проверка ответа от сервера
      if (response.statusCode == 200) {
        // Обработка успешного ответа (например, показ сообщения об успешном продлении лицензии)
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Успешное продление'),
              content: Text('Лицензия успешно продлена на $licenseDays дней'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    locator<NavigationService>()
                        .navigateTo(ProfileRoute, arguments: widget.userId);
                  },
                ),
              ],
            );
          },
        );
      } else {
        // Обработка ошибочного ответа (например, показ сообщения об ошибке)
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Ошибка'),
              content: Text('Произошла ошибка при продлении лицензии'),
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
    } catch (e) {
      // Обработка ошибок при отправке запроса (например, показ сообщения об ошибке)
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Ошибка'),
            content: Text('Произошла ошибка при отправке запроса'),
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
            Color.fromRGBO(135, 90, 86, 1),
            Color.fromRGBO(229, 255, 0, 1),
          ],
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 10),
          Text(
            'Тарифы',
            style: TextStyle(
              color: Colors.white,
              fontSize: 100,
              fontWeight: FontWeight.bold,
              fontFamily: 'Jura',
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            flex: 3,
            child: Center(
              child: Wrap(
                spacing: 100,
                runSpacing: 20,
                children: List.generate(tariffPlans.length, (index) {
                  return SubscriptionCard(
                    plan: tariffPlans[index],
                    purchaseLicense: () {
                      renewLicense(index);
                    },
                  );
                }),
              ),
            ),
          ),
          SizedBox(height: 10),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            color: Color.fromRGBO(53, 50, 50, 1),
            child: SizedBox(
              height: 87,
              width: 804,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    '**Скидка при покупке на несколько устройств 5%',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 30,
                      fontFamily: 'Jura',
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

class MobileView extends StatefulWidget {
  final int userId;
  MobileView({Key? key, required this.userId}) : super(key: key);

  @override
  State<MobileView> createState() => _MobileViewState();
}

class _MobileViewState extends State<MobileView> {
  int selectedPlanIndex = 0;
  bool isLoggedIn = false;
  List<TariffPlan> tariffPlans = [
    TariffPlan('Подписка\nна 1 месяц', 30, 450),
    TariffPlan('Подписка\nна 3 месяце', 90, 1350),
    TariffPlan('Подписка\nна год', 365, 5400),
  ];

  Future<void> renewLicense(int selectedPlanIndex) async {
    // Получение количества дней лицензии в зависимости от выбранного тарифного плана
    int licenseDays = tariffPlans[selectedPlanIndex].days;

    // Формирование JSON-тела запроса
    var requestBody = {
      'userId': widget.userId,
      'selectedPlanIndex': selectedPlanIndex,
    };

    try {
      // Отправка данных на сервер
      var response = await http.post(
        Uri.parse('http://62.217.182.138:3000/renewLicense'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      // Проверка ответа от сервера
      if (response.statusCode == 200) {
        // Обработка успешного ответа (например, показ сообщения об успешном продлении лицензии)
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Успешное продление'),
              content: Text('Лицензия успешно продлена на $licenseDays дней'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    locator<NavigationService>()
                        .navigateTo(ProfileRoute, arguments: widget.userId);
                  },
                ),
              ],
            );
          },
        );
      } else {
        // Обработка ошибочного ответа (например, показ сообщения об ошибке)
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Ошибка'),
              content: Text('Произошла ошибка при продлении лицензии'),
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
    } catch (e) {
      // Обработка ошибок при отправке запроса (например, показ сообщения об ошибке)
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Ошибка'),
            content: Text('Произошла ошибка при отправке запроса'),
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
              Color.fromRGBO(135, 90, 86, 1),
              Color.fromRGBO(229, 255, 0, 1),
            ],
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 30),
            Text(
              'Тарифы',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold,
                fontFamily: 'Jura',
              ),
            ),
            SizedBox(height: 45),
            Center(
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                children: List.generate(tariffPlans.length, (index) {
                  return SubscriptionCard(
                    plan: tariffPlans[index],
                    purchaseLicense: () {
                      renewLicense(index);
                    },
                  );
                }),
              ),
            ),
            SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              color: Color.fromRGBO(53, 50, 50, 1),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  '**Скидка 5% при покупке на несколько устройств',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontFamily: 'Jura',
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class SubscriptionCard extends StatelessWidget {
  final TariffPlan plan;
  final VoidCallback purchaseLicense;

  const SubscriptionCard({
    required this.plan,
    required this.purchaseLicense,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      color: Color.fromRGBO(53, 50, 50, 1),
      child: Container(
        width: 404,
        height: 471,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              plan.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                height: 1.5,
                color: Colors.white,
                fontSize: 36,
                fontFamily: 'Jura',
              ),
            ),
            SizedBox(height: 125),
            Text(
              '${plan.price}р за ${plan.days} дней',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontFamily: 'Jura',
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: purchaseLicense,
              child: Text(
                'Купить',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 64,
                  fontFamily: 'Jura',
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(34, 16, 16, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0),
                ),
                minimumSize: Size(302, 74),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TariffPlan {
  final String title;
  final int days;
  final int price;

  TariffPlan(this.title, this.days, this.price);
}

class Footer extends StatelessWidget {
  const Footer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(53, 50, 50, 1),
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
