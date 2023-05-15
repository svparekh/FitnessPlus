import 'package:fitnessplus/src/diet_planner/diet_planner_view.dart';
import 'package:fitnessplus/src/workout_builder/workout_builder_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'exercise_bank/exercise_details_view.dart';
import 'exercise_bank/exercise_bank_view.dart';
import 'menu/routes.dart';
import 'navigator_view.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  final RouteObserver<ModalRoute<void>> routeObserver =
      RouteObserver<ModalRoute<void>>();

  @override
  Widget build(BuildContext context) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The AnimatedBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: ThemeData(
              colorScheme: ColorScheme.light(
                  background: Colors.white, primary: Colors.blue)),
          darkTheme: ThemeData.dark().copyWith(colorScheme: ColorScheme.dark()),
          themeMode: settingsController.themeMode,
          debugShowCheckedModeBanner: false,
          // Builder to keep a menu persistent over pages
          navigatorObservers: [routeObserver],
          navigatorKey: NavUtils.navigatorStateKey,
          builder: (context, child) {
            return Overlay(
              initialEntries: [
                OverlayEntry(
                  builder: (context) => NavigatorView(
                    page: child,
                  ),
                ),
              ],
            );
          },
          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            // If diet, workout, or list view,
            // Then do a fade transition
            // Otherwise, a slide transition
            final uri = Uri.parse(routeSettings.name!);
            final currentPath = uri.path;
            if (currentPath == DietPlannerView.routeName ||
                currentPath == WorkoutBuilderView.routeName ||
                currentPath == SampleItemListView.routeName) {
              return FadePageRoute<void>(
                settings: routeSettings,
                builder: (BuildContext context) {
                  switch (currentPath) {
                    case DietPlannerView.routeName:
                      return DietPlannerView(
                        routeObserver: routeObserver,
                      );
                    case WorkoutBuilderView.routeName:
                      return WorkoutBuilderView(
                        routeObserver: routeObserver,
                      );
                    case SampleItemListView.routeName:
                    default:
                      return SampleItemListView(
                        routeObserver: routeObserver,
                      );
                  }
                },
              );
            } else {
              return SlidePageRoute<void>(
                direction: SlideDirection.left,
                settings: routeSettings,
                builder: (BuildContext context) {
                  switch (currentPath) {
                    case SampleItemDetailsView.routeName:
                      return SampleItemDetailsView(
                        routeObserver: routeObserver,
                      );
                    case SettingsView.routeName:
                    default:
                      return SettingsView(
                        controller: settingsController,
                        routeObserver: routeObserver,
                      );
                  }
                },
              );
            }
          },
        );
      },
    );
  }
}
