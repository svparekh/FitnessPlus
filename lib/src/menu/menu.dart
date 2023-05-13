import 'package:fitnessplus/src/menu/menu_item.dart';
import 'package:fitnessplus/src/menu/resize_bar.dart';
import 'package:fitnessplus/src/menu/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MenuSize {
  static const double menuWidthOpen = 250;
  static const double menuWidthClosed = 60;
}

enum MenuAlignment {
  topLeft,
  topCenter,
  topRight,
  centerLeft,
  center,
  centerRight,
  bottomLeft,
  bottomCenter,
  bottomRight
}

enum MenuState { open, closed }

enum MenuPosition { top, bottom, left, right }

class MenuStyle {}

class MenuItemStyle {
  final MainAxisAlignment? mainAxisAlignment;
  final BorderRadius? borderRadius;
  final OutlinedBorder? shape;
  final double? elevation;
  final EdgeInsets? padding;
  final BoxConstraints? constraints;
  final double? width;
  final double? height;
  final Color? accentColor;
  final Color? selectedAccentColor;
  final Color? bgColor;
  final Color? selectedBgColor;

  const MenuItemStyle({
    this.borderRadius,
    this.selectedAccentColor,
    this.selectedBgColor,
    this.accentColor,
    this.bgColor,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.constraints = const BoxConstraints(),
    this.height,
    this.width,
    this.elevation = 0,
    this.padding = const EdgeInsets.all(0),
    this.shape = const RoundedRectangleBorder(),
  });
}

class MenuDropdownStyle {
  final BorderRadius? borderRadius;
  final double? elevation;
  final Color? color;
  final EdgeInsets? padding;
  final BoxConstraints? constraints;
  final MenuAlignment? alignment;

  /// position of the top left of the dropdown relative to the top left of the button
  final Offset? offset;

  ///button width must be set for this to take effect
  final double width;
  final double? height;

  const MenuDropdownStyle({
    this.alignment = MenuAlignment.bottomLeft,
    this.constraints = const BoxConstraints(),
    this.offset,
    this.width = 200,
    this.height,
    this.elevation = 0,
    this.color = Colors.white,
    this.padding,
    this.borderRadius,
  });
}

class MenuFunctionController {
  MenuFunctionController({this.position = MenuPosition.right});
  late void Function() open;
  late void Function() close;
  late void Function() toggle;
  final MenuPosition position;
  final ValueNotifier<MenuState> state =
      ValueNotifier<MenuState>(MenuState.closed);
  final ValueNotifier<double> size =
      ValueNotifier<double>(MenuSize.menuWidthClosed);
}

class Menu extends StatefulWidget {
  const Menu({
    Key? key,
    required this.items,
    this.header,
    this.footer,
    this.controller,
    this.barColor,
    this.backgroundColor,
    this.enableSelector = true,
  }) : super(key: key);
  final MenuFunctionController? controller;
  final List<MenuItem> items;
  final Widget? header;
  final Widget? footer;
  final Color? barColor;
  final Color? backgroundColor;
  final bool enableSelector;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  int selectedIndex = 0;
  MenuFunctionController controller = MenuFunctionController();

  void _openMenu() {
    setState(() {
      controller.size.value = MenuSize.menuWidthOpen;
      controller.state.value = MenuState.open;
    });
  }

  void _closeMenu() {
    setState(() {
      controller.size.value = MenuSize.menuWidthClosed;
      controller.state.value = MenuState.closed;
    });
  }

  void _toggleMenu() {
    if (controller.size.value > MenuSize.menuWidthClosed) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

  @override
  void initState() {
    if (widget.controller != null) {
      controller = widget.controller!;
    }

    controller.open = _openMenu;
    controller.close = _closeMenu;
    controller.toggle = _toggleMenu;

    controller.size.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    for (var item in widget.items) {
      if (item is MenuButtonItem && item.isSelected == true) {
        selectedIndex = widget.items.indexOf(item);
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Left resize bar
        if (controller.position == MenuPosition.right)
          ResizeBar(
            menuController: controller,
          ),

        AnimatedContainer(
          padding: EdgeInsets.symmetric(horizontal: 5),
          color: widget.backgroundColor ??
              Theme.of(context).colorScheme.background,
          duration: Duration(milliseconds: 250),
          width: (controller.position == MenuPosition.left ||
                  controller.position == MenuPosition.right)
              ? controller.size.value
              : null,
          height: (controller.position == MenuPosition.top ||
                  controller.position == MenuPosition.bottom)
              ? controller.size.value
              : null,
          child: Column(
            children: [
              // Top resize bar
              if (controller.position == MenuPosition.bottom)
                ResizeBar(
                  menuController: controller,
                ),
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        widget.header ?? Container(),
                        Stack(
                          children: [
                            Column(
                              children: widget.items,
                            ),
                            // Moving bar to indicate page number
                            if (widget.enableSelector &&
                                widget.items.isNotEmpty)
                              AnimatedContainer(
                                duration: Duration(milliseconds: 250),
                                padding: EdgeInsets.only(
                                    left: 1, top: 15 + (selectedIndex * 50)),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: widget.barColor ??
                                          Theme.of(context)
                                              .colorScheme
                                              .onPrimary),
                                  height: 25,
                                  width: 5,
                                ),
                              )
                          ],
                        ),
                      ],
                    ),
                    widget.footer ??
                        Container(
                          child: TextButton(
                            child: Text('T'),
                            onPressed: () {
                              _toggleMenu();
                            },
                          ),
                        )
                  ]),
              // Bottom resize bar
              if (controller.position == MenuPosition.top)
                ResizeBar(
                  menuController: controller,
                ),
            ],
          ),
        ),

        // Right resize bar
        if (controller.position == MenuPosition.left)
          ResizeBar(
            menuController: controller,
          ),
      ],
    );
  }
}

