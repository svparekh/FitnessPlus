import 'package:fitnessplus/src/menu/menu_item.dart';
import 'package:flutter/material.dart';

import '../menu/menu.dart';
import '../navigator_view.dart';
import '../settings/settings_view.dart';

/// Displays a list of SampleItems.
class WorkoutBuilderView extends StatefulWidget {
  const WorkoutBuilderView({
    required this.routeObserver,
    super.key,
  });

  static const routeName = '/workout-builder';
  final RouteObserver<ModalRoute<void>> routeObserver;

  @override
  State<WorkoutBuilderView> createState() => _WorkoutBuilderViewState();
}

class _WorkoutBuilderViewState extends State<WorkoutBuilderView>
    with RouteAware {
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
    print(WorkoutBuilderView.routeName);
    NavUtils.route.value = WorkoutBuilderView.routeName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Builder'),
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
