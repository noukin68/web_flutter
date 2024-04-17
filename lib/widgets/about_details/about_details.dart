import 'dart:math';

import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:auto_size_text/auto_size_text.dart';

class AboutDetails extends StatelessWidget {
  final int userId;
  const AboutDetails({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Colors.purple,
            Colors.purple,
            Color.fromRGBO(55, 55, 55, 1),
          ],
          center: Alignment.centerLeft,
          radius: 1.8,
          stops: [0.2, 0.3, 1],
        ),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 950) {
            return DesktopView(userId: userId);
          } else {
            return MobileView(userId: userId);
          }
        },
      ),
    );
  }
}

class DesktopView extends StatelessWidget {
  final int userId;
  const DesktopView({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: Image.asset(
                          'assets/family.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 3,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: 1180,
                          child: CardContent(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MobileView extends StatelessWidget {
  final int userId;
  const MobileView({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final shortestSide = min(size.width, size.height);

    double imageWidth;
    double imageHeight;

    if (shortestSide < 600) {
      // Маленькие экраны (мобильные телефоны)
      imageWidth = 250;
      imageHeight = 250;
    } else if (shortestSide < 850) {
      // Средние экраны (планшеты)
      imageWidth = 400;
      imageHeight = 400;
    } else {
      // Большие экраны (десктопы)
      imageWidth = 500;
      imageHeight = 500;
    }

    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: imageWidth,
                      height: imageHeight,
                      child: Image.asset(
                        'assets/family.png',
                        fit: BoxFit.cover, // Заполняем доступное пространство
                      ),
                    ),
                    const SizedBox(height: 20),
                    CardContent(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardContent extends StatelessWidget {
  const CardContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        double titleFontSize =
            sizingInformation.deviceScreenType == DeviceScreenType.mobile
                ? 12 // Меньший размер для мобильных устройств
                : 40;
        return Card(
          color: Colors.white.withOpacity(0.8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AutoSizeText.rich(
                  TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            'Ваш ребенок стал проводить слишком много времени в компьютере? Стал более',
                      ),
                      TextSpan(
                        text: ' агрессивным',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ' и проводит все',
                      ),
                      TextSpan(
                        text: ' меньше времени с семьей',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: '? Мы поможем',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            ' решить вашу проблему! Наше приложение поможет избавить ',
                      ),
                      TextSpan(
                        text: 'вашего ребенка',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            ' от компьютерной зависимости, а также "подтянет" его по предметам',
                      ),
                      TextSpan(
                        text: ' на ваш выбор',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: '! Наше приложение имеет',
                      ),
                      TextSpan(
                        text: ' гибкую',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ' вопросительную',
                      ),
                      TextSpan(
                        text: ' базу',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ' по всем школьным предметам,',
                      ),
                      TextSpan(
                        text: ' удобную настройку',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ' и',
                      ),
                      TextSpan(
                        text: ' простое управление',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ' через мобильное устройство',
                      ),
                      TextSpan(
                        text: ' с любой точки',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ' земного шара.',
                      ),
                    ],
                  ),
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontFamily: 'Jura',
                    color: Colors.black,
                  ),
                  minFontSize: 12,
                  maxFontSize: 45,
                ),
              ],
            ),
          ),
        );
      },
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
