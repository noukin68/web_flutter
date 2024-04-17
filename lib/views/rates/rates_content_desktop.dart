import 'package:flutter/material.dart';
import 'package:web_flutter/widgets/rates_details/rates_details.dart';

class RatesContentDesktop extends StatelessWidget {
  final int userId;

  const RatesContentDesktop({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: RatesDetails(userId: userId),
            ),
          ),
          Footer(),
        ],
      ),
    );
  }
}
