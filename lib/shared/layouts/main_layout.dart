import 'package:flutter/material.dart';
import '../../core/constants/color_constants.dart';
import '../../routes/route_names.dart';

class MainLayout extends StatefulWidget {
  final Widget child;
  final int currentIndex;

  const MainLayout({
    Key? key,
    required this.child,
    required this.currentIndex,
  }) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  void _onItemTapped(int index, BuildContext context) {
    if (index == widget.currentIndex) return;
    
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, RouteNames.discover);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, RouteNames.chatList);
        break;
      case 2:
        Navigator.pushReplacementNamed(context, RouteNames.profile);
        break;
      case 3:
        Navigator.pushReplacementNamed(context, RouteNames.notifications);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: widget.currentIndex,
          onTap: (index) => _onItemTapped(index, context),
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDarkMode ? AppColors.backgroundDark : Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: 'Discover',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none),
              label: 'Activity',
            ),
          ],
        ),
      ),
    );
  }
}
