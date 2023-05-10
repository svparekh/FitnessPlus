import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class MenuItem<T> extends StatefulWidget {
  const MenuItem({
    Key? key,
    this.child,
    this.value,
  }) : super(key: key);
  final Widget? child;
  final T? value;

  @override
  State<MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  @override
  Widget build(BuildContext context) {
    return widget.child ?? Container();
  }
}

class MenuButtonItem extends MenuItem {
  const MenuButtonItem({
    Key? key,
    required this.icon,
    this.title,
    this.isSelected = false,
    required this.onPressed,
    this.selectedColor = const Color.fromARGB(255, 255, 255, 255),
    this.selectedIconColor = const Color.fromARGB(255, 33, 150, 243),
    this.unselectedColor = const Color.fromARGB(255, 255, 255, 255),
    this.unselectedIconColor = const Color.fromARGB(255, 0, 0, 0),
  })  : assert(isSelected != null),
        super(key: key);
  final IconData icon;
  final String? title;
  final bool isSelected;
  final void Function() onPressed;
  final Color selectedColor;
  final Color selectedIconColor;
  final Color unselectedColor;
  final Color unselectedIconColor;

  @override
  State<MenuButtonItem> createState() => _MenuButtonItemState();
}

class _MenuButtonItemState extends State<MenuButtonItem> {
  @override
  Widget build(BuildContext context) {
    final Widget icon = Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Icon(
        widget.icon,
        color: widget.isSelected
            ? widget.selectedIconColor
            : widget.unselectedIconColor,
      ),
    );
    return AnimatedContainer(
      height: 45,
      margin: EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color:
            widget.isSelected ? widget.selectedColor : widget.unselectedColor,
      ),
      duration: Duration(milliseconds: 250),
      child: TextButton.icon(
        onPressed: () {
          widget.onPressed();
        },
        icon: icon,
        label: Text(
          widget.title ?? '',
          style: TextStyle(
              color: widget.isSelected
                  ? widget.selectedIconColor
                  : widget.unselectedIconColor),
          overflow: TextOverflow.fade,
          maxLines: 1,
          softWrap: false,
        ),
      ),
    );
  }
}

// Wrapper for abstract class MenuItem
class CustomMenuItem extends MenuItem {
  const CustomMenuItem({super.key, super.child, super.value});
}

class MenuDropdownItem<T> extends MenuItem {
  const MenuDropdownItem({
    Key? super.key,
    required T super.value,
    this.leading,
    this.title,
    this.trailing,
  });
  final Widget? leading;
  final Widget? title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return title ?? Container();
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
