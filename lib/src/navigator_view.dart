import 'package:fitnessplus/src/diet_planner/diet_planner_view.dart';
import 'package:fitnessplus/src/exercise_bank/exercise_details_view.dart';
import 'package:fitnessplus/src/exercise_bank/exercise_bank_view.dart';
import 'package:fitnessplus/src/settings/settings_view.dart';
import 'package:fitnessplus/src/workout_builder/workout_builder_view.dart';

import 'menu/menu.dart';
import 'menu/menu_item.dart';
import 'package:flutter/material.dart';

class NavUtils {
  static final NavUtils _instance = NavUtils._internal();
  factory NavUtils() {
    return _instance;
  }
  NavUtils._internal();

  // Set value of route in didPopNext() of RouteAware widget's route name so that the current route can be known
  // Set value of route to pushed route name so current route can be know

  static final GlobalKey<NavigatorState> navigatorStateKey =
      GlobalKey<NavigatorState>();

  static final ValueNotifier<String> route = ValueNotifier<String>('/');

  static pushNamed({String? routeName}) {
    navigatorStateKey.currentState?.restorablePushNamed(
      routeName ?? '/',
    );
    route.value = routeName ?? '/';
  }
}

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
  void initState() {
    NavUtils.route.addListener(() {
      setSelected(routeName: NavUtils.route.value);
    });
    super.initState();
  }

  void setSelected({String? routeName}) {
    print('Route: $routeName');
    setState(() {
      if (routeName == SampleItemListView.routeName ||
          routeName == SampleItemDetailsView.routeName ||
          routeName == SettingsView.routeName) {
        selectedIndex = 0;
      } else if (routeName == WorkoutBuilderView.routeName) {
        selectedIndex = 1;
      } else if (routeName == DietPlannerView.routeName) {
        selectedIndex = 2;
      } else {
        selectedIndex = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SSideMenu(
              resizable: false,
              enableSelector: true,
              style: SSideMenuStyle(
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
              controller: _menuController,
              footer: TextButton(
                child: Icon(Icons.menu_open),
                onPressed: () => _menuController.toggle(),
              ),
              header: Icon(Icons.fluorescent_sharp),
              items: [
                SMenuItemButton(
                  style: SMenuItemStyle(),
                  title: 'Exercise Bank',
                  isSelected: selectedIndex == 0,
                  icon: Icons.home,
                  onPressed: () {
                    NavUtils.pushNamed(routeName: SampleItemListView.routeName);
                    setState(() {
                      setSelected(routeName: SampleItemListView.routeName);
                    });
                  },
                ),
                SMenuItemButton(
                  title: 'Workout Builder',
                  isSelected: selectedIndex == 1,
                  icon: Icons.fitness_center,
                  onPressed: () {
                    NavUtils.pushNamed(routeName: WorkoutBuilderView.routeName);
                    setState(() {
                      setSelected(routeName: WorkoutBuilderView.routeName);
                    });
                  },
                ),
                SMenuItemButton(
                  title: 'Diet Planner',
                  isSelected: selectedIndex == 2,
                  icon: Icons.food_bank,
                  onPressed: () {
                    NavUtils.pushNamed(routeName: DietPlannerView.routeName);
                    setState(() {
                      setSelected(routeName: DietPlannerView.routeName);
                    });
                  },
                ),
              ]),
          Expanded(
            child: Center(
              child: widget.page,
            ),
          ),
        ],
      ),
    );
  }
}
