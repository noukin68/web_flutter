import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_flutter/widgets/login_details/login_details.dart';

class RegisterDetails extends StatelessWidget {
  const RegisterDetails({Key? key}) : super(key: key);

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
  const DesktopView({Key? key});

  @override
  State<DesktopView> createState() => _DesktopViewState();
}

class _DesktopViewState extends State<DesktopView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          'Регистрация',
          style: TextStyle(
            color: Colors.white,
            fontSize: 96,
            fontWeight: FontWeight.bold,
            fontFamily: 'Jura',
          ),
        ),
        Expanded(
          flex: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RegisterCard(),
            ],
          ),
        ),
      ],
    );
  }
}

class MobileView extends StatefulWidget {
  const MobileView({Key? key});

  @override
  State<MobileView> createState() => _MobileViewState();
}

class _MobileViewState extends State<MobileView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Text(
            'Регистрация',
            style: TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
              fontFamily: 'Jura',
            ),
          ),
          RegisterCard(),
        ],
      ),
    );
  }
}

class RegisterCard extends StatefulWidget {
  @override
  State<RegisterCard> createState() => _RegisterCardState();
}

class _RegisterCardState extends State<RegisterCard> {
  bool isChecked = false;

  TextEditingController emailController = TextEditingController();

  TextEditingController usernameController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController emailVerificationCodeController =
      TextEditingController();

  bool enableConfirmEmail = false;

  bool isEmailVerified = false;

