import 'package:flutter/material.dart';
import 'package:web_flutter/widgets/login_details/login_details.dart';

class LoginContentMobile extends StatelessWidget {
  const LoginContentMobile({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: LoginDetails(),
            ),
          ),
          Footer(),
        ],
      ),
    );
  }
}
