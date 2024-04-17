import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_builder/responsive_builder.dart';
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ConnectDevicesDetails extends StatelessWidget {
  final int userId;
  const ConnectDevicesDetails({Key? key, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Color.fromRGBO(111, 128, 20, 1),
            Color.fromRGBO(111, 128, 20, 1),
            Color.fromRGBO(55, 55, 55, 1), // Цвет внутри круга// Цвет вне круга
          ],
          center: Alignment.bottomRight, // Центр градиента - по центру экрана
          radius: 1.8, // Радиус градиента
          stops: [0.2, 0.3, 1], // Остановки для цветового перехода
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

class DesktopView extends StatefulWidget {
  final int userId;
  const DesktopView({Key? key, required this.userId}) : super(key: key);

  @override
  State<DesktopView> createState() => _DesktopViewState();
}

class _DesktopViewState extends State<DesktopView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 40.0),
        SizedBox(
          width: 721,
          height: 272,
          child: ConnectDevicesCard(userId: widget.userId),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Text(
                  'Список подключенных устройств:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 64,
                    fontFamily: 'Jura',
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  width: 957,
                  height: 393,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(53, 50, 50, 1),
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: ConnectedDevicesList(userId: widget.userId),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class MobileView extends StatefulWidget {
  final int userId;
  const MobileView({Key? key, required this.userId}) : super(key: key);

  @override
  State<MobileView> createState() => _MobileViewState();
}

class _MobileViewState extends State<MobileView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 30.0),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.3,
            child: ConnectDevicesCard(userId: widget.userId),
          ),
          SizedBox(height: 50.0),
          Text(
            'Список подключенных устройств:',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontFamily: 'Jura',
            ),
          ),
          SizedBox(height: 20.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(53, 50, 50, 1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ConnectedDevicesList(userId: widget.userId),
              ),
              SizedBox(height: 20.0), // Добавлено свободное пространство
            ],
          ),
        ],
      ),
    );
  }
}

class ConnectDevicesCard extends StatefulWidget {
  final int userId;
  const ConnectDevicesCard({Key? key, required this.userId}) : super(key: key);

  @override
  State<ConnectDevicesCard> createState() => _ConnectDevicesCardState();
}

