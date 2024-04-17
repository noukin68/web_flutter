import 'package:flutter/material.dart';
import 'package:web_flutter/widgets/register_details.dart/register_details.dart';

class RegisterContentDesktop extends StatelessWidget {
  const RegisterContentDesktop({Key? key}) : super(key: key);

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
