import 'package:flutter/material.dart';
import 'package:web_flutter/widgets/renewRates_details/renewRates_details.dart';

class RenewRatesMobile extends StatelessWidget {
  final int userId;

  const RenewRatesMobile({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: RenewRatesDetails(userId: userId),
            ),
          ),
          Footer()
        ],
      ),
    );
  }
}
