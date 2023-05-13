import 'menu/menu.dart';
import 'menu/menu_item.dart';
import 'package:flutter/material.dart';

class NavigatorView extends StatefulWidget {
  const NavigatorView({Key? key, this.page}) : super(key: key);
  final Widget? page;

  @override
  State<NavigatorView> createState() => _NavigatorViewState();
}

class _NavigatorViewState extends State<NavigatorView> {
  int selectedIndex = 0;
  final SMenuController _menuController = SMenuController(startSize: 50);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SSideMenu(
              controller: _menuController,
              header: Icon(Icons.fluorescent_sharp),
              items: [
                SMenuItemButton(
                  title: 'Exercise Bank',
                  isSelected: selectedIndex == 0,
                  icon: Icons.home,
                  onPressed: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                  },
                ),
                SMenuItemButton(
                  title: 'Workout Builder',
                  isSelected: selectedIndex == 1,
                  icon: Icons.fitness_center,
                  onPressed: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
                ),
                SMenuItemButton(
                  title: 'Diet Planner',
                  isSelected: selectedIndex == 2,
                  icon: Icons.food_bank,
                  onPressed: () {
                    setState(() {
                      selectedIndex = 2;
                    });
                  },
                ),
              ]),
          Expanded(
            child: Container(
              color: Colors.white,
              child: Center(
                child: widget.page,
              ),
            ),
          ),
          SSideMenu(
            items: [],
            header: Text('Custom view'),
            enableSelector: false,
          ),
        ],
      ),
    );
  }
}