abstract class MenuDropdown<T> extends StatefulWidget {
  /// the child widget for the button, this will be ignored if text is supplied
  final Widget child;
  final MenuFunctionController? controller;
  final List<MenuItem<T>> items;
  final Widget? header;
  final Widget? footer;

  /// onChange is called when the selected option is changed.;
  /// It will pass back the value and the index of the option.
  final void Function(T, int)? onChange;

  /// list of DropdownItems
  final MenuDropdownStyle? style;

  /// dropdown button icon defaults to caret
  final Icon? icon;
  final bool? hideIcon;

  /// if true the dropdown icon will as a leading icon, default to false
  final bool? leadingIcon;

  const MenuDropdown({
    Key? key,
    this.hideIcon = false,
    required this.child,
    required this.items,
    this.style = const MenuDropdownStyle(),
    this.icon,
    this.leadingIcon = false,
    this.onChange,
    this.controller,
    this.header,
    this.footer,
  }) : super(key: key);

  @override
  State<MenuDropdown<T>> createState() => _MenuDropdownState<T>();
}

class _MenuDropdownState<T> extends State<MenuDropdown<T>>
    with TickerProviderStateMixin {
  int selectedIndex = 0;
  MenuFunctionController controller = MenuFunctionController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class MenuDropdownCascade<T> extends MenuDropdown {
  // /// the child widget for the button, this will be ignored if text is supplied
  // final Widget child;
  // final MenuFunctionController? controller;
  // final List<MenuItem<T>> items;
  // final Widget? header;
  // final Widget? footer;

  // /// onChange is called when the selected option is changed.;
  // /// It will pass back the value and the index of the option.
  // final void Function(T, int)? onChange;

  // /// list of DropdownItems
  // final DropdownStyle dropdownStyle;

  // /// dropdownButtonStyles passes styles to OutlineButton.styleFrom()
  // final DropdownButtonStyle dropdownButtonStyle;

  // /// dropdown button icon defaults to caret
  // final Icon? icon;
  // final bool hideIcon;

  // /// if true the dropdown icon will as a leading icon, default to false
  // final bool leadingIcon;
  const MenuDropdownCascade({
    final Key? key,
    final bool? hideIcon = false,
    required Widget child,
    required List<MenuItem<T>> items,
    final MenuDropdownStyle style = const MenuDropdownStyle(),
    this.buttonStyle = const MenuItemStyle(),
    final Icon? icon,
    final bool? leadingIcon = false,
    final void Function(dynamic, int)? onChange,
    final MenuFunctionController? controller,
    final Widget? header,
    final Widget? footer,
  }) : super(
            key: key,
            hideIcon: hideIcon,
            child: child,
            items: items,
            style: style,
            icon: icon,
            leadingIcon: leadingIcon,
            onChange: onChange,
            controller: controller,
            header: header,
            footer: footer);
  final MenuItemStyle? buttonStyle;
  @override
  State<MenuDropdownCascade<T>> createState() => _MenuDropdownCascadeState<T>();
}

class _MenuDropdownCascadeState<T> extends State<MenuDropdownCascade<T>>
    with TickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  int _currentIndex = -1;
  AnimationController? _animationController;
  Animation<double>? _expandAnimation;
  Animation<double>? _rotateAnimation;
  int selectedIndex = 0;
  MenuFunctionController controller = MenuFunctionController();

  void _openMenu() {
    setState(() {
      controller.size.value = MenuSize.menuWidthOpen;
      controller.state.value = MenuState.open;
    });
  }

  void _closeMenu() {
    setState(() {
      controller.size.value = MenuSize.menuWidthClosed;
      controller.state.value = MenuState.closed;
    });
  }

  void _toggleMenu() {
    if (controller.size.value > MenuSize.menuWidthClosed) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

  @override
  void initState() {
    if (widget.controller != null) {
      controller = widget.controller!;
    }

    controller.open = _openMenu;
    controller.close = _closeMenu;
    controller.toggle = _toggleMenu;

    controller.size.addListener(() {
      setState(() {});
    });

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _expandAnimation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    );
    _rotateAnimation = Tween(begin: 0.0, end: 0.5).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    ));

    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    this._overlayEntry?.remove();
    this._overlayEntry?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var style = widget.buttonStyle;
    // link the overlay to the button
    return CompositedTransformTarget(
      link: this._layerLink,
      child: Container(
        width: style?.width,
        height: style?.height,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            padding: style?.padding,
            backgroundColor: style?.bgColor ?? Colors.white,
            elevation: style?.elevation,
            foregroundColor: style?.accentColor,
            shape: style?.shape,
          ),
          onPressed: _toggleDropdown,
          child: Row(
            mainAxisAlignment:
                style?.mainAxisAlignment ?? MainAxisAlignment.center,
            textDirection:
                widget.leadingIcon != null && widget.leadingIcon == true
                    ? TextDirection.rtl
                    : TextDirection.ltr,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_currentIndex == -1) ...[
                widget.child,
              ] else ...[
                widget.items[_currentIndex],
              ],
              if (widget.hideIcon != null && !widget.hideIcon!)
                RotationTransition(
                  turns: _rotateAnimation!,
                  child: widget.icon ?? Icon(Icons.abc),
                ),
            ],
          ),
        ),
      ),
    );
  }

  OverlayEntry _createOverlayEntry() {
    // find the size and position of the current widget
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    var offset = renderBox.localToGlobal(Offset.zero);
    var topOffset = offset.dy + size.height + 50;
    var leftOffset = offset.dx - size.width - 5;
    print(topOffset);
    print(leftOffset);
    return OverlayEntry(
      // full screen GestureDetector to register when a
      // user has clicked away from the dropdown
      builder: (context) => GestureDetector(
        onTap: () => _toggleDropdown(close: true),
        behavior: HitTestBehavior.translucent,
        // full screen container to register taps anywhere and close drop down
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Positioned(
                left: leftOffset,
                top: topOffset,
                width: widget.style?.width ?? size.width,
                child: CompositedTransformFollower(
                  offset: widget.style?.offset ?? Offset(0, size.height + 5),
                  link: this._layerLink,
                  showWhenUnlinked: false,
                  child: Material(
                    elevation: widget.style?.elevation ?? 0,
                    borderRadius:
                        widget.style?.borderRadius ?? BorderRadius.zero,
                    color: widget.style?.color,
                    child: SizeTransition(
                      axisAlignment: 1,
                      sizeFactor: _expandAnimation!,
                      child: ConstrainedBox(
                        constraints: widget.style?.constraints ??
                            BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height -
                                  topOffset -
                                  15,
                            ),
                        child: ListView(
                          padding: widget.style?.padding ?? EdgeInsets.zero,
                          shrinkWrap: true,
                          children: widget.items.asMap().entries.map((item) {
                            return InkWell(
                              onTap: () {
                                setState(() => _currentIndex = item.key);
                                if (widget.onChange != null &&
                                    item.value.value != null) {
                                  widget.onChange!(
                                      item.value.value as T, item.key);
                                }

                                _toggleDropdown();
                              },
                              child: item.value,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleDropdown({bool close = false}) async {
    if (_isOpen || close) {
      await _animationController!.reverse();
      this._overlayEntry!.remove();
      setState(() {
        _isOpen = false;
      });
    } else {
      this._overlayEntry = this._createOverlayEntry();
      Overlay.of(context).insert(this._overlayEntry!);
      print('Pushed');
      setState(() => _isOpen = true);
      _animationController!.forward();
    }
  }
}

class MenuDropdownMorph<T> extends MenuDropdown {
  // /// the child widget for the button, this will be ignored if text is supplied
  // final Widget child;
  // final MenuFunctionController? controller;
  // final List<MenuItem<T>> items;
  // final Widget? header;
  // final Widget? footer;

  // /// onChange is called when the selected option is changed.;
  // /// It will pass back the value and the index of the option.
  // final void Function(T, int)? onChange;

  // /// list of DropdownItems
  // final DropdownStyle dropdownStyle;

  // /// dropdownButtonStyles passes styles to OutlineButton.styleFrom()
  // final DropdownButtonStyle dropdownButtonStyle;

  // /// dropdown button icon defaults to caret
  // final Icon? icon;
  // final bool hideIcon;

  // /// if true the dropdown icon will as a leading icon, default to false
  // final bool leadingIcon;
  const MenuDropdownMorph({
    this.itemStyle,
    final Key? key,
    final bool? hideIcon = false,
    required Widget child,
    required List<MenuItem<T>> items,
    final MenuDropdownStyle? style = const MenuDropdownStyle(),
    final Icon? icon,
    final bool? leadingIcon = false,
    final void Function(dynamic, int)? onChange,
    final MenuFunctionController? controller,
    final Widget? header,
    final Widget? footer,
  }) : super(
            key: key,
            hideIcon: hideIcon,
            child: child,
            items: items,
            style: style,
            icon: icon,
            leadingIcon: leadingIcon,
            onChange: onChange,
            controller: controller,
            header: header,
            footer: footer);
  final MenuItemStyle? itemStyle;
  @override
  State<MenuDropdownMorph<T>> createState() => _MenuDropdownMorphState<T>();
}

class _MenuDropdownMorphState<T> extends State<MenuDropdownMorph<T>>
    with TickerProviderStateMixin {
  int selectedIndex = 0;
  MenuFunctionController controller = MenuFunctionController();
  GlobalKey renderKey = GlobalKey();

  void _openMenu() {
    setState(() {
      controller.size.value = MenuSize.menuWidthOpen;
      controller.state.value = MenuState.open;
    });
  }

  void _closeMenu() {
    setState(() {
      controller.size.value = MenuSize.menuWidthClosed;
      controller.state.value = MenuState.closed;
    });
  }

  void _toggleMenu() {
    if (controller.size.value > MenuSize.menuWidthClosed) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

  @override
  void initState() {
    if (widget.controller != null) {
      controller = widget.controller!;
    }

    controller.open = _openMenu;
    controller.close = _closeMenu;
    controller.toggle = _toggleMenu;

    controller.size.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomHero(
      tag: 0,
      child: Container(
        decoration: BoxDecoration(
            color: widget.itemStyle?.bgColor ??
                Theme.of(context).colorScheme.background,
            borderRadius: widget.style?.borderRadius),
        child: SizedBox(
          width: 50,
          height: 50,
          child: TextButton(
            key: renderKey,
            child: Text('^'),
            onPressed: () {
              Navigator.push(context, TaskDialogRoute(
                builder: (context) {
                  return _MenuPopup(
                    position: calcPopupPosition(),
                    tag: 0,
                    items: widget.items,
                    style: widget.style,
                    controller: widget.controller,
                    header: widget.header,
                    footer: widget.footer,
                  );
                },
              ));
            },
          ),
        ),
      ),
    );
  }

  Offset calcPopupPosition() {
    var renderBox = renderKey.currentContext?.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var windowSize = MediaQuery.of(context).size;
    var offset = renderBox.localToGlobal(Offset.zero);
    double topOffset;
    double leftOffset;

    switch (widget.style?.alignment) {
      case MenuAlignment.topLeft:
        break;
      case MenuAlignment.topCenter:
        break;
      case MenuAlignment.topRight:
        break;
      case MenuAlignment.centerLeft:
        break;
      case MenuAlignment.center:
        break;
      case MenuAlignment.centerRight:
        break;
      case MenuAlignment.bottomLeft:
        break;
      case MenuAlignment.bottomCenter:
        break;
      case MenuAlignment.bottomRight:
      default:
        // default is bottom right

        break;
    }

    if (windowSize.height <
        (offset.dy + size.height + (widget.style?.height ?? 250))) {
      topOffset = offset.dy - size.height - (widget.style?.height ?? 250);
    } else {
      topOffset = offset.dy + size.height;
    }
    if ((0 - (offset.dx + size.width + (widget.style?.width ?? 150))) < 0) {
      leftOffset = offset.dx - size.width - (widget.style?.width ?? 150);
    } else {
      leftOffset = offset.dx - size.width + (widget.style?.width ?? 150);
    }
    return Offset(leftOffset, topOffset);
  }
}

class _MenuPopup<T> extends StatelessWidget {
  final Object tag;
  final List<MenuItem<T>> items;
  final MenuDropdownStyle? style;
  final MenuItemStyle? itemStyle;
  final MenuFunctionController? controller;
  final Widget? header;
  final Widget? footer;
  final Offset position;
  const _MenuPopup(
      {Key? key,
      required this.tag,
      required this.items,
      this.controller,
      this.header,
      this.footer,
      this.itemStyle = const MenuItemStyle(),
      this.style = const MenuDropdownStyle(),
      required this.position})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: position.dx,
          top: position.dy,
          width: style?.width ?? 250,
          child: CustomHero(
            tag: tag,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: style?.borderRadius,
                  color: style?.color ?? Colors.white),
              constraints: style?.constraints ??
                  BoxConstraints(
                      maxHeight: style?.height ?? 350,
                      maxWidth: 250,
                      minHeight: style?.height ?? 10),
              child: Column(
                children: [
                  ListView(
                    padding: style?.padding ?? EdgeInsets.zero,
                    shrinkWrap: true,
                    children: items,
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