class _ConnectDevicesCardState extends State<ConnectDevicesCard>
    with AutomaticKeepAliveClientMixin {
  IO.Socket? socket;
  TextEditingController uidController = TextEditingController();
  List<String> connectedUIDs = [];
  Map<String, IO.Socket> sockets = {};

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    initSocket();
  }

  void initSocket() {
    socket = IO.io('http://62.217.182.138:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket?.connect();

    socket?.on('action', (data) {
      String uid = data['uid'];
      String action = data['action'];
      print('Received action: $action for UID: $uid');
    });
  }

  void addUID(String uid) async {
    Map<String, dynamic> requestBody = {
      'uid': uid,
      'type': 'flutter',
    };

    try {
      var response = await http.post(
        Uri.parse('http://62.217.182.138:3000/check-uid-license'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        socket?.emit('join', requestBody); // Отправляем данные на сервер
        socket?.once('joined', (data) {
          setState(() {
            if (!connectedUIDs.contains(uid)) {
              connectedUIDs.add(uid);
              sockets[uid] = socket!;
            }
          });

          // После успешного добавления UID отправляем событие flutter-connected
          socket?.emit('flutter-connected', {'uid': uid});
        });
      } else {
        var jsonResponse = jsonDecode(response.body);
        showErrorMessage('Ошибка: ${jsonResponse['error']}');
      }
    } catch (error) {
      showErrorMessage('Ошибка: $error');
    }
  }

  void showErrorMessage(String message) {
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

  void disconnectUID(String uid) {
    setState(() {
      connectedUIDs.remove(uid);
      sockets.remove(uid);
    });
    socket?.emit('disconnect-uid', uid);
    socket?.emit('flutter-disconnected',
        {'uid': uid}); // Отправляем на сервер событие об отключении Flutter
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ResponsiveBuilder(builder: (context, sizingInformation) {
      double titleFontSize =
          sizingInformation.deviceScreenType == DeviceScreenType.mobile
              ? 24 // Меньший размер для мобильных устройств
              : 48;
      double heightSize =
          sizingInformation.deviceScreenType == DeviceScreenType.mobile
              ? 10 // Меньший размер для мобильных устройств
              : 50;
      return Card(
        color: Color.fromRGBO(53, 50, 50, 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 557,
                height: 85,
                child: TextField(
                  controller: uidController,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: titleFontSize,
                      fontFamily: 'Jura'), // Set the text color and size
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromRGBO(100, 100, 100, 1),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    hintText: 'Идентификатор',
                    hintStyle: TextStyle(
                        fontSize: titleFontSize,
                        color: Colors.white,
                        fontFamily: 'Jura'),
                  ),
                ),
              ),
              SizedBox(height: heightSize),
              SizedBox(
                width: 302,
                height: 74,
                child: ElevatedButton(
                  onPressed: () {
                    String uid = uidController.text.trim();
                    if (uid.isNotEmpty) {
                      addUID(uid);
                      uidController.clear();
                    } else {
                      showErrorMessage(
                          'Пожалуйста, введите действительный UID');
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromRGBO(34, 16, 16, 1),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              35.0), // Set the border radius of the button
                        ),
                      )),
                  child: Text(
                    'Подключить',
                    style:
                        TextStyle(color: Colors.white, fontSize: titleFontSize),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class ConnectedDevicesList extends StatefulWidget {
  final int userId;
  const ConnectedDevicesList({Key? key, required this.userId})
      : super(key: key);

  @override
  State<ConnectedDevicesList> createState() => _ConnectedDevicesListState();
}

class _ConnectedDevicesListState extends State<ConnectedDevicesList>
    with AutomaticKeepAliveClientMixin {
  IO.Socket? socket;
  List<String> connectedUIDs = [];
  Map<String, IO.Socket> sockets = {};

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    initSocket();
  }

  void initSocket() {
    socket = IO.io('http://62.217.182.138:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket?.connect();

    socket?.on('action', (data) {
      String uid = data['uid'];
      String action = data['action'];
      print('Received action: $action for UID: $uid');
    });
  }

  void addUID(String uid) async {
    Map<String, dynamic> requestBody = {
      'uid': uid,
      'type': 'flutter',
    };

    try {
      var response = await http.post(
        Uri.parse('http://62.217.182.138:3000/check-uid-license'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        socket?.emit('join', requestBody); // Отправляем данные на сервер
        socket?.once('joined', (data) {
          setState(() {
            if (!connectedUIDs.contains(uid)) {
              connectedUIDs.add(uid);
              sockets[uid] = socket!;
            }
          });

          // После успешного добавления UID отправляем событие flutter-connected
          socket?.emit('flutter-connected', {'uid': uid});
        });
      } else {
        var jsonResponse = jsonDecode(response.body);
        showErrorMessage('Ошибка: ${jsonResponse['error']}');
      }
    } catch (error) {
      showErrorMessage('Ошибка: $error');
    }
  }

  void showErrorMessage(String message) {
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

  void disconnectUID(String uid) {
    setState(() {
      connectedUIDs.remove(uid);
      sockets.remove(uid);
    });
    socket?.emit('disconnect-uid', uid);
    socket?.emit('flutter-disconnected',
        {'uid': uid}); // Отправляем на сервер событие об отключении Flutter
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return connectedUIDs.isEmpty
        ? Center(
            child: Text(
              'У пользователя нет подключений',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 30, color: Colors.white, fontFamily: 'Jura'),
            ),
          )
        : ListView.builder(
            shrinkWrap: true,
            itemCount: connectedUIDs.length,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(28.0),
            itemBuilder: (context, index) {
              String uid = connectedUIDs[index];
              return ListTile(
                title: SizedBox(
                  width: 437, // Устанавливаем ширину BoxDecoration
                  height: 20, // Устанавливаем высоту BoxDecoration
                  child: Container(
                    alignment:
                        Alignment.centerLeft, // Выравниваем текст по центру
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(100, 100, 100,
                          1), // Полупрозрачный белый цвет фона для текста
                      borderRadius: BorderRadius.circular(
                          15), // Скругление углов для текста
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.0), // Отступ для текста
                    child: Text(
                      uid,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontFamily: 'Jura',
                      ),
                    ),
                  ),
                ),
                horizontalTitleGap: 190.0,
                trailing: Container(
                  width: 245,
                  height: 61,
                  child: ElevatedButton(
                    onPressed: () {
                      disconnectUID(uid);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromRGBO(34, 16, 16, 1),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Отключить',
                        style: TextStyle(
                          fontSize: 36,
                          color: Color.fromRGBO(202, 202, 202, 1),
                          fontFamily: 'Jura',
                        ),
                      ),
                    ),
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
