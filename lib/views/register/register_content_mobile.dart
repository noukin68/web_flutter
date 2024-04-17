import 'package:flutter/material.dart';
import 'package:web_flutter/widgets/register_details.dart/register_details.dart';

class RegisterContentMobile extends StatelessWidget {
  const RegisterContentMobile({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: RegisterDetails(),
            ),
          ),
          Footer()
        ],
      ),
    );
  }
}
