import 'package:fitnessplus/src/menu/menu_item.dart';
import 'package:fitnessplus/src/menu/resize_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MenuSize {
  static const double menuWidthOpen = 250;
  static const double menuWidthClosed = 60;
}

enum MenuState { open, closed }

enum MenuPosition { top, bottom, left, right }

class MenuStyle {}

class DropdownButtonStyle {
  final MainAxisAlignment? mainAxisAlignment;
  final OutlinedBorder? shape;
  final double? elevation;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final BoxConstraints? constraints;
  final double? width;
  final double? height;
  final Color? primaryColor;
  const DropdownButtonStyle({
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.backgroundColor = Colors.white,
    this.primaryColor = Colors.blue,
    this.constraints = const BoxConstraints(),
    this.height,
    this.width,
    this.elevation = 0,
    this.padding = const EdgeInsets.all(0),
    this.shape = const RoundedRectangleBorder(),
  });
}

class DropdownStyle {
  final BorderRadius? borderRadius;
  final double? elevation;
  final Color? color;
  final EdgeInsets? padding;
  final BoxConstraints? constraints;

  /// position of the top left of the dropdown relative to the top left of the button
  final Offset? offset;

  ///button width must be set for this to take effect
  final double? width;

  const DropdownStyle({
    this.constraints = const BoxConstraints(),
    this.offset = const Offset(0, 1.0),
    this.width = 100,
    this.elevation = 0,
    this.color = Colors.white,
    this.padding = const EdgeInsets.all(0),
    this.borderRadius = BorderRadius.zero,
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
    this.barColor = const Color.fromARGB(255, 33, 150, 243),
    this.backgroundColor = const Color.fromARGB(255, 255, 255, 255),
    this.enableSelector = true,
  }) : super(key: key);
  final MenuFunctionController? controller;
  final List<MenuItem> items;
  final Widget? header;
  final Widget? footer;
  final Color barColor;
  final Color backgroundColor;
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
          color: widget.backgroundColor,
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
                                      color: widget.barColor),
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

class MenuDropdown<T> extends StatefulWidget {
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
  final DropdownStyle dropdownStyle;

  /// dropdownButtonStyles passes styles to OutlineButton.styleFrom()
  final DropdownButtonStyle dropdownButtonStyle;

  /// dropdown button icon defaults to caret
  final Icon? icon;
  final bool hideIcon;

  /// if true the dropdown icon will as a leading icon, default to false
  final bool leadingIcon;
  const MenuDropdown({
    Key? key,
    this.hideIcon = false,
    required this.child,
    required this.items,
    this.dropdownStyle = const DropdownStyle(),
    this.dropdownButtonStyle = const DropdownButtonStyle(),
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
  Widget build(BuildContext context) {
    var style = widget.dropdownButtonStyle;
    // link the overlay to the button
    return CompositedTransformTarget(
      link: this._layerLink,
      child: Container(
        width: style.width,
        height: style.height,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            padding: style.padding,
            backgroundColor: style.backgroundColor,
            elevation: style.elevation,
            // foregroundColor: style.primaryColor,
            shape: style.shape,
          ),
          onPressed: _toggleDropdown,
          child: Row(
            mainAxisAlignment:
                style.mainAxisAlignment ?? MainAxisAlignment.center,
            textDirection:
                widget.leadingIcon ? TextDirection.rtl : TextDirection.ltr,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_currentIndex == -1) ...[
                widget.child,
              ] else ...[
                widget.items[_currentIndex],
              ],
              if (!widget.hideIcon)
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
    var topOffset = offset.dy + size.height + 5;
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
                left: offset.dx,
                top: topOffset,
                width: widget.dropdownStyle.width ?? size.width,
                child: CompositedTransformFollower(
                  offset:
                      widget.dropdownStyle.offset ?? Offset(0, size.height + 5),
                  link: this._layerLink,
                  showWhenUnlinked: false,
                  child: Material(
                    elevation: widget.dropdownStyle.elevation ?? 0,
                    borderRadius:
                        widget.dropdownStyle.borderRadius ?? BorderRadius.zero,
                    color: widget.dropdownStyle.color,
                    child: SizeTransition(
                      axisAlignment: 1,
                      sizeFactor: _expandAnimation!,
                      child: ConstrainedBox(
                        constraints: widget.dropdownStyle.constraints ??
                            BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height -
                                  topOffset -
                                  15,
                            ),
                        child: ListView(
                          padding:
                              widget.dropdownStyle.padding ?? EdgeInsets.zero,
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
      setState(() => _isOpen = true);
      _animationController!.forward();
    }
  }
}
