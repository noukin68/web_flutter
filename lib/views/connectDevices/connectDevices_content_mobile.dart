import 'package:flutter/material.dart';
import 'package:web_flutter/widgets/connectDevices_details/connectDevices_details.dart';

class ConnectDevicesContentMobile extends StatelessWidget {
  final int userId;
  const ConnectDevicesContentMobile({Key? key, required this.userId})
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
              child: ConnectDevicesDetails(userId: userId),
            ),
          ),
          Footer(),
        ],
      ),
    );
  }
}
