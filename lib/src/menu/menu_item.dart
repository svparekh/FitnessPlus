import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'menu.dart';

abstract class MenuItem<T> extends StatelessWidget {
  const MenuItem({
    Key? key,
    this.value,
    this.style,
  }) : super(key: key);
  final T? value;
  final MenuItemStyle? style;
}

class MenuButtonItem<T> extends MenuItem {
  const MenuButtonItem({
    Key? key,
    T? value,
    MenuItemStyle? style = const MenuItemStyle(),
    required this.icon,
    this.selectedTextColor,
    this.selectedIconColor,
    this.textColor,
    this.iconColor,
    this.title,
    this.isSelected = false,
    required this.onPressed,
  })  : assert(isSelected != null),
        super(key: key, value: value, style: style);
  final IconData icon;
  final Color? selectedTextColor;
  final Color? selectedIconColor;
  final Color? textColor;
  final Color? iconColor;
  final String? title;
  final bool isSelected;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: 45,
      margin: EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: isSelected
            ? style?.selectedBgColor ?? Theme.of(context).colorScheme.primary
            : style?.bgColor ?? Theme.of(context).colorScheme.background,
      ),
      duration: Duration(milliseconds: 250),
      child: TextButton.icon(
        onPressed: () {
          onPressed();
        },
        icon: Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Icon(
            icon,
            color: isSelected
                ? style?.selectedAccentColor ??
                    selectedIconColor ??
                    Theme.of(context).colorScheme.onPrimary
                : style?.accentColor ??
                    iconColor ??
                    Theme.of(context).colorScheme.primary,
          ),
        ),
        label: Text(
          title ?? '',
          style: TextStyle(
              color: isSelected
                  ? style?.selectedAccentColor ??
                      selectedTextColor ??
                      Theme.of(context).colorScheme.onPrimary
                  : style?.accentColor ??
                      textColor ??
                      Theme.of(context).colorScheme.primary),
          overflow: TextOverflow.fade,
          maxLines: 1,
          softWrap: false,
        ),
      ),
    );
  }
}

// Wrapper for abstract class MenuItem
class CustomMenuItem<T> extends MenuItem {
  final Widget? child;
  const CustomMenuItem({Key? key, T? value, MenuItemStyle? style, this.child})
      : super(
          key: key,
          value: value,
          style: style,
        );

  @override
  Widget build(BuildContext context) {
    return child ?? Container();
  }
}

class MenuDropdownItem<T> extends MenuItem {
  const MenuDropdownItem({
    Key? key,
    required T value,
    MenuItemStyle? style,
    this.leading,
    this.title,
    this.trailing,
  }) : super(
          key: key,
          value: value,
          style: style,
        );
  final Widget? leading;
  final Widget? title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: style?.bgColor,
      leading: leading,
      title: title,
      trailing: trailing,
    );
  }
}

class MenuSelectableDropdownItem extends MenuItem {
  const MenuSelectableDropdownItem({
    Key? key,
    this.leading,
    this.title,
    this.trailing,
  }) : super(key: key);
  final Widget? leading;
  final Widget? title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: 40,
      margin: EdgeInsets.only(top: 5),
      duration: Duration(milliseconds: 250),
      child: ListTile(
        leading: leading,
        title: title,
        trailing: trailing,
      ),
    );
  }
}
