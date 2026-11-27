import 'package:flutter/material.dart';
import '../../home/views/home_page.dart';
import '../../explore/views/explore_page.dart';
import '../../agenda/views/agenda_page.dart';
import '../../messages/views/messages_page.dart';
import '../../profile/views/profile_page.dart';
import '../widgets/sabios_bottom_nav_bar.dart';

class MainNavigationScreen extends StatefulWidget {
  final VoidCallback? onLogout;

  const MainNavigationScreen({
    super.key,
    this.onLogout,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(onNavigateToTab: _onTabChanged),
      const ExplorePage(),
      AgendaPage(onScheduleNew: () => _onTabChanged(1)),
      const MessagesPage(),
      ProfilePage(onLogout: widget.onLogout),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: SabiosBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabChanged,
      ),
    );
  }
}
