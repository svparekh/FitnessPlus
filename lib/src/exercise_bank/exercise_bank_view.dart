import 'package:fitnessplus/src/menu/menu_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../menu/menu.dart';
import '../navigator_view.dart';
import '../settings/settings_view.dart';
import 'item.dart';
import 'exercise_details_view.dart';

enum ExerciseBankView { list, grid }

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
  ExerciseBankView _view = ExerciseBankView.grid;

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
      color: Theme.of(context).colorScheme.onPrimary,
      child: CustomScrollView(
        primary: true,
        slivers: [
          // Title
          _buildAppbar(context),

          // Content
          SliverFillRemaining(
            child: Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 35),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    borderRadius: BorderRadius.circular(15)),
                child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (child, anim) =>
                        FadeTransition(opacity: anim, child: child),
                    child: _buildGrid(context)),
              ),
            ),
          )
        ],
      ),
    );
  }

  SliverAppBar _buildAppbar(BuildContext context) {
    return SliverAppBar(
      primary: true,
      bottom: PreferredSize(
          preferredSize: const Size(100, 25),
          child: Container(
              padding: const EdgeInsets.only(bottom: 16, top: 16),
              color: Theme.of(context).colorScheme.onPrimary,
              child: _buildToolbar())),
      pinned: true,
      expandedHeight: 450,
      elevation: 0,
      foregroundColor: Colors.white,
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      flexibleSpace: FlexibleSpaceBar(
        expandedTitleScale: 1.15,
        background: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 450,
              child: Image.asset(
                'assets/images/exercise_bank_bg.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: Text(
                'Exercise Bank',
                style: TextStyle(
                  fontSize: 60,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
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
    );
  }

  Container _buildToolbar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 35),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.transparent,
      ),
      child: Stack(
        children: [
          // Start of toolbar
          const Padding(
            padding: EdgeInsets.only(right: 175.0),
            child: Expanded(
                child: CupertinoSearchTextField(
              prefixIcon: Icon(Icons.search),
              suffixIcon: Icon(Icons.close_rounded),
            )),
          ),
          // Middle of toolbar
          //,
          // End of toolbar
          Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (_view != ExerciseBankView.list) {
                        // Change view
                      }
                      _view = ExerciseBankView.list;
                    });
                  },
                  icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (child, anim) =>
                          FadeTransition(opacity: anim, child: child),
                      child: _view == ExerciseBankView.list
                          ? const Icon(Icons.view_agenda,
                              key: ValueKey('list-icon-on'))
                          : const Icon(
                              Icons.view_agenda_outlined,
                              key: ValueKey('list-icon-off'),
                            )),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (_view != ExerciseBankView.grid) {
                        // Change view
                      }
                      _view = ExerciseBankView.grid;
                    });
                  },
                  icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      transitionBuilder: (child, anim) =>
                          FadeTransition(opacity: anim, child: child),
                      child: _view == ExerciseBankView.grid
                          ? const Icon(Icons.grid_view_rounded,
                              key: ValueKey('grid-icon-on'))
                          : const Icon(
                              Icons.grid_view_outlined,
                              key: ValueKey('grid-icon-off'),
                            )),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: SDropdownMenuMorph(
                    items: [
                      SMenuItemDropdown(
                        title: Text('data'),
                        value: 'data',
                      ),
                    ],
                    icon: Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Icon(Icons.filter_alt_rounded),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 12.0),
                      child: Text(
                        'Filter',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                )
              ]),
        ],
      ),
    );
  }

  Widget _buildGrid(BuildContext context) {
    return _view == ExerciseBankView.grid
        ? GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width ~/ 200),
            // Providing a restorationId allows the ListView to restore the
            // scroll position when a user leaves and returns to the app after it
            // has been killed while running in the background.
            restorationId: 'sampleItemListView',
            physics: NeverScrollableScrollPhysics(),
            // shrinkWrap: true,
            itemCount: widget.items.length,
            itemBuilder: (BuildContext context, int index) {
              final item = widget.items[index];

              return SizedBox(
                width: MediaQuery.of(context).size.width / 300,
                height: MediaQuery.of(context).size.width / 300,
                child: Material(
                  color: Colors.transparent,
                  child: TextButton(
                    style: ButtonStyle(
                        overlayColor: MaterialStatePropertyAll(Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(.1)),
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)))),
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
                                style: const TextStyle(fontSize: 10),
                              ),
                            ]),
                        const Icon(Icons.wind_power)
                      ],
                    ),
                  ),
                ),
              );
            },
          )
        : ListView.builder(
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              final item = widget.items[index];
              Color c = Theme.of(context).colorScheme.primary.withOpacity(.1);
              return Container(
                height: 75,
                child: Stack(
                  children: [
                    Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        hoverColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(.1),
                        splashColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(.1),
                        onTap: () {
                          // Navigate to the details page. If the user leaves and returns to
                          // the app after it has been killed while running in the
                          // background, the navigation stack is restored.
                          Navigator.restorablePushNamed(
                              context, SampleItemDetailsView.routeName);
                        },
                        leading: const CircleAvatar(
                          // Display the Flutter Logo image asset.
                          foregroundImage: AssetImage(
                            'assets/images/3.0x/flutter_logo.png',
                          ),
                        ),
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(item.name ?? 'Exercise Item'),
                            Text(
                              item.description ?? 'Description',
                              style: const TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.wind_power),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }
}
