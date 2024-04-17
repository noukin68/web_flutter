import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_builder/responsive_builder.dart';
import 'package:web_flutter/locator.dart';
import 'package:web_flutter/routing/route_names.dart';
import 'package:web_flutter/services/navigation_service.dart';
import 'package:web_flutter/views/rates/rates_view.dart';

class ProfileDetails extends StatelessWidget {
  final int userId;

  const ProfileDetails({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Colors.purple,
            Colors.purple, // Цвет внутри круга
            Color.fromRGBO(55, 55, 55, 1), // Цвет вне круга
          ],
          center: Alignment.centerLeft, // Центр градиента - по центру экрана
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
  late Future<Map<String, dynamic>> _userInfoFuture;

  @override
  void initState() {
    super.initState();
    _userInfoFuture = fetchUserInfo(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(
          width: 200,
        ),
        Expanded(
          child: UserInfoCard(userId: widget.userId),
        ),
        const SizedBox(
          width: 500,
        ),
        Expanded(
          child: LicenseInfoCard(userId: widget.userId),
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
  late Future<Map<String, dynamic>> _userInfoFuture;

  @override
  void initState() {
    super.initState();
    _userInfoFuture = fetchUserInfo(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          UserInfoCard(userId: widget.userId),
          LicenseInfoCard(userId: widget.userId),
        ],
      ),
    );
  }
}

class UserInfoCard extends StatefulWidget {
  final int userId;

  const UserInfoCard({Key? key, required this.userId}) : super(key: key);

  @override
  State<UserInfoCard> createState() => _UserInfoCardState();
}

class _UserInfoCardState extends State<UserInfoCard> {
  late Future<Map<String, dynamic>> _userInfoFuture;

  @override
  void initState() {
    super.initState();
    _userInfoFuture = fetchUserInfo(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _userInfoFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final userInfo = snapshot.data!;
          return _buildUserInfo(userInfo, widget.userId);
        }
      },
    );
  }

