import 'package:flutter/material.dart';
import 'package:web_flutter/widgets/profile_details/profile_details.dart';

class ProfileContentMobile extends StatelessWidget {
  final int userId;

  const ProfileContentMobile({Key? key, required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: ProfileDetails(userId: userId),
            ),
          ),
          Footer(),
        ],
      ),
    );
  }
}
