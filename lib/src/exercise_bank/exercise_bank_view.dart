import 'package:fitnessplus/src/menu/menu_item.dart';
import 'package:flutter/material.dart';

import '../menu/menu.dart';
import '../navigator_view.dart';
import '../settings/settings_view.dart';
import 'item.dart';
import 'exercise_details_view.dart';

/// Displays a list of SampleItems.
class SampleItemListView extends StatefulWidget {
  SampleItemListView(
      {super.key,
      this.items = const [
        ExerciseItem(id: 1, name: 'Alt Bicep Curl'),
        ExerciseItem(id: 2, name: 'Hammer Curl'),
        ExerciseItem(id: 3, name: 'Leg Press')
      ],
      required this.routeObserver});

  static const routeName = '/';
  final RouteObserver<ModalRoute<void>> routeObserver;

  final List<ExerciseItem> items;

  @override
  State<SampleItemListView> createState() => _SampleItemListViewState();
}

class _SampleItemListViewState extends State<SampleItemListView>
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
    print(SampleItemListView.routeName);
    NavUtils.route.value = SampleItemListView.routeName;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
      color: Theme.of(context).colorScheme.onPrimary,
      padding: EdgeInsets.all(35),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: [
            AppBar(
              elevation: 0,
              foregroundColor: Colors.black,
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              title: const Text('Sample Items'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    // Navigate to the settings page. If the user leaves and returns
                    // to the app after it has been killed while running in the
                    // background, the navigation stack is restored.
                    Navigator.restorablePushNamed(
                        context, SettingsView.routeName);
                  },
                ),
                SDropdownMenuMorph(child: Text('HI'), items: [
                  SMenuItemDropdown(
                    title: Text('data'),
                    value: 'data',
                  ),
                ]),
              ],
            ),
            ListTile(
              title: SizedBox(
                height: 150,
                child: Container(
                    child: Padding(
                  padding: EdgeInsets.only(top: 25),
                  child: Text(
                    'Exercise Bank',
                    style: TextStyle(fontSize: 50),
                    textAlign: TextAlign.center,
                  ),
                )),
              ),
            ),
            // Header
            ListTile(
              title: SizedBox(
                height: 35,
                child: Container(
                    child: Padding(
                  padding: EdgeInsets.all(25),
                  child: Text(
                    'Exercise Bank',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                )),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width ~/ 300),
                // Providing a restorationId allows the ListView to restore the
                // scroll position when a user leaves and returns to the app after it
                // has been killed while running in the background.
                restorationId: 'sampleItemListView',
                itemCount: widget.items.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = widget.items[index];

                  return SizedBox(
                    width: MediaQuery.of(context).size.width / 250,
                    height: MediaQuery.of(context).size.width / 250,
                    child: TextButton(
                      onPressed: () {
                        // Navigate to the details page. If the user leaves and returns to
                        // the app after it has been killed while running in the
                        // background, the navigation stack is restored.
                        Navigator.restorablePushNamed(
                            context, SampleItemDetailsView.routeName);
                      },
                      child: Stack(
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CircleAvatar(
                                  // Display the Flutter Logo image asset.
                                  foregroundImage: AssetImage(
                                    'assets/images/3.0x/flutter_logo.png',
                                  ),
                                ),
                                Text(item.name ?? 'Exercise Item'),
                                Text(
                                  item.description ?? 'Description',
                                  style: TextStyle(fontSize: 10),
                                ),
                              ]),
                          Icon(Icons.wind_power)
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
