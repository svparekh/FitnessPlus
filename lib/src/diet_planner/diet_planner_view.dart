import 'package:fitnessplus/src/menu/menu_item.dart';
import 'package:fitnessplus/src/navigator_view.dart';
import 'package:flutter/material.dart';

import '../menu/menu.dart';
import '../settings/settings_view.dart';

/// Displays a list of SampleItems.
class DietPlannerView extends StatefulWidget {
  const DietPlannerView({
    super.key,
    required this.routeObserver,
  });

  final RouteObserver<ModalRoute<void>> routeObserver;

  static const routeName = '/diet-planner';

  @override
  State<DietPlannerView> createState() => _DietPlannerViewState();
}

class _DietPlannerViewState extends State<DietPlannerView> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    widget.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    // Route was pushed onto navigator and is now topmost route.
  }

  @override
  void didPopNext() {
    print(DietPlannerView.routeName);
    NavUtils.route.value = DietPlannerView.routeName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diet Planner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      body: Center(
        child: Container(),
      ),
    );
  }
}
