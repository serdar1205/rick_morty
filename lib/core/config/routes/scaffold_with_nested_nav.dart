import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rick_morty/core/constants/colors/app_colors.dart';
import 'package:rick_morty/core/constants/strings/app_strings.dart';
import 'bottom_navbar_widget.dart';
import 'widget_keys_srt.dart';

class ScaffoldWithNestedNavigation extends StatefulWidget {
  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;

  @override
  State<ScaffoldWithNestedNavigation> createState() =>
      _ScaffoldWithNestedNavigationState();
}

class _ScaffoldWithNestedNavigationState
    extends State<ScaffoldWithNestedNavigation> {
  void _goBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  List<BottomNavigationBarItem> items = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    items = [
      BottomNavigationBarItem(
        label: 'Home',
        icon: buildIcon(Icons.home_outlined,
            color: Theme.of(context).colorScheme.outlineVariant),
        activeIcon: buildIcon(Icons.home, color: AppColors.mainbuttonColor2),
      ),
      BottomNavigationBarItem(
        label: AppStrings.favorites,
        icon: buildIcon(Icons.star_outline,
            color: Theme.of(context).colorScheme.outlineVariant),
        activeIcon: buildIcon(Icons.star, color: AppColors.mainbuttonColor2),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        body: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + 44,
          ),
          child: widget.navigationShell,
        ),
        bottomNavigationBar: buildBottomWidget());
  }

  Widget buildBottomWidget() {
    return BottomNavBar(
      key: bottomNavBarKey,
      onTap: _goBranch,
      currentIndex: widget.navigationShell.currentIndex,
      items: items,
    );
  }

  Widget buildIcon(IconData icon, {Color? color}) {
    return Padding(padding: const EdgeInsets.only(top: 5), child: Icon(icon));
  }
}