  Widget _buildUserInfo(Map<String, dynamic> userInfo, int userId) {
    final screenSize = MediaQuery.of(context).size;
    final avatarRadius = screenSize.width > 600 ? 70.0 : 40.0;
    return ResponsiveBuilder(builder: (context, sizingInformation) {
      double titleFontSize =
          sizingInformation.deviceScreenType == DeviceScreenType.mobile
              ? 12 // Меньший размер для мобильных устройств
              : 20;
      return Container(
        width: screenSize.width > 600 ? 575 : double.infinity,
        height: screenSize.width > 600 ? 448 : null,
        child: Card(
          color: Color.fromRGBO(53, 50, 50, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Информация о пользователе',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(236, 236, 236, 1),
                      fontFamily: 'Jura',
                    )),
                SizedBox(height: 40),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: titleFontSize),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Имя: ${userInfo['username']}',
                                  style: TextStyle(
                                    fontSize: titleFontSize,
                                    color: Color.fromRGBO(202, 202, 202, 1),
                                    fontFamily: 'Jura',
                                  ))),
                          SizedBox(height: titleFontSize),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Почта: ${userInfo['email']}',
                              style: TextStyle(
                                fontSize: titleFontSize,
                                color: Color.fromRGBO(202, 202, 202, 1),
                                fontFamily: 'Jura',
                              ),
                            ),
                          ),
                          SizedBox(height: titleFontSize),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Номер телефона: ${userInfo['phone_number']}',
                              style: TextStyle(
                                fontSize: titleFontSize,
                                color: Color.fromRGBO(202, 202, 202, 1),
                                fontFamily: 'Jura',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 20,
                      ), // Space between text fields and avatar
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                              height:
                                  0), // Space between text fields and avatar
                          Align(
                            alignment: Alignment.topCenter,
                            child: GestureDetector(
                              onTap: () async {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles(
                                  type: FileType.image,
                                  allowMultiple: false,
                                );

                                if (result != null) {
                                  PlatformFile file = result.files.first;
                                  await uploadAvatar(widget.userId.toString(),
                                      file.bytes!, file.name);
                                  setState(() {
                                    _userInfoFuture =
                                        fetchUserInfo(widget.userId);
                                  });
                                }
                              },
                              child: FutureBuilder<Map<String, dynamic>>(
                                future: _userInfoFuture,
                                builder: (context, snapshot) {
                                  final userInfo = snapshot.data;
                                  final avatarUrl = userInfo?['avatar_url'];

                                  return CircleAvatar(
                                    radius: avatarRadius,
                                    backgroundColor:
                                        const Color.fromRGBO(100, 100, 100, 1),
                                    backgroundImage: avatarUrl.isNotEmpty
                                        ? NetworkImage(avatarUrl)
                                        : null,
                                    child: avatarUrl.isEmpty
                                        ? Image.asset(
                                            "assets/images/person.png",
                                            scale: 4,
                                          )
                                        : null,
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class LicenseInfoCard extends StatelessWidget {
  final int userId;

  const LicenseInfoCard({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchUserInfo(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final licenseInfo = snapshot.data!;
          return _buildLicenseInfo(licenseInfo, context);
        }
      },
    );
  }

  Widget _buildLicenseInfo(
      Map<String, dynamic> licenseInfo, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildIdentifierCard(licenseInfo['uid'], context),
        const SizedBox(height: 120),
        _buildLicenseStatusCard(licenseInfo, context, userId),
      ],
    );
  }

  Widget _buildIdentifierCard(String uid, BuildContext context) {
    return Container(
      width: 357,
      height: 111,
      child: Card(
        color: const Color.fromRGBO(53, 50, 50, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Идентификатор',
                      style: TextStyle(
                        fontSize: 32,
                        color: Color.fromRGBO(236, 236, 236, 1),
                        fontFamily: 'Jura',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      uid,
                      style: const TextStyle(
                        fontSize: 32,
                        color: Color.fromRGBO(202, 202, 202, 1),
                        fontFamily: 'Jura',
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                iconSize: 24,
                icon: const Icon(
                  Icons.copy,
                  color: Colors.white,
                ),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: uid));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('UID скопирован')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLicenseStatusCard(
      Map<String, dynamic> licenseInfo, BuildContext context, int userId) {
    return Container(
      width: 357,
      height: 196,
      child: Card(
        color: const Color.fromRGBO(53, 50, 50, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text('Статус лицензии',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(236, 236, 236, 1),
                      fontFamily: 'Jura',
                    )),
              ),
              const SizedBox(
                height: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Статус: Активна',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromRGBO(202, 202, 202, 1),
                      fontFamily: 'Jura',
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Срок окончания: ${calculateRemainingDays(licenseInfo['expiration_date'])} дней',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color.fromRGBO(202, 202, 202, 1),
                      fontFamily: 'Jura',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10), // Add space between elements
              Center(
                child: Container(
                  width: 270,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      locator<NavigationService>()
                          .navigateTo(RenewRatesRoute, arguments: userId);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromRGBO(100, 100, 100, 1)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Продлить лицензию',
                        style: TextStyle(
                          fontSize: 24,
                          color: Color.fromRGBO(202, 202, 202, 1),
                          fontFamily: 'Jura',
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<Map<String, dynamic>> fetchUserInfo(int userId) async {
  final response =
      await http.get(Uri.parse('http://62.217.182.138:3000/user/${userId}'));
  final licenseResponse = await http
      .get(Uri.parse('http://62.217.182.138:3000/licenseInfo/${userId}'));

  if (response.statusCode == 200 && licenseResponse.statusCode == 200) {
    final userInfo = jsonDecode(response.body);
    final licenseInfo = jsonDecode(licenseResponse.body);
    final avatarResponse = await http
        .get(Uri.parse('http://62.217.182.138:3000/getAvatar/${userId}'));
    String? avatarUrl;
    if (avatarResponse.statusCode == 200) {
      final avatarData = jsonDecode(avatarResponse.body);
      avatarUrl = avatarData['avatarUrl'];
    }
    return {
      'uid': licenseInfo['uid'] ?? '',
      'expiration_date': licenseInfo['expiration_date'] ?? '',
      'username': userInfo['username'] ?? '',
      'email': userInfo['email'] ?? '',
      'phone_number': userInfo['phone_number'] ?? '',
      'avatar_url': avatarUrl ?? '',
    };
  } else {
    throw Exception('Failed to load user info');
  }
}

Future<File?> pickImage() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['png', 'jpg'],
    allowMultiple: false,
  );

  if (result != null) {
    PlatformFile file = result.files.first;
    return File(file.path!);
  } else {
    return null;
  }
}

Future<void> uploadAvatar(
    String userId, List<int> imageBytes, String fileName) async {
  final url = Uri.parse('http://62.217.182.138:3000/uploadAvatar/$userId');
  final request = http.MultipartRequest('POST', url);
  request.files.add(
      http.MultipartFile.fromBytes('avatar', imageBytes, filename: fileName));

  final response = await request.send();
  final responseData = await response.stream.bytesToString();

  if (response.statusCode == 200) {
    final data = jsonDecode(responseData);
    final avatarUrl = data['avatarUrl'];
    print('Avatar uploaded successfully. URL: $avatarUrl');
  } else {
    print('Failed to upload avatar: ${response.reasonPhrase}');
  }
}

int calculateRemainingDays(String? expirationDate) {
  if (expirationDate == null) return 0;

  DateTime now = DateTime.now();
  DateTime expire = DateTime.parse(expirationDate);
  int difference = expire.difference(now).inDays;
  return difference > 0 ? difference : 0;
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