  int userId = 0;

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ошибка'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void navigateToLoginPage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Успешная регистрация'),
          content: const Text('Вы успешно зарегистрированы!'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginDetails()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> registerUser() async {
    String email = emailController.text.trim();
    String username = usernameController.text.trim();
    String phone = phoneController.text.trim();
    String password = passwordController.text;

    if (email.isEmpty ||
        username.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        !isEmailVerified) {
      if (!isEmailVerified) {
        showErrorMessage('Пожалуйста, подтвердите email');
      } else {
        showErrorMessage('Пожалуйста, заполните все поля');
      }
      return;
    }

    RegExp phoneRegExp = RegExp(r'^\+7|8[0-9]{10}$');
    if (!phoneRegExp.hasMatch(phone)) {
      showErrorMessage('Пожалуйста, введите корректный номер телефона');
      return;
    }

    try {
      var requestBody = jsonEncode({
        'email': email,
        'username': username,
        'phone': phone,
        'password': password,
      });

      var response = await http.post(
        Uri.parse('http://62.217.182.138:3000/userregister'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: requestBody,
      );

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', email);

        navigateToLoginPage();
      } else {
        showErrorMessage('Ошибка регистрации');
      }
    } catch (e) {
      showErrorMessage('Ошибка регистрации: $e');
    }
  }

  Future<void> sendEmailVerificationCode() async {
    String email = emailController.text.trim();

    if (email.isEmpty) {
      showErrorMessage('Пожалуйста, введите email');
      return;
    }

    try {
      var response = await http.post(
        Uri.parse('http://62.217.182.138:3000/checkEmailExists'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (responseData['exists'] == true) {
          showErrorMessage('Этот email уже зарегистрирован');
          return;
        }
      } else {
        showErrorMessage('Ошибка проверки email');
        return;
      }
    } catch (e) {
      showErrorMessage('Ошибка проверки email: $e');
      return;
    }

    // Если email не существует, отправляем код подтверждения
    try {
      var response = await http.post(
        Uri.parse('http://62.217.182.138:3000/sendEmailVerificationCode'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (responseData['error'] != null) {
          showErrorMessage(
              'Ошибка отправки кода подтверждения: ${responseData['error']}');
        }
      } else {
        showErrorMessage('Ошибка отправки кода подтверждения');
      }
    } catch (e) {
      showErrorMessage('Ошибка отправки кода подтверждения: $e');
    }
  }

  Future<void> verifyEmail() async {
    String email = emailController.text.trim();
    String code = emailVerificationCodeController.text.trim();

    if (email.isEmpty || code.isEmpty) {
      showErrorMessage('Пожалуйста, заполните все поля');
      return;
    }

    try {
      var response = await http.post(
        Uri.parse('http://62.217.182.138:3000/verifyEmail'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'email': email, 'code': code}),
      );

      if (response.statusCode == 200) {
        setState(() {
          isEmailVerified = true;
        });
      } else {
        showErrorMessage('Ошибка подтверждения email');
      }
    } catch (e) {
      showErrorMessage('Ошибка подтверждения email: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromRGBO(53, 50, 50, 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      elevation: 10,
      child: Container(
        width: 957,
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 557,
              height: 85,
              child: TextFormField(
                controller: usernameController,
                style: TextStyle(
                    color: Colors.white, fontSize: 48, fontFamily: 'Jura'),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: 'Имя',
                  hintStyle: TextStyle(
                    color: Color.fromRGBO(216, 216, 216, 1),
                    fontSize: 48,
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
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 557,
                  height: 85,
                  child: TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                        color: Colors.white, fontSize: 48, fontFamily: 'Jura'),
                    cursorColor: Colors.white,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      hintText: 'E-mail',
                      hintStyle: TextStyle(
                        color: Color.fromRGBO(216, 216, 216, 1),
                        fontSize: 48,
                      ),
                      filled: true,
                      fillColor: Color.fromRGBO(100, 100, 100, 1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        enableConfirmEmail = value.isNotEmpty;
                      });
                    },
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: enableConfirmEmail
                      ? () {
                          sendEmailVerificationCode();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                elevation: 0.0,
                                backgroundColor:
                                    const Color.fromRGBO(100, 100, 100, 1),
                                child: Container(
                                  width: 557, // set the width of the dialog box
                                  height:
                                      250, // set the height of the dialog box
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(20.0),
                                        child: Text(
                                          'Введите код отправленный на почту',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontFamily: 'Jura',
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: TextFormField(
                                          cursorColor: Colors.black,
                                          controller:
                                              emailVerificationCodeController,
                                          keyboardType: TextInputType.number,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 48,
                                            fontFamily: 'Jura',
                                          ),
                                          decoration: InputDecoration(
                                            hintText:
                                                'Введите код подтверждения',
                                            hintStyle: const TextStyle(
                                              color: Color.fromRGBO(
                                                  216, 216, 216, 1),
                                              fontSize: 48,
                                            ),
                                            filled: true,
                                            fillColor: const Color.fromRGBO(
                                                255, 255, 255, 1),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text(
                                              'Отмена',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Jura',
                                                color: Color.fromRGBO(
                                                    216, 216, 216, 1),
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      100, 100, 100, 1),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          ElevatedButton(
                                            onPressed: () {
                                              verifyEmail();
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text(
                                              'Подтвердить',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Jura',
                                                color: Color.fromRGBO(
                                                    216, 216, 216, 1),
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      100, 100, 100, 1),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      : null,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Подтвердить\nemail',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Jura',
                          color:
                              enableConfirmEmail ? Colors.white : Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              width: 557,
              height: 85,
              child: TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                style: TextStyle(
                    color: Colors.white, fontSize: 48, fontFamily: 'Jura'),
                cursorColor: Colors.white,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    if (!value.startsWith('+7') && !value.startsWith('8')) {
                      phoneController.text = '+7';
                      phoneController.selection = TextSelection.fromPosition(
                        TextPosition(offset: phoneController.text.length),
                      );
                    }

                    String digits = value.replaceAll(RegExp(r'\D'), '');

                    if (digits.length >= 1) {
                      String formattedPhone = '+7';

                      if (digits.length >= 2) {
                        formattedPhone += ' (' + digits.substring(1, 4);
                      }

                      if (digits.length >= 5) {
                        formattedPhone += ') ' + digits.substring(4, 7);
                      }

                      if (digits.length >= 8) {
                        formattedPhone += '-' + digits.substring(7, 9);
                      }

                      if (digits.length >= 10) {
                        formattedPhone += '-' + digits.substring(9, 11);
                      }

                      phoneController.value = phoneController.value.copyWith(
                        text: formattedPhone,
                        selection: TextSelection.collapsed(
                            offset: formattedPhone.length),
                      );
                    }
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Номер телефона',
                  hintStyle: TextStyle(
                      color: Color.fromRGBO(216, 216, 216, 1),
                      fontSize: 48,
                      fontFamily: 'Jura'),
                  filled: true,
                  fillColor: Color.fromRGBO(100, 100, 100, 1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  RegExp phoneRegExp =
                      RegExp(r'^\+7 \(\d{3}\) \d{3}-\d{2}-\d{2}$');
                  if (!phoneRegExp.hasMatch(value!)) {
                    return 'Введите корректный номер телефона';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 557,
              height: 85,
              child: TextFormField(
                controller: passwordController,
                obscureText: true,
                style: TextStyle(
                    color: Colors.white, fontSize: 48, fontFamily: 'Jura'),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: 'Пароль',
                  hintStyle: TextStyle(
                      color: Color.fromRGBO(216, 216, 216, 1),
                      fontSize: 48,
                      fontFamily: 'Jura'),
                  filled: true,
                  fillColor: Color.fromRGBO(100, 100, 100, 1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: Checkbox(
                      value: isChecked,
                      onChanged: (bool? newValue) {
                        setState(() {
                          isChecked = newValue!;
                        });
                      },
                      activeColor: Colors.white,
                      checkColor: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Я согласен с ',
                            style: TextStyle(
                                color: Color.fromRGBO(216, 216, 216, 1),
                                fontSize: 20,
                                fontFamily: 'Jura'),
                          ),
                          TextSpan(
                            text: 'лицензионным соглашением',
                            style: const TextStyle(
                                color: Color.fromRGBO(192, 8, 196, 1),
                                fontSize: 20,
                                fontFamily: 'Jura'),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 302,
              height: 74,
              child: TextButton(
                onPressed: () {
                  registerUser();
                },
                child: Text(
                  'Войти',
                  style: TextStyle(fontSize: 64, fontFamily: 'Jura'),
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
