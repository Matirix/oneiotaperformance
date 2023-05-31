import 'package:flutter/material.dart';
import 'package:one_iota_mobile_app/utils/persistent_bottom_bar_scaffold.dart';
import 'package:one_iota_mobile_app/screens/habit_feature/habit_main.dart';
import 'package:one_iota_mobile_app/screens/home_page.dart';
import 'package:one_iota_mobile_app/screens/rounds_feature/rounds_main.dart';
import 'package:one_iota_mobile_app/screens/settings_page.dart';

/// Navigation page. This is where the bottom navigation bar is created.
/// It is is necessary to add a new navigator key for each item to preserve state and go to nested routes.
/// Such is the case for AddHabit(), and AddRound() in the HabitPage() and RoundsMain() respectively.
/// Without this, there will be no way to display the navbar on those pages.
class NavigationPage extends StatelessWidget {
  final _tab1navigatorKey = GlobalKey<NavigatorState>();
  final _tab2navigatorKey = GlobalKey<NavigatorState>();
  final _tab3navigatorKey = GlobalKey<NavigatorState>();
  final _tab4navigatorKey = GlobalKey<NavigatorState>();

  NavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PersistentBottomBarScaffold(
      items: [
        PersistentTabItem(
          tab: const HomePage(),
          icon: Icons.home,
          title: 'Home',
          navigatorkey: _tab1navigatorKey,
        ),
        PersistentTabItem(
          tab: const RoundsMain(),
          icon: Icons.sports_golf,
          title: 'Rounds',
          navigatorkey: _tab2navigatorKey,
        ),
        PersistentTabItem(
          tab: const HabitPage(),
          icon: Icons.hotel,
          title: 'Habits',
          navigatorkey: _tab3navigatorKey,
        ),
        PersistentTabItem(
          tab: const Settings(),
          icon: Icons.settings,
          title: 'Settings',
          navigatorkey: _tab4navigatorKey,
        ),
      ],
    );
  }
}
