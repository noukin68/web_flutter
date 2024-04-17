import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:web_flutter/views/connectDevices/connectDevices_content_desktop.dart';
import 'package:web_flutter/views/connectDevices/connectDevices_content_mobile.dart';

class ConnectDevicesView extends StatelessWidget {
  final int userId;
  const ConnectDevicesView({key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: ConnectDevicesContentMobile(userId: userId),
      desktop: ConnectDevicesContentDesktop(userId: userId),
    );
  }
}
