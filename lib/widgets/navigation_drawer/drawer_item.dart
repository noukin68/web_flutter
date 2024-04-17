import 'package:flutter/material.dart';
import 'package:web_flutter/widgets/navigation_bar/navbar_item.dart';

class DrawerItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final String navigationPath;
  final Color color;

  const DrawerItem(this.title, this.icon, this.navigationPath, this.color,
      {required String fontFamily});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20),
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            color: color,
          ),
          SizedBox(
            width: 30,
          ),
          Flexible(
            child: NavBarItem(title, navigationPath),
          ),
        ],
      ),
    );
  }
}
