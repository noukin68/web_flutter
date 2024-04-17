import 'package:flutter/material.dart';
import 'package:web_flutter/widgets/about_details/about_details.dart';

class HomeContentMobile extends StatelessWidget {
  final int userId;
  const HomeContentMobile({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: AboutDetails(userId: userId),
            ),
          ),
          Footer(),
        ],
      ),
    );
  }
}
