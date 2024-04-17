import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:web_flutter/views/register/register_content_desktop.dart';
import 'package:web_flutter/views/register/register_content_mobile.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: RegisterContentMobile(),
      desktop: RegisterContentDesktop(),
    );
  }
}
