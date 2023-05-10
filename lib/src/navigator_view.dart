import 'menu/menu.dart';
import 'menu/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_side_menu/flutter_side_menu.dart';

class NavigatorView extends StatefulWidget {
  const NavigatorView({Key? key, this.page}) : super(key: key);
  final Widget? page;

  @override
  State<NavigatorView> createState() => _NavigatorViewState();
}

class _NavigatorViewState extends State<NavigatorView> {
  int selectedIndex = 0;
  final MenuFunctionController _menuController =
      MenuFunctionController(position: MenuPosition.left);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Menu(
              controller: _menuController,
              header: Icon(Icons.fluorescent_sharp),
              items: [
                MenuButtonItem(
                  title: 'Exercise Bank',
                  isSelected: selectedIndex == 0,
                  icon: Icons.home,
                  onPressed: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                  },
                ),
                MenuButtonItem(
                  title: 'Workout Builder',
                  isSelected: selectedIndex == 1,
                  icon: Icons.fitness_center,
                  onPressed: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
                ),
                MenuButtonItem(
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
          Menu(
            items: [],
            header: Text('Custom view'),
            enableSelector: false,
          ),
        ],
      ),
    );
  }
}
