import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:web_flutter/views/login/login_content_desktop.dart';
import 'package:web_flutter/views/login/login_content_mobile.dart';

class LoginView extends StatelessWidget {
  const LoginView({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: LoginContentMobile(),
      desktop: LoginContentDesktop(),
    );
  }
}
