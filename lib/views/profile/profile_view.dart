import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:web_flutter/views/profile/profile_content_desktop.dart';
import 'package:web_flutter/views/profile/profile_content_mobile.dart';

class ProfileView extends StatelessWidget {
  final int userId;

  const ProfileView({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: ProfileContentMobile(userId: userId),
      desktop: ProfileContentDesktop(userId: userId),
    );
  }
}
