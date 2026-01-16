import 'package:flutter/material.dart';
import 'navigation_destinations.dart';

class AdaptiveNavigation extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;
  final Widget body;
  final Widget? drawerHeader;
  final List<Widget>? drawerFooter;

  const AdaptiveNavigation({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.body,
    this.drawerHeader,
    this.drawerFooter,
  });

  @override
  State<AdaptiveNavigation> createState() => _AdaptiveNavigationState();
}

class _AdaptiveNavigationState extends State<AdaptiveNavigation> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late bool showNavigationDrawer;

  void openDrawer() {
    scaffoldKey.currentState!.openEndDrawer();
  }

  Widget buildBottomBarScaffold() {
    return Scaffold(
      body: widget.body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.selectedIndex,
        onDestinationSelected: widget.onDestinationSelected,
        destinations: AppNavigationDestinations.destinations.map((destination) {
          return NavigationDestination(
            label: destination.label,
            icon: destination.icon,
            selectedIcon: destination.selectedIcon,
            tooltip: destination.label,
          );
        }).toList(),
      ),
    );
  }

  Widget buildDrawerScaffold(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        bottom: false,
        top: false,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: NavigationRail(
                minWidth: 50,
                destinations: AppNavigationDestinations.destinations.map((destination) {
                  return NavigationRailDestination(
                    label: Text(destination.label),
                    icon: destination.icon,
                    selectedIcon: destination.selectedIcon,
                  );
                }).toList(),
                selectedIndex: widget.selectedIndex,
                useIndicator: true,
                onDestinationSelected: widget.onDestinationSelected,
              ),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: widget.body),
          ],
        ),
      ),
      endDrawer: NavigationDrawer(
        onDestinationSelected: widget.onDestinationSelected,
        selectedIndex: widget.selectedIndex,
        children: [
          if (widget.drawerHeader != null) widget.drawerHeader!,
          const Padding(
            padding: EdgeInsets.fromLTRB(28, 16, 16, 10),
            child: Text('Menu', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ...AppNavigationDestinations.destinations.map((destination) {
            return NavigationDrawerDestination(
              label: Text(destination.label),
              icon: destination.icon,
              selectedIcon: destination.selectedIcon,
            );
          }),
          if (widget.drawerFooter != null) ...[
            const Padding(padding: EdgeInsets.fromLTRB(28, 16, 28, 10), child: Divider()),
            ...widget.drawerFooter!,
          ],
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    showNavigationDrawer = MediaQuery.of(context).size.width >= 450;
  }

  @override
  Widget build(BuildContext context) {
    return showNavigationDrawer ? buildDrawerScaffold(context) : buildBottomBarScaffold();
  }
}
