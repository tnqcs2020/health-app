import 'package:flutter/material.dart';
import 'package:stronglier/common/global_variables.dart';
import 'package:stronglier/screens/drawer/drawer_screen.dart';
import 'package:stronglier/screens/drawer/widgets/drawer_items.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile({
    super.key,
    required this.index,
    required this.onTap,
  });

  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ListTile(
        onTap: onTap,
        selected: indexClicked == index,
        selectedTileColor: GV.drawerSelectedTileColor,
        leading: Icon(
          DrawerItems.icon[index],
          size: indexClicked == index ? 35 : 25,
          color: indexClicked == index
              ? GV.drawerItemSelectedColor
              : GV.drawerItemColor,
        ),
        title: Text(
          DrawerItems.menu[index],
          style: TextStyle(
            fontSize: indexClicked == index ? 18 : 15,
            fontWeight:
                indexClicked == index ? FontWeight.bold : FontWeight.normal,
            color: indexClicked == index
                ? GV.drawerItemSelectedColor
                : GV.drawerItemColor,
          ),
        ),
      ),
    );
  }
}
