import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum SlideDirection { left, right, up, down }

class SlidePageRoute<T> extends PageRoute<T> {
  /// {@macro hero_dialog_route}
  SlidePageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    super.fullscreenDialog,
    this.direction,
  })  : _builder = builder,
        super(settings: settings);

  final WidgetBuilder _builder;
  final SlideDirection? direction;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black54;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    Offset begin = const Offset(1.0, 0.0);
    Offset end = Offset.zero;
    switch (direction) {
      case SlideDirection.up:
        begin = const Offset(0.0, 1.0);
        end = Offset.zero;
        break;
      case SlideDirection.down:
        begin = const Offset(0.0, -1.0);
        end = Offset.zero;
        break;
      case SlideDirection.left:
        begin = const Offset(1.0, 0.0);
        end = Offset.zero;
        break;
      case SlideDirection.right:
        begin = const Offset(-1.0, 0.0);
        end = Offset.zero;
        break;
      default:
        begin = const Offset(1.0, 0.0);
        end = Offset.zero;
    }

    const curve = Curves.ease;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
    // return child;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return _builder(context);
  }

  @override
  String get barrierLabel => 'Popup dialog open';
}

class BottomUpPageRoute<T> extends PageRoute<T> {
  /// {@macro hero_dialog_route}
  BottomUpPageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool fullscreenDialog = true,
  })  : _builder = builder,
        super(settings: settings, fullscreenDialog: fullscreenDialog);

  final WidgetBuilder _builder;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black54;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    const begin = Offset(0.0, 1.0);
    const end = Offset.zero;
    const curve = Curves.ease;

    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
    // return child;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return _builder(context);
  }

  @override
  String get barrierLabel => 'Popup dialog open';
}
